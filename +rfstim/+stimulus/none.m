classdef none < handle
    %RFSTIM.STIMULUS.NONE     Dummy module.
    
    methods(Static)
        function [label,order] = name()
            %NAME   Name and sorting priority.
            label = '(none)';
            order = -Inf;
        end
    end
    
    properties(Access=protected,Hidden)
        Config 
        Parent
        Component
    end

    methods
        function obj = none(parentapp) %#ok<*INUSD,*MANU>
            obj.Parent = parentapp;
            obj.Config = appconfig(obj.Parent.Config, 'stimulus.none');
        end

        function startup(obj) 
            %STARTUP    Initialize module.

            obj.Component = rfstim.stimulus.comp.none(obj.Parent.StimulusPanel);
        end
    end
end

