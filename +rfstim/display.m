classdef display < handle
    %RFSTIM.DISPLAY     Display screen description and tools.
    %
    %   Details of the display screen used as stimulus.
    %
    
    properties
        Name                        % Display name (e.g. "Generic - XYZ123").
        Dimension                   % Rectangular panel dimensions (w×h mm).
        Resolution                  % Pixel resolution (w×h).
        Brightness = struct( ...    % Panel brightness (gray values vs. cd/mm²).
            Value = [],...
            Luminance = []);
        Source = []                 % INI file name.
        Driver = []                 % TBD may be used for curved displays
    end

    properties(Hidden)
        ptbHandle = []              % Psychtoolbox handle (window pointer).
        ptbRect = []                % ... and rectangle.
    end
    
    methods(Static)
        function [res,displays] = find()
            %FIND   Get all display descriptions.
            %
            %   This function returns known display names as well as the list of display descriptions.

            % get from local config file (possibly contains calibrated data)
            cfg = appconfig(Program = 'matlab-rfstim', File = 'displays.mat');
            displays = cfg.get('displays', []);

            if isempty(displays)
                displays = struct('name',{},'dimension',{},'resolution',{},'brightness',{},'source',{});
            end

            % complement from ini files
            inipath = fileparts(mfilename('fullpath'));
            inipath = fileparts(inipath);
            inipath = fullfile(inipath, 'data', 'displays');
            
            files = dir(inipath);
            for i = 1:numel(files)
                if ~files(i).isdir
                    ini = INI(File=fullfile(inipath,files(i).name));
                    
                    m = +ini.global;
                    m.brightness = +ini.brightness;
                    m.source = files(i).name;
                   
                    if ~any(strcmp({displays.source},files(i).name))
                        displays(end+1) = m; %#ok<AGROW>
                    end
                end
            end

            % save to local config
            cfg.set('displays',displays);
            cfg.save();

            % display names
            res = {displays.name};
        end
    end

    methods
        function obj = display(options)
            %DISPLAY    Construct an instance of this class
            arguments
                options.Name = []   % Display name.
            end

            if isempty(options.Name)
                obj.load('Generic');
            else
                obj.load(options.Name);
            end
        end

        function delete(obj)
            obj.close();
        end

        function load(obj, name)
            %LOAD   Load display parameters (by name).
            arguments
                obj rfstim.display
                name string
            end

            [~,displays] = rfstim.display.find();
            idx = find(strcmp({displays.name}, name));
            if isempty(idx)
                error(['Screen ''' char(name) ''' is not known.'])
            end

            obj.Name = displays(idx).name;
            obj.Dimension = displays(idx).dimension;
            obj.Resolution = displays(idx).resolution;
            obj.Brightness.Value = displays(idx).brightness.value;
            obj.Brightness.Luminance = displays(idx).brightness.luminance;
            obj.Source = displays(idx).source;
        end

        function save(obj,as_ini)
            %SAVE   Save display parameters.
            %
            arguments
                obj rfstim.display
                as_ini {mustBeNumericOrLogical} = false
            end

            % save as INI if requested
            if as_ini
                inipath = fileparts(mfilename('fullpath'));
                inipath = fileparts(inipath);
                inipath = fullfile(inipath, 'data', 'displays');

                % FIXME
            end
            
            % save in local configuration
            cfg = appconfig(Program = 'matlab-rfstim', File = 'displays.mat');
            displays = cfg.get('displays', []);
            
            self = struct(...
                name = obj.Name,...
                dimension = obj.Dimension,...
                resolution = obj.Resolution,...
                brightness = struct(...
                    value = obj.Brightness.Value,...
                    luminance = obj.Brightness.Luminance),...
                source = obj.Source);

            idx = find(strcmp({displays.name}, obj.Name));
            if isempty(idx)
                displays(end+1) = self;
            else
                displays(idx) = self;
            end

            cfg.set('displays',displays);
            cfg.save();
        end

        function res = open(obj, screenno, color)
            %OPEN   Open Psychtoolbox window.
            arguments
                obj rfstim.display
                screenno {mustBeInteger}                % Screen number.
                color {mustBeNumeric} = [0 0 0]         % Default color.
            end

            try
                [obj.ptbHandle, obj.ptbRect] = Screen('OpenWindow', screenno, color);
                res = true;
            catch
                warning(['Opening screen ' num2str(screenno) ' failed.' ])
                res = false;
            end
        end

        function close(obj)
            %CLOSE  Close Psychtoolbox screen.
            arguments
                obj rfstim.display
            end

            Screen('Close', obj.ptbHandle);
        end

        function [VBLTimestamp, StimulusOnsetTime, FlipTimestamp, Missed, Beampos] = flip(obj,options)
            %FLIP       PTB's Screen('Flip')
            arguments
                obj rfstim.display
                options.When = 0
                options.DontClear = 0
                options.DontSync = 0
                options.MultiFlip = 0
            end

            [VBLTimestamp, StimulusOnsetTime, FlipTimestamp, Missed, Beampos] = ...
                Screen('Flip', obj.ptbHandle, options.When, options.DontClear, options.DontSync, options.MultiFlip);
        end

        function fill(obj,color)
            %FILL       Fill screen (and set background color).
            Screen('FillRect', obj.ptbHandle, color);
        end

        function command(obj, what, varargin)
            %COMMANDS   PTB's Screen(what, windowPtr, ...)
            Screen(what, obj.ptbHandle, varargin{:});
        end
    end
end

