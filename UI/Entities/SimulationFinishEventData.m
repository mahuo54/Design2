classdef SimulationFinishEventData < event.EventData
    properties
        param SimulationParameter;
        result;
    end
    methods
        function obj = SimulationFinishEventData(param, result)
            %SIMULATIONFINISHEVENTDATA Construct an instance of this class
            %   Detailed explanation goes here
            obj.param = param;
            obj.result = result;
        end
    end
end

