from pipelines.inference.recognize_api import RecognitionAPI
from recognition_crnn.tools.test_shadownet import reco
import os
import cv2

BASEDIR = os.path.dirname(os.path.dirname(__file__))

def _test101():

    weights_path = os.path.join(BASEDIR, 'recognition_crnn/model/zh_model/shadownet.ckpt')
    char_dict_path = os.path.join(BASEDIR, 'recognition_crnn/data/char_dict/char_dict_cn.json')
    ord_map_dict_path = os.path.join(BASEDIR, 'recognition_crnn/data/char_dict/ord_map_cn.json')

    model_info = {
        'weights_path': weights_path,
        'char_dict_path': char_dict_path,
        'ord_map_dict_path': ord_map_dict_path
    }

    recognizer = RecognitionAPI(model_info)

    recognizer.load_model()


    img_fn = os.path.join(BASEDIR, 'data', 'test_04.jpg')
    image = cv2.imread(img_fn, cv2.IMREAD_COLOR)
    res = recognizer.infer(image)
    print(res)

    return res

    # reco()

if __name__ == '__main__':

    _test101()