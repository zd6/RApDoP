% recursively add files in root folder to MATLAB 
pathdef_rapdop

% create empty result file
max_data.r = [];
max_data.xc = {};
max_data.yc = {};
max_data.trails = [];
save('max.mat','max_data')

% testing computational cost of: 
%% dispersing 20 circles in a unit square
unit_square_1_20

%% dispersing 20 circles in a L shape
unit_L_1_20

%% dispersing 20 circles in a n sides convex polygons
npolygon_computation

%% dispersing 20 circles in a n//2 star non convex polygons
non_convex_npolygon_computation