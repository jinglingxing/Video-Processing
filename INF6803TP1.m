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

C=3; % rgb channels
K=3; % number of gaussian components (can be upto 3-5)- I was getting good results with 3 components

fg_matrix=zeros(height,width);
bg_matrix=zeros(height,width);

%initialize some parameters
mean=zeros(height,width,K); %the number of single gaussian model is 3
weight=zeros(height,width,K);
variance_init=5;
variance=zeros(height,width,K);
verify_K_distribution = zeros(height,width,K);
rankComp = zeros(1,K); 
%pixel_depth = 24;
%pixel_range = 2^pixel_depth -1;
%initialize the background model
for i=1:height
    for j=1:width
        for k=1:K     
            %k gaussian distribution   
            %initialize the mean, weight, variance of the k-th gaussian diistribution
            mean(i,j,k) = frame_bg(i,j);   % first frame value as the mean
            %mean(i,j,k) = rand*pixel_range;
            weight(i,j,k) = 1/K; %initializing with equal weights
            variance(i,j,k) = variance_init;               
            
        end
    end
end


for ii=1:len
  frame=I;
  frame_bg = rgb2gray(frame);%re-read images
  
  %calculate the |X_t-Mu_k,t-1|, the abosolute difference mean value of pixles and the
  %k-th distribution
  for iii=1:K
      verify_K_distribution(:,:,iii)=abs(double(frame_bg) - double(mean(:,:,iii))); 
  end
  
  %update the gaussian model parameters
  for i=1:height
      for j=1:width
          for k=1:K
              alpha=0.01;
              m=0;
              if verify_K_distribution(i,j,k)<=2.5*variance(i,j,k)
                  m=1;  %m is the match on slides page 21
                  weight(i,j,k) = (1-alpha)*weight(i,j,k) + alpha*m;
                  beta = normpdf(double(frame_bg(i,j)),mean(i,j,k),variance(i,j,k)); %gaussian pdf
                  mean(i,j,k) = (1-beta)*mean(i,j,k) + beta*double(frame_bg(i,j));
                  variance(i,j,k) = sqrt((1-beta)*(variance(i,j,k)^2) + beta*verify_K_distribution(i,j,k));
                  %variance(i,j,k)=sqrt((1-beta)*variance(i,j,k).^2) +beta * transpose(double(frame_bg(i,j))-mean(i,j,k))*(double(frame_bg(i,j))-mean(i,j,k));  
              else
                  m=0;
                  %adjust weight and do not update
                  weight(i,j,k)=(1-alpha)*weight(i,j,k)+alpha*m;               
              end    
          end
          weight(i,j,:) = weight(i,j,:)./sum(weight(i,j,:)); 
          bg_matrix(i,j)=0; 
          for k=1:K
                bg_matrix(i,j) = bg_matrix(i,j)+ mean(i,j,k)*weight(i,j,k);
          end
          
          if (m==0) 
                [min_w,min_w_index] = min(weight(i,j,:));
                mean(i,j,min_w_index) = double(frame_bg(i,j));
                variance(i,j,min_w_index) = variance_init;  
          end
          
          rankComp=weight(i,j,:) ./ variance(i,j,:);             
          rankIndex=[1:1:K];
           for k=2:K               
                for m=1:(k-1)
                    if (rankComp(:,:,k) > rankComp(:,:,m))                     
                        % swaping max values
                        rank_temp = rankComp(:,:,m);  
                        rankComp(:,:,m) = rankComp(:,:,k);
                        rankComp(:,:,k) = rank_temp;
                        % swaping max index values
                        rank_ind_temp = rankIndex(m);  
                        rankIndex(m) = rankIndex(k);
                        rankIndex(k) = rank_ind_temp;    
                    end
                end
           end
          %detect the pixels value, set the value which is less than
          %2.5*sigma, set it as 0(background),and the other is 255(foreground) 
          fg_matrix(i,j) = 0; 
          m=0;
          k=1;
          x=0;
          foreThreshold=0.25;
          while ((m == 0)&&(k<=K))
             x=x+weight(i,j,rankIndex(k)); 
             if ( x>= foreThreshold)
                    if (abs(verify_K_distribution(i,j,rankIndex(k))) <= 2.5*variance(i,j,rankIndex(k)))
                        fg_matrix(i,j) = 0;
                        m = 1;
                    else
                        fg_matrix(i,j) = 255;     
                    end
              end
                k = k+1;
          end
      end
  end
  
    figure(ii)
    subplot(1,3,1),imshow(bg);
    subplot(1,3,2),imshow(uint8(fg_matrix));
    %store all the output images in a specific folder.
    filename = strcat('/Users/jinlingxing/Documents/INF6803/lab/highway/output/img',num2str(ii));
    print('-djpeg',filename);
    close all
end
toc
    


