classdef SimulationDataFormator < handle
    %SIMULATIONDATAFORMATOR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ColumnName;
        rowsDatas;
        varyingParams;
    end
    
    methods
        function obj = SimulationDataFormator() %Thingy to calculate score and all

        end       
        function SetSimulation(obj, params)
            obj.SetColumnNames(params);
        end
        function SetResults(obj, resultByParameter)
            obj.SetDataCellsTable(resultByParameter);            
        end
    end
    methods (Access = public, Static)
        function ColumnNames = GetDefaultColumnName()
            ColumnNames  = {'Id' 'Succès' 'Temps' 'Justesse' 'Vitesse d''accord'};
        end
    end
    methods (Access = private)
        function SetColumnNames(obj, params)
            obj.varyingParams = params.GetVaryingParam();
            if(~isempty(obj.varyingParams))
                varyingParamLabels = cellfun(@(p) SimulationParameterManager.GetLabel(p), obj.varyingParams, 'UniformOutput',false);
                obj.ColumnName = ['Id' varyingParamLabels 'Succès' 'Temps' 'Justesse' 'Vitesse d''accord'];
            else
                obj.ColumnName = SimulationDataFormator.GetDefaultColumnName();
            end            
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
    end
end

