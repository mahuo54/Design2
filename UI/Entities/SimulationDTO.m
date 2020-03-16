classdef SimulationDTO
       
    properties
        Frequence(1,:) double;
        LinearDensity (1,:) double;
        Length (1,:) double;
                        
        Duration double; %Basta ya!
    end
    
    methods
        function obj = SimulationDTO()
        end
        function N = GetNumberOfSimulation(obj)
           N =  length(obj.Frequence)*length(obj.LinearDensity)*length(obj.Length);
        end
    end
end

