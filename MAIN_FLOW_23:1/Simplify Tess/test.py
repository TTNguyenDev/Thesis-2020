from detection import get_detector, get_textbox
from utils import group_text_box, get_image_list, diff, reformat_input, isMedicine, tesseract, checkUnitComponents
import numpy as np
import cv2
import torch
from PIL import Image, ImageDraw

# detector parameters
DETECTOR_FILENAME = 'craft_mlt_25k.pth'

imgH = 64
input_channel = 1
output_channel = 512
hidden_size = 512

commonMedicinePath = "/content/gdrive/My Drive/EasyOCR/easyocr/commonMedicine.txt"
medicineNamePath = "/content/gdrive/My Drive/EasyOCR/easyocr/medicineName.txt"

def readtext(image, min_size = 20, contrast_ths = 0.1, adjust_contrast = 0.5, filter_ths = 0.003,\
                text_threshold = 0.7, low_text = 0.4, link_threshold = 0.4, canvas_size = 2560,\
                mag_ratio = 1., slope_ths = 0.1, ycenter_ths = 0.5, height_ths = 0.5,\
                width_ths = 0.5, add_margin = 0.1):
        device = 'cpu'
        if torch.cuda.is_available():
              device = 'cuda'

        detector = get_detector(DETECTOR_FILENAME, device)

        img, img_cv_grey = reformat_input(image)

        text_box = get_textbox(detector, img, canvas_size, mag_ratio,\
                               text_threshold, link_threshold, low_text,\
                               False, device)
        horizontal_list, free_list = group_text_box(text_box, slope_ths,\
                                                    ycenter_ths, height_ths,\
                                                    width_ths, add_margin)

        if min_size:
            horizontal_list = [i for i in horizontal_list if max(i[1]-i[0],i[3]-i[2]) > min_size]
            free_list = [i for i in free_list if max(diff([c[0] for c in i]), diff([c[1] for c in i]))>min_size]

        image_list, _ = get_image_list(horizontal_list, free_list, img_cv_grey, model_height = imgH)

        coord = [item[0] for item in image_list]
    
        result = []
        for zipped in zip(coord):
            box = zipped
        
            tesseractResult, tesseractResult2 = tesseract(box, img)
            checkMedicine, _ = isMedicine(tesseractResult, commonMedicinePath)
            if checkMedicine:
                medicineName = []
                amount = []
                unit = []
                listText = tesseractResult.split()
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
                    result.append(('\n tesseract eng: ' + tesseractResult + '\n' + tesseractResult2, '\n spell checking: ' + completed_medicine))
      
        return result


path = 'image16.png'
im = Image.open(path)
bounds = readtext(path)
for i in range(0, len(bounds)):
  print(bounds[i][0] + bounds[i][1])



