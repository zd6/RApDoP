function res = npolygon_computation
% config.pts = [0 0 1 1; 0 1 1 0]; % unit square
config.n = 20;
config.trails = 500;
config.cons = [];
varTypes = {'int8','double','double','double','double','double','double','double','double','double','double','double'};
stat_table = table('Size', [50, 12], 'VariableTypes',varTypes,'VariableNames',...
    {'Num_Circle', 'Max_untuned', 'Mean_untuned','Median_untuned', 'Std_untuned','Range_untuned',...
                   'Max_tuned', 'Mean_tuned', 'Median_tuned', 'Std_tuned','Range_tuned','computational time'});
raw_data_tuned = [];
raw_data_untuned = [];
for i = 3:1:50
    pts = zeros(2, i);
    for j = 1:i
        pts(1,j) = cosd(360/i*j);
        pts(2,j) = sind(360/i*j);
    end
    config.pts = pts;
    starttime = tic();
    [res, untuned_r, tuned_r] = main_config(config);
    total = toc(starttime);
    raw_data_tuned = [raw_data_tuned;tuned_r];
    raw_data_untuned = [raw_data_untuned; untuned_r];
    untuned_stat = datastats(untuned_r');
    tuned_stat = datastats(tuned_r');
    stat_table(i,:) = {i, untuned_stat.max, untuned_stat.mean, untuned_stat.median, untuned_stat.std, untuned_stat.range, ...
        tuned_stat.max, tuned_stat.mean, tuned_stat.median, tuned_stat.std, tuned_stat.range, total};
    GeneratePlots(config.n, res.xt, res.yt, res.xc, res.yc, res.r, config.cons, i);
    save('.\test\Stat_result_npoly','stat_table')
    save('.\test\raw_result_nploy','raw_data_tuned', 'raw_data_untuned')
end
end