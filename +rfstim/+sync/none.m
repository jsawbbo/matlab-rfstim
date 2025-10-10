classdef none < handle
    %RFSTIM.SYNC.NONE     Dummy module.
    
    methods(Static)
        function [label,prio] = name()
            %NAME   Name and sorting priority.
            label = '(none)';
            prio = -Inf;
        end
    end
    
    methods
        function obj = none()
        end

        function init(obj,pconfig) %#ok<*INUSD,*MANU>
            %INIT       Initialize module.
        end

        function res = good(obj)
            %GOOD       Check if module is working.
            res = true;
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

