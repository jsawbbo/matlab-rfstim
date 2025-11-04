classdef none < rfstim.stimulus.base
    %RFSTIM.STIMULUS.NONE     Dummy module.
    
    methods(Static)
        function [label,order] = label()
            %label      Label and sorting priority.
            label = '(none)';
            order = -Inf;
        end
    end
    
    methods
        function obj = none(parentapp)
            %none   Construct an instance of this class.
            obj@rfstim.stimulus.base(parentapp);
            obj.Config = appconfig(obj.Parent.Config, 'stimulus.none');
        end

        function startup(obj) 
            obj.Component = rfstim.stimulus.comp.none(obj.Parent.ModulePanel);
        end
    end
end

