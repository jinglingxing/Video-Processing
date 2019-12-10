#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Tue Jan 29 13:53:47 2019

@author: Luc and Jinling
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
#import images
#filenames = [img for img in glob.glob("/Users/jinlingxing/INF6804/tp2/dataset/im_dinosaur/*.jpg")]
filenames = [img for img in glob.glob("/Users/jinlingxing/INF6804/tp2/dataset/iceskater1*.jpg")]
#filenames = [img for img in glob.glob("/Users/jinlingxing/INF6804/tp2/dataset/im_sunshade/*.jpg")]
filenames.sort() # ADD THIS LINE

imlist = []
for img in filenames:
    n= cv2.imread(img)
    imlist.append(n)


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
rects_list = []

for i in range(0,N):   
    im = imlist[i]
    im1 = im[:, :, 0]
    (rects, weights) = hog.detectMultiScale(im1, winStride = (4,4), padding = (8,8), scale = 1.05)
   
    rects_list.append(rects) 

#    bin_fg = np.zeros((height, width), np.int)

##Viewing
    for x, y, w, h in rects:
        cv2.rectangle(im, (x, y), (x + w, y + h), (0, 255, 0), 2)
#        
#    for l in range (0,len(rects)):
#        pad_w,pad_h = int(0.15 * rects[l,1]),int(0.05 * rects[l,3])
#        bin_fg[rects[l,1]:rects[l,1]+rects[l,3],rects[l,0]:rects[l,0]+rects[l,2]]=1               
        

#Detection score
#print(weights)




####
##  evaluation criteria
####

epsilon_h=30   
epsilon_w=30
d_max=60
tracking_ok=0   #represents if the tracking was made ok or not
tracking_error=0    #represents when the tracking failed
rect_obj_list=[]    #contains the rectangles in a picture.                  

rect_courant=rects_list[3]
if (len(rect_courant)!=1):
    tracking_error=1
else:
    rect_obj=[rect_courant[0,0],rect_courant[0,1],rect_courant[0,2],rect_courant[0,3],0]
    rect_obj_list.append(rect_obj)
          
for i in range(5,90):
    rect_new=rects_list[i]
    if (len(rect_new)==0):
        tracking_error+=1
    else:
        obj=rect_obj_list[-1]
        mid1=[obj[0]+obj[2]/2,obj[1]+obj[3]/2]
        for j in range (0, len(rect_new)):
            nearestmid=200000
            test=rect_new[j]
            mid2=[test[0]+test[2]/2,test[1]+test[3]/2]
            if(abs(mid1[0]-mid2[0])+abs(mid1[1]-mid2[1])<nearestmid):
                nearest_rect=rect_new[j]
                nearestmid=(abs(mid1[0]-mid2[0])+abs(mid1[1]-mid2[1]))
            test=nearest_rect
            mid2=[test[0]+test[2]/2,test[1]+test[3]/2]
            if ((abs(obj[2]-test[2])<epsilon_h)and(abs(obj[3]-test[3])<epsilon_w)and(abs(mid1[0]-mid2[0])+abs(mid1[1]-mid2[1])<d_max)):
                 rect_obj_list.append([test[0],test[1],test[2],test[3],i])
                 cv2.putText(imlist[i], "Id1", (test[0], test[1]-5),cv2.FONT_HERSHEY_SIMPLEX, 0.6, (0, 255, 0), 2)
                 tracking_ok+=1
            else:
                 tracking_error+=1
    
a=7
plt.figure(figsize = (8,8))
plt.imshow(imlist[a], cmap = plt.get_cmap('gray'))
plt.show()
                                      
#                   
#imlist_crit_inter=[]
#imlist_crit_union=[]
#crit_result=[]
#for p in range(0,20):
#    inter_im_test = np.zeros((height, width), np.int)
#    union_im_test = np.zeros((height, width), np.int)
#    im1=imlist_out[p]
#    im2=imlist_gt[p] 
#    sum_inter=0.
#    sum_union=0.
#    for j in range(0, height):
#        for k in range(0, width):
#            inter_im_test[j,k] = im1[j,k]&im2[j,k]
#            union_im_test[j,k] = im1[j,k]|im2[j,k]
#            sum_inter=sum_inter + inter_im_test[j,k]
#            sum_union=sum_union + union_im_test[j,k]
#    crit_result.append(sum_inter/sum_union)
#    imlist_crit_inter.append(inter_im_test)  
#    imlist_crit_union.append(union_im_test)


