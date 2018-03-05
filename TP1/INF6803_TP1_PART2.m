clear; clc; close all;

srcDir=uigetdir('/Users/jinlingxing/Documents/INF6803/lab/highway/input'); 
cd(srcDir);
allnames=struct2cell(dir('*.jpg')); %take all the pictures with jpg as end
[k,len]=size(allnames); 
for ii=1:len %take out images in order
    name=allnames{1,ii};
    I=imread(name); 
end

img = imread('in000001.jpg');
[width, height] = size(img(:,:,1));
img1 = double(rgb2gray(img));
Vx = zeros([width, height]);
Vy = zeros([width, height]);

winsize = 25;   % (window_size * window_size)
win_size= floor(winsize/2);% build weight matrix
W= ones(window,window);% weight

for n = 1:len
    name=allnames{1,n};
    I=imread(name);
    im = I;
    img2 = double(rgb2gray(im));
    
    % calculate derivatives
    Ix_m = conv2(img2,[-1 1; -1 1],'valid'); 
    Iy_m = conv2(img2, [-1 -1; 1 1],'valid');
    It_m = conv2(img2, ones(2),'same') + conv2(img1, -ones(2),'same');
    
    
    % build matrices A, b and calculate v
    for i = win_size+1: size(Ix_m,1)-win_size
        for j = win_size+1: size(Ix_m,2)-win_size
            Ix = Ix_m(i-win_size:i+win_size, j-win_size:j+win_size);
            Iy = Iy_m(i-win_size:i+win_size, j-win_size:j+win_size);
            It = It_m(i-win_size:i+win_size, j-win_size:j+win_size);
            
            A = [Ix(:) Iy(:)];
            b = -It(:);
            
            %v = (inv(transpose(A)*A) * transpose(A)) * b;
            mat = A'*A;
            if (det(mat) < 10^(-10))
                continue
            end
            v = ((mat)\A')*b;
            Vx(i, j) = v(1);
            Vy(i, j) = v(2);
        end
    end
 
    vv = sqrt(Vx.^2 + Vy.^2);
    subplot(1,2,1),imshow(im);
    subplot(1,2,2),imshow(uint8(150*vv));
    %store all the output images in a specific folder.
    filename = strcat('/Users/jinlingxing/Documents/INF6803/lab/highway/op-output/op-img',num2str(n));
    print('-djpeg',filename);
    close all
    
end
