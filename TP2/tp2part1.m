clc
clear
%read all the images
srcDir=uigetdir('/Users/jinlingxing/Documents/INF6803/lab/TP2/mydata'); 
cd(srcDir);
allnames=struct2cell(dir('*.jpg')); %take all the pictures with jpg as end
[k,len]=size(allnames); 
for ii=1:len %take out images in order
    name=allnames{1,ii};
    I=imread(name); 
end

%compare these two images
im1 =imread('1791.jpg');
im2 =imread('1792.jpg');


%the bins of H,S,V
binH = 16;
binS = 8;
binV = 8;
N = binH * binS * binV;

%resize images
[im1_1,im1_2,im1_3]=size(im1);
[im2_1,im2_2,im2_3]=size(im2);

if im1_1*im1_2 > im2_1*im2_2
     im1=imresize(im1,[im2_1 im2_2],'bicubic');
     im2=imresize(im2,[im2_1 im2_2],'bicubic');
     rows=im2_1; cols=im2_2;
else im2=imresize(im2,[im1_1 im1_2],'bicubic');
     im1=imresize(im1,[im1_1 im1_2],'bicubic');
     rows=im1_1; cols=im1_2;
end

image1 = rgb2hsv(im1); 
image2 = rgb2hsv(im2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% bins of images %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

h1 = image1(:, :, 1);
s1 = image1(:, :, 2);
v1 = image1(:, :, 3);

h2 = image2(:, :, 1);
s2 = image2(:, :, 2);
v2 = image2(:, :, 3);

% Find the max
maxH1 = max(h1(:));
maxS1 = max(s1(:));
maxV1 = max(v1(:));
maxH2 = max(h2(:));
maxS2 = max(s2(:));
maxV2 = max(v2(:));

% create histogram matrix
hsvColorHistogram1 = zeros(binH, binS, binV);
hsvColorHistogram2 = zeros(binH, binS, binV);


% create new matrics, to put pixels
H1_matrix = ceil(binH * h1/maxH1);
quantizedH1 = reshape(H1_matrix',[rows*cols,1]);
S1_matrix = ceil(binS * s1/maxS1);
quantizedS1 = reshape(S1_matrix',[rows*cols,1]);
V1_matrix = ceil(binV * v1/maxV1);
quantizedV1 = reshape(V1_matrix',[rows*cols,1]);

H2_matrix = ceil(binH * h2/maxH2);
quantizedH2 = reshape(H2_matrix',[rows*cols,1]);
S2_matrix = ceil(binS * s2/maxS2);
quantizedS2 = reshape(S2_matrix',[rows*cols,1]);
V2_matrix = ceil(binV * v2/maxV2);
quantizedV2 = reshape(V2_matrix',[rows*cols,1]);

% create col vector of indexes for later reference
index1 = zeros(rows*cols, 3);
index2 = zeros(rows*cols, 3);

% keep indexes where 1 should be put in matrix hsvHist
index1(:, 1) = quantizedH1;
index1(:, 2) = quantizedS1;
index1(:, 3) = quantizedV1;

index2(:, 1) = quantizedH2;
index2(:, 2) = quantizedS2;
index2(:, 3) = quantizedV2;

%%%%%%%%%%%%%%%%%%%%%%%%% hsv Color Histogram %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for row = 1:size(index1, 1)
    if (index1(row, 1) == 0 || index1(row, 2) == 0 || index1(row, 3) == 0)
        continue;
    end
    hsvColorHistogram1(index1(row, 1), index1(row, 2), index1(row, 3)) = hsvColorHistogram1(index1(row, 1), index1(row, 2), index1(row, 3)) + 1;
end
for row = 1:size(index2, 1)
    if (index2(row, 1) == 0 || index2(row, 2) == 0 || index2(row, 3) == 0)
        continue;
    end
    hsvColorHistogram2(index2(row, 1), index2(row, 2), index2(row, 3)) = hsvColorHistogram2(index2(row, 1), index2(row, 2), index2(row, 3)) + 1;
end


% normalize hsvHist to unit sum
hsvColorHistogram1 = hsvColorHistogram1(:)';
hsvColorHistogram1 = hsvColorHistogram1/sum(hsvColorHistogram1);

hsvColorHistogram2 = hsvColorHistogram2(:)';
hsvColorHistogram2 = hsvColorHistogram2/sum(hsvColorHistogram2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%compute cosine similarity%%%%%%%%%%%%%%%%%%%%%%%%%%%

A=sqrt(sum(hsvColorHistogram1.^2));
B=sqrt(sum(hsvColorHistogram2.^2));
C=sum(hsvColorHistogram1.*hsvColorHistogram2);
cos=1-C/(A*B);%cosine value

%output
figure,
subplot(2,2,1),imshow(im1);title('image1')
subplot(2,2,3),plot(hsvColorHistogram1);title('HSVhistogram of image1')
subplot(2,2,2),imshow(im2);title('image2')
subplot(2,2,4),plot(hsvColorHistogram2);title('HSVhistogram of image2');
