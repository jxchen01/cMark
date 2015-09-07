# Tracking Module

## input:  xxxx_track.mat

### (1) cellEachFrame:

A 1-by-T cell array, each cell of which is a struct with the following keys:


* seg: a binary image (logical type), where all pixels with "true" indicate the whole object.



* size: a double value, showing the area of the object
* ~~boundary: a k-by-2 matrix listing the boundary pixels of the object (circularly ordered). Each row is the (x,y)-coordinate of a boundary pixel~~


* id: an integer value, indicating the identity of this object. 



* ~~child: a k-by-1 matrix indicating the daugher cells. Usually, k=1. When cell division occurs (such as mitosis), k could be 2 or 3. For example, cellEachFrame{5}{10}.child=[9,12]; It means cellEachFrame{6}{9} and cellEachFrame{6}{12} are the corresponding daughter cells.~~

* ~~parent: a k-by-1 matrix indicating the mother cells. In all cases of our applications, k=1, because cell fusion does not exist in our problem. But, we want to make the program general to all types of cell tracking problems. So, we should take the cases of k>1 into consideration. ~~

* child: a k-by-2 matrix indicating the daughter cells. Usually, k=1. When cell division occurs (such as mitosis), k could be 2 or 3. For example, cellEachFrame{5}{10}.child=[6,12; 6,15];It means cellEachFrame{6}{12} and cellEachFrame{6}{15} are the corresponding daughter cells, whose have the same id with cellEachFrame{5}{10}. 

       
* parent: a 1-by-2 matrix indicating the mother cells. For example, cellEachFrame{5}{10}.parent=[2,9]. It means cellEachFrame{2}{9} is the mother cell, with the same id. 


* ~~other keys: candi, inflow, outflow, relaxinCost, relaxOutCost, division, candi_child, candi_parent. These keys are only related to internal tracking algorithm. You don't need to care about them.~~


### (2) matEachFrame:

A 1-by-T cell array, each cell of which is a M-by-N matrix showing the position of each object.

For example, all pixels with value p in matEachFrame{i} coorespondes to cellEachFrame{i}{p}.

### (3) idEachFrame:

A 1-by-T cell array, each cell of which is a M-by-N matrix showing the id of each object.

For example, all pixels with value p in idEachFrame{i} correspondes to cellEachFrame{i}{j}, where cellEachFrame{i}{j}.id=**p**;


### (4) rawEachFrame:

A 1-by-T cell array, each cell of which is a M-by-N matrix of the raw image. 

## Output: xxxx_track.mat

### (1) cellEachFrame:

It has the same structure as the input, while "id", "child", and "parent" may be updated. If segmentation errors are found, "seg",~~"boundary",~~"size" may be updated. 

~~Note: To get the boundary of "seg" (a binary image with only one object in it), use: 
bd=bwboundaries(seg,'nohole');
L=bd{1};
Then, L is the list of boundary pixels.~~

### (2) matEachFrame:

If not segmentation error is found, then this variable should keep unchagned. Otherwise, it has the same structure as the input, while the values may be updated according to the changes. (For example, one object is cut into two.)

### (3) idEachFrame:

**Must be updated according to the modification of tracking results.**

## function:

* View +/-:  allow users to go to the next or previous frame easily.
* Go To: allow users to go to a particular frame directly. 
* Delete relation: disconnect the correspondence between two objects.
* Add relation: build the correspondence between two objects
* save/load: allow users to save partially corrected results or load previous work. 
* exit: allow users to quit the GUI. (Release memory!)

Note:

* Add/delete relation, Be careful. Relation includes an object leaves and enters the image, i.e. NULL matches to an object or an object matches to NULL. Moreover, when one object divides, update child/parent correctly.
* It is important to design a nice way to visualize the tracking results, such as a decent layout, or a mice multi-channel image, or some other details that can help user experience. 

