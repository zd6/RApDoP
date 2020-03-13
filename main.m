clear;clc;close all
pathdef_rapdop
LE_trails = 1;
n=10;
cons = {};
cons = [1,2,3,5;3,2,2,3;4,2,3,4;4,1,2,3; 1,3,3,4];
% cons = [1,2,0.1,0.2;3,2,0.2,0.5];
% cons = [1,40,0.5,0.8;1,3,0.1,0.4; 3,40,0.4,1.0];
consDic = containers.Map('KeyType', 'int32', 'ValueType', 'any');
if ~isempty(cons)
    for i = unique(cons(:,1:2))'
        consDic(i) = [];
        if i > n
            error('Constrains on non-existing circles')
        end
    end
    for i = 1:length(cons(:,1))
        con = cons(i,:);
        consDic(con(1)) = [consDic(con(1)); con(2) con(3) con(4)];
        consDic(con(2)) = [consDic(con(2)); con(1) con(3) con(4)];
    end
end

 
% DEFINE CONTOUR SHAPE AND ITS CONVEXITY

% pts = drawPoints;
% pts = [0 0.5 1; 0 0.866025 0];
% pts = [0 0 1 1; 0 1 1 0]; % unit square
% pts = [0,0,1,1,2,2,3,3,2,2,1,1;0,3,3,2,2,3,3,0,0,1,1,0]; %Fixed Shape H
% pts = [1,6,6,1;1,1,6,6]; %Fixed Square
% pts = [0,1,2,3,4,5,6,8.5,11,12,13,14,15,16,17,13.5,12,10,9,6.5,4;0,4,7,11,15,17,19,24,19,17,15,11,7,4,0,5.5,7,9.5,9,7,4]; %Fixed StarTrek
% pts = [0,0,1,1,2,2,0;0,2,2,1,1,0,0]; %L shape
pts = [6.27071823204420,1.33517495395948,1.77716390423573,8.53591160220994,9.86187845303867,9.08839779005525,6.67587476979742,8.79373848987109,8.51749539594843,7.46777163904236,3.19521178637201;3.37009803921569,3.90931372549020,9.08088235294118,9.79166666666667,5.50245098039216,1.28676470588236,1.33578431372549,2.34068627450981,7.07107843137255,5.01225490196079,4.79166666666667]
save('pts.mat', 'pts', 'n')
xt = pts(1,:);
xt = [xt xt(1)];
yt = pts(2,:);
yt = [yt yt(1)];



if ispolycw( pts(1,:),  pts(2,:))
    xt = flip(xt);
    yt = flip(yt);
end
convex = isConvex(xt,yt,length(xt)-1);
s = length(xt)-1;
shape = zeros(s,4);
for i = 1:s
    shape(i,:) = [xt(i) yt(i) xt(i+1) yt(i+1)];
end
ptsT = [pts'; pts(1,1) pts(1,2)];
polygon_check = lineSegmentIntersect([ptsT(1:s,:) ptsT(2:s+1,:)],shape);
if sum(polygon_check.intAdjacencyMatrix(:)) > 2*s+2
    disp(polygon_check.intAdjacencyMatrix)
    error('Shape not polygon: shape has intersecting edges.')
end


% INITIALIZE VARIABLES
    %[xc,yc] = GetPointsInside(n, xt, yt);
    max_xc = [];
    max_yc = [];
    isConvex = sum(convex) ==  s+1;
    LE_r_store = zeros(1,LE_trails);
    
    D = parallel.pool.DataQueue;
    global maxProgress
    maxProgress = [];
    global h
    h= waitbar(0, 'Please wait ...', 'Name', 'n-dispersion in progress');
    global N p r_prev
    N= LE_trails; p= 1; r_prev = 0;
   
    afterEach(D, @nUpdateWaitbar);
    disp('starting LE_trails')
    parfor i = 1:LE_trails
        LE_store(i) = Loosing_expansion(xt,yt,n,isConvex, cons, consDic);
        maxr = (max(LE_store(i).r));
        LE_r_store(i) = LE_store(i).r;
        send(D, maxr);
    end
    
    close(h)
    [max_r,idx] = max(LE_r_store);
    LE_r_store = sort(LE_r_store);
    LE_max = LE_store(idx);
    try_max = Loosing_expansion_go(xt, yt, LE_max, n, isConvex, cons, consDic);
    if try_max.r > max_r
        LE_max = try_max;
    end
    save('LE_store.mat','LE_store', 'max_r', 'LE_r_store', 'n')
    save('LE_max.mat','LE_max')
    clearvars LE_store
    
    GeneratePlotsWithForce(n, xt, yt, LE_max.xc, LE_max.yc, LE_max.r, LE_max.Csum, cons);
    figure(2)
    hist(LE_r_store);
    xlabel('radius brackets');
    ylabel('Frequency');
    title(strcat('r_{max} in ',int2str(LE_trails),' trails'))
    
    figure(3)
    plot(maxProgress(1,:), maxProgress(2,:))
    xlim = ([1,LE_trails]);
    xlabel('Iterations');
    ylabel('r_max at moment');
    title('maxProgress')
    
    function nUpdateWaitbar(maxr)
        global p N h r_prev
        global maxProgress
        if r_prev < maxr
            r_prev = maxr;
            maxProgress = [maxProgress [p;maxr]];
        end
        waitbar(p/N,h,sprintf('Iterations: %d/%d, current r_{max} = %5f',p, N, r_prev));
        p = p + 1;
    end
%     TMO_max = LE_max;
%     temp_r = TMO_max.r;
%     ite = 0;
%     while ite < TMO_trails
%         ite = ite + 1;
%         TMO_max = tryMoveOne(xt,yt,n,TMO_max.xc,TMO_max.yc,TMO_max.Csum,isConvex);
%         if TMO_max.r > temp_r
%             temp_r = TMO_max.r;
%             ite = ite - 1;
%         end
%     end
%     
%     GeneratePlotsWithForce(n, xt, yt, TMO_max.xc, TMO_max.yc, TMO_max.r,TMO_max.Csum);