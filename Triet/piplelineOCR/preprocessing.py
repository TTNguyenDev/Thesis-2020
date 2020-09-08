import cv2
import numpy as np
from matplotlib import pyplot as plt

# Read the image
img = cv2.imread('ab.jpg',0)
# Simple thresholding
# ret,thresh1 = cv2.threshold(img,127,255,cv.THRESH_BINARY)
th3 = cv2.adaptiveThreshold(img,255,cv2.ADAPTIVE_THRESH_MEAN_C, cv2.THRESH_BINARY,11,2)
cv2.imshow('gray', th3)
cv2.waitKey() 
