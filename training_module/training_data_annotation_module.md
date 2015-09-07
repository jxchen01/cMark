# Training Data Annotation Module

The purpose of this module is to allow users to manually label certain pixels which can be used as training data, usually serving as the input of the following pixel-based learning algorithm. 

## input:  xxxx.mat


### rawEachFrame:

A 1-by-T cell array, each cell of which is a M-by-N matrix of the raw image. 

## output: xxx_training.mat

A 1-by-k cell array, where k is obtained from the user. The i-th cell in the array is a P(i)-by-3 matrix, entry row of which is the coordinate (x,y,t) of one pixel labeled as i. P(i) is total number of pixel with label i.

## functions:

###(1) type in the number of labels:
Namely, a user should tell the program the value of k in the outpur.

###(2) select pixels for each label with pickers of different sizes

For example, the user is selecting pixels for label i. Each time, the user click on one pixel, say p, in the image. Then, all pixels within the circel of radius R, centered at p will be labeled as i. Then, all these pixels will be saved in the form of (x,y,t), where t is the frame index. Then, the displayed figure should be updated immediately with the newly selected pixels labeled by the corresponding color of label i. 

Note 1: We cannot assume users have to work on each labels one by one. In other words, we should allow users to swith among different labels easily at any time.

Note 2: Do not use "plot" function. Use imshow instead. Refresh the figure, after each mouse click. The displayed pixels shoule be accuract. 

## useful functions

* se=strel('disk',R);
* imdilate(I,se);
* pixelList = cat(1,pixelList, newPixel)
* display red pixels on raw image:
    - raw= rawEachFrame{1};
    - ind = NewPixels; (suppose ind contains the index of all newly selected pixels)
    - r=raw; g=raw; b=raw; 
    - r(ind)=1; g(ind)=0; b(ind)=0;
    - rgb=cat(3,r,g,b);
    - imshow(rgb);
    - Comment: If the basic idea is the duplicate the raw image in the r,g,b channels and set certain pixels with desired value, such as [1,0,0] for red.
    








 