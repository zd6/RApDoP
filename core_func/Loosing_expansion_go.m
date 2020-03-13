function LE_max = Loosing_expansion_go(xt,yt,prev_result,n,isConvex, cons, consDic)
xc = prev_result.xc;
yc = prev_result.yc;
pause(0.0)
LE_max.r = -1;
LE_max.xc = xc;
LE_max.yc = yc;
LE_max.Csum = [];
s = length(xt)-1;
rep.threshod = 0.01*prev_result.r;
rep.muB = 10000*s;
rep.muC = 10000*n;
rep.muP = 10000*s;
rep.s = s;
% fprintf('previously r is: %d\n', prev_result.r)
r_prev = -1*ones(1,10);
maxRatio = min(max(10,ceil(n/s)^0.5), 20);
ratio_list = [];
for i = flip(1:maxRatio)
    ratio_list = [1/(1.5^i) ratio_list];
    ratio_list = [ratio_list 1.5^i];
end
for ratio = ratio_list
    rep.muB = ratio*10000;
    rep.muC = 10000;
    rep.muP = ratio*10000;
%     fprintf('muB/muC: %d\n', rep.muB/rep.muC)
    ite = n+150;
    stp = 0.1;
    i = 1;
    curmax = -1;
    xc = LE_max.xc;
    yc = LE_max.yc;
    while i < ite
        [r,CtCVec,CtBVec,CC,CB] = GetStateGeometry(xc,yc,xt,yt,n,s,isConvex,mean(r_prev), isempty(cons));
        if r_prev(mod(i-1,10)+1) > r
            stp = stp/(1.02);
        end
        r_prev(mod(i,10)+1) = r;
        Csum = GetRepulsionForce(n,CtCVec,CtBVec,CC,CB,r,rep);
%         GeneratePlotsWithForce( n, xt , yt , xc , yc , r, Csum,cons)
        if n^3*var(r_prev) > r^2 && ite < 100*n
            ite = ite + 1;
        end
        if r > curmax
            curmax = r;
        end
        if LE_max.r < r
            LE_max.r = r;
            LE_max.xc = xc;
            LE_max.yc = yc;
            LE_max.Csum = Csum;
        end
        move = updateCircle(Csum,n ,r, stp);
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
    nUpdateWaitbar(LE_max.r)
%     fprintf('with above mus r is: %d\n', curmax)
end
% fprintf('after r is: %d\n', LE_max.r)
end