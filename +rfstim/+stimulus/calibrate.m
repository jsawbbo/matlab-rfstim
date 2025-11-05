classdef calibrate < rfstim.stimulus.base
    %RFSTIM.STIMULUS.CALIBRATE  Monitor calibration.
    
    methods(Static)
        function [label,order] = label()
            %label      Label and sorting priority.
            label = 'Calibration';
            order = 0;
        end
    end
    
    methods
        function obj = calibrate(parentapp)
            %none   Construct an instance of this class.
            obj@rfstim.stimulus.base(parentapp);
            obj.Config = appconfig(obj.Parent.Config, 'stimulus.calibrate');
        end

        function startup(obj) 
            obj.Component = rfstim.stimulus.comp.calibrate(obj.Parent.ModulePanel);
        end
    end
end

