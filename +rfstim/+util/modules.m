function list = modules(path,subdir)
    %RFSTIM.UTIL.MODULES                List modules in given directory.
    %
    %

    list = struct(...
        'module',{},...         % M-file name
        'name',{}, ...          % module label
        'order',{});         % sorting order

    % list files
    files = dir(path);
    for i = 1:numel(files)
        if ~files(i).isdir
            [~,module,~] = fileparts(files(i).name);
            try
                [name,order] = rfstim.(subdir).(module).name();

                if isempty(list) || ~strcmp({list.module}, module)
                    list(end+1).module = module; %#ok<AGROW>
                    list(end).name = name;
                    list(end).order = order;
                end
            catch
            end
        end
    end

    % sort
    tmp = struct2table(list);
    tmp = sortrows(tmp, {'order','name'});

    list = table2struct(tmp);
end

