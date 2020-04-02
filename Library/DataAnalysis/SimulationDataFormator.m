classdef SimulationDataFormator < handle
    %SIMULATIONDATAFORMATOR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ColumnName;
        rowsDatas;
        varyingParams;
        FinishAddRowDelegate;
    end
    
    methods
        function obj = SimulationDataFormator(FinishAddRowDelegate) %Thingy to calculate score and all
            if(nargin == 0)
               FinishAddRowDelegate = @obj.DoNothing; 
            end
            obj.FinishAddRowDelegate = FinishAddRowDelegate;
        end       
        function SetSimulation(obj, params)
            obj.SetColumnNames(params);
        end
%         function SetResults(obj, resultByParameter)
%             obj.SetDataCellsTable(resultByParameter);            
%         end
        
        function SingleSimulationFinishHandler(obj,eventSrc, eventData)
            AddRow(obj, eventData.result, eventData.param);
            obj.FinishAddRowDelegate(obj.rowsDatas);
        end
        
        function Reset(obj)
            obj.rowsDatas = {};
            obj.ColumnName = SimulationDataFormator.GetDefaultColumnName();
        end
    end
    methods (Access = public, Static)
        function ColumnNames = GetDefaultColumnName()
            ColumnNames  = {'Id' 'Succ�s' 'Temps' 'Justesse' 'Vitesse d''accord'};
        end
    end
    methods (Access = private)
        function SetColumnNames(obj, params)
            obj.varyingParams = params.GetVaryingParam();
            if(~isempty(obj.varyingParams))
                varyingParamLabels = cellfun(@(p) SimulationParameterManager.GetLabel(p), obj.varyingParams, 'UniformOutput',false);
                obj.ColumnName = ['Id' varyingParamLabels 'Succ�s' 'Temps' 'Justesse' 'Vitesse d''accord'];
            else
                obj.ColumnName = SimulationDataFormator.GetDefaultColumnName();
            end            
        end
        function AddRow(obj, result, params)
            i = size(obj.rowsDatas, 1)+1; %TODO - Check if correct idx 1/2
            if(isempty(result.ErrorMessage))
                successStr = 'Oui';
            else
                successStr = 'Non';
            end
            rowEnd = {successStr ...
                num2str(result.SimulationMetadata.TimingInfo.TotalElapsedWallTime) ...
                '?' '?'};
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
        function SetDataCellsTable(obj, resultsByParameter)
            %Populate rows.
            obj.rowsDatas = {};
            for i = 1:length(resultsByParameter)
                result = resultsByParameter{i}{2};
                params = resultsByParameter{i}{1};
                if(isempty(result.ErrorMessage))
                    successStr = 'Oui';
                else
                    successStr = 'Non';
                end
                rowEnd = {successStr ...
                    num2str(result.SimulationMetadata.TimingInfo.TotalElapsedWallTime) ...
                    '?' '?'};
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
%             set(app.ResultUITable, 'data', rowsDatas);
        end
        function DoNothing(obj,rowsDatas)
            %I'm a stupid language that can't see to have empty delegate.
        end
    end
end
