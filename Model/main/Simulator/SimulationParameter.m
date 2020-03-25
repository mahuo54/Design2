classdef SimulationParameter
    properties
        duration = 5;
        f_final = 220;
        f_start = 200;
        f_time_step = 3;
        dt = 0.0001;
        
        corde CordeParameter = CordeParameter();
            
        position_centre = 0.001;% 0.00143
        pos_actuateur_relative = 0.75;
        pos_capteur_relative = 0.25;
        polarite = 180;%degree or rad    
        
        isImpulseOn = false;
        impulse_relative_position = 0.5;
        
        actuateur_force_magnetique = 11.65;
        actuateur_circuitRL_s = 0.07668;
        
        capteur_R3 = 744.5;
        circuit_passe_haut = 0.000738;
        circuit_passe_bas = 0.0099;
        
        regulateur_gain = -0.0008936;
        
        servoclef_clef = -0.384;
        freq_mes_transfer = 0.1;
    end
    methods
        function obj = SimulationParameter()
            obj.corde.x_0 = 0.01;
        end
        function isValid = Validate(obj)
            if(length(obj.corde.x_0) ~= 1 && length(obj.corde.x_0) ~= obj.corde.N)
                isValid = false;
            elseif (length(obj.corde.v_0) ~= 1 && length(obj.corde.v_0) ~= obj.corde.N)
                isValid = false;
            elseif (obj.f_time_step < obj.duration)
                isValid = false;
            else
                isValid = true;
            end
                   
        end
    end
    
end
