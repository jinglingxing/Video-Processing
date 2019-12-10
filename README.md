# video processing and application
**Author**: Jinling XING jinling.xing@polymtl.ca
## TP1 problem:
TP1 is about video segmentation. Background was subtracted from foreground using two methods: GMM and Optical flow, the performances of which were tested with three special cases in the dataset (highway video with 1700 frames). Detailed implementation steps can be found in the report, and one can compare the output images with groundtruth to evaluate their performances.

For detailed information about questions, please click the link: [TP1 questions](https://github.com/jinglingxing/Video-Processing/blob/master/TP1/INF6803_H2018_TP1_EN_v2.pdf)

This dataset includes 1700 frames, which is on the baseline of highway.zip. Website link: [Dataset](http://jacarini.dinf.usherbrooke.ca/dataset2012/)

To check the two methods: 

* GMM(Gaussian Mixture model). Code: [GMM](https://github.com/jinglingxing/Video-Processing/blob/master/TP1/INF6803_TP1_PART1.m)

* Optical flow. Code: [Optical flow](https://github.com/jinglingxing/Video-Processing/blob/master/TP1/INF6803_TP1_PART2.m)

The implementation and detailed analysis can be seen by clicking [Report](https://github.com/jinglingxing/Video-Processing/blob/master/TP1/tp1-inf6803-video.pdf)

## TP2 problem:
TP2 used color histogram and SIFT for the description of regions of interest in images, and determine which method is better under what circumstances. Detailed implementation steps can be found in the report, and by calculating cosine similarity of the feature matrics of two images one can evaluate the performance of these two methods.

For detailed information about questions, please click the link: [TP2 questions](https://github.com/jinglingxing/Video-Processing/blob/master/TP2/INF6803_H2018_TP2_EN_v01.pdf)

To check the two methods: 

* Color histogram. Code: [color histogram](https://github.com/jinglingxing/Video-Processing/blob/master/TP2/tp2part1.m)

* SIFT. Code: [SIFT](https://github.com/jinglingxing/Video-Processing/blob/master/TP2/tp2part2.m)

The implementation and detailed analysis can be seen by clicking [Report](https://github.com/jinglingxing/Video-Processing/blob/master/TP2/tp2-inf6803-video.pdf)

## TP3 problem:
TP3 is about object tracking. Based on the work of KCF and SAMF, I changed the run_tracker and show_video code of their projects. Finally, I got a .txt file of the data given by professor, and the professor will evaluate the performace with their groundtruth. 

## Python version:
worked with [Luc Michea](https://github.com/lucmichea) 
including SIMPLE GAUSSIAN, HOG, LBP, HOG DETECTOR, LBP DETECHOR.
