classdef AnimationCordeCreator
    %ANIMATIONCORDECREATOR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
         %N, timestep. Can be determined when we run the methods though
    end
    
    methods
        function obj = AnimationCordeCreator()
            %ANIMATIONCORDECREATOR Construct an instance of this class
            %   Detailed explanation goes here
        end
        
        function AnimateCorde(~, fig, datas, N, timestep, slowFactor, stopDelegate)   
            simulationStepTime = datas.Time(2)-datas.Time(1);
            animationTimeStepIdx = timestep/simulationStepTime;
            waitTime = (datas.Time(animationTimeStepIdx+1) - datas.Time(1))*slowFactor;
            
            x = 1:N;
            xi = linspace(0, N+1, N*6);
%             ymax = 1.25*max(max(max(abs(datas.Data)))); %0.003
%             figure(fig);
            
            for k = 1 : animationTimeStepIdx : length(datas.Time)
                if (stopDelegate())
                    break;
                end
                y = datas.Data(k,x);
                yi = interp1([0 x N+1], [0 y 0], xi, 'spline', 'extrap');
                plot(fig, xi, yi, '-r');
%                 title('Animation de la corde');
%                 hold off;
%                 grid;
%                 xlim([0 N+1]);
%                 ylim([-1*ymax ymax]);
%                 xlabel('Segments de corde');
%                 ylabel('Position');
                drawnow limitrate;
                pause(waitTime);
            end
        end
    end
end

