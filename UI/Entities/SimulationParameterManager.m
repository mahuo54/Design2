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
        
        actuateur_force_magnetique (1,:) double;
        actuateur_circuitRL_s  (1,:) double;
        capteur_R3  (1,:) double;
        circuit_passe_haut  (1,:) double;
        circuit_passe_bas  (1,:) double;        
        regulateur_gain  (1,:) double;        
        servoclef_clef  (1,:) double;
        freq_mes_transfer  (1,:) double;
        
        %% Pas un array
        %On met un vecteur et si ce n'est pas un scalaire, on prend les N
        %premiers termes (N pouvant changer...)
        x_0 (1,:) double; %Semble pertinent seulement pour une seule simulation, difficile de faire un array d'array dans le UI...
        v_0 (1,:) double;
        
        isImpulseOn logical;
        impulse_relative_position double;
        
        Duration double; %Basta ya!        
        Frequence_initial double;
        Frequence_time_step double;
    end
    
    methods
        function obj = SimulationParameterManager()
            obj.SetToDefault();
        end
        
        function N = GetNumberOfSimulation(obj)
           N =  length(obj.Frequence_final				)*...
               length(obj.dt                           )*...
               length(obj.position_centre              )*...
               length(obj.pos_actuateur_relative       )*...
               length(obj.pos_capteur_relative         )*...
               length(obj.polarite                     )*...
               length(obj.LinearDensity                )*...
               length(obj.Length                       )*...
               length(obj.frottement                   )*...
               length(obj.N                            )*...
               length(obj.T_0                          )*...
               length(obj.actuateur_force_magnetique   )*...
               length(obj.actuateur_circuitRL_s        )*...
               length(obj.capteur_R3                   )*...
               length(obj.circuit_passe_haut           )*...
               length(obj.circuit_passe_bas            )*...
               length(obj.regulateur_gain              )*...
               length(obj.servoclef_clef               )*...
               length(obj.freq_mes_transfer            );
        end
        
        function SetToDefault(obj)
            defaultParameter = SimulationParameter();
            obj.Frequence_final = defaultParameter.f_final;
            obj.dt = defaultParameter.dt;
            
            obj.position_centre = defaultParameter.position_centre;
            obj.pos_actuateur_relative = defaultParameter.pos_actuateur_relative ;
            obj.pos_capteur_relative = defaultParameter.pos_capteur_relative;
            obj.polarite = defaultParameter.polarite;
            
            obj.LinearDensity = defaultParameter.corde.M/defaultParameter.corde.L; %Vericarlo que escribimos en el informe
            obj.Length = defaultParameter.corde.L;
            obj.frottement = defaultParameter.corde.b;
            obj.N = defaultParameter.corde.N;
            obj.T_0 = defaultParameter.corde.T_0;

            obj.x_0 = defaultParameter.corde.x_0;
            obj.v_0 = defaultParameter.corde.v_0;
            
            obj.isImpulseOn = defaultParameter.isImpulseOn;
            obj.impulse_relative_position = defaultParameter.impulse_relative_position;
            
            obj.Duration = defaultParameter.duration;
            obj.Frequence_initial = defaultParameter.f_start;
            obj.Frequence_time_step = defaultParameter.f_time_step;
            obj.actuateur_force_magnetique = defaultParameter.actuateur_force_magnetique  ;
            obj.actuateur_circuitRL_s       = defaultParameter.actuateur_circuitRL_s  ;
            obj.capteur_R3                  = defaultParameter.capteur_R3  ;
            obj.circuit_passe_haut          = defaultParameter.circuit_passe_haut  ;
            obj.circuit_passe_bas           = defaultParameter.circuit_passe_bas  ;
            obj.regulateur_gain             = defaultParameter.regulateur_gain  ;
            obj.servoclef_clef              = defaultParameter.servoclef_clef  ;
            obj.freq_mes_transfer           = defaultParameter.freq_mes_transfer  ;
        end
        
        function SimulationParametersArray = EnumerateSimulationParameters(obj)
            elements = {obj.Frequence_final     ,...
                obj.dt                          ,...
                obj.position_centre             ,...
                obj.pos_actuateur_relative      ,...
                obj.pos_capteur_relative        ,...
                obj.polarite                    ,...
                obj.LinearDensity               ,...
                obj.Length                      ,...
                obj.frottement                  ,...
                double(obj.N)                   ,...
                obj.T_0                         ,...
                obj.actuateur_force_magnetique  ,...
                obj.actuateur_circuitRL_s       ,...
                obj.capteur_R3                  ,...
                obj.circuit_passe_haut          ,...
                obj.circuit_passe_bas           ,...
                obj.regulateur_gain             ,...
                obj.servoclef_clef              ,...
                obj.freq_mes_transfer           }; %cell array with N vectors to combine
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
                simParams.actuateur_force_magnetique = parameters(12);
                simParams.actuateur_circuitRL_s      = parameters(12);
                simParams.capteur_R3                 = parameters(13);
                simParams.circuit_passe_haut         = parameters(14);
                simParams.circuit_passe_bas          = parameters(15);
                simParams.regulateur_gain            = parameters(16);
                simParams.servoclef_clef             = parameters(17);
                simParams.freq_mes_transfer          = parameters(18);
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

