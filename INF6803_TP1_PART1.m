%the dataset is from website "changedetection.net"
tic
%read all the images
srcDir=uigetdir('/Users/jinlingxing/Documents/INF6803/lab/highway/input'); 
cd(srcDir);
allnames=struct2cell(dir('*.jpg')); %take all the pictures with jpg as end
[k,len]=size(allnames); 
for ii=1:len %take out images in order
    name=allnames{1,ii};
    I=imread(name); 
end

%information about image
bg=imread('in000001.jpg'); %read the first image as background
frame_bg = rgb2gray(bg); 
InfoImage=imfinfo('in000001.jpg'); 
height=240;
width=320; 

K=3; % number of gaussian components 
fg_matrix=zeros(height,width);
bg_matrix=zeros(height,width);

%initialize some parameters
mean=zeros(height,width,K); %the number of single gaussian model is 3
weight=zeros(height,width,K);
variance_init=5;
variance=zeros(height,width,K);
verify_K_distribution = zeros(height,width,K);

%%%%%%%%%%%%%%%%%%%%%%%%%initialize the background model%%%%%%%%%%%%%%%%%%%
for i=1:height
    for j=1:width
        for k=1:K     
            %k gaussian distribution   
            %initialize the mean, weight, variance of the k-th gaussian diistribution
            mean(i,j,k) = frame_bg(i,j);   % first frame value as the mean
            weight(i,j,k) = 1/K; %initialize with equal weights
            variance(i,j,k) = variance_init;                         
        end
    end
end

%%%%%%%%%%%%%%%calculate the difference |X_t-Mu_k,t-1|%%%%%%%%%%%%%%%%%%
for ii=1:len
  name=allnames{1,ii};
  I=imread(name); 
  frame=I;
  frame_bg = rgb2gray(frame);%re-read images
  %calculate the |X_t-Mu_k,t-1|, the abosolute difference mean value of pixles and the
  %k-th distribution
    for iii=1:K
         verify_K_distribution(:,:,iii)=abs(double(frame_bg) - double(mean(:,:,iii))); 
    end

%%%%%%%%%%%%%%%%%%%%background model update%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %update the gaussian model parameters for every images
  for i=1:height
      for j=1:width
          for k=1:K
              alpha=0.01;
              if verify_K_distribution(i,j,k)<=2.5*variance(i,j,k)
                  m=1;  
                  %m is the match on slides page 21
                  %the parameters update according to the formulas on
                  %slides on page 22
                  weight(i,j,k) = (1-alpha)*weight(i,j,k) + alpha*m;
                  beta = alpha * normpdf(double(frame_bg(i,j)),mean(i,j,k),variance(i,j,k)); %gaussian pdf
                  mean(i,j,k) = (1-beta)*mean(i,j,k) + beta*double(frame_bg(i,j));
                  variance(i,j,k)=sqrt((1-beta)*variance(i,j,k).^2) +beta * transpose(double(frame_bg(i,j))-mean(i,j,k))*(double(frame_bg(i,j))-mean(i,j,k));  
              else
                  m=0;
                  %%%%the adjustment when m==0, is according to the
                  %%%%description on slides on page 21
                  
                  %the distributions with the smallest weight is replaced
                  %with a new one with the value of the first frame as the
                  %mean, a large arbitrary variance(the initial one) and a
                  %small weight
                  weight(i,j,:) = weight(i,j,:)./sum(weight(i,j,:)); 
                  [min_weight,min_weight_index] = min(weight(i,j,:));
                  mean(i,j,min_weight_index) = double(frame_bg(i,j));
                  variance(i,j,min_weight_index) = variance_init;  
              end    
          end
          
%%%%%%%%%%%%%%%%%%%%%%%%%%display the segmetation%%%%%%%%%%%%%%%%%%%%%%

          %choose the bestB distribution over the total of K
          %best b distributions is the the weight/variance ratio
          bestB=weight(i,j,:) ./ variance(i,j,:);             
          bestB_Index=[1:1:K];
          %detect the pixels value, set the value which is less than
          %2.5*sigma, set it as 0(background),and the other is 255(foreground) 
          fg_matrix(i,j) = 0; 
          m=0;
          k=1;    
          if((m==0)&&(k<=K))
              if (abs(verify_K_distribution(i,j,bestB_Index(k))) <= 2.5*variance(i,j,bestB_Index(k)))
                  fg_matrix(i,j) = 0;
              else
                  fg_matrix(i,j) = 255;
              end
              k=k+1;
          end
      end
  end
    figure(ii)
    subplot(1,2,1),imshow(frame);
    subplot(1,2,2),imshow(uint8(fg_matrix));
    %store all the output images in a specific folder.
    filename = strcat('/Users/jinlingxing/Documents/INF6803/lab/highway/gmm-output/img',num2str(ii));
    print('-djpeg',filename);
    close all
end
toc
    


