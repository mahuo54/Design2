classdef PerformanceResult   
    properties
        Justesse;
        Precision;
        A;
        Vitesse;
        RatioHarmonique;
        HasError = false;
    end
    
    methods
        function obj = PerformanceResult(Justesse, Precision, A, Vitesse, RatioHarmonique)
            %PERFORMANCERESULT Construct an instance of this class
            %   Detailed explanation goes here
            obj.Justesse = Justesse;
            obj.Precision = Precision;
            obj.A = A;
            obj.Vitesse = Vitesse;
            obj.RatioHarmonique = RatioHarmonique;
        end
    end
    methods(Static)
        function obj = FailedSimulation()
            obj = PerformanceResult('','','','');
            obj.HasError = true;
        end
    end
end

