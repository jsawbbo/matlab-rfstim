function list = modules(path)
    %RFSTIM.UTIL.MODULES                List modules in given directory.
    %
    %

    list = struct(...
        'module',{},...         % M-file name
        'name',{}, ...          % module label
        'priority',{});         % sorting priority

    % list files
    files = dir(path);
    for i = 1:numel(files)
        if ~files(i).isdir
            [~,module,~] = fileparts(files(i).name);
            try
                [name,priority] = rfstim.sync.(module).name();

                if isempty(list) || ~strcmp({list.module}, module)
                    list(end+1).module = module; %#ok<AGROW>
                    list(end).name = name;
                    list(end).priority = priority;
                end
            catch
            end
        end
    end

    % sort
    tmp = struct2table(list);
    tmp = sortrows(tmp, {'priority','name'});

    list = table2struct(tmp);
end

