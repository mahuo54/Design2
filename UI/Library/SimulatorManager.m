classdef SimulatorManager < handle
    properties
        systemSimulator SystemSimulator;
        resultsByParameter;
        resultPerformanceAnalyser ResultPerformanceAnalyser = ResultPerformanceAnalyser();
        flagStopSimulation = false;
    end
    
    events
       SingleSimulationFinish; 
    end
    
    methods
        function obj = SimulatorManager(systemSimulator)
            obj.systemSimulator = systemSimulator;
        end
        function results = Simulate(obj, simulationParamArrays, PrintStatusDelegate)
            obj.flagStopSimulation = false;
            N = length(simulationParamArrays);
            if(nargin == 2)
                PrintStatusDelegate = @(s) disp(s);
            end
            for i = 1:N
                if(obj.flagStopSimulation)
                   continue;
                end
                PrintStatusDelegate(sprintf('Simulation en cours (%i/%i)',i,N));
                result = obj.systemSimulator.RunSimulation(simulationParamArrays(i));
                if(obj.flagStopSimulation)
                    result.ErrorMessage = "Simulation stopped";
                end
                performances = obj.resultPerformanceAnalyser.GetPerformance(result, simulationParamArrays(i));
                obj.resultsByParameter{i} = {simulationParamArrays(i), result, performances};
                notify(obj, 'SingleSimulationFinish', SimulationFinishEventData(simulationParamArrays(i), result, i, performances));
            end           
            results = obj.resultsByParameter;
        end
        function result = GetLatestResult(obj) 
            result = obj.resultsByParameter{length(obj.resultsByParameter)};
        end
        function Stop(obj)
            obj.flagStopSimulation = true;
            obj.systemSimulator.Stop();
        end
        function SetAutoEntretien(obj, ShouldBeActivated)
            obj.systemSimulator.SetAutoEntretien(ShouldBeActivated);
        end
        function SetAutoAccord(obj, ShouldBeActivated)
            obj.systemSimulator.SetAutoAccord(ShouldBeActivated);
        end
         function SetNoiseRandom(obj, isOn, var, mean)
            obj.systemSimulator.SetNoiseRandom(isOn, var, mean);

        end
        function SetSineNoise(obj, isOn, w, A)
            obj.systemSimulator.SetSineNoise(isOn, w, A);
        end
        function SetOffSet(obj, isOn, x)
            obj.systemSimulator.SetOffSet(isOn,x);
        end
        function SetManualFrequence(obj, isOn, freq)
            obj.systemSimulator.SetManualFrequence(isOn, freq);
        end
        
        function add_listener_formator(obj, simulationDataFormator)
            addlistener(obj, 'SingleSimulationFinish', @simulationDataFormator.SingleSimulationFinishHandler);
        end
    end
end

