classdef none < handle
    %RFSTIM.SYNC.NONE     Dummy module.
    
    methods(Static)
        function [label,order] = name()
            %NAME   Name and sorting priority.
            label = '(none)';
            order = -Inf;
        end
    end
    
    properties(Access=protected,Hidden)
        Parent
    end

    methods
        function obj = none(parentapp) %#ok<*INUSD,*MANU>
            obj.Parent = parentapp;
        end

        function startup(obj,pconfig) 
            %STARTUP    Initialize module.
        end

        function res = good(obj)
            %GOOD       Check if module is working.
            res = false;
        end

        function on(obj)
            %ON         Set sync signal "high".
        end

        function off(obj)
            %OFF        Set sync signal "low".
        end

        function pulse(obj,t)
            %PULSE      Emit a pulse with given duration t (s).
            obj.on()
            pause(t)
            obj.off()
        end
    end
end

