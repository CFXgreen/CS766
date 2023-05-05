# CS766 Computer Vision Final Project

############################ Object Removal #####################################
#################################################################################

Simple Background Subtraction
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
One approach to remove moving objects from a scene is to use background subtraction. The idea behind background subtraction is to estimate the background of the scene by computing a model of the static parts of the image and then subtracting this model from the input image to obtain the moving objects. Note that this approach assumes that the camera is stationary and that the moving objects in the scene do not occlude each other.

Median Filtering
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Background subtraction can be improved using a median filter to estimate the background model, which should be more robust to variations in the scene. We then use an adaptive thresholding technique to segment the foreground. The resulting foreground is shown overlaid on the input image, along with the final background image. By adjusting the threshold value and other parameters the desired result can be achieved for a specific application.
To improve the background subtraction results using the median filtering method, we can use the following techniques:
    1)	Increase the number of frames used for computing the median background model. This can help capture the actual background better and reduce the chances of         including foreground objects in the background model.
    2)	Apply morphological operations to the binary foreground image to remove noise, fill holes, and smooth object boundaries.
    3)	Apply a threshold to the difference image before converting it to binary to reduce noise and shadows.
This code creates a background buffer, updates it with each new frame, and computes the median background model. It then computes the difference between the current frame and the background model, applies a threshold, and performs morphological operations on the binary foreground image to improve the results. Finally, it displays the background and foreground images.

################################################################################
Object Removal and Image Alignment
################################################################################

Median filtering, SIFT and RANSAC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
One possible approach to align images is by using SIFT and RANSAC. These methods along with median filtering can remove moving objects from a scene with unstable camera capture. With this approach it was challenging to get and good background image. For improvement the algorithm was tested with a sliding window approach to create the background model. Instead of using all images for the background model, you could use a subset of the images. This can help adapt the background model to changes caused by camera shake more effectively.
Feel free to adjust the windowSize variable to see if it improves the results. Keep in mind that a smaller window size will result in a background model that adapts more quickly to changes, but it may also be more sensitive to noise. A larger window size will result in a more stable background model, but it may be less responsive to changes caused by camera shake.

Median Filtering and Optical Flow
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
An alternative approach to image stabilization is ‘Optical flow’. This technique was implemented using Lucas-Kanade method. This method, known as the pyramidal Lucas-Kanade method, can better handle larger displacements between frames.
*Parameters to adjust: numFrames and threshold

Median Filtering and Crossnorm
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Another alternative technique is using ‘crossnorm’ which is a technique used to normalize feature vectors obtained from images. For the set of images ‘dam-shaky’ given that the displacements due to camera shake are not large, this simpler approach that relies on image registration based on cross-correlation was used. The idea is to compute the cross-correlation between the reference image and the current image to estimate the relative shift between them. This method provided satisfactory results as shown below. 
*Parameters to adjust: numFrames and threshold



Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
numFrames - is a variable that determines the size of the buffer that stores stabilized images. It represents the number of frames used for calculating the background model using the median filter.

threshold - is a variable used for foreground detection is used to separate the foreground objects from the background.

windowSize - a smaller window size will result in a background model that adapts more quickly to changes, but it may also be more sensitive to noise. A larger window size will result in a more stable background model, but it may be less responsive to changes caused by camera shake.

