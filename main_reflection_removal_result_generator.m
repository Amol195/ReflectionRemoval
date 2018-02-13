%% Removal of Relection (Ghosting) in Images

clc; clear;

%% Scan Images

path = [pwd,'/test_images/'];
image_list = dir([path,'*.jpg']);
num_images = length(image_list);
figure_num = 1;

%% Implement Reflection Removal Algorithm on Test Images

for i=1:num_images
    lambda = 2;  % Tunable Hyperparameter for Smoothness Control
    
    image_path = [path,image_list(i).name]; 
    image = im2double(imread(image_path));
    
    [transmission_layer, reflection_layer] = reflection_removal(image,lambda);
    transmission_layer = transmission_layer*1.5;
    reflection_layer = reflection_layer*1.5;
    
    fig_handle = figure(1);
    image_save_handle = ['Reflection Removal ',int2str(i)];
    
    set(fig_handle,'name',image_save_handle,'Numbertitle','off');
    
    for j = 1:1:3
        figure(figure_num)
        imshow(image);
        title('Original Image')
    
        figure(figure_num + 1)
        imshow(transmission_layer);
        title('Transmission Layer')
    
        figure(figure_num + 2)
        imshow(reflection_layer);
        title('Reflection Layer')
    end
    
    figure_num = figure_num + 3;
end


% %Spectrum Checking 
% s0 = fftshift(fft2(rgb2gray(image)));
% s = mat2gray(log(abs(s0)+1));
% figure(1)
% imshow(s,[])


% st = fftshift(fft2(rgb2gray(transmission_layer)));
% st_display = mat2gray(log(abs(st)+1));
% figure(2)
% imshow(st_display,[])
% 
% sr = fftshift(fft2(rgb2gray(reflection_layer)));
% sr_display = mat2gray(log(abs(sr)+1));
% figure(3)
% imshow(sr_display,[])


