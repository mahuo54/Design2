classdef SystemSimulator < handle
    properties
        modelName = 'SystemeCompletProcedural';
    end
    methods 
        function obj = SystemSimulator()
            load_system('simulink');
            load_system(obj.modelName);
        end
        function results = RunSimulation(obj, simulationParameter)
            %Actually though, maybe we want to have it in memory. Look
            %inSimulation.                        
            model = load_system(obj.modelName);
            obj.SetParameter(model,simulationParameter);
            save_system(model);            
            
            mdl_cs = getActiveConfigSet(obj.modelName);
%             mdl_cs = cs.copy;
            set_param(mdl_cs,  'StartTime','0','StopTime',num2str(simulationParameter.duration),'SolverType','Fixed-step', 'FixedStep',num2str(simulationParameter.dt));
            %          'SaveState','on','StateSaveName','xoutNew',...
            %          'SaveOutput','on','OutputSaveName','youtNew',...
            %Test timer
%             set_param(mdl_cs,'Name','ConfigSim');
%             attachConfigSet(obj.modelName, mdl_cs);
%             setActiveConfigSet(obj.modelName,'ConfigSim');
            results = sim(obj.modelName, 'CaptureErrors', 'on','timeout', 120 ); %'StartTime','0','StopTime','10','FixedStep',num2str(dt));
            %Other parameters to consider 
            % 'CaptureErrors', 'on' -> results hold error in metadata
            % 'timeout', '1000' -> results hold error in metadata
        end
        function Stop(obj)
            set_param(obj.modelName, 'SimulationCommand', 'stop');
        end
        function SetAutoEntretien(~, ShouldBeActivated)
            actuateur_h = Simulink.findBlocks(model, 'Name','Actuateur');
            actuateur_activated_h = Simulink.findBlocks(actuateur_h, 'Name','ActuateurActivated');
            if(ShouldBeActivated)
                set_param(actuateur_activated_h, 'Gain','1'); 
            else
                set_param(actuateur_activated_h, 'Gain','0');
            end
        end
        function SetAutoAccord(~, ShouldBeActivated)
            regulateur_h = Simulink.findBlocks(model, 'Name','Régulateur');
            regulateur_autoaccord_h = Simulink.findBlocks(regulateur_h, 'Name','Auto-accord');
            if(ShouldBeActivated)
                set_param(regulateur_autoaccord_h, 'Gain','1');
            else
                set_param(regulateur_autoaccord_h, 'Gain','0');
            end
        end
        function SetNoiseRandom(obj, isOn, w, A)
            
        end
    end
    methods (Access = private)
        function SetParameter(obj, model, simulationParameter)
            %I deal with handle here, but it's useless. It might be faster,
            %but I chose that strategy in order to avoid saving the file.
            %We need to save it to run it. I'll explore alternatives later.
            %Sim(InSimulation)
            %% Also please organize those parameters, it's getting messy. Or Don't. No one is gonna work on this in 2 weeks...
            
            %% Consigne F
            consigne_h = Simulink.findBlocks(model,'Name','Consigne_f_step');
            set_param(consigne_h,'Time',num2str(simulationParameter.f_time_step));
            set_param(consigne_h,'Before',num2str(simulationParameter.f_start));
            set_param(consigne_h,'After',num2str(simulationParameter.f_final));
            
            %% Corde 
            %Here we could switch the file with FunctionName
            corde_h = Simulink.findBlocks(model,'Name','corde_fct');
            set_param(corde_h,'Parameters',sprintf('%d, %d, %d, %i, %d',...
                simulationParameter.corde.M,simulationParameter.corde.L,simulationParameter.corde.b,simulationParameter.corde.N,simulationParameter.dt));
            
            %% Set Initial Conditions
            x_0_cst_h = Simulink.findBlocks(model,'Name','x_0_cst');
            if(length(simulationParameter.corde.x_0) == 1)
                set_param(x_0_cst_h, 'Value', ['repmat(' num2str(simulationParameter.corde.x_0) ',1,' num2str(simulationParameter.corde.N) ')']);
            else
                set_param(x_0_cst_h, 'Value', ['[' num2str(simulationParameter.corde.x_0) ']']);
            end
            
            v_0_cst_h = Simulink.findBlocks(model,'Name','v_0_cst');
            if(length(simulationParameter.corde.x_0) == 1)
                set_param(v_0_cst_h, 'Value', ['repmat(' num2str(simulationParameter.corde.v_0) ',1,' num2str(simulationParameter.corde.N) ')']);
            else
                set_param(v_0_cst_h, 'Value', ['[' num2str(simulationParameter.corde.v_0) ']']);
            end
            
            %% Config actuateur
            actuateur_pos_h = Simulink.findBlocks(model,'Name','actuateur_assignment');
            idx_actuateur = simulationParameter.GetIndexActuateur();
            set_param(actuateur_pos_h,'Indices',num2str(idx_actuateur));
                        
            actuateur_h = Simulink.findBlocks(model, 'Name','Actuateur');
            actuateur_fm_h = Simulink.findBlocks(actuateur_h, 'Name','Force magnétique');
            set_param(actuateur_fm_h, 'Gain',num2str(simulationParameter.actuateur_force_magnetique));
            actuateur_RL_h = Simulink.findBlocks(actuateur_h, 'Name','Circuit RL');
            set_param(actuateur_RL_h, 'Denominator', ['[' num2str(simulationParameter.actuateur_circuitRL_s) ' 263]']);
            actuateur_pol_h = Simulink.findBlocks(actuateur_h, 'Name','Polarisation');
            if(simulationParameter.IsPolarisationInverted) %TOADD
                set_param(actuateur_pol_h,'Gain','1');
            else
                set_param(actuateur_pol_h,'Gain','-1');
            end
            %% Config capteur
            idx_capteur = simulationParameter.GetIndexCapteur();
            capteur_pos_h = Simulink.findBlocks(model,'Name','x_out_selector');
            set_param(capteur_pos_h,'Indices',num2str(idx_capteur));
            
            capteur_h = Simulink.findBlocks(model,'Name','Capteur+Circuit');
            capteur_R3_h = Simulink.findBlocks(capteur_h,'Name','R3');
            set_param(capteur_R3_h, 'Gain',num2str(simulationParameter.capteur_R3));
            
            courant_max_h = Simulink.findBlocks(capteur_h,'Name','Courant max');
            set_param(courant_max_h, 'Gain',num2str(simulationParameter.capteur_courantMax)); %TOADD
            
            passe_haut_h = Simulink.findBlocks(capteur_h,'Name','Passe-haut centré');
            set_param(passe_haut_h,'Numerator', ['[' num2str(simulationParameter.circuit_passe_haut) ' 0]']);
            set_param(passe_haut_h,'Denominator', ['[' num2str(simulationParameter.circuit_passe_bas) ' 1]']);

            tension_ajustable_h = Simulink.findBlocks(capteur_h,'Name','Tension ajustable');
            set_param(tension_ajustable_h, 'Gain',num2str(simulationParameter.tensionAjustableFactor)); %TOADD - in UI 5 = 1 in param
            
            Va_h = Simulink.findBlocks(capteur_h,'Name','Va_cst');
            set_param(Va_h, 'Value',num2str(simulationParameter.Circuit_Va)); %TOADD
            
            Vb_h = Simulink.findBlocks(capteur_h,'Name','Vb_cst');
            set_param(Vb_h, 'Value',num2str(simulationParameter.Circuit_Vb)); %TOADD            
            
            %% Initial Tension
            T_0_h = Simulink.findBlocks(model,'Name','Tension initiale');
            set_param(T_0_h,'Value',num2str(simulationParameter.corde.T_0));
            
            %% Position centre
            position_centre_h = Simulink.findBlocks(model,'Name', 'Position centre');
            set_param(position_centre_h, 'Value',num2str(simulationParameter.position_centre));
