function max = Loosing_expansion(xt,yt,n,isConvex, cons, consDic)

% [xc,yc] = GetPointsInside(n, xt, yt);
[xc, yc] = ConstraintsHelper(xt, yt, n, isConvex, {});
% disp('start looking')
tries = 0;
% disp(checkCons(cons, xc, yc))

while ~checkCons(cons, xc, yc)% && tries < 100
    if tries > 10000
        pause(0.0)
        max.r = -1;
        max.xc = zeros(1,n);
        max.yc = zeros(1,n);
        max.Csum = [];
        disp('failed to find possible initialization')
        return
    end
    [xc,yc] = GetPointsInside(n, xt, yt);
    tries = tries + 1;
end 

% disp('found')
pause(0.0)
max.r = -1;
max.xc = xc;
max.yc = yc;
max.Csum = [];
s = length(xt)-1;
rep.threshod = 0.01;
rep.muB = 10000*s;
rep.muC = 10000*n;
rep.muP = 10000*s;
rep.s = s;

r_prev = 0;

ite = n+150;
stp = 0.3;
i = 1;
while i < ite
    [r,CtCVec,CtBVec,CC,CB] = GetStateGeometry(xc,yc,xt,yt,n,s,isConvex,r_prev, isempty(cons));
    r_prev = r;
    Csum = GetRepulsionForce(n,CtCVec,CtBVec,CC,CB,r,rep);
    if n^3*var(r_prev) > r^2 && ite < 100*n
        ite = ite + 1;
    end
    if max.r < r
        max.r = r;
        max.xc = xc;
        max.yc = yc;
        max.Csum = Csum;
    end
    move = updateCircle(Csum,n ,r, stp);
    % GeneratePlotsWithMove( n, xt , yt , xc , yc , r , move, cons)
    if ~isempty(cons)
        idx = cell2mat(consDic.keys());
        [~, forceRank] = sort(vecnorm(Csum(idx,:)'));
        idx = idx(forceRank);
        for cirNum = idx
            con = consDic(cirNum);
            NonCons = true;

            for j = 1:length(con(:,1))
                k = cirNum;
                c1 = [xc(k) yc(k)] + move(k,:);
                c2 = [xc(con(j,1)) yc(con(j,1))];
                dis = norm(c1 - c2);
                NonCons = NonCons && (dis >= con(j,2) && dis <=con(j,3));
            end
            if ~NonCons
                move(k,1) = 0;
                move(k,2) = 0;
            else
                xc(k) = xc(k) +  move(k,1);
                yc(k) = yc(k) +  move(k,2);
                move(k,1) = 0;
                move(k,2) = 0;
            end
        end
    end
    xc = xc + move(:,1);
    yc = yc + move(:,2);
    if ~checkCons(cons, xc, yc)
        disp('boundary about to brokern')
        return
    end
    i = i + 1;
end
end