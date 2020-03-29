# Operational Optimization research: RApDoP
Repulsion-Based Applied p-dispersion with Distance-Constraints of non-/convex Polygon
### Authors: Zhengguan Dai(Gary), Kathleen Xu, Melkior Ornik
#### requirement
MATLAB2018 or later; Save time by using MATLAB Parallel Computing Toolbox.
## Motivation
Motivated by the question of optimal facility placement, a classical variant of the p-dispersion problem seeks to place a fixed number of equally sized non-overlapping circles of maximal possible radius into a subset of the two-dimensional Euclidean space. This code is the implmentation of a repulsion based p-dispersion algorithm. 
## Functionality
Given a convex or non-convex simple (no side intersection) polygon, number of circles p, and distance contraints(upper and/or lower bound) on circle centers, the code will produce a sub-optimal maximizer of which maximize the circle radius of all circles given: all cirles share the same radius; all circles are not intersecting each other,; all circles are in the polygon, no circle overlap the boundary, and given constraints are satisfied.
## Running Instruction
Once you have downloaded the code, you will see a RApDop.m file at primary directory. This is an access point to the program. You have to run this file before digging into futher codes (if you wish to, of course). As you run the program, you would be prompt to configure your circle packing, please be ready to input the number of circles, the random starting point trails you would like to try, and the vertex of the polygon. If you had previously run the program, you have the option tp rerun the previous configuration without input anything. To specify contrains, go to RApDop.m and change variable 'config.cons'. You will have to put in a 2D array with first two columns inidicating the circles you would like to put contrains on (index start with 1 and max at circle numbers you want to put in the polygon), and the last two columns indicating the the upper and lower bound of the distance between the circle centers you give in the same row's first tow columns.
The returned x and y coordinates will be given in file max.mat's max.xc and max.yc variables, a figure will show the best circle packing we found and max radius will be printed in the command line and figure. 
## Disclaimer
This computational method doesn't solve the non-convex optimization non linear function so the result will be almost always sub-optimal.
All the files in this directory is created by Gary and Kathleen, except for a utility function /util/lineSegmentIntersect.m. It was adapted from U. Murat Erdem's code published at MathWorks File exchange website: https://www.mathworks.com/matlabcentral/fileexchange/27205-fast-line-segment-intersection. 
