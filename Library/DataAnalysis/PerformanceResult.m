classdef PerformanceResult   
    properties
        Justesse;
        Precision;
        A;
        Vitesse;
    end
    
    methods
        function obj = PerformanceResult(Justesse, Precision, A, Vitesse)
            %PERFORMANCERESULT Construct an instance of this class
            %   Detailed explanation goes here
            obj.Justesse = Justesse;
            obj.Precision = Precision;
            obj.A = A;
            obj.Vitesse = Vitesse;
        end
    end
end

