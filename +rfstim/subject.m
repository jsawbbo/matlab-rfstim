classdef subject < handle
    %RFSTIM.SUBJECT     Subject info.
    %
    %   Details of subject (animal), such as focal length of the eye,
    %   position with respect to the screen, etc.
    
    properties
        Name
        Eye = struct(...
            FocalLength = [])
        Source
    end

    properties
        Position = [0 0 200]           % Subject position (mm).
    end
    
    methods(Static)
        function [res,subjects] = find()
            %FIND   Get all subject descriptions.
            %
            %   This function returns known subject names as well as the list of subject descriptions.

            % get from local config file
            cfg = appconfig(Program = 'matlab-rfstim', File = 'subjects.mat');
            subjects = cfg.get('subjects', []);

            if isempty(subjects)
                subjects = struct('name',{},'eye',{},'source',{});
            end

            % complement from ini files
            inipath = fileparts(mfilename('fullpath'));
            inipath = fileparts(inipath);
            inipath = fullfile(inipath, 'data', 'subjects');
            
            files = dir(inipath);
            for i = 1:numel(files)
                if ~files(i).isdir
                    ini = INI(File=fullfile(inipath,files(i).name));
                    
                    m = +ini.global;
                    m.eye = +ini.eye;
                    m.source = files(i).name;
                   
                    if ~any(strcmp({subjects.source},files(i).name))
                        subjects(end+1) = m; %#ok<AGROW>
                    end
                end
            end

            % save to local config
            cfg.set('subjects',subjects);
            cfg.save();

            % display names
            res = {subjects.name};
        end        
    end

    methods
        function obj = subject(options)
            %SUBJECT Construct an instance of this class
            arguments
                options.Name = []   % Display name.
            end

            if isempty(options.Name)
                obj.load('Generic');
            else
                obj.load(options.Name);
            end
        end
        
        function load(obj, name)
            %LOAD   Load subject parameters (by name).
            arguments
                obj rfstim.subject
                name string
            end

            [~,subjects] = rfstim.subject.find();
            idx = find(strcmp({subjects.name}, name));
            if isempty(idx)
                error(['Subject ''' char(name) ''' is not known.'])
            end

            obj.Name = subjects(idx).name;
            obj.Eye.FocalLength = subjects(idx).eye.f;
            obj.Source = subjects(idx).source;
        end

        function save(obj)
            %SAVE   Save display parameters.
            %
            arguments
                obj rfstim.subject
            end

            % save in local configuration
            cfg = appconfig(Program = 'matlab-rfstim', File = 'subjects.mat');
            subjects = cfg.get('subjects', []);
            
            self = struct(...
                name = obj.Name,...
                eye = struct(...
                    value = obj.Eye.FocalLength),...
                source = obj.Source);

            idx = find(strcmp({subjects.name}, obj.Name));
            if isempty(idx)
                subjects(end+1) = self;
            else
                subjects(idx) = self;
            end

            cfg.set('subjects',subjects);
            cfg.save();
        end
    end
end

