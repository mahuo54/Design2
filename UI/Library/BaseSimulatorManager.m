classdef (Abstract) BaseSimulatorManager %WIP
    properties
        %List of results for simulation depending on t
        Property1
    end
    
    methods
        function obj = BaseSimulatorManager()
        end
        function SimulateGroup(SimulationDtos) %Differentiate the class holding all the params from the simple list of param
            %SimulationDtos should provide an enumerator
            
        end
    end
    methods (Abstract)
       Simulate(Inputs) %Or a DTO probably holding all the spec for this sim 
    end
end

