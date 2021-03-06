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
            RatioHarmonique = obj.GetRatio(result, params, N);
            performanceResult = PerformanceResult(Justesse, Precision, A, Vitesse, RatioHarmonique);
        end

        function RatioHarmonique = GetRatio(~, result, params, N) 
            [PSD, f] = FT_FromVector(result.corde_mesure.Data((end-N):end,params.GetIndexCapteur()), result.corde_mesure.Time((end-N):end));
            f_final =params.f_final;            
            A2 = max(PSD(f >= 2*f_final*0.95 & f <= 2*f_final*1.05));
            A1 = max(PSD(f >= f_final*0.95 & f <= f_final*1.05));
            RatioHarmonique = A2/A1;
        end
        function vitesse = GetVitesse(obj, freqTimeSeries, params)
            consigne = params.GetConsigne();
            criteria = obj.GetCriteria(consigne); %Actually depends on the freq. 1/8 ton...
%             N = params.f_time_step/params.dt;
            idx = find( abs(freqTimeSeries.Data-consigne) > criteria, 1 ,'last');
            vitesse = freqTimeSeries.Time(idx)-params.f_time_step;
        end
        function [justesse, precision] = GetJustessePrecision(obj, freqVector, params)
            consigne = params.GetConsigne();
            if((params.duration - params.f_time_step) < obj.performanceTimeConsidered)
                l = params.duration - params.f_time_step;
            else
                l = obj.performanceTimeConsidered;
            end
            N =  l/ params.dt;
            %Check time
            fSample =freqVector((end-N):end);
            justesse = mean((fSample-consigne)/consigne);
            precision = std(fSample);
        end
        function criteria = GetCriteria(~, consigne)
            criteria = min([consigne*(2^(1/6)-1)/8 1]);
        end
    end

end


