classdef SimulationFinishEventData < event.EventData
    properties
        simulationId;
        param SimulationParameter;
        result;
        performance PerformanceResult;
    end
    methods
        function obj = SimulationFinishEventData(param, result, simulationId, performanceResult)
            %SIMULATIONFINISHEVENTDATA Construct an instance of this class
            %   Detailed explanation goes here
            obj.param = param;
            obj.result = result;
            obj.simulationId = simulationId;
            obj.performance = performanceResult;
        end
    end
end

