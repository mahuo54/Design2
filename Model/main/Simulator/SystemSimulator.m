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
            set_param(consigne_h,'Time',num2str(simulationParameter.f_time_step));
            set_param(consigne_h,'Before',num2str(simulationParameter.f_start));
            set_param(consigne_h,'After',num2str(simulationParameter.f_final));
            
            %% Corde 
            %Here we could switch the file with FunctionName
            corde_h = Simulink.findBlocks(model,'Name','corde_fct');
            set_param(corde_h,'Parameters',sprintf('%d, %d, %d, %i, %d',...
                simulationParameter.M,simulationParameter.L,simulationParameter.b,simulationParameter.N,simulationParameter.dt));
            
            %% Set Initial Conditions
            x_0_cst_h = Simulink.findBlocks(model,'Name','x_0_cst');
            if(length(simulationParameter.x_0) == 1)
                set_param(x_0_cst_h, 'Value', ['repmat(' num2str(simulationParameter.x_0) ',1,' num2str(simulationParameter.N) ')']);
            else
                set_param(x_0_cst_h, 'Value', ['[' num2str(simulationParameter.x_0) ']']);
            end
            
            v_0_cst_h = Simulink.findBlocks(model,'Name','v_0_cst');
            if(length(simulationParameter.x_0) == 1)
                set_param(v_0_cst_h, 'Value', ['repmat(' num2str(simulationParameter.v_0) ',1,' num2str(simulationParameter.N) ')']);
            else
                set_param(v_0_cst_h, 'Value', ['[' num2str(simulationParameter.v_0) ']']);
            end
            
            %% Config actuateur
            idx_actuateur = obj.GetIndex(simulationParameter.pos_actuateur_relative, simulationParameter.N);
            actuateur_h = Simulink.findBlocks(model,'Name','actuateur_assignment');
            set_param(actuateur_h,'Indices',num2str(idx_actuateur));
            
            %% Config capteur
            idx_capteur = obj.GetIndex(simulationParameter.pos_capteur_relative, simulationParameter.N);
            capteur_h = Simulink.findBlocks(model,'Name','x_out_selector');
            set_param(capteur_h,'Indices',num2str(idx_capteur));
            
            %% Polarité - not an option at the time.

            %% Initial Tension
            T_0_h = Simulink.findBlocks(model,'Name','Tension initiale');
            set_param(T_0_h,'Value',num2str(simulationParameter.T_0));
            
            %% Position centre
            position_centre_h = Simulink.findBlocks(model,'Name', 'Position centre');
            set_param(position_centre_h, 'Value',num2str(simulationParameter.position_centre));
        end
        
        function idx = GetIndex(~,x,N)
            idx = round(x*(N+1)); %From 0 to N+1, wouldn't work if at 0 or N_1 though...
        end
    end
end
        