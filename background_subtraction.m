%%% GOOD FOR VIDEO
% % Loop through the rest of the images
% for i = 2:length(filelist)
%     % Read the next image in the sequence
%     I = imread([folder filelist(i).name]);
%     % Subtract the current image from the previous image and display the result
%     imshowpair(I, bgModel, 'diff');
%     drawnow;
% end

% Load the first image in the sequence
% folder = 'C:\Users\Dimuth Panditharatne\Desktop\Spring 2023\CS 766\MATLAB\ams\';
% filelist = dir([folder '*.jpg']);
% I = imread([folder filelist(1).name]);
% 
% Initialize the background model with the first image
% bgModel = double(I);
% 
% Loop through the rest of the images
% for i = 2:length(filelist)
%     Read the next image in the sequence
%     I = imread([folder filelist(i).name]);
%     Update the background model using a simple averaging technique
%     alpha = 0.01;
%     bgModel = alpha * double(I) + (1 - alpha) * bgModel;
% end
% 
% Display the final background image in color
% imshow(uint8(bgModel));


% % Load the first image in the sequence
% folder = 'C:\Users\Dimuth Panditharatne\Desktop\Spring 2023\CS 766\MATLAB\ams\';
% filelist = dir([folder '*.jpg']);
% I = imread([folder filelist(1).name]);
% 
% % Initialize the background model with the first image
% bgModel = double(I);
% 
% % Loop through the rest of the images
% for i = 2:length(filelist)
%     % Read the next image in the sequence
%     I = imread([folder filelist(i).name]);
%     
%     % Update the background model using a simple averaging technique
%     alpha = 0.01;
%     bgModel = alpha * double(I) + (1 - alpha) * bgModel;
%     
%     % Compute the absolute difference between the current image and the background model
%     diff = abs(double(I) - bgModel);
%     
%     % Threshold the difference image to create a binary mask of the foreground objects
%     threshold = 30;
%     mask = diff > threshold;
%     
%     % Display the current image and the foreground mask
%     subplot(1, 2, 1), imshow(I), title('Current image');
%     subplot(1, 2, 2), imshow(mask), title('Foreground mask');
% end

% % Load the first image in the sequence
% folder = 'C:\Users\Dimuth Panditharatne\Desktop\Spring 2023\CS 766\MATLAB\ams\';
% filelist = dir([folder '*.jpg']);
% I = imread([folder filelist(1).name]);
% 
% % Initialize the background model with the first image
% bgModel = double(I);
% 
% % Loop through the rest of the images
% for i = 2:length(filelist)
%     % Read the next image in the sequence
%     I = imread([folder filelist(i).name]);
%     
%     % Update the background model using a simple averaging technique
%     alpha = 0.01;
%     bgModel = alpha * double(I) + (1 - alpha) * bgModel;
%     
%     % Compute the absolute difference between the current image and the background model
%     diff = abs(double(I) - bgModel);
%     
%     % Threshold the difference image to create a binary mask of the foreground objects
%     threshold = 30;
%     mask = diff > threshold;
%     
%     % Convert the foreground mask to grayscale for visualization
%     mask_gray = uint8(mask * 255);
%     
%     % Display the current image and the foreground mask
%     subplot(1, 2, 1), imshow(I), title('Current image');
%     subplot(1, 2, 2), imshow(mask_gray), title('Foreground mask');
% end

% Load the first image in the sequence
folder = 'C:\Users\Dimuth Panditharatne\Desktop\Spring 2023\CS 766\MATLAB\ams\';
filelist = dir([folder '*.jpg']);
I = imread([folder filelist(1).name]);

% Initialize the background model with the first image
bgModel = double(I);

% Loop through the rest of the images
for i = 2:length(filelist)
    % Read the next image in the sequence
    I = imread([folder filelist(i).name]);
    
    % Update the background model using a simple averaging technique
    alpha = 0.01;
    bgModel = alpha * double(I) + (1 - alpha) * bgModel;
    
    % Compute the absolute difference between the current image and the background model
    diff = abs(double(I) - bgModel);
    
    % Threshold the difference image to create a binary mask of the foreground objects
    threshold = 30;
    mask = diff > threshold;
end

% Convert the foreground mask to grayscale for visualization
mask_gray = uint8(mask * 255);

% Convert the final background image to grayscale for visualization
bgModel_gray = uint8(bgModel);

% Concatenate the final background image and the foreground mask horizontally
combined_image = cat(2, bgModel_gray, mask_gray);

% Display the final background image and foreground mask in grayscale
imshow(combined_image);


% Save the final background image and foreground mask separately
imwrite(bgModel_gray, 'background_ams_fd.jpg');
imwrite(mask_gray, 'foreground_ams_fd.jpg');
