classdef SystemSimulator < handle
    properties
        modelName;
    end
    methods 
        function obj = SystemSimulator(modelName)
            load_system('simulink');
            obj.modelName = modelName;
        end
        function results = RunSimulation(obj, simulationParameter)
            %Actually though, maybe we want to have it in memory.
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
            f_h = Simulink.findBlocks(model,'Name','Fréquence voulue');
            set_param(f_h,'Value',num2str(simulationParameter.f));
            
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
            idx_actuateur = obj.GetIndex(simulationParameter.pos_actuateur_relative, simulationParameter.N);
            %Remove connection from mux to the actuateur, add it back and
            %fill the rest.            
            f_mux_h = Simulink.findBlocks(model,'Name','f_mux');
            force_cst_h = Simulink.findBlocks(model,'Name','force cst');
            actuateur_h = Simulink.findBlocks(model,'Name','Actuateur'); %Doesn't refresh. It's not a handle, it refers to the handle.
            
            actuateur_lines_h = get_param(actuateur_h,'LineHandles');
            if(actuateur_lines_h.Outport(1) ~= -1)
                delete_line(actuateur_lines_h.Outport(1));
            end            
            f_mux_lines_h = get_param(f_mux_h,'LineHandles');
            if(f_mux_lines_h.Inport(idx_actuateur) ~= -1)
                delete_line(f_mux_lines_h.Inport(idx_actuateur)); 
            end
            %add lines back
            actuateur_port_h = get_param(actuateur_h,'PortHandles'); 
            f_mux_port_h= get_param(f_mux_h,'PortHandles');
            force_cst_port_h= get_param(force_cst_h,'PortHandles');
            add_line(model,actuateur_port_h.Outport(1), f_mux_port_h.Inport(idx_actuateur),'autorouting','on');
            %For all -1
            f_mux_lines_h = get_param(f_mux_h,'LineHandles');
            for i = find(f_mux_lines_h.Inport == -1)
                add_line(model,force_cst_port_h.Outport(1), f_mux_port_h.Inport(i),'autorouting','on');    
            end
            
            
            %% Config capteur
            idx_capteur = obj.GetIndex(simulationParameter.pos_capteur_relative, simulationParameter.N);
            x_out_demux_h = Simulink.findBlocks(model,'Name','x_out_demux');
            position_sum_h = Simulink.findBlocks(model,'Name','position_sum');
            x_out_demux_lines_h = get_param(x_out_demux_h,'LineHandles');
            
            %remove all but idx_capteur, add idx_capteur if needed.
            for i = find(x_out_demux_lines_h.Outport ~= -1)
                if(i ~= idx_capteur)
                    delete_line(x_out_demux_lines_h.Outport(i));
                end
            end            
            %add lines back
            if(x_out_demux_lines_h.Outport(idx_capteur) == -1)
                x_out_demux_ports_h = get_param(x_out_demux_h,'PortHandles');
                position_sum_lines_h= get_param(position_sum_h,'LineHandles');
                position_sum_ports_h= get_param(position_sum_h,'PortHandles');
                add_line(model,x_out_demux_ports_h.Outport(idx_capteur), position_sum_ports_h.Inport(find(position_sum_lines_h.Inport==-1,1,'first')),'autorouting','on');
            end   
            %% Polarité - not an option at the time.

            %% Initial Tension
            T_0_h = Simulink.findBlocks(model,'Name','Tension initiale');
            set_param(T_0_h,'Value',num2str(simulationParameter.T_0));
        end
        
        function idx = GetIndex(~,x,N)
            idx = round(x*(N+1)); %From 0 to N+1, wouldn't work if at 0 or N_1 though...
        end
    end
end
        