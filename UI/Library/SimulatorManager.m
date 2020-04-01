classdef SimulatorManager < handle
    properties
        systemSimulator SystemSimulator;
        resultsByParameter;
        
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
                obj.resultsByParameter{i} = {simulationParamArrays(i), result};
                notify(obj, 'SingleSimulationFinish', SimulationFinishEventData(simulationParamArrays(i), result));
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
        function add_listener_formator(obj, simulationDataFormator)
            addlistener(obj, 'SingleSimulationFinish', @simulationDataFormator.SingleSimulationFinishHandler);
        end
    end
end

