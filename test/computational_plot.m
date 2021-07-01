
figure(100)
hold on; grid on;
ncircle = load('Stat_result_unit_square.mat');
comp = ncircle.stat_table(:,[1,12]);
comp(~comp.Num_Circle,:) = [];
plot(comp{:,1}, comp{:,2}, '.')

npoly = load('Stat_result_npoly.mat');
comp = npoly.stat_table(:,[1,12]);
comp(~comp.Num_Circle,:) = [];
plot(comp{:,1}, comp{:,2}, '*')

nonconv = load('Stat_result_noncov_new.mat');
comp = nonconv.stat_table(:,[1,12]);
comp(~comp.Num_Circle,:) = [];
plot(comp{:,1}, comp{:,2}, 'o')