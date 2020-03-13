clear;clc;
xc = [6.28997481131802;2.47786370909369;7.45668684000735;3.94704270167068;2.28989311347058;2.85120258095563;5.17202454305015;7.96819200310681;4.56003845591546;6.41226119664384];
yc = [8.52838061889383;6.61195249925297;7.11519580059360;5.73646944856616;4.83702067268404;8.27011289194586;6.92779662893819;8.74648196205974;8.51249638729755;5.78570580998412];
xt = [6.27071823204420,3.19521178637201,7.46777163904236,8.51749539594843,8.79373848987109,6.67587476979742,9.08839779005525,9.86187845303867,8.53591160220994,1.77716390423573,1.33517495395948,6.27071823204420];
yt = [3.37009803921569,4.79166666666667,5.01225490196079,7.07107843137255,2.34068627450981,1.33578431372549,1.28676470588236,5.50245098039216,9.79166666666667,9.08088235294118,3.90931372549020,3.37009803921569];
n = 10;
isConvex = 0;
max.r = 0.826844648181720;
max.xc = xc;
max.yc = yc;
max.Csum = [];
s = length(xt)-1;
rep.threshod = 0.1;
rep.muB = 10000/s;
rep.muC = 10000/n; 
rep.muP = 10000/s;
rep.s = s;

r_prev = -1*ones(1,10);

ite = n+150;
stp = 0.03;
i = 1;
mov_mem = 5;
move_prev = zeros(n,2,mov_mem);
while i < ite
    [r,CtCVec,CtBVec,CC,CB] = GetStateGeometry(xc,yc,xt,yt,n,s,isConvex,mean(r_prev));
    if r_prev(mod(i-1,10)+1) > r
        stp = stp/1.03;
    end
    r_prev(mod(i,10)+1) = r;
    Csum = GetRepulsionForce(n,CtCVec,CtBVec,CC,CB,r,rep);
    GeneratePlotsWithForce(n, xt, yt, xc, yc, r,Csum);
    if n^3*var(r_prev) > r^2 && ite < 500
        ite = ite + 1;
    end
    if max.r < r
        max.r = r;
        max.xc = xc;
        max.yc = yc;
        max.Csum = Csum;
    end
    move = updateCircle(Csum,n ,r ,1,100,stp);
    move_prev(:,:,mod(i,3)+1) = move;
    if i > mov_mem
        tmp = mean(move_prev,3);
        move = squeeze(tmp);
    end
    xc = xc + move(:,1);
    yc = yc + move(:,2);
    i = i + 1;
    max = tryMoveOne(xt,yt,n,xc,yc,Csum,isConvex);
    xc = max.xc;
    yc = max.yc;
    Csum = max.Csum;
    r = max.r;
end