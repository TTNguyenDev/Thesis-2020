from detection import get_detector, get_textbox
from utils import group_text_box, get_image_list, diff, reformat_input, isMedicine, tesseract, checkUnitComponents, get_paragraph, cleanName
import numpy as np
import cv2
import torch
import pandas as pd
from spellcheck import SpellCheck
import os

from fuzzywuzzy import fuzz, process
from collections import OrderedDict 

from flask import Flask, request, redirect, jsonify, render_template
from werkzeug.utils import secure_filename
from PIL import Image
import pytesseract
import json

from werkzeug.utils import secure_filename


# detector parameters
DETECTOR_FILENAME = 'craft_mlt_25k.pth'

imgH = 64
input_channel = 1
output_channel = 512
hidden_size = 512

medicinePath =  'main_dict/high_res.csv'
df = pd.read_csv(medicinePath, sep=';', quotechar="\"", header=0, dtype=str)

class Medicine(object):
    afternoon = 1
    contains = ''
    display_name = ''
    evening = ''
    info = 'Chưa có thông tin về thuốc'
    line = ''
    morning = 1

def readData():
    full_name = df[df.columns[0]].tolist()
    contains = df[df.columns[2]].tolist()

    singleName = [name.split() for name in full_name]
    singleContain = [contain.split() for contain in contains]

    singleName = [cleanName(item) for sublist in singleName for item in sublist]
    singleContain = [cleanName(item) for sublist in singleContain for item in sublist]

    full_name_process = [cleanName(name) for name in full_name]

    return singleName + singleContain, full_name_process

def findObj(name, data):
    index = data.index(name)
    return df.iloc[index].to_dict()

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

        final_result = []
        for item in croped_images:
            isExist = False
            tesseractResult = tesseract(item)
            # print('tesseractResult ' + tesseractResult)
            tesseractResult = cleanName(tesseractResult)

            tesseractResultArr.append(tesseractResult) 

            #put each line in to check func 
            # print(medicineClassifier.check(tesseractResult))
            medicine_name, isMedicine = medicineClassifier.check(tesseractResult)
            if isMedicine >= 50: #xét trường hợp tên thuốc == từ điển thì xuất ra ~ 100% matching => handle case này riêng
                #check xem đây là tên thuốc nào, nếu check 0 ra tên thuốc thì hiển thị đây là thuốc nhưng chưa có trong db

                #nếu kết quả so khớp theo proccess và kết quả so kớp theo từ ~90% thì hiển thị ra tên, còn nếu không thì sẽ hiển thị warning và các option của hệ thống
                #Check độ dài input, độ dài sửa theo từ, độ dài sửa theo dòng gần bằng nhau thì sẽ cho kết quả dạng option
                correct = process.extract(cleanName(tesseractResult), medicineCorrectionData, limit=5, scorer=fuzz.token_set_ratio)
                first_match, percent_match = correct[0]
                
                for previousResult in final_result:
                    for item in previousResult:
                        if cleanName(item['line']) == first_match:
                            isExist = True

                if isExist:
                    continue

                if percent_match >= 90:
                    obj = findObj(first_match, medicineCorrectionData)
                    print(obj)
                    final_result.append([obj])
                elif percent_match >= 70:
                    objs = [findObj(item[0], medicineCorrectionData) for item in correct]
                    final_result.append(objs)
                elif percent_match > 50:
                    objs = Medicine()
                    objs.display_name = medicine_name
                    # print(objs)
                    final_result.append([{'line': '', 'display_name': medicine_name, 'morning': 1, 'afternoon': 1, 'evening': 1}])
        #             {
        #     "afternoon": "1",
        #     "contains": "",
        #     "display_name": "",
        #     "evening": "1",
        #     "info": "Chưa có thông tin về thuốc",
        #     "line": "",
        #     "morning": "1"
        # }
        # [print(item) for item in final_result]
        return final_result


app = Flask(__name__, template_folder='templates')

@app.route("/")
def index():
    return render_template('policy.html') 

ALLOWED_EXTENSIONS = set(["txt", "pdf", "png", "jpg", "jpeg", "gif"])


def allowed_file(filename):
    return "." in filename and filename.rsplit(".", 1)[1].lower() in ALLOWED_EXTENSIONS


@app.route("/file-upload", methods=["POST"])
def upload_file():
    if "file" not in request.files:
        resp = jsonify({"message": "No file part in the request"})
        resp.status_code = 400
        return resp
    file = request.files["file"]
    if file.filename == "":
        resp = jsonify({"message": "No file selected for uploading"})
        resp.status_code = 400
        return resp

    if file and allowed_file(file.filename):
        filename = secure_filename(file.filename)
        filepath = os.path.join('userImages', filename)
        file.save(filepath)
        res = readtext(filepath)

        if len(res) > 0:
            print(res)
            resp = jsonify(res)
            resp.status_code = 200
            return resp
        else:
            resp = jsonify({"message": "Not found medical data in your image!"})
            resp.status_code = 400
            return resp
    else:
        resp = jsonify(
            {"message": "Allowed file types are txt, pdf, png, jpg, jpeg, gif"}
        )
        resp.status_code = 400
        return resp
