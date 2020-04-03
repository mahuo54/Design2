classdef SimulationFinishEventData < event.EventData
    properties
        simulationId;
        param SimulationParameter;
        result;
    end
    methods
        function obj = SimulationFinishEventData(param, result, simulationId)
            %SIMULATIONFINISHEVENTDATA Construct an instance of this class
            %   Detailed explanation goes here
            obj.param = param;
            obj.result = result;
            obj.simulationId = simulationId;
        end
    end
end

