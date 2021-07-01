function pathdef_rapdop
    cur_dir = pwd;
    if ispc
        addpath(sprintf('%s%s',cur_dir,'\geometry'))
        addpath(sprintf('%s%s',cur_dir,'\util'))
        addpath(sprintf('%s%s',cur_dir,'\rep_calc'))
        addpath(sprintf('%s%s',cur_dir,'\core_func'))
        addpath(sprintf('%s%s',cur_dir,'\test'))
    elseif ismac
        addpath(sprintf('%s%s',cur_dir,'/geometry'))
        addpath(sprintf('%s%s',cur_dir,'/util'))
        addpath(sprintf('%s%s',cur_dir,'/rep_calc'))
        addpath(sprintf('%s%s',cur_dir,'/core_func'))
        addpath(sprintf('%s%s',cur_dir,'/test'))
    end
end