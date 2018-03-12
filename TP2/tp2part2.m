%this code referenced code on mathwork, link is below
%"https://www.mathworks.com/matlabcentral/fileexchange/43723-sift--scale-invariant-feature-transform--algorithm"
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

[m,n,k]=size(im1); %k=3, transform rgb to gray

a=rgb2gray(im1);
a=im2double(a);
original_a=a;

b=rgb2gray(im2);
b=im2double(im2);
original_b=b;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%construct DoGs %%%%%%%%%%%%%%%%%%%%%%%%%%%%

%1st octave generation
k2=0;
a(m:m+6,n:n+6)=0;
b(m:m+6,n:n+6)=0;%360*480-->366*486
store1_a=[];
store1_b=[];
for k1=0:3
    k=sqrt(2);
    sigma=(k^(k1+(2*k2)))*1.6;

    for x=-3:3
        for y=-3:3
            h(x+4,y+4)=(1/((2*pi)*((k*sigma)*(k*sigma))))*exp(-((x*x)+(y*y))/(2*(k*k)*(sigma*sigma))); %gaussian convplutions
        end
    end
    for i=1:m
        for j=1:n
            ta=a(i:i+6,j:j+6)'.*h;
            tb=b(i:i+6,j:j+6)'.*h;
            ca(i,j)=sum(sum(ta));
            cb(i,j)=sum(sum(tb));
        end
    end
store1_a=[store1_a ca];
store1_b=[store1_b cb];
end

clear a;
clear b;
a=imresize(original_a,1/((k2+1)*2));
b=imresize(original_b,1/((k2+1)*2));
% 2nd Octave generation
k2=1;
[m,n]=size(a);
a(m:m+6,n:n+6)=0;
b(m:m+6,n:n+6)=0;
store2_a=[];
store2_b=[];
clear ca;
clear cb;
for k1=0:3
    k=sqrt(2);
    sigma=(k^(k1+(2*k2)))*1.6;
    for x=-3:3
        for y=-3:3
            h(x+4,y+4)=(1/((2*pi)*((k*sigma)*(k*sigma))))*exp(-((x*x)+(y*y))/(2*(k*k)*(sigma*sigma))); %%gaussian convplutions
        end
    end
    for i=1:m
        for j=1:n
            ta=a(i:i+6,j:j+6)'.*h;
            tb=b(i:i+6,j:j+6)'.*h;
            ca(i,j)=sum(sum(ta));
            cb(i,j)=sum(sum(tb));
        end
    end
store2_a=[store2_a ca];
store2_b=[store2_b cb];
end
clear a;
a=imresize(original_a,1/((k2+1)*2));
b=imresize(original_b,1/((k2+1)*2));
% 3rd octave generation
k2=2;
[m,n]=size(a);
a(m:m+6,n:n+6)=0;
b(m:m+6,n:n+6)=0;
store3_a=[];
store3_b=[];
clear c;
for k1=0:3
    k=sqrt(2);
    sigma=(k^(k1+(2*k2)))*1.6;
    for x=-3:3
        for y=-3:3
            h(x+4,y+4)=(1/((2*pi)*((k*sigma)*(k*sigma))))*exp(-((x*x)+(y*y))/(2*(k*k)*(sigma*sigma)));
        end
    end
    for i=1:m
        for j=1:n
            ta=a(i:i+6,j:j+6)'.*h;
            tb=b(i:i+6,j:j+6)'.*h;
            ca(i,j)=sum(sum(ta));
            cb(i,j)=sum(sum(tb));
        end
    end
store3_a=[store3_a ca];
store3_b=[store3_b cb];
end
[m,n]=size(original_a);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Obtaining key point from the image %%%%%%%%%%%%%%%%%%%%%%%%%%%%


i1=store1_a(1:m,1:n)-store1_a(1:m,n+1:2*n);
i2=store1_a(1:m,n+1:2*n)-store1_a(1:m,2*n+1:3*n);
i3=store1_a(1:m,2*n+1:3*n)-store1_a(1:m,3*n+1:4*n);

i11=store1_b(1:m,1:n)-store1_b(1:m,n+1:2*n);
i22=store1_b(1:m,n+1:2*n)-store1_b(1:m,2*n+1:3*n);
i33=store1_b(1:m,2*n+1:3*n)-store1_b(1:m,3*n+1:4*n);
[m,n]=size(i2);
kp=[];
kpl=[];
kpp=[];
kpll=[];
for i=2:m-1
    for j=2:n-1
        x=i1(i-1:i+1,j-1:j+1);
        y=i2(i-1:i+1,j-1:j+1);
        z=i3(i-1:i+1,j-1:j+1);
        xb=i11(i-1:i+1,j-1:j+1);
        yb=i22(i-1:i+1,j-1:j+1);
        zb=i33(i-1:i+1,j-1:j+1);
        y(1:4)=y(1:4);
        y(5:8)=y(6:9);
        yb(1:4)=yb(1:4);
        yb(5:8)=yb(6:9);
        mx=max(max(x));
        mz=max(max(z));
        mx2=max(max(xb));
        mz2=max(max(zb));
        
        mix=min(min(x));
        miz=min(min(z));
        mix2=min(min(xb));
        miz2=min(min(zb));
        
        my=max(max(y));
        miy=min(min(y));
        my2=max(max(yb));
        miy2=min(min(yb));

        
        if (i2(i,j)>my && i2(i,j)>mz) || (i2(i,j)<miy && i2(i,j)<miz)
            kp=[kp i2(i,j)];
            kpl=[kpl i j];
        end
        
        if (i22(i,j)>my2 && i22(i,j)>mz2) || (i22(i,j)<miy2 && i22(i,j)<miz2)
            kpp=[kpp i22(i,j)];
            kpll=[kpll i j];
        end
    end
end

for i=1:2:length(kpl);
    k1=kpl(i);
    j1=kpl(i+1);
    i2(k1,j1)=1;
end

for i=1:2:length(kpll);
    k1=kpll(i);
    j1=kpll(i+1);
    i22(k1,j1)=1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%compute cosine similarity%%%%%%%%%%%%%%%%%%%%%%%%%%%

A=sqrt(sum(i2.^2));
B=sqrt(sum(i22.^2));
C=sum(i2.*i22);
cos=1-C/(A.*B);%cosine value
%output
figure,
subplot(2,2,1),imshow(im1);title('image1')
subplot(2,2,3),imshow(i2);title('image1 with key points')
subplot(2,2,2),imshow(im2);title('image2')
subplot(2,2,4),imshow(i22);title('image2 with key points');


