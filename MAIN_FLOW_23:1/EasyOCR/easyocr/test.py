from detection import get_detector, get_textbox
from easyocr import Reader
from craft_utils import getDetBoxes, adjustResultCoordinates
import PIL
from PIL import ImageDraw
import cv2
import numpy as np
import PIL
from PIL import ImageDraw
from utils import group_text_box, get_image_list, calculate_md5, get_paragraph,\
                   download_and_unzip, printProgressBar, diff, reformat_input


path = 'examples/main_test/image16.png'
im = PIL.Image.open(path)
reader = Reader(['en'])
bounds = reader.readtext(path)
for i in range(0, len(bounds)):
  print(bounds[i][0] + bounds[i][1])
#   print("\n")



# for i in range(0, len(bounds)):
#   print(bounds[i][1])
# def draw_boxes(image, bounds, color='red', width=2):
#     draw = ImageDraw.Draw(image)
#     for bound in bounds:
#         p0, p1, p2, p3 = bound[0]
#         draw.line([*p0, *p1, *p2, *p3, *p0], fill=color, width=width)
#     return image

# draw_boxes(im, bounds)

# numpy_image=np.array(im)  
# opencv_image=cv2.cvtColor(numpy_image, cv2.COLOR_RGB2BGR) 

# res_img_file ='medical_res.jpg'
# # img = cv2.imread('medical.jpg')
# cv2.imwrite(res_img_file, opencv_image)