classdef SimulationParameter
    properties
        duration = 5;
        f_final = 120;
        f_start = 100;
        f_time_step = 3;
        dt = 0.0001;
        
        corde CordeParameter = CordeParameter();
            
        position_centre = 0.001;% 0.00143
        pos_actuateur_relative = 0.75;
        pos_capteur_relative = 0.25;

        actuateur_force_magnetique = 11.65;
        actuateur_circuitRL_s = 0.07668;
        
        capteur_R3 = 744.5;
        circuit_passe_haut = 0.000738;
        circuit_passe_bas = 0.0099;
        
        regulateur_gain = -0.006;
        
        servoclef_clef = -0.384;
        freq_mes_transfer = 0.1;
        
        %New variables - done
        clockFreq = 16000; %???
        servoClefVitesseMax = 1000;
        freq_coupure = 0.03;
        gainVoltageAngle = 800;
        Circuit_Va = 2.563;
        Circuit_Vb = 2.312;
        tensionAjustableFactor = 1; %%%1=5V
        capteur_courantMax = 0.0218;
        IsPolarisationInverted = true;
        regulateur_accordI = -0.000271;
        
        Harmonique = 2;
    end
    methods
        function obj = SimulationParameter()
            obj.corde.x_0 = 0.01;
        end
        function isValid = Validate(obj)
            if(length(obj.corde.x_0) ~= 1 && length(obj.corde.x_0) ~= obj.corde.N)
                isValid = false;
            elseif (length(obj.corde.v_0) ~= 1 && length(obj.corde.v_0) ~= obj.corde.N)
                isValid = false;
            elseif (obj.f_time_step < obj.duration)
                isValid = false;
            else
                isValid = true;
            end
                   
        end
        
        function idx = GetIndexActuateur(obj)
            idx = obj.GetIndex(obj.pos_actuateur_relative);
        end
        function idx = GetIndexCapteur(obj)
            idx = obj.GetIndex(obj.pos_capteur_relative);
        end
        function decimation = GetClockDecimation(obj)
            if(obj.clockFreq >= 1000)
                decimation = 10;
            else
                decimation = ceil(1000/obj.clockFreq);
            end
        end
        function consigne = GetConsigne(obj)
            consigne = obj.f_final*obj.Harmonique;
        end
    end
    methods (Access = private)
        function idx = GetIndex(obj, x)
            idx = round(x*(obj.corde.N+1)); %From 0 to N+1, wouldn't work if at 0 or N_1 though...
            if (idx ==0 )
                idx = 1;
            elseif (idx == obj.corde.N+1)
                idx = obj.corde.N;
            end
        end
    end
end
