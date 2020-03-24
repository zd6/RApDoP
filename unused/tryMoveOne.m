%% Main Test Section
function max = tryMoveOne(xt,yt,n,xc,yc,Csum_old,isConvex) 
max_xcoord = xc;
max_ycoord = yc;
s = length(xt)-1;
[r,CtCVec,CtBVec,CC,CB] = GetStateGeometry(xc,yc,xt,yt,n,s,isConvex,-1);
r_max = r;
Csum_max = Csum_old;
rep.threshod = r/100000;
rep.muC = 0;%10000/n; 
rep.muB = 10000/s;
rep.muP = 10000/s;
rep.s = s;
Csum = GetRepulsionForce(n,CtCVec,CtBVec,CC,CB,r,rep);
for i = 1:n
    move = updateCircle(Csum, n, r, 1,1,0.001);
    Newxcoord = xc + move(:,1);
    Newycoord = yc + move(:,2);
    [rNew,~] = GetStateGeometry(Newxcoord,Newycoord,xt,yt,n,s,isConvex,-1);
    if r_max < rNew
        r_max = rNew;
        max_xcoord = Newxcoord;
        max_ycoord = Newycoord;
        Csum_max = Csum; 
        disp(rNew)
        GeneratePlotsWithForce(n,xt,yt,Newxcoord,Newycoord,rNew, Csum)
        pause(0)
    end
end 
max.r = r_max;
max.xc = max_xcoord;
max.yc = max_ycoord;
max.Csum = Csum_max;
end