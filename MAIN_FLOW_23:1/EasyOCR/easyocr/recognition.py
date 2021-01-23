from PIL import Image
import torch
import torch.backends.cudnn as cudnn
import torch.utils.data
import torch.nn.functional as F
import torchvision.transforms as transforms
import numpy as np
import cv2
from collections import OrderedDict
import pytesseract
from model import Model
from utils import CTCLabelConverter
import math
from spell import spell_check_single_word, create_dictionary
from spellcheck import SpellCheck
# import preprocess as pp

commonMedicinePath = "/content/gdrive/My Drive/EasyOCR/easyocr/commonMedicine.txt"
medicineNamePath = "/content/gdrive/My Drive/EasyOCR/easyocr/medicineName.txt"
def contrast_grey(img):
    high = np.percentile(img, 90)
    low  = np.percentile(img, 10)
    return (high-low)/np.maximum(10, high+low), high, low

def adjust_contrast_grey(img, target = 0.4):
    contrast, high, low = contrast_grey(img)
    if contrast < target:
        img = img.astype(int)
        ratio = 200./np.maximum(10, high-low)
        img = (img - low + 25)*ratio
        img = np.maximum(np.full(img.shape, 0) ,np.minimum(np.full(img.shape, 255), img)).astype(np.uint8)
    return img

class NormalizePAD(object):

    def __init__(self, max_size, PAD_type='right'):
        self.toTensor = transforms.ToTensor()
        self.max_size = max_size
        self.max_width_half = math.floor(max_size[2] / 2)
        self.PAD_type = PAD_type

    def __call__(self, img):
        img = self.toTensor(img)
        img.sub_(0.5).div_(0.5)
        c, h, w = img.size()
        Pad_img = torch.FloatTensor(*self.max_size).fill_(0)
        Pad_img[:, :, :w] = img  # right pad
        if self.max_size[2] != w:  # add border Pad
            Pad_img[:, :, w:] = img[:, :, w - 1].unsqueeze(2).expand(c, h, self.max_size[2] - w)

        return Pad_img

class ListDataset(torch.utils.data.Dataset):

    def __init__(self, image_list):
        self.image_list = image_list
        self.nSamples = len(image_list)

    def __len__(self):
        return self.nSamples

    def __getitem__(self, index):
        img = self.image_list[index]
        return Image.fromarray(img, 'L')

class AlignCollate(object):

    def __init__(self, imgH=32, imgW=100, keep_ratio_with_pad=False, adjust_contrast = 0.):
        self.imgH = imgH
        self.imgW = imgW
        self.keep_ratio_with_pad = keep_ratio_with_pad
        self.adjust_contrast = adjust_contrast

    def __call__(self, batch):
        batch = filter(lambda x: x is not None, batch)
        images = batch

        resized_max_w = self.imgW
        input_channel = 1
        transform = NormalizePAD((input_channel, self.imgH, resized_max_w))

        resized_images = []
        for image in images:
            w, h = image.size
            #### augmentation here - change contrast
            if self.adjust_contrast > 0:
                image = np.array(image.convert("L"))
                image = adjust_contrast_grey(image, target = self.adjust_contrast)
                image = Image.fromarray(image, 'L')

            ratio = w / float(h)
            if math.ceil(self.imgH * ratio) > self.imgW:
                resized_w = self.imgW
            else:
                resized_w = math.ceil(self.imgH * ratio)

            resized_image = image.resize((resized_w, self.imgH), Image.BICUBIC)
            resized_images.append(transform(resized_image))

        image_tensors = torch.cat([t.unsqueeze(0) for t in resized_images], 0)
        return image_tensors

def recognizer_predict(model, converter, test_loader, batch_max_length,\
                       ignore_idx, char_group_idx, decoder = 'greedy', beamWidth= 5, device = 'cpu'):
    model.eval()
    result = []
    with torch.no_grad():
        for image_tensors in test_loader:
            batch_size = image_tensors.size(0)
            image = image_tensors.to(device)
            # For max length prediction
            length_for_pred = torch.IntTensor([batch_max_length] * batch_size).to(device)
            text_for_pred = torch.LongTensor(batch_size, batch_max_length + 1).fill_(0).to(device)

            preds = model(image, text_for_pred)

            # Select max probabilty (greedy decoding) then decode index to character
            preds_size = torch.IntTensor([preds.size(1)] * batch_size)

            ######## filter ignore_char, rebalance
            preds_prob = F.softmax(preds, dim=2)
            preds_prob = preds_prob.cpu().detach().numpy()
            preds_prob[:,:,ignore_idx] = 0.
            pred_norm = preds_prob.sum(axis=2)
            preds_prob = preds_prob/np.expand_dims(pred_norm, axis=-1)
            preds_prob = torch.from_numpy(preds_prob).float().to(device)

            if decoder == 'greedy':
                # Select max probabilty (greedy decoding) then decode index to character
                _, preds_index = preds_prob.max(2)
                preds_index = preds_index.view(-1)
                preds_str = converter.decode_greedy(preds_index.data, preds_size.data)
            elif decoder == 'beamsearch':
                k = preds_prob.cpu().detach().numpy()
                preds_str = converter.decode_beamsearch(k, beamWidth=beamWidth)
            elif decoder == 'wordbeamsearch':
                k = preds_prob.cpu().detach().numpy()
                preds_str = converter.decode_wordbeamsearch(k, beamWidth=beamWidth)

            preds_max_prob, _ = preds_prob.max(dim=2)

            for pred, pred_max_prob in zip(preds_str, preds_max_prob):
                confidence_score = pred_max_prob.cumprod(dim=0)[-1]
                result.append([pred, confidence_score.item()])

    return result

def get_recognizer(input_channel, output_channel, hidden_size, character,\
                   separator_list, dict_list, model_path, device = 'cpu'):

    converter = CTCLabelConverter(character, separator_list, dict_list)
    num_class = len(converter.character)
    model = Model(input_channel, output_channel, hidden_size, num_class)

    if device == 'cpu':
        state_dict = torch.load(model_path, map_location=device)
        new_state_dict = OrderedDict()
        for key, value in state_dict.items():
            new_key = key[7:]
            new_state_dict[new_key] = value
        model.load_state_dict(new_state_dict)
    else:
        model = torch.nn.DataParallel(model).to(device)
        model.load_state_dict(torch.load(model_path, map_location=device))

    return model, converter

def get_text(img, character, imgH, imgW, recognizer, converter, image_list,\
             ignore_char = '',decoder = 'greedy', beamWidth =5, batch_size=1, contrast_ths=0.1,\
             adjust_contrast=0.5, filter_ths = 0.003, workers = 1, device = 'cpu'):
    batch_max_length = int(imgW/10)

    char_group_idx = {}
    ignore_idx = []
    for char in ignore_char:
        try: ignore_idx.append(character.index(char)+1)
        except: pass

    coord = [item[0] for item in image_list]
   
    img_list = [item[1] for item in image_list]
    AlignCollate_normal = AlignCollate(imgH=imgH, imgW=imgW, keep_ratio_with_pad=True)
    test_data = ListDataset(img_list)
    test_loader = torch.utils.data.DataLoader(
        test_data, batch_size=batch_size, shuffle=False,
        num_workers=int(workers), collate_fn=AlignCollate_normal, pin_memory=True)

    # predict first round
    result1 = recognizer_predict(recognizer, converter, test_loader,batch_max_length,\
                                 ignore_idx, char_group_idx, decoder, beamWidth, device = device)
    
    # predict second round
    low_confident_idx = [i for i,item in enumerate(result1) if (item[1] < contrast_ths)]
    if len(low_confident_idx) > 0:
        img_list2 = [img_list[i] for i in low_confident_idx]
        AlignCollate_contrast = AlignCollate(imgH=imgH, imgW=imgW, keep_ratio_with_pad=True, adjust_contrast=adjust_contrast)
        test_data = ListDataset(img_list2)
        test_loader = torch.utils.data.DataLoader(
                        test_data, batch_size=batch_size, shuffle=False,
                        num_workers=int(workers), collate_fn=AlignCollate_contrast, pin_memory=True)
        result2 = recognizer_predict(recognizer, converter, test_loader, batch_max_length,\
                                     ignore_idx, char_group_idx, decoder, beamWidth, device = device)

    result = []
    for i, zipped in enumerate(zip(coord, result1, image_list)):
        box, pred1, image = zipped
        
        tesseractResult, tesseractResult2 = tesseract(box, img)
        checkMedicine, _ = isMedicine(tesseractResult, commonMedicinePath)
        if checkMedicine:
            medicineName = []
            amount = []
            unit = []
            listText = tesseractResult.split()
            print(listText)
            for text in listText:
                if text.isnumeric() and len(text) > 1:
                    amount.append(text)
                if text.isalpha and len(text) > 2:
                  checkMedicine, medicine = isMedicine(text, medicineNamePath)
                  if checkMedicine:
                      medicineName.append(medicine)
                if checkUnitComponents(text):
                  unit.append(text)

            completed_medicine = ''
            if len(medicineName) > 0:
              summary = medicineName + amount + unit
              completed_medicine_arr = list(dict.fromkeys(summary))
              completed_medicine = ' '.join(completed_medicine_arr) 
            if i in low_confident_idx:
                pred2 = result2[low_confident_idx.index(i)]
                if pred1[1]>pred2[1]:
                    result.append(('\n tesseract eng: ' + tesseractResult, '\n spell checking: ' + completed_medicine,  pred1[1]) )
                else:
                    result.append(('\n tesseract eng: ' + tesseractResult, '\n spell checking: ' + completed_medicine, pred2[1]) )
            else:
                result.append(('\n tesseract eng: ' + tesseractResult,'\n spell checking: ' + completed_medicine, pred1[1]) )
        # correct = spellCorrection(tesseractResult)
        # if correct != '':
        # # if True:
        #   if i in low_confident_idx:
        #       pred2 = result2[low_confident_idx.index(i)]
        #       if pred1[1]>pred2[1]:
        #           result.append(('\n tesseract eng: ' + tesseractResult, '\n spell checking: ' + correct,  pred1[1]) )
        #       else:
        #           result.append(('\n tesseract eng: ' + tesseractResult, '\n spell checking: ' + correct, pred2[1]) )
        #   else:
        #       result.append(('\n tesseract eng: ' + tesseractResult,'\n spell checking: ' + correct, pred1[1]) )
    return result

def tesseract(box,image):
  result = ''
  result2 = ''
  poly = np.array(box).astype(np.int32).reshape((-1))
  poly = poly.reshape(4, 2)
  # First find the minX minY maxX and maxY of the polygon
  minX = image.shape[1]
  maxX = -1
  minY = image.shape[0]
  maxY = -1
  for point in poly:
      x = point[0]
      y = point[1]

      if x < minX:
          minX = x
      if x > maxX:
          maxX = x
      if y < minY:
          minY = y
      if y > maxY:
          maxY = y

  # Go over the points in the image if thay are out side of the emclosing rectangle put zero
  # if not check if thay are inside the polygon or not
  cropedImage = np.zeros_like(image)
  for y in range(0,image.shape[0]):
      for x in range(0, image.shape[1]):

          if x < minX or x > maxX or y < minY or y > maxY:
              continue

          if cv2.pointPolygonTest(np.asarray(poly),(x,y),False) >= 0:
              cropedImage[y, x, 0] = image[y, x, 0]
              cropedImage[y, x, 1] = image[y, x, 1]
              cropedImage[y, x, 2] = image[y, x, 2]

  # Now we can crop again just the envloping rectangle
  finalImage = cropedImage[minY:maxY,minX:maxX]
  config = ('-l eng --oem 1 --psm 7')
  text = pytesseract.image_to_string(finalImage, config=config)
  config2 = ('-l medicine --oem 1 --psm 7')
  text2 = pytesseract.image_to_string(finalImage, config=config2)
  result += text
  result2 += text2
  return result, result2

#load text recognition in input.txt 
#output output.txt
#we need 2 input files (alpha file and symbol file)
def spellCorrection(word_in):
    spell_check = SpellCheck("/content/gdrive/My Drive/EasyOCR/easyocr/commonMedicine.txt")
    spell_check.check(word_in)
    isMedicine, result = spell_check.isMedicine()
    if isMedicine: 
        return result
    else:
        return ''

def checkUnitComponents(word):
  ignore_characters = ['mg', 'ml', 'gr']
  for i in ignore_characters:
    if i in word.lower():
      print(word)
      return True
  return False

def isMedicine(word_in, path):
    spell_check = SpellCheck(path)
    spell_check.check(word_in)
    return spell_check.isMedicine()
    
    
    # dictionary = {}
    # # start_time = time.time()
    # create_dictionary(dictionary, "/content/gdrive/My Drive/EasyOCR/easyocr/commonMedicine.txt")
    # # run_time = time.time() - start_time
    # # print ('%.2f seconds to run' % run_time)

    # return spell_check_single_word(dictionary=dictionary, word_in=word_in)

