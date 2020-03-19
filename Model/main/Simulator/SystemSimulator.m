classdef SystemSimulator < handle
    properties
        modelName = 'SystemeCompletProcedural';
    end
    methods 
        function obj = SystemSimulator()
            load_system('simulink');
        end
        function results = RunSimulation(obj, simulationParameter)
            %Actually though, maybe we want to have it in memory. Look
            %inSimulation.
                        
            model = load_system(obj.modelName);
            obj.SetParameter(model,simulationParameter);
            save_system(model);            
            
            cs = getActiveConfigSet(obj.modelName);
            mdl_cs = cs.copy;
            set_param(mdl_cs,  'StartTime','0','StopTime',num2str(simulationParameter.duration),'SolverType','Fixed-step', 'FixedStep',num2str(num2str(simulationParameter.dt)));
            %          'SaveState','on','StateSaveName','xoutNew',...
            %          'SaveOutput','on','OutputSaveName','youtNew',...
            %Test timer
            results = sim(obj.modelName, mdl_cs); %'StartTime','0','StopTime','10','FixedStep',num2str(dt));
            %Other parameters to consider 
            % 'CaptureErrors', 'on' -> results hold error in metadata
            % 'timeout', '1000' -> results hold error in metadata
        end
    end
    methods (Access = private)
        function SetParameter(obj, model, simulationParameter)
            %% Consigne F
            consigne_h = Simulink.findBlocks(model,'Name','Consigne_f_step');
            set_param(consigne_h,'Time',num2str(4));
            set_param(consigne_h,'Before',num2str(200));
            set_param(consigne_h,'After',num2str(220));
            
            %% Corde 
            %Here we could switch the file with FunctionName
            corde_h = Simulink.findBlocks(model,'Name','corde_fct');
            set_param(corde_h,'Parameters',sprintf('%d, %d, %d, %i, %d',...
                simulationParameter.M,simulationParameter.L,simulationParameter.b,simulationParameter.N,simulationParameter.dt));
            
            %% Set Initial Conditions
            %x_0, v_0
            
            %% Config actuateur
            idx_actuateur = obj.GetIndex(simulationParameter.pos_actuateur_relative, simulationParameter.N);
            actuateur_h = Simulink.findBlocks(model,'Name','actuateur_assignment');
            set_param(actuateur_h,'Indices',idx_actuateur);
            
            %% Config capteur
            idx_capteur = obj.GetIndex(simulationParameter.pos_capteur_relative, simulationParameter.N);
            
            %% Polarit� - not an option at the time.

            %% Initial Tension
            T_0_h = Simulink.findBlocks(model,'Name','Tension initiale');
            set_param(T_0_h,'Value',num2str(simulationParameter.T_0));
        end
        
        function idx = GetIndex(~,x,N)
            idx = round(x*(N+1)); %From 0 to N+1, wouldn't work if at 0 or N_1 though...
        end
    end
end
        