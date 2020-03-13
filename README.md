# RApDoP
Repulsion-Based Applied p-dispersion with Distance-Constraints of non-/convex Polygon
### Authors: Zhengguan Dai(Gary), Kathleen Xu, Melkior Ornik
#### requirement
MATLAB2018 or later; Save time by enable MATLAB Parallel Computing Toolbox.
## Motivation
Motivated by the question of optimal facility placement, a classical variant of the p-dispersion problem seeks to place a fixed number of equally sized non-overlapping circles of maximal possible radius into a subset of the two-dimensional Euclidean space. This code is the implmentation of a repulsion based p-dispersion algorithm. 
## Functionality
Given a convex or non-convex simple (no side intersection) polygon, number of circles p, and distance contraints(upper and/or lower bound) on circle centers, the code will produce a sub-optimal maximizer of which maximize the circle radius of all circles given: all cirles share the same radius; all circles are not intersecting each other,; all circles are in the polygon, no circle overlap the boundary, and given constraints are satisfied.
## Running Instruction
