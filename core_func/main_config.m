function LE_max = main_config(config)
% clear;close all

n = config.n;
LE_trails = config.trails;
pts = config.pts;
cons = config.cons;
consDic = consDicHelper(cons,n);

% DEFINE CONTOUR SHAPE AND ITS CONVEXITY

% save('pts.mat', 'pts', 'n')
xt = pts(1,:);
xt = [xt xt(1)];
yt = pts(2,:);
yt = [yt yt(1)];


if ispolycw( pts(1,:),  pts(2,:))
    xt = flip(xt);
    yt = flip(yt);
end
convex = isPolyConvex(xt,yt,length(xt)-1);
s = length(xt)-1;
shape = zeros(s,4);
for i = 1:s
    shape(i,:) = [xt(i) yt(i) xt(i+1) yt(i+1)];
end
% ptsT = [pts'; pts(1,1) pts(1,2)];
% polygon_check = lineSegmentIntersect([ptsT(1:s,:) ptsT(2:s+1,:)],shape);
% if sum(polygon_check.intAdjacencyMatrix(:)) > 2*s+2
%     disp(polygon_check.intAdjacencyMatrix)
%     error('Shape not polygon: shape has intersecting edges.')
% end


% INITIALIZE VARIABLES
isConvex = sum(convex) ==  s+1;
LE_r_store = zeros(1,LE_trails);

% WaitBar initialization
D = parallel.pool.DataQueue;
global h
h= waitbar(0, 'Please wait ...', 'Name', sprintf('%d-dispersion in progress',n));
global N p r_prev
N= LE_trails + min(max(10,ceil(n/s)^0.5), 20)*2; p= 1; r_prev = 0;
afterEach(D, @nUpdateWaitbar);

% Loosing Expansion trails to get optimal circle placing
parfor i = 1:LE_trails
    LE_store(i) = Loosing_expansion(xt, yt, n, isConvex, cons, consDic);
    maxr = (max(LE_store(i).r));
    LE_r_store(i) = LE_store(i).r;
    send(D, maxr);
end


[max_r,idx] = max(LE_r_store);
% LE_r_store = sort(LE_r_store);
LE_max = LE_store(idx);

% Further attempts to maximize radium by changing mu
try_max = Loosing_expansion_go(xt, yt, LE_max, n, isConvex, cons, consDic);
if try_max.r > max_r
    LE_max = try_max;
end
LE_max.xt = xt;
LE_max.yt = yt;
clearvars LE_store

% updating output file
load('max.mat', 'max_data')
max_data.r = [max_data.r LE_max.r];
max_data.xc{end+1} = LE_max.xc;
max_data.yc{end+1} = LE_max.yc;
max_data.trails = [max_data.trails idx];
save('max.mat', 'max_data');    
close(h)
end 
   
