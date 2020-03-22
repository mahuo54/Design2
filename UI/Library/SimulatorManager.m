classdef SimulatorManager < handle
    properties
        systemSimulator SystemSimulator;
        resultsByParameter;
    end
    
    methods
        function obj = SimulatorManager(systemSimulator)
            obj.systemSimulator = systemSimulator;
        end
        function Simulate(obj, simulationParamArrays)
            for i = 1:length(simulationParamArrays)
                result = obj.systemSimulator.RunSimulation(simulationParamArrays(i));
                obj.resultsByParameter{i} = {simulationParamArrays(i), result};
            end            
        end
    end
end
