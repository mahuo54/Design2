classdef SimulationParameter
    properties
        duration = 5;
        f_final = 220;
        f_start = 200;
        f_time_step = 4;
        dt = 0.0001;
        
        corde CordeParameter = CordeParameter();
              
        position_centre = 0.001;% 0.00143
        pos_actuateur_relative = 0.75;
        pos_capteur_relative = 0.25;
        polarite = 180;%degree or rad    
        
        isImpulseOn = true;
        impulse_relative_position = 0.5;
    end
    methods
        function obj = SimulationParameter()
        end
        function isValid = Validate(obj)
            if(length(obj.x_0) ~= 1 && length(obj.x_0) ~= obj.N)
                isValid = false;
            elseif (length(obj.v_0) ~= 1 && length(obj.v_0) ~= obj.N)
                isValid = false;
            elseif (obj.f_time_step < obj.duration)
                isValid = false;
            else
                isValid = true;
            end
                   
        end
    end
    
end
