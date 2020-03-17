classdef SimulationParameter
    
    properties
        duration;
        f;
        
        M;
        L;
        b;
        N = 25;
        dt = 0.001 ;
       
        T_0 = 60;
        %Falta x_0, v_0
        
        pos_actuateur_relative = 0.75;
        pos_capteur_relative = 0.25;
        polarite = 180;%degree or rad        
    end
    methods
        function obj = SimulationParameter()
            
        end
    end
    
end
