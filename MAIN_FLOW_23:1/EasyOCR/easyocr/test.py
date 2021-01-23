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


def readtext(self, image, decoder = 'greedy', beamWidth= 5, batch_size = 1,\
                 workers = 0, allowlist = None, blocklist = None, detail = 1,\
                 paragraph = False, min_size = 20,\
                 contrast_ths = 0.1,adjust_contrast = 0.5, filter_ths = 0.003,\
                 text_threshold = 0.7, low_text = 0.4, link_threshold = 0.4,\
                 canvas_size = 2560, mag_ratio = 1.,\
                 slope_ths = 0.1, ycenter_ths = 0.5, height_ths = 0.5,\
                 width_ths = 0.5, add_margin = 0.1):
        '''
        Parameters:
        image: file path or numpy-array or a byte stream object
        '''
        img, img_cv_grey = reformat_input(image)
        print("Hello")
        horizontal_list, free_list = self.detect(img, min_size, text_threshold,\
                                                 low_text, link_threshold,\
                                                 canvas_size, mag_ratio,\
                                                 slope_ths, ycenter_ths,\
                                                 height_ths,width_ths,\
                                                 add_margin, False)
        print(horizontal_list[0])
        print(free_list[0])
        result = self.recognize(img_cv_grey, img, horizontal_list, free_list,\
                                decoder, beamWidth, batch_size,\
                                workers, allowlist, blocklist, detail,\
                                paragraph, contrast_ths, adjust_contrast,\
                                filter_ths, False)
      
        return result


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