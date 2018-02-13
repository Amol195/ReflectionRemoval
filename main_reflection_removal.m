%% Removal of Relection (Ghosting) in Images

clc; clear;

%% Scan Images

path = [pwd,'/test_images/'];
image_list = dir([path,'*.jpg']);
num_images = length(image_list);


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
    
    subplot(1,3,1);
    imshow(image);
    title('Input Image');
    
    subplot(1,3,2);
    imshow(transmission_layer);
    title('Transmission Layer (Background)'); 
    
    subplot(1,3,3); 
    imshow(reflection_layer); 
    title('Reflection Layer (Ghosting)');
    
    cd result_images
    saveas(1,image_save_handle,'png')
    cd .. 
end

