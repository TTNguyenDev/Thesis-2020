import cv2

whites = 0
blacks = 0

rows, cols = roi.shape

tmp = []

for k in range(rows):
    for m in range(cols):
        tmp.append(int(roi[k, m]))

pix_min = min(tmp)
pix_max = max(tmp)
thresh_pix = (pix_max + pix_min) / 2

tmp1 = []
tmp2 = []

for k in range(rows):
    for m in range(cols):
        if(int(roi[k, m] > thresh_pix)):
            tmp1.append(int(roi[k, m]))
            whites += 1
        else:
            tmp2.append(int(roi[k, m]))
            blacks += 1

if (whites > blacks):
    thresh = min(tmp1)
    for i in range(rows):
        for j in range(cols):
            if(roi[i, j] > thresh):
                roi[i, j] = 255
            else:
                roi[i, j] = 0
else: 
    thresh = max(tmp2)
    for j in range(cols):
        if (roi[i, j] > thresh):
            roi[i, j] = 0
        else:
            roi[i, j] = 255

roi = cv2.bilateralFilter(roi, 11, 17, 17)