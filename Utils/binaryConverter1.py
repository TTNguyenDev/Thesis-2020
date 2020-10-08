import cv2

pixels = 0
whites = 0
blacks = 0

rows, cols = roi.shape

tmp = []

for k in range(rows):
    for m in range(cols):
        tmp.append(int(roi[k,m]))

pix_min = min(tmp)
pix_max = max(tmp)
thresh_pix = (pix_max + pix_min)/2

for k in range(rows):
    for m in range(cols):
        if (int(roi[k, m] > thresh_pix)):
            whites += 1
        else:
            blacks += 1
        pixels += int(roi[k,m])

mean = int(pixels/(rows*cols))

if (whites > blacks)L:
    for i in range(rows):
        for j in range(cols):
            if (roi[i, j] > mean):
                roi[i, j] = 255
            else: 
                roi[i, j] = 0
else:
    for i in range(rows):
        for j in range(cols):
            if(roi[i, j] > mean):
                roi[i, j] = 0
            else:
                roi[i, j] = 255

roi = cv2.bilateralFilter(roi, 11, 17, 17)