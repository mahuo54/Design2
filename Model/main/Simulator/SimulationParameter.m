classdef SimulationParameter
    properties
        duration = 10;
        f_final = 120;
        f_start = 100;
        f_time_step = 4;
        
        M = 0.0031;
        L;
        b;
        N = 25;
        dt = 0.0001 ;
       
        T_0 = 60;
        x_0 = 0;
        v_0 = 0;
        position_centre = 0.00143;
        
        pos_actuateur_relative = 0.75;
        pos_capteur_relative = 0.25;
        polarite = 180;%degree or rad        
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