%             %% Impulse %Removed!!! %Dependancy on DPS
%             impulse_h = Simulink.findBlocks(model,'Name', 'impulse_switch');
%             impulse_assignment_h = Simulink.findBlocks(model,'Name', 'impulse_assignment');
%             idx_impulse = simulationParameter.GetIndexImpulsion();
%             set_param(impulse_assignment_h,'Indices',num2str(idx_impulse));
%             if(simulationParameter.isImpulseOn)
%                 set_param(impulse_h,'LabelModeActiveChoice','ImpulseOn');
%             else
%                 set_param(impulse_h,'LabelModeActiveChoice','ImpulseOff');
%             end
            %% Régulateur
            regulateur_h = Simulink.findBlocks(model, 'Name','Régulateur');
            regulateur_gain_h = Simulink.findBlocks(regulateur_h, 'Name','Gain');
            set_param(regulateur_gain_h, 'Gain',num2str(simulationParameter.regulateur_gain));
            regulateur_gain_h = Simulink.findBlocks(regulateur_h, 'Name','I');
            set_param(regulateur_gain_h, 'Numerator',num2str(simulationParameter.regulateur_accordI)); %ToAdd
           
            %% Servoclef
            servoclef_h = Simulink.findBlocks(model, 'Name','Servoclef');
            servoclef_clef_h = Simulink.findBlocks(servoclef_h, 'Name','Clef');
            set_param(servoclef_clef_h, 'Gain', num2str(simulationParameter.servoclef_clef));
            
            servoclef_FctTrans_h = Simulink.findBlocks(servoclef_h, 'Name','Fct transfer position');
            set_param(servoclef_FctTrans_h, 'Numerator', ['[' num2str(simulationParameter.gainVoltageAngle) ']' ]); %TOADD
            set_param(servoclef_FctTrans_h, 'Denominator', ['[' num2str(simulationParameter.freq_coupure) ' 1]' ]); %TOADD
            
            servoclef_vMax_h = Simulink.findBlocks(servoclef_h, 'Name','Vitesse maximale');
            set_param(servoclef_vMax_h, 'UpperLimit', num2str(simulationParameter.servoClefVitesseMax)); %TOADD
            
            %% Mesure fréquence
            mesure_freq_h = Simulink.findBlocks(model, 'Name','Mesure fréquence');
            mesure_fre_transFct_h = Simulink.findBlocks(mesure_freq_h, 'Name','Transfer Fcn');
            set_param(mesure_fre_transFct_h, 'Denominator',['[' num2str(simulationParameter.freq_mes_transfer) ' 1]' ]);
            clock_h =  Simulink.findBlocks(mesure_freq_h, 'Name','Clock');
            set_param(clock_h, 'Decimation',num2str(simulationParameter.GetClockDecimation())); %TOADD AND CHECK

        end
        
%         function idx = GetIndex(~,x,N)
%             idx = round(x*(N+1)); %From 0 to N+1, wouldn't work if at 0 or N_1 though...
%         end
    end
end
        