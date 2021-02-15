from detection import get_detector, get_textbox
from utils import group_text_box, get_image_list, diff, reformat_input, isMedicine, tesseract, checkUnitComponents, get_paragraph, cleanName
import numpy as np
import cv2
import torch
from PIL import Image, ImageDraw
import pandas as pd
from spellcheck import SpellCheck

# detector parameters
DETECTOR_FILENAME = 'craft_mlt_25k.pth'

imgH = 64
input_channel = 1
output_channel = 512
hidden_size = 512

medicinePath =  'main_dict/high_res.csv'

def readData():
    df = pd.read_csv(medicinePath, sep=';', quotechar="\"", header=0)
    # print(df['fullName'])
    full_name = df[df.columns[0]].tolist()
    contains = df[df.columns[2]].tolist()

    singleName = [name.split() for name in full_name]
    singleContain = [contain.split() for contain in contains]

    singleName = [cleanName(item) for sublist in singleName for item in sublist]
    singleContain = [cleanName(item) for sublist in singleContain for item in sublist]

    return singleName + singleContain, full_name

def readtext(image, min_size = 0, contrast_ths = 0.1, adjust_contrast = 0.5, filter_ths = 0.003,\
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

        croped_images = map(lambda x: x[1], image_list)
    
        result = []
        tesseractResultArr = []

        #medicineClassifierData các tên thuốc sẽ được tách ra thành các từ cefuroxim, 500mg, (efodyl 500mg)
        #các dòng có sự xuất hiện của các từ này sẽ có khả năng cao là tên thuốc
        #xoá các kí tự đặc biệt cho dict và input
        medicineClassifierData, medicineCorrectionData = readData()

        medicineClassifier = SpellCheck(medicineClassifierData)
        medicineCorrection = SpellCheck(medicineCorrectionData)

        for item in croped_images:
            tesseractResult = tesseract(item)
            # print('tesseractResult ' + tesseractResult)
            tesseractResult = cleanName(tesseractResult)

            tesseractResultArr.append(tesseractResult) 

            #put each line in to check func 
            # print(medicineClassifier.check(tesseractResult))
            _, isMedicine = medicineClassifier.check(tesseractResult)
            if isMedicine >= 50: #xét trường hợp tên thuốc == từ điển thì xuất ra ~ 100% matching => handle case này riêng
                #check xem đây là tên thuốc nào, nếu check 0 ra tên thuốc thì hiển thị đây là thuốc nhưng chưa có trong db

                #nếu kết quả so khớp theo proccess và kết quả so kớp theo từ ~90% thì hiển thị ra tên, còn nếu không thì sẽ hiển thị warning và các option của hệ thống
                print('original:\t' + tesseractResult)
                print(medicineCorrection.correct(tesseractResult))

           
            # if checkMedicine:
            #     medicineName = []
            #     amount = []
            #     unit = []
            #     listText = tesseractResult.split()
            #     for text in listText:
            #         if text.isnumeric() and len(text) > 1:
            #             amount.append(text)
            #         if text.isalpha and len(text) > 2:
            #             checkMedicine, medicine = isMedicine(text, medicineNamePath)
            #             if checkMedicine:
            #                 medicineName.append(medicine)
            #         if checkUnitComponents(text):
            #             unit.append(text)

            #     completed_medicine = ''
            #     if len(medicineName) > 0:
            #         summary = medicineName + amount + unit
            #         completed_medicine_arr = list(dict.fromkeys(summary))
            #         completed_medicine = ' '.join(completed_medicine_arr) 
            #         result.append(('\ntesseractResult: ' + tesseractResult + '\ntesseractResult2: ' + tesseractResult2, '\nspell checking: ' + completed_medicine))
        
        # print('\n \n FINAL1: ' + ' \n'.join(tesseractResultArr)) 
       
        return result


path = 'image5.png'
im = Image.open(path)
bounds = readtext(path)