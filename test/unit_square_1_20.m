function unit_square_1_20
config.pts = [0 0 1 1; 0 1 1 0]; % unit square
config.trails = 500;
config.cons = [];
varTypes = {'int8','double','double','double','double','double','double','double','double','double','double','double'};
stat_table = table('Size', [20, 12], 'VariableTypes',varTypes,'VariableNames',...
    {'Num_Circle', 'Max_untuned', 'Mean_untuned','Median_untuned', 'Std_untuned','Range_untuned',...
                   'Max_tuned', 'Mean_tuned', 'Median_tuned', 'Std_tuned','Range_tuned','computational time'});
raw_data_tuned = [];
raw_data_untuned = [];
for i = 1:50
    config.n = i;
    starttime = tic();
    [~, untuned_r, tuned_r] = main_config(config);
    total = toc(starttime);
    raw_data_tuned = [raw_data_tuned;tuned_r];
    raw_data_untuned = [raw_data_untuned; untuned_r];
    untuned_stat = datastats(untuned_r');
    tuned_stat = datastats(tuned_r');
    stat_table(i,:) = {i, untuned_stat.max, untuned_stat.mean, untuned_stat.median, untuned_stat.std, untuned_stat.range, ...
        tuned_stat.max, tuned_stat.mean, tuned_stat.median, tuned_stat.std, tuned_stat.range, total};
    save('.\test\Stat_result_unit_square','stat_table')
    save('.\test\raw_result_unit_square','raw_data_tuned', 'raw_data_untuned')
end
end