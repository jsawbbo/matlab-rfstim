function list = modules(path,subdir)
    %RFSTIM.UTIL.MODULES                List modules in given directory.
    %
    %

    list = struct(...
        module={},...       % M-file name
        label={}, ...       % module label
        order={});          % sorting order

    % list files
    files = dir(path);
    for i = 1:numel(files)
        if ~files(i).isdir
            [~,module,~] = fileparts(files(i).name);
            try
                [text,order] = rfstim.(subdir).(module).label();

                if isempty(list) || all(~strcmp({list.module}, module))
                    list(end+1).module = module; %#ok<AGROW>
                    list(end).label = text;
                    list(end).order = order;
                end
            catch 
                % not a module
            end
        end
    end

    % sort
    tmp = struct2table(list);
    tmp = sortrows(tmp, {'order','label'});

    list = table2struct(tmp);
end

