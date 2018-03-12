# video processing and application
**Author**: Jinling XING jinling.xing@polymtl.ca
## TP1 problem:
TP1 is about video segmentation. What I did in this TP is that I substracted foreground and background using two methods: GMM and Optical flow and tested the performances of GMM and Optical flow with three special cases in the dataset(highway video with 1700 frames). I wrote the detailed implementation steps on the report and compared the output images with groundtruth to evaluate the performance of these two method.

The detailed info of questions, please click the link: [TP1 questions](https://github.com/jinglingxing/Video-Processing/blob/master/TP1/INF6803_H2018_TP1_EN_v2.pdf)

This dataset including 1700 frames, which is on the baseline of highway.zip. Website link: [Dataset](http://jacarini.dinf.usherbrooke.ca/dataset2012/)

I wrote two methods: GMM(Gaussian Mixture model). Code: [GMM](https://github.com/jinglingxing/Video-Processing/blob/master/TP1/INF6803_TP1_PART1.m)

one is Optical flow. Code: [Optical flow](https://github.com/jinglingxing/Video-Processing/blob/master/TP1/INF6803_TP1_PART2.m)

The detailed implementation and analysis is on report. [Report](https://github.com/jinglingxing/Video-Processing/blob/master/TP1/tp1-inf6803-video.pdf)

## TP2 problem:
TP2 used color histogram and SIFT for the description of regions ofinterest in images, and determine which method is better, and under which circumstances. I wrote the detailed implementation steps on the report and calculated cosine similarity of the feature matrics of two images to evaluate the performance of these two method.

The detailed info of questions, please click the link: [TP2 questions](https://github.com/jinglingxing/Video-Processing/blob/master/TP2/INF6803_H2018_TP2_EN_v01.pdf)

I wrote two methods: color histogram Code: [color histogram](https://github.com/jinglingxing/Video-Processing/blob/master/TP2/tp2part1.m)

one is SIFT. Code: [SIFT](https://github.com/jinglingxing/Video-Processing/blob/master/TP2/tp2part2.m)

The detailed implementation and analysis is on report.
