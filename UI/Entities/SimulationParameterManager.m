classdef SimulationParameterManager < handle
    properties %Might want to organize them. It's just really messy in Matlab
        Frequence_final(1,:) double;
        dt(1,:) double;
       
        position_centre (1,:) double;
        pos_actuateur_relative (1,:) double;
        pos_capteur_relative (1,:) double;
        polarite (1,:) double;%degree or rad ??? don't know where it is in the model yet.   
                
        LinearDensity (1,:) double;
        Length (1,:) double;
        frottement (1,:) double;
        N (1,:) int16;
        T_0 (1,:) double;
        
        %On met un vecteur et si ce n'est pas un scalaire, on prend les N
        %premiers termes (N pouvant changer...)
        x_0 (1,:) double; %Semble pertinent seulement pour une seule simulation, difficile de faire un array d'array dans le UI...
        v_0 (1,:) double;
        
        Duration double; %Basta ya!        
        Frequence_initial double;
        Frequence_time_step double;
    end
    
    methods
        function obj = SimulationParameterManager()
        end
        
        function N = GetNumberOfSimulation(obj)
           N =  length(obj.Frequence_final			)*...
                length(obj.dt						)*...	
                length(obj.position_centre 			)*...
                length(obj.pos_actuateur_relative 	)*...	
                length(obj.pos_capteur_relative 	)*...	
                length(obj.polarite 				)*...	
                length(obj.LinearDensity 			)*...	
                length(obj.Length 					)*...	
                length(obj.frottement 				)*...	
                length(obj.N 						)*...	
                length(obj.T_0 						);
        end
        
        function SetToDefault(obj)
            obj.Frequence_final = 220;
            obj.dt = 0.0001;
            
            obj.position_centre = 0.01;
            obj.pos_actuateur_relative = 0.25 ;
            obj.pos_capteur_relative = 0.75;
            obj.polarite = 180;
            
            obj.LinearDensity = 0.00745;
            obj.Length = 0.443;
            obj.frottement = 0.002; %What was it again?
            obj.N = 25;
            obj.T_0 = 60;

            obj.x_0 = 0;
            obj.v_0 = 0;
            
            obj.Duration = 7;
            obj.Frequence_initial = 200;
            obj.Frequence_time_step = 3;
        end
        
        function SimulationParametersArray = EnumerateSimulationParameters(obj)
            elements = {obj.Frequence_final	,...
                obj.dt						,...
                obj.position_centre 		,...
                obj.pos_actuateur_relative 	,...
                obj.pos_capteur_relative 	,...
                obj.polarite 				,...
                obj.LinearDensity 			,...
                obj.Length 					,...
                obj.frottement 				,...
                double(obj.N) 				,...
                obj.T_0          }; %cell array with N vectors to combine
            combinations = SimulationParameterManager.GetCombinations(elements);
            for i = size(combinations,1):-1:1 %Allocation starts at the end
                parameters = combinations(i,:);
                
                simParams = SimulationParameter();         
                simParams.duration = obj.Duration;
                simParams.f_final = parameters(1);
                simParams.f_start = obj.Frequence_initial;
                simParams.f_time_step = obj.Frequence_time_step;
                simParams.dt = parameters(2);
                simParams.corde = CordeParameter();
                simParams.corde.L = parameters(8);
                simParams.corde.M = parameters(7)*parameters(8);
                               
                simParams.corde.b = parameters(9);
                simParams.corde.N = parameters(10);
                simParams.corde.T_0 = parameters(11);
                simParams.pos_actuateur_relative = parameters(4);
                simParams.pos_capteur_relative = parameters(5);
                simParams.polarite = parameters(6);%degree or rad  
                simParams.position_centre = parameters(3);
                
                SimulationParametersArray(i) = simParams; 
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

