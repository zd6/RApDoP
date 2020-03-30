function config = ui
    if isfile('last_config.mat')
        load('last_config.mat', 'config')
        useLastConfig = questdlg(sprintf('Would you like to use last configuration? Circle: %d, Trails: %d. Constains:%s', config.n, config.trails, mat2str(config.cons)),...
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
%     disp(str2num(configChoice{2}))
    configntmp = str2num(configChoice{1});
    configtrailstmp = str2num(configChoice{2});
    
    answer = questdlg('Would you like to draw a polygon w/ mouse or use .csv file?',...
                      'Getting start with a polygon',...
                      'Draw by mouse', 'Type in numbers','Draw by mouse');
    
    switch answer
        case 'Draw by mouse'    
            configptstmp = drawPoints;
        case 'Type in numbers'
            prompt = {'Polygon vertice x Coords(numbers seperated by space):', 'Polygon Vertice y Coords(numbers seperated by space):'};
            dlgtitle = 'Polygon vertice';
            dims = [1 50];
            if isfile('last_config.mat')
                load('last_config.mat','config')
                definput1 = mat2str(config.pts(1,:));
                definput2 = mat2str(config.pts(2,:));
                definput = {definput1(2:end-1),definput2(2:end-1)};
            else
                definput = {'0 1 1 0','0 0 1 1'};
            end
            answer = inputdlg(prompt,dlgtitle,dims,definput);
            configptstmp = [str2num(answer{1});str2num(answer{2})];
%             disp(config.pts)
    end
    
    answer = questdlg('Would you want any hard distance constrains on circles?',...
                  'Constraints',...
                  'No constraints', 'Yes, put constriants', 'No constraints');
    switch answer
        case 'No constraints'
            configconstmp = [];
        case 'Yes, put constriants'
            prompt = {'Input Constrains as matrix as in [circle1(index) circle2(index) distance(lower bound) distance(upper bound)], eg.:[1 2 3 4] will limit the center distance between circle 1 and 2 within 3 to 4'};
            dlgtitle = 'Polygon vertice';
            dims = [5 50];
            if isfile('last_config.mat')
                load('last_config.mat','config')
                definput = {mat2str(config.cons)};
            else
                definput = {'0 1 1 0','0 0 1 1'};
            end
            tmpanswer = inputdlg(prompt,dlgtitle,dims,definput);
            configconstmp = str2num(tmpanswer{1});
    end
    
    config.n = configntmp;
    config.trails = configtrailstmp;
    config.cons = configconstmp;
    config.pts = configptstmp;
end