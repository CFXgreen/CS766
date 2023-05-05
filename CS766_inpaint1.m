% % Specify the video file name
% videoFile = 'rolling_tape_2.mp4';

% Specify the image and mask file names for inpainting
imageFile = 'diff_img.png';
maskFile = 'mask.png';

% % Create a VideoReader object
% videoReader = VideoReader(videoFile);
% 
% % Determine the total number of frames in the video
% num_images = videoReader.NumFrames;
% 
% % Preallocate a cell array to store the frames
% images = cell(1, num_images);
% 
% % Read each frame of the video and store it in the cell array
% for i = 1:num_images
%     images{i} = read(videoReader, i);
% end

% Load images
% img_list = {'frame_001.png', 'frame_002.png', 'frame_003.png', 'frame_004.png'};
img_list = {'ams_1.jpg', 'ams_2.jpg', 'ams_3.jpg'};
num_images = length(img_list);
% % Preallocate a cell array to store the frames
images = cell(1, num_images);
for i = 1:length(img_list)
    images{i} = imread(img_list{i});
end

% Computing SIFT matches between all pairs of images
impl = 'VLFeat';
xs_all = cell(num_images-1, 1);
xd_all = cell(num_images-1, 1);
for i = 1:num_images-1
    [xs, xd] = genSIFTMatches(images{i}, images{i+1}, impl);
    xs_all{i} = xs;
    xd_all{i} = xd;
end

% Combine all matches into a single set
xs = cat(1, xs_all{:});
xd = cat(1, xd_all{:});

% Use RANSAC to reject outliers
ransac_n = 75; % Max number of iterations
ransac_eps = 2; % Acceptable alignment error
[inliers_id, H_3x3] = runRANSAC(xs, xd, ransac_n, ransac_eps);

% Find the size of the output image
[h, w, ~] = size(images{1});
[cx, cy] = meshgrid(1:w, 1:h);
coords = [cx(:), cy(:), ones(numel(cx), 1)];
trans_coords = (H_3x3 * coords')';
tx = trans_coords(:,1) ./ trans_coords(:,3);
ty = trans_coords(:,2) ./ trans_coords(:,3);
tx = reshape(tx, [h, w]);
ty = reshape(ty, [h, w]);

% Compute the difference between each image and the composite image
composite_img = images{1};
for i = 2:num_images
    % warping current image to align with the composite image
    current_img = images{i};
    diff_img = zeros(size(current_img), 'like', current_img);
    for c = 1:size(current_img, 3)
        channel1 = interp2(double(current_img(:,:,c)), tx, ty, 'linear', 0);
        channel2 = interp2(double(composite_img(:,:,c)), cx, cy, 'linear', 0);
        diff_img(:,:,c) = abs(channel1 - channel2);
    end
    
    % Inpainting algorithm to remove object from difference image
    mask = im2double(diff_img) > 0.01;
    diff_img = im2double(diff_img);
    imwrite(diff_img, imageFile);

    mask_8bit = uint8(mask * 255); % Convert mask to 8-bit
    imwrite(mask_8bit, maskFile);

%     imwrite(mask, maskFile);
    diff_img_reconstructed = Inpainting(imageFile, maskFile);
    diff_img = uint8(diff_img_reconstructed*255);
    
    % Update composite image with difference image
    composite_img = imfuse(composite_img, diff_img, 'blend', 'Scaling', 'joint');
end

figure;
imshow(composite_img);
imwrite(composite_img, 'ams_inpaint_001p.png');