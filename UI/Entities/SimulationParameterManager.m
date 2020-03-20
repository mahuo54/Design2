classdef SimulationParameterManager
    properties
        Frequence(1,:) double;
        LinearDensity (1,:) double;
        Length (1,:) double;
                        
        Duration double; %Basta ya!
    end
    
    methods
        function obj = SimulationParameterManager()
        end
        function N = GetNumberOfSimulation(obj)
           N =  length(obj.Frequence)*length(obj.LinearDensity)*length(obj.Length);
        end
        function SimulationParametersArray = EnumerateSimulationParameters(obj)
            elements = {obj.Frequence, obj.LinearDensity, obj.Length}; %cell array with N vectors to combine
            combinations = SimulationParameterManager.GetCombinations(elements);
            for i = length(combinations):-1:1 
                %Parameters from combinations
                parameters = combinations(i,:);
                simParams = SimulationParameter();
                simParams.f_final = parameters(1);
                simParams.L = parameters(3);
                simParams.M = parameters(2)*parameters(3);
                
                %Fixed parameters from manager
                simParams.duration = obj.Duration;
                
                %Parameters not handled yet by UI
                simParams.b = 0;
                simParams.N = 25;
                simParams.dt = 0.001;
                simParams.T_0 = 60;
                simParams.pos_actuateur_relative = 0.76;
                simParams.pos_capteur_relative = 0.24;
                simParams.polarite = 180;%degree or rad  
        
                SimulationParametersArray(i) = simParams; % %Allocation starts at the end
            end
        end
    end
    
    methods (Access = private, Static = true)
        %https://www.mathworks.com/matlabcentral/answers/98191-how-can-i-obtain-all-possible-combinations-of-given-vectors-in-matlab
        function results = GetCombinations(elements)
            combinations = cell(1, numel(elements)); %set up the varargout result
            [combinations{:}] = ndgrid(elements{:});
            combinations = cellfun(@(x) x(:), combinations,'uniformoutput',false); %there may be a better way to do this
            results = [combinations{:}];
        end
    end
end

