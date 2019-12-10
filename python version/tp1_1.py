#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Tue Jan 29 13:53:47 2019

@author: jinlingxing
"""

import numpy as np
import cv2
import matplotlib.pyplot as plt
import glob
from skimage.feature import hog
import random

#Detection with HOG + SVM
####
## Pictures import
####

#import images
#filenames = [img for img in glob.glob("/Users/jinlingxing/INF6804/tp1/PETS2006/input/*.jpg")]
filenames = [img for img in glob.glob("/Users/jinlingxing/INF6804/tp1/sidewalk/input/*.jpg")]
#filenames = [img for img in glob.glob("/Users/jinlingxing/INF6804/tp1/park/input/*.jpg")]
filenames.sort() # ADD THIS LINE

imlist = []
for img in filenames:
    n= cv2.imread(img)
    imlist.append(n)

#gt_filenames = [img for img in glob.glob("/Users/jinlingxing/INF6804/tp1/PETS2006/groundtruth/*.png")]
gt_filenames = [img for img in glob.glob("/Users/jinlingxing/INF6804/tp1/sidewalk/groundtruth/*.png")]
#gt_filenames = [img for img in glob.glob("/Users/jinlingxing/INF6804/tp1/park/groundtruth/*.png")]
gt_filenames.sort() # ADD THIS LINE

imlist_ground_truth = []
for img in gt_filenames:
   n = cv2.imread(img)
   imlist_ground_truth.append(n)

#parameters of images   
im = imlist[0] #first image
height = np.size(im, 0) 
width = np.size(im, 1)
RGB = np.size(im, 2)
N = len(imlist)

####
## Initialization of the detector
####


hog = cv2.HOGDescriptor()  #64 x 128 pixels
hog.setSVMDetector(cv2.HOGDescriptor_getDefaultPeopleDetector())

#Multi-scale detection and display.
xl = []
imlist_out = []
imlist_gt = []
rects_list = []

for i in range(0,20):
    x = random.randint(1, N-1)
    xl.append(x)   
    im = imlist[x]
    im1 = im[:, :, 0]
    (rects, weights) = hog.detectMultiScale(im1, winStride = (4,4), padding = (8,8), scale = 1.05)
   
    rects_list.append(rects) 
    im_gt = imlist_ground_truth[x]

    bin_fg = np.zeros((height, width), np.int)
    im_gt2 = np.zeros((height, width), np.int)
    bin_gt =  np.zeros((height, width), np.int)

##Viewing
    for x, y, w, h in rects:
        cv2.rectangle(im, (x, y), (x + w, y + h), (0, 255, 0), 2)
        
    for l in range (0,len(rects)):
        pad_w,pad_h = int(0.15 * rects[l,1]),int(0.05 * rects[l,3])
        bin_fg[rects[l,1]:rects[l,1]+rects[l,3],rects[l,0]:rects[l,0]+rects[l,2]]=1               
    
    for j in range(0, height):
       for k in range(0, width):
           im_gt2[j,k] = im_gt[j,k,0] + im_gt[j,k,1] + im_gt[j,k,2]
           if im_gt2[j,k] > 0:
              bin_gt[j,k]=1
           else:
              bin_gt[j,k]=0
              
    imlist_out.append(bin_fg)
    imlist_gt.append(bin_gt)
    
a=7
plt.figure(figsize = (8,8))
plt.imshow(imlist[xl[a]], cmap = plt.get_cmap('gray'))
plt.show()
plt.figure(figsize = (8,8))
plt.imshow(imlist_out[a], cmap = plt.get_cmap('binary'))
plt.show()
plt.figure(figsize = (8,8))
plt.imshow(imlist_ground_truth[xl[a]], cmap = plt.get_cmap('gray'))
plt.show()

#Detection score
print(weights)



####
##  evaluation criteria
####

imlist_crit_inter=[]
imlist_crit_union=[]
crit_result=[]
for p in range(0,20):
    inter_im_test = np.zeros((height, width), np.int)
    union_im_test = np.zeros((height, width), np.int)
    im1=imlist_out[p]
    im2=imlist_gt[p] 
    sum_inter=0.
    sum_union=0.
    for j in range(0, height):
        for k in range(0, width):
            inter_im_test[j,k] = im1[j,k]&im2[j,k]
            union_im_test[j,k] = im1[j,k]|im2[j,k]
            sum_inter=sum_inter + inter_im_test[j,k]
            sum_union=sum_union + union_im_test[j,k]
    crit_result.append(sum_inter/sum_union)
    imlist_crit_inter.append(inter_im_test)  
    imlist_crit_union.append(union_im_test)
