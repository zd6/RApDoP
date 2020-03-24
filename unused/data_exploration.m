clear
clc
close all
load('LE_store.mat')
load('pts.mat')
[sorted_r, sorted_idx] = sort(LE_r_store);
figure(1)
hist(sorted_r);
figure(2)
%pause(0.2)
hold off
xt = pts(1,:);
xt = [xt xt(1)];
yt = pts(2,:);
yt = [yt yt(1)];
plot(xt, yt,'LineWidth',2) % polygon
axis equal
hold on
% Largest_idx = sorted_idx(length(sorted_r)-floor(h(end)/2):length(sorted_r));
Largest_idx = sorted_idx(length(sorted_r)/20*19:length(sorted_r));
xcp = [];
ycp = [];
for i = Largest_idx
    xcp = [xcp LE_store(i).xc'];
    ycp = [ycp LE_store(i).yc'];
end
for i = 1:length(xcp)
    plot(xcp(i),ycp(i),'*')
    xlim([min(xt)-1,max(xt)+1])
    ylim([min(yt)-1,max(yt)+1])
    [xcc, ycc] = circle([xcp(i) ycp(i)], LE_r_store(floor((i-1)/n)+1), 100);
    plot(xcc, ycc)
    hold on
end
LE_max.xc = [LE_store(sorted_idx(end)).xc];
LE_max.yc = [LE_store(sorted_idx(end)).yc];
for i = 1:n
    [xcc, ycc] = circle([LE_max.xc(i) LE_max.yc(i)], sorted_r(end), 1000);
    plot(xcc, ycc)
    plot(LE_max.xc(i),LE_max.yc(i), 'ro')
    hold on
    drawnow
end
    
