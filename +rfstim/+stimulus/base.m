classdef base < handle
    %RFSTIM.STIMULUS.BASE       Base class for stimulus modules.
    %

    properties(Access=protected,Hidden)
        Parent          % Parent application (rfstim.app).
        Component       % The component for this stimulus module.
        Config          % The configuration of this stimulus module.
    end

    properties(SetAccess=protected,GetAccess=public)
        Display         % Display data from parent app.
        Subject         % Subject data from parent app.
    end
    
    methods(Access = protected,Hidden)
        function mem = clearFields(obj,fields)
            %clearFields    Clear (and save) given fields.
            mem = struct();
            for i = 1:numel(fields)
                mem{i} = obj.(fields{i});
                obj.(fields{i}) = [];
            end
        end

        function restoreFields(obj,mem)
            %restoreFields  Restore field previously cleared (see saveFields).
            fn = fieldnames(mem);
            for i = 1:numel(fn)
                obj.(fn{i}) = mem.(fn{i});
            end
        end

        function enableRun(obj, value)
            %enable     Enable start/stop (in parent application).
            if nargin < 2
                value = true;
            end
            obj.Parent.enableRun(value);
        end

        function status(obj,fmt,varargin)
            try 
                if nargin == 1
                    obj.Parent.status();
                else
                    obj.Parent.status(fmt,varargin{:});
                end
            catch
            end
        end
    end

    methods
        function obj = base(parentapp)
            %base   Construct an instance of this class.
            obj.Parent = parentapp;
        end

        function save(obj,filename,varargin)
            %save       Save this object.
            RFstim = copy(obj);
            RFstim.clearFields({"Parent","Component","Config"});
            save(filename,'RFstim',varargin{:});
        end

        function startup(obj) %#ok<*MANU>
            %startup    Initialize GUI.
        end

        function reset(obj)
            %reset      Reset module.
        end

        function run(obj)
            %run        Run stimulus.
        end

        function pause(obj)
            %pause      Pause stimulus.
            warning("Stimulus cannot be paused (possibly not implemented).")
        end

        function stop(obj)
            %stop       Stop stimulus.
            warning("Stimulus cannot be stopped (possibly not implemented).")
        end

        function compute(obj)
            %compute    Compute stimulus.
        end
    end
end

