# Segmentation Module

## input:  xxxx_seg.mat

### (1) cellEachFrame:

A 1-by-T cell array, each cell of which is a struct with the following keys:

* seg: a binary image (logical type), where all pixels with "true" indicate the whole object.
* size: a double value, showing the area of the object

~~* boundary: a k-by-2 matrix listing the boundary pixels of the object (circularly ordered). Each row is the (x,y)-coordinate of a boundary pixel
* other keys: child, parent, candi, inflow, outflow, relaxinCost, relaxOutCost, division, candi_child, candi_parent. These keys are only related to internal tracking algorithm. You don't need to care about them.~~
* 



### (2) matEachFrame:

A 1-by-T cell array, each cell of which is a M-by-N matrix showing the position of each object.

For example, all pixels with value p in matEachFrame{i} coorespondes to cellEachFrame{i}{p}.

### (3) rawEachFrame:

A 1-by-T cell array, each cell of which is a M-by-N matrix of the raw image. 

## output:  xxxx_seg.mat

### (1) cellEachFrame:

It has the same structure as the input, while "seg", "size"~~, and "boundary"~~ may be updated. 

~~Note: To get the boundary of "seg" (a binary image with only one object in it), use: 
bd=bwboundaries(seg,'nohole');
L=bd{1};
Then, L is the list of boundary pixels. ~~

### (2) matEachFrame:

It has the same structure as the input, while the values may be updated according to the changes. (For example, a new object is added or one object is cut into two.)

### (3) rawEachFrame:

Same as input.

## function:

* insert: allow users to add a new object
* modify: allow users to change the segmentation of a particular object
* delete: allow users to remove certain objects
* View +/-: allow users to go to the next or previous frame easily.
* Go To: allow users to go to a particular frame directly. 
* Raw Image: When conducting manual correction, present the raw image (grayscale) in a proper way to aid the examination.
* save/load: allow users to save partially corrected results or load previous work. 
* exit: allow users to quit the GUI. (Release memory!)
* Size parameter: allow user to enter the mininum size (no. of pixels) of an object. This is meant to automatically remove small connected components. 
* Extra two text fields: Leave two extra text fields on the interface, similar to the size parameter. We may need extra parameters to automatically prune the segmentation results.   



