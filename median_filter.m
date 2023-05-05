% Load the first image in the sequence
folder = 'C:\Users\Dimuth Panditharatne\Desktop\Spring 2023\CS 766\MATLAB\ams\';
filelist = dir([folder '*.jpg']);
I = imread([folder filelist(1).name]);

% Initialize the background model with the first image
bgModel = double(I);
% disp(length(filelist))
% Loop through the rest of the images
for i = 2:length(filelist)
    % Read the next image in the sequence
    I = imread([folder filelist(i).name]);      %ams photos
    
    % Update the background model using a median filter
    bgModel = median(cat(4, bgModel, double(I)), 4);
end

% Compute the absolute difference between the current frame and the background model
diffImage = imabsdiff(I, uint8(bgModel));

% Display the final background and foreground images
subplot(1, 2, 1), imshow(uint8(bgModel)), title('background');
subplot(1, 2, 2), imshow(I), title('foreground');
hold on;

foreground = rgb2gray(foreground); % Convert to grayscale
foreground = imbinarize(foreground); % Convert to binary

%%%RED PLOT
% [B,~] = bwboundaries(foreground,8,'noholes');
% for k = 1:length(B)
%    boundary = B{k};
%    plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 2)
% end

%% Video median filtering

% Specify the video file name
videoFile = 'rolling_tape_2.mp4';

% Create a VideoReader object
videoReader = VideoReader(videoFile);

% Determine the total number of frames in the video
numFrames = videoReader.NumFrames;

% Load the first frame in the sequence
I = read(videoReader, 1);

% Initialize the background model with the first frame
bgModel = double(I);

% Preallocate a cell array to store the foreground masks for each frame
foregroundMasks = cell(1, numFrames);

% Loop through the rest of the frames
for i = 2:numFrames
    % Read the next frame in the sequence
    I = read(videoReader, i);
    
    % Update the background model using a median filter
    bgModel = median(cat(4, bgModel, double(I)), 4);
    
    % Compute the absolute difference between the current frame and the background model
    diffImage = imabsdiff(I, uint8(bgModel));
    
    % Threshold the difference image to create a binary mask of the foreground
    foreground = imbinarize(diffImage, 'adaptive', 'Sensitivity', 0.4);
    
    % Convert the foreground image to binary
    foreground = double(foreground);
    
    % Store the foreground mask for this frame in the cell array
    foregroundMasks{i} = foreground;
end

% Display the final background and foreground images
subplot(1, 2, 1), imshow(uint8(bgModel)), title('background');
subplot(1, 2, 2), imshow(read(videoReader, 1)), title('foreground');
hold on;
visboundaries(bwperim(foregroundMasks{1}), 'Color', 'r', 'LineWidth', 2);

% Play the video with the foreground masks overlaid
figure;
for i = 1:numFrames
    % Read the next frame in the sequence
    I = read(videoReader, i);
    
    % Overlay the foreground mask on the frame
    foregroundMask = foregroundMasks{i};
    I(foregroundMask == 1) = 255;
    
    % Display the frame with the foreground mask overlaid
    imshow(I);
    pause(1/videoReader.FrameRate);
end

%% adaptive thresholding

% Load the first image in the sequence
folder = 'C:\Users\Dimuth Panditharatne\Desktop\Spring 2023\CS 766\MATLAB\ams\';
filelist = dir([folder '*.jpg']);
I = imread([folder filelist(1).name]);

% Initialize the background model with the first image
bgModel = double(I);

% Initialize the threshold value
threshold = 20;

% Loop through the rest of the images
for i = 2:length(filelist)
    % Read the next image in the sequence
    I = imread([folder filelist(i).name]);      %ams photos
    
    % Update the background model using a median filter
    bgModel = median(cat(4, bgModel, double(I)), 4);
    
    % Compute the absolute difference between the current frame and the background model
    diffImage = imabsdiff(I, uint8(bgModel));
    
    % Adaptive thresholding to create a binary mask of the foreground
    foreground = diffImage > threshold;
    
    % Display the final background and foreground images
    subplot(1, 2, 1), imshow(uint8(bgModel)), title('background');
    subplot(1, 2, 2), imshow(I), title('foreground');
    hold on;
    visboundaries(bwperim(foreground), 'Color', 'r', 'LineWidth', 2);
end

%% Median filtering 2.0

% Load the first image in the sequence
% folder = 'C:\Users\Dimuth Panditharatne\Desktop\Spring 2023\CS 766\MATLAB\ams\';
% folder = 'C:\Users\Dimuth Panditharatne\Desktop\Spring 2023\CS 766\MATLAB\ams-shaky-1\';
folder = 'C:\Users\Dimuth Panditharatne\Desktop\Spring 2023\CS 766\MATLAB\dam-shaky\';
filelist = dir([folder '*.jpg']);
I = imread([folder filelist(1).name]);

% Initialize the background buffer with the first image
numFrames = 10;
bgBuffer = zeros([size(I), numFrames]);
bgBuffer(:, :, :, 1) = double(I);

% Loop through the rest of the images
for i = 2:length(filelist)
    % Read the next image in the sequence
    I = imread([folder filelist(i).name]);
    
    % Update the background buffer with the current frame
    bgBuffer(:, :, :, mod(i-1, numFrames) + 1) = double(I);

    % Update the background model using the median filter
    bgModel = median(bgBuffer, 4);
end

% Compute the difference between the current frame and the background model
diffImage = imabsdiff(I, uint8(bgModel));

% Convert the difference image to grayscale and apply a threshold
diffImage = rgb2gray(diffImage);
threshold = 15;
foreground = diffImage > threshold;

% Apply morphological operations to the binary foreground image
se = strel('disk', 2);
foreground = imopen(foreground, se);
foreground = imclose(foreground, se);
foreground = imfill(foreground, 'holes');

% Display the final background and foreground images
subplot(1, 2, 1), imshow(uint8(bgModel)), title('Background');
subplot(1, 2, 2), imshow(foreground), title('Foreground');

% figure;
% imshow(composite_img);
imwrite(foreground, 'foreground_ams_shaky_median.png');
imwrite(uint8(bgModel), 'background_ams_shaky_median.png');