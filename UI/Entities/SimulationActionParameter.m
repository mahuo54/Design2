classdef SimulationActionParameter < handle
    properties        
        IsAutoAccordOn = false;
        IsAutoEntretienOn = false;
        %%Manual freq
        ManualFreqIsOn = false;
        ManualFreqValue = 100;
        
        OffSetIsOn = false;
        OffSetValue = 0.00001;
        
        SineNoiseIsOn = false;
        SineNoiseA = 0.00001;
        SineNoiseW = 10;
        
        WhiteNoiseIsOn = false;
        WhiteNoiseVar = 0.0000000001;
        WhiteNoiseMean = 0;
        
        harmonique = 2;
    end
    
    methods
        function obj = SimulationActionParameter()

        end
    end
end

