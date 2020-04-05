classdef ResultPerformanceAnalyser    
    properties
        performanceTimeConsidered double = 0.2;
    end
    
    methods
        function obj = ResultPerformanceAnalyser()
        end
        function performanceResult = GetPerformance(obj, result, params)
            if(~isempty(result.ErrorMessage))
                performanceResult = PerformanceResult.FailedSimulation();
                return;
            end
            if((params.duration - params.f_time_step) < obj.performanceTimeConsidered)
                l = params.duration - params.f_time_step;
            else
                l = obj.performanceTimeConsidered;
            end
            N =  l/ params.dt;
            posConsidered = result.corde_mesure.Data((end-N):end, params.GetIndexCapteur());
            A = max(posConsidered) - min(posConsidered);
            [Justesse, Precision] = obj.GetJustessePrecision(result.freq.Data(:,1), params);
            Vitesse = obj.GetVitesse(result.freq, params);
            performanceResult = PerformanceResult(Justesse, Precision, A, Vitesse);
        end

        function vitesse = GetVitesse(~, freqTimeSeries, params)
            criteria = 1; %Actually depends on the freq. 1/8 ton...
%             N = params.f_time_step/params.dt;
            idx = find( (freqTimeSeries.Data-params.f_final) > criteria, 1 ,'last');
            vitesse = freqTimeSeries.Time(idx);
        end
        function [justesse, precision] = GetJustessePrecision(obj, freqVector, params)
            if((params.duration - params.f_time_step) < obj.performanceTimeConsidered)
                l = params.duration - params.f_time_step;
            else
                l = obj.performanceTimeConsidered;
            end
            N =  l/ params.dt;
            %Check time
            fSample =freqVector((end-N):end);
            justesse = mean((fSample-params.f_final)/params.f_final);
            precision = std(fSample);
        end
    end

end


