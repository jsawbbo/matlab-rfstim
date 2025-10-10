classdef bboteensy < rfstim.sync.none   
    %RFSTIM.SYNC.BBOTEENSY     Custom Teensy USB-to-TTL sync gadget.
    %
    %   FIXME
    
    properties(SetAccess = protected)
        Handle = []
        Config
    end
    
    methods(Static)
        function [label,prio] = name()
            label = 'Custom Teensy (BBO)';
            prio = 0;
        end
    end

    methods
        function obj = bboteensy(parentapp)
            %TEENSY Construct an instance of this class
            obj@rfstim.sync.none(parentapp);
        end

        function res = open(obj,port)
            try
                obj.Handle = serialport(port,9600);
                res = true;
            catch
                res = false;
            end
        end

        function close(obj)
            try
                delete(obj.Handle)
            catch
            end

            obj.Handle = [];
        end

        function init(obj,pconfig)
            obj.Config = appconfig(pconfig, 'sync.bboteensy');

            % open port, if configure and possible
            port = obj.Config.get('port',[]);
            if ~isempty(port)
                if obj.open(port)
                    return
                end
            end

            % otherwise configure 
            ui = rfstim.sync.ui.bboteensy(obj,obj.Parent.UIFigure.Position);
            ui.wait();

            if ~ui.Result
                delete(ui);
                return
            end

            obj.open(ui.Port);
            delete(ui);
        end

        function res = good(obj)
            res = ~isempty(obj.Handle) && ishandle(obj.Handle);
        end
        
        function on(obj)
            write(obj.Handle, 255, 'uint8');
        end

        function off(obj)
            write(obj.Handle, 0, 'uint8');
        end
    end
end

