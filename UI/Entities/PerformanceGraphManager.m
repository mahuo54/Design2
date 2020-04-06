classdef PerformanceGraphManager < handle 
    properties
        simulationDataFormator SimulationDataFormator;
        group;
        uniqueParameter;
    end
    properties (Access = private)
        currentParameterName = "";
        idxCurrentParam;
    end
    
    methods
        function obj = PerformanceGraphManager(simulationDataFormator)
            obj.simulationDataFormator = simulationDataFormator;
        end
        %two diff callbacks, select param vs select performance., reset,
        %set parameter.
        function UpdateGraphHandler(obj, fig, p, criteria)
            p = string(p);
            criteria = string(criteria);
            if(obj.currentParameterName ~= p)
                obj.SetGroupFromParameter(p);
                obj.UpdateFigMetadata(fig, p, criteria);
            end            
            idx_perf = find( cellfun( @(x) x == criteria, obj.simulationDataFormator.ColumnName),1 , 'first');
            
            %Color gradient.
            if(isempty(obj.group))
                x = str2double(obj.simulationDataFormator.rowsDatas(:,obj.idxCurrentParam+1));
                y = str2double(obj.simulationDataFormator.rowsDatas(:, idx_perf));
                plot(fig,x,y);
            else
                colorGradient = jet(max(obj.group));
                for i = 1: max(obj.group)
                    x = str2double(obj.simulationDataFormator.rowsDatas(obj.group==i,obj.idxCurrentParam+1));
                    y = str2double(obj.simulationDataFormator.rowsDatas(obj.group==i, idx_perf));
                    plot(fig,x,y,'Color',colorGradient(i,:),'DisplayName', num2str(i));
                    hold(fig);
                end
                hold(fig, 'off');
            end
           
            %sadly, unsupported with current version of matlab...
%             dcm_obj = datacursormode(fig);
%             set(dcm_obj,'DisplayStyle','datatip',...
%                 'SnapToDataVertex','off','Enable','on')
%             set(dcm_obj,'UpdateFcn',@myupdatefcn)
        end
        function UpdateFigMetadata(~, fig, p, criteria)
            title(fig, 'Performance en fonction des paramètres');
            xlabel(fig, p);
            ylabel(fig, criteria);
        end
        function SetGroupFromParameter(obj, p) 
            obj.idxCurrentParam = find( cellfun( @(x) x == p, obj.simulationDataFormator.ParameterLabelName),1 , 'first');
            
            N = length(obj.simulationDataFormator.varyingParams);
            if (N==1)
                return;
            end
            paramToGroup = 1:N;
            paramToGroup(obj.idxCurrentParam) = [];
            paramToGroup = paramToGroup+1;  
            
            %Build command to find groups
            obj.uniqueParameter = {};
            rows = obj.simulationDataFormator.GetSuccessRow();
            paramsInputStr = strjoin(arrayfun( @(idx) sprintf('obj.uniqueParameter{:,%i}',idx),   1:length(paramToGroup), 'UniformOutput',   false), ',');
            rowsDataStr = strjoin(arrayfun( @(idx) sprintf('rows(:,%i)',idx),   paramToGroup, 'UniformOutput',   false), ',');
            cmdStr = sprintf('[obj.group,%s] = findgroups(%s)',paramsInputStr,rowsDataStr );
            eval(cmdStr);
            %G = findgroups(simulationDataFormator.rowsDatas(:,2),simulationDataFormator.rowsDatas(:,4));
        end        
    end
    methods (Access = private)
        function txt = myupdatefcn(~,event_obj)
            % Customizes text of data tips
            %Actually this would be where we call handler from app1 to
            %update data table. At the moment, just test for linewidth
%             pos = get(event_obj,'Position');
%             txt = {['Temps : ',num2str(pos(1))],...
%                 ['Amplitude : ',num2str(pos(2))], ...
%                 ['Freq : ', event_obj.Target.DisplayName]};
            
            for l = event_obj.Target.Parent.Children
                set(l,'LineWidth',0.5) ;
            end
            set(event_obj.Target,'LineWidth',2) ;
        end
    end
end

