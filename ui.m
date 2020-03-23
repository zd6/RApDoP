function config = ui
    if isfile('last_config.mat')
        load('last_config.mat', 'config')
        useLastConfig = questdlg(sprintf('Would you like to use last configuration? Circle: %d, Trails: %d.', config.n, config.trails),...
              'Detected a recent configuration file',...
              'Yes', 'No','Yes');
        switch useLastConfig
            case 'Yes'
                return
        end
        definput = {num2str(config.n),num2str(config.trails)};

    else
        definput = {'1','50'};
    end
    prompt = {'How many cirles?:','How many initialization random trails?'};
    dlgtitle = 'RApDop Basic Configuration';
    dims = [1 35];
    configChoice = inputdlg(prompt,dlgtitle,dims,definput);
    disp(str2num(configChoice{2}))
    config.n = str2num(configChoice{1});
    config.trails = str2num(configChoice{2});
    
    answer = questdlg('Would you like to draw a polygon w/ mouse or use .csv file?',...
                      'Getting start with a polygon',...
                      'Draw by mouse', 'Type in numbers','Draw by mouse');
    
    switch answer
        case 'Draw by mouse'    
            config.pts = drawPoints;
        case 'Type in numbers'
            prompt = {'Polygon vertice x Coords(numbers seperated by space):', 'Polygon Vertice y Coords(numbers seperated by space):'};
            dlgtitle = 'Polygon vertice';
            dims = [1 50];
            if isfile('last_config.mat')
                load('last_config.mat',config)
                definput = {str(config.pts(1)),str(config.pts(2))};
            else
                definput = {'0 1 1 0','0 0 1 1'};
            end
            answer = inputdlg(prompt,dlgtitle,dims,definput);
            config.pts = [str2num(answer{1});str2num(answer{2})];
            disp(config.pts)
    end
end