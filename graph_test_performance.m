paramsArray = SimulationParameterManager();
simulationDataFormator = SimulationDataFormator();
 
paramsArray.N = [20 25 30];
paramsArray.Frequence_final = 130:10:140;
paramsArray.gainVoltageAngle = 700:100:900;

simulator = SystemSimulator(); % C'est lui qui conna�t Simulink.
simulatorManager = SimulatorManager(simulator); % Il permet juste de coordonner les simulations.
simulationDataFormator.SetSimulation(paramsArray);

results = simulatorManager.Simulate(paramsArray.EnumerateSimulationParameters()); 
% disp(simulationDataFormator.varyingParams);

simulationDataFormator.AddArraysOfResultParameters(results);

fig = figure;

graphProducer =  PerformanceGraphManager(simulationDataFormator);

graphProducer.UpdateGraphHandler(fig, "N", "Justesse");
paramsArray.GetVaryingParam();

%Let's say we are intersted in N
% p = "N";
% idx_p = find( cellfun( @(x) x == p, simulationDataFormator.varyingParams),1 , 'first'); 
% %Upon select we know the values. Why would we care though hugh
% x_array = simulationDataFormator.MapVaryingParamsToValues('N');
% 
% %Hence we want all combination of the rest of the data in the map.
% % elements = {};
% % params = {};
% % for i = 1:length(simulationDataFormator.varyingParams)
% %     disp(simulationDataFormator.varyingParams{i});
% %     if ~(simulationDataFormator.varyingParams{i}==p)
% %         params = [params; simulationDataFormator.varyingParams{i}];
% %         elements = [elements; simulationDataFormator.MapVaryingParamsToValues(simulationDataFormator.varyingParams{i})];
% %     else
% %         disp(i);
% %         elements = [elements; 0];
% %     end    
% % end
% % combinations =  SimulationParameterManager.GetCombinations(elements);
% 
% 
% % cell2mat(simulationDataFormator.rowsDatas(:,2))
% 
% N = length(simulationDataFormator.varyingParams);
% paramToGroup = 1:N;
% paramToGroup(idx_p) = [];
% paramToGroup = paramToGroup+1;
% 
% G = findgroups(simulationDataFormator.rowsDatas(:,2),simulationDataFormator.rowsDatas(:,4));
% performanceLabel = "";
% idx_perf = 10;
% %that's actually the only thing we want to have.
% for i = 1: max(G)
%    x = simulationDataFormator.rowsDatas(G==i,idx_p+1);
%    y = simulationDataFormator.rowsDatas(G==i, idx_perf);
% end
% 
% for i =  1:length(combinations)
%     
%     isDataToShow = false;
%     for j = 1:length(simulationDataFormator.varyingParams)
%         if(j==idx_p)
%             continue;
%         else
%             
%         end        
%     end    
%     %Get the data from simulationDataFormator
%     %Pues, el index es 1 + idx; skip idx of selected param.
%     %Draw the line
% end


%two diff callbacks, select param vs select performance.