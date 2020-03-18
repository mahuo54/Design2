classdef SystemSimulator < handle
    properties
        modelName;
        idx_actuateur_default = 20;
        idx_capteur_default = 6;
    end
    methods 
        function obj = CordeSimulator(modelName)
            load_system('simulink');
            obj.modelName = modelName;
        end
        function results = RunSimulation(obj, simulationParameter)
            %Actually though, maybe we want to have it in memory.
            model = load_system(obj.modelName);
            SetParameter(model,simulationParameter);
            cs = getActiveConfigSet(obj.modelName);
            mdl_cs = cs.copy;
            set_param(mdl_cs,  'StartTime','0','StopTime',simulationParameter.duration,'SolverType','Fixed-step', 'FixedStep',num2str(simulationParameter.dt));
            %          'SaveState','on','StateSaveName','xoutNew',...
            %          'SaveOutput','on','OutputSaveName','youtNew',...
            results = sim(modelname, mdl_cs); %'StartTime','0','StopTime','10','FixedStep',num2str(dt));
        end
        
        function SetParameter(model, simulationParameter)
            %% Consigne F
            f_h = Simulink.findBlocks(model,'Name','Fréquence voulue');
            set_param(f_h,'Value',simulationParameter.F);
            
            %% Corde 
            %Here we could switch the file with FunctionName
            corde_h = Simulink.findBlocks(model,'Name','corde');
            set_param(corde_h,'Parameters',sprintf('%d, %d, %d, %i, %d',...
                simulationParameter.M,simulationParameter.L,simulationParameter.b,simulationParameter.N,simulationParameter.dt));
            
            %% If N different than default, readjust the arrays
            % What depends on N? 
            % - x_0_mux, v_0_mux, f_mux, x_out_demux
            
            %% Set Initial Conditions
            
            %% Config actuateur
            idx_actuateur = GetIndex(simulationParameter.pos_actuateur_relative, simulationParameter.N);
            %Remove connection from mux to the constant and 
            if(idx_actuateur ~= obj.idx_actuateur_default)
                f_mux_h = Simulink.findBlocks(model,'Name','f_mux');
                force_cst_h = Simulink.findBlocks(model,'Name','force cst');
                actuateur_h = Simulink.findBlocks(model,'Name','Actuateur');
                
                f_mux_lines_h = get_param(f_mux_h,'LineHandles');
                %Delete line for both indexes
                delete_line(f_mux_lines_h.Inport(idx_actuateur)); 
                delete_line(f_mux_lines_h.Inport(obj.idx_actuateur_default));
                %add lines back
                add_line(model,actuateur_h.Outport(1), f_mux_h.Inport(idx_actuateur));
                add_line(model,force_cst_h.Outport(1), f_mux_h.Inport(obj.idx_actuateur_default));
            end
            %% Config capteur
            idx_capteur = GetIndex(simulationParameter.pos_capteur_relative, simulationParameter.N);
            %Remove connection from mux to the constant and 
            if(idx_capteur ~= obj.idx_capteur_default)
                x_out_demux_h = Simulink.findBlocks(model,'Name','x_out_demux');
                position_sum_h = Simulink.findBlocks(model,'Name','position_sum');
                x_out_demux_lines_h = get_param(x_out_demux_h,'LineHandles');
                
                %Delete line
                delete_line(x_out_demux_lines_h.Outport(obj.idx_capteur_default)); 
                %add lines back
                position_sum_lines_h= get_param(position_sum_h,'LineHandles');
                add_line(model,x_out_demux_h.Outport(idx_capteur), position_sum_h.Inport(find(position_sum_lines_h.Inport==-1,1,'first')));
            end
            %% Polarité - not an option at the time.

            %% Initial Tension
            T_0_h = Simulink.findBlocks(model,'Name','Tension initiale');
            set_param(T_0_h,'Value',simulationParameter.T_0);
        end
        
        function idx = GetIndex(x,N)
            idx = round(x*(N+1)); %From 0 to N+1, wouldn't work if at 0 or N_1 though...
        end
    end
end
        