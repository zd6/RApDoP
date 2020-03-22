pathdef_rapdop
% config.pts = [0 0 1 1; 0 1 1 0]; % unit square

config.pts = drawPoints;
% pts = [0 0 1 1; 0 1 1 0]; % unit square
% pts = [0,0,1,1,2,2,3,3,2,2,1,1;0,3,3,2,2,3,3,0,0,1,1,0]; %Fixed Shape H
% pts = [1,6,6,1;1,1,6,6]; %Fixed Square
% pts = [0,4,8,4;0,4,0,8]; %Fixed StarTrek
% pts = [0,0,1,1,2,2,0;0,2,2,1,1,0,0]; %L shape
% pts = [6.27071823204420,1.33517495395948,1.77716390423573,8.53591160220994,9.86187845303867,9.08839779005525,6.67587476979742,8.79373848987109,8.51749539594843,7.46777163904236,3.19521178637201;3.37009803921569,3.90931372549020,9.08088235294118,9.79166666666667,5.50245098039216,1.28676470588236,1.33578431372549,2.34068627450981,7.07107843137255,5.01225490196079,4.79166666666667]
config.trails = 50;
config.cons = [];% [1 2 5 6;1,3,3,4];
max_data.r = [];
max_data.xc = {};
max_data.yc = {};
max_data.trails = [];
save('max.mat','max_data')
fig_count = 1;
config.p_list = [10];
for i = config.p_list
    config.n = i;
    LE_max = main_config(config);
    figure(fig_count)
    GeneratePlots(config.n, LE_max.xt, LE_max.yt, LE_max.xc, LE_max.yc, LE_max.r, config.cons, fig_count);
    fig_count = fig_count + 1;
end
load('max.mat','max_data')
disp(max_data.r)
