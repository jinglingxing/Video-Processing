# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""
import numpy as np
import cv2
import matplotlib.pyplot as plt
import glob
import random
####
## Pictures import
####


#filenames = [img for img in glob.glob("/Users/jinlingxing/INF6804/tp1/PETS2006/input/*.jpg")]
#filenames = [img for img in glob.glob("/Users/jinlingxing/INF6804/tp1/sidewalk/input/*.jpg")]
filenames = [img for img in glob.glob("/Users/jinlingxing/INF6804/tp1/park/input/*.jpg")]
filenames.sort() # ADD THIS LINE

imlist = []
for img in filenames:
    n= cv2.imread(img)
    imlist.append(n)

#gt_filenames = [img for img in glob.glob("/Users/jinlingxing/INF6804/tp1/PETS2006/groundtruth/*.png")]
#gt_filenames = [img for img in glob.glob("/Users/jinlingxing/INF6804/tp1/sidewalk/groundtruth/*.png")]
gt_filenames = [img for img in glob.glob("/Users/jinlingxing/INF6804/tp1/park/groundtruth/*.png")]
gt_filenames.sort() # ADD THIS LINE

imlist_ground_truth = []
for img in gt_filenames:
   n = cv2.imread(img)
   imlist_ground_truth.append(n)
####
## Get the information of pictures
####

im = imlist[0]
height = np.size(im, 0)
width = np.size(im, 1)
RGB = np.size(im, 2)
N = len(imlist)

#####
### Mean and variance for pictures
#####

M = 100  #number of images we used to initialize mean and variance
sum_im = np.zeros((height, width ,RGB), np.float)
power_im = np.zeros((height, width ,RGB), np.float)
mean = np.zeros((height, width ,RGB), np.float)
variance = np.zeros((height, width, RGB), np.float)
for i in xrange(0, M):
    im = imlist[i]
    for j in range(0, height):
        for k in range(0, width):
            for p in range(0, RGB):
                sum_im[j,k,p] = sum_im[j,k,p] + im[j,k,p]
                power_im[j,k,p] = power_im[j,k,p] + np.power(im[j,k,p], 2)       
mean = sum_im/M 
variance = power_im/M - np.power(mean, 2)

###
#  Sensitivity and Segmentation
###

n = 2 #Sensitivity
xl = []
imlist_out = []
imlist_gt = []

for i in range(0, 20):
    x = random.randint(1,N-1)
    xl.append(x)
    
    im = imlist[x]
    im_gt = imlist_ground_truth[x]
    
    foreground = np.abs(im - mean) > n * np.sqrt(variance)   
    curr_matrix = np.zeros((height, width, RGB), np.int)
    bin_fg = foreground + curr_matrix
    
    
    bin_fg2 = np.zeros((height, width), np.int)
    im_gt2 = np.zeros((height, width), np.int)
    bin_gt =  np.zeros((height, width), np.int)
 
    for j in range(0, height):
       for k in range(0, width):
           bin_fg2[j,k] = bin_fg[j,k,0] + bin_fg[j,k,1] + bin_fg[j,k,2]
           if bin_fg2[j,k] > 0:
               bin_fg2[j,k]=1
           else:
               bin_fg2[j,k]=0

    for j in range(0, height):
       for k in range(0, width):
           im_gt2[j,k] = im_gt[j,k,0] + im_gt[j,k,1] + im_gt[j,k,2]
           if im_gt2[j,k] > 0:
              bin_gt[j,k]=1
           else:
              bin_gt[j,k]=0
        
    imlist_out.append(bin_fg2)
    imlist_gt.append(bin_gt)
  

####
##  evaluation criteria
####
    
a=1
print('For the image',xl[a],'we have the result :')
plt.imshow(imlist_out[a], plt.get_cmap('binary'))
plt.show()
plt.imshow(imlist[xl[a]])
plt.show()
plt.imshow(imlist_ground_truth[xl[a]])
plt.show()

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


    