classdef SimulationDataFormator < handle
    %SIMULATIONDATAFORMATOR Summary of this class goes here
    %   Detailed explanation goes here
    properties
        ColumnName;
        varyingParams;
        ParameterLabelName;
        rowsDatas;        
        MapVaryingParamsToValues;
        MapLabelToValues;
        
        FinishAddRowDelegate;
    end
    events
        NewRowAdded;
    end
    properties (Constant)
        criteriaName = {'Justesse' 'Pr�cision' 'Vitesse d''accord' 'Amplitude' 'Ratio harmonique' 'Fr�quence'};
    end
    
    methods
        function obj = SimulationDataFormator(FinishAddRowDelegate) %Thingy to calculate score and all
            if(nargin == 0)
               FinishAddRowDelegate = @obj.DoNothing; 
            end
            obj.FinishAddRowDelegate = FinishAddRowDelegate;
        end 
        function rowsDatas = GetSuccessRow(obj)
            rowsDatas = obj.rowsDatas(obj.rowsDatas(:,obj.ColumnName == "Succ�s")=="Oui",:);
        end
        function SetSimulation(obj, params)
            obj.SetColumnNames(params);
            paramNames = params.GetVaryingParam();
            obj.MapVaryingParamsToValues = containers.Map('KeyType','char','ValueType','any');
            obj.MapLabelToValues = containers.Map('KeyType','char','ValueType','any');

            for i = 1:length(paramNames)
                obj.MapVaryingParamsToValues(paramNames{i}) = eval(strcat('params.',paramNames{i}));
                obj.MapLabelToValues(SimulationParameterManager.GetLabel( paramNames{i})) = eval(strcat('params.',paramNames{i}));
            end
        end
        
        function SingleSimulationFinishHandler(obj,eventSrc, eventData)
            AddRow(obj, eventData.result, eventData.param, eventData.performance);
            obj.FinishAddRowDelegate(obj.rowsDatas);
            notify(obj, 'NewRowAdded',eventData);
        end
        
        function AddArraysOfResultParameters(obj,resultsByParameters)
            for i = 1:length(resultsByParameters)
                result = resultsByParameters{i};
                AddRow(obj, result{2}, result{1}, result{3});
            end
            obj.FinishAddRowDelegate(obj.rowsDatas);
        end
        
        function Reset(obj)
            obj.rowsDatas = {};
            obj.ColumnName = SimulationDataFormator.GetDefaultColumnName();
        end
    end
    methods (Access = public, Static)
        function ColumnNames = GetDefaultColumnName()
            ColumnNames  = ['Id' 'Succ�s' 'Temps' SimulationDataFormator.criteriaName];
        end
    end
    methods (Access = private)
        function SetColumnNames(obj, params)
            obj.varyingParams = params.GetVaryingParam();
            if(~isempty(obj.varyingParams))
                varyingParamLabels = cellfun(@(p) SimulationParameterManager.GetLabel(p), obj.varyingParams, 'UniformOutput',false);
                obj.ParameterLabelName = varyingParamLabels;
                obj.ColumnName = ['Id' varyingParamLabels 'Succ�s' 'Temps' SimulationDataFormator.criteriaName];
            else
                obj.ColumnName = SimulationDataFormator.GetDefaultColumnName();
            end            
        end
        function AddRow(obj, result, params, performance)
            i = size(obj.rowsDatas, 1)+1; %TODO - Check if correct idx 1/2
            if(isempty(result.ErrorMessage))
                successStr = 'Oui';
            else
                successStr = 'Non';
            end
            rowEnd = {successStr ...
                num2str(result.SimulationMetadata.TimingInfo.TotalElapsedWallTime) ...
                num2str(performance.Justesse) num2str(performance.Precision) num2str(performance.Vitesse) num2str(performance.A) num2str(performance.RatioHarmonique) num2str(result.freq.Data(end))};
            %create the row. first try it without the varying params
            if(~isempty(obj.varyingParams))
                paramRow = {};
                for p = 1:length(obj.varyingParams)
                    paramValueStr = SimulationParameterManager.GetParameterValueStr(obj.varyingParams{p}, params); %are they the same though? fuuuuckkk. same with the name actually... get method to return the label name and the param value.
                    paramRow = [paramRow paramValueStr];
                end
                row = [num2str(i) paramRow rowEnd];
            else
                row = [num2str(i) rowEnd];
            end
            obj.rowsDatas = [obj.rowsDatas; row];
        end
      
        function DoNothing(obj,rowsDatas)
            %I'm a stupid language that can't see to have empty delegate.
        end
    end
end

