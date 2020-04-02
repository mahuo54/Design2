%Exemples de plusieurs simulations.

paramsArray = SimulationParameterManager();
%Celui-ci contient des arrays des différents paramètres à tester et permet
%d'énumérer l'ensemble des combinaisons. Par défaut, il tient seulement les
%paramètres par SimulationParameter.

% paramsArray.pos_actuateur_relative = 0:0.25:1; 
% paramsArray.pos_capteur_relative = 0:0.25:1; 
% paramsArray.Frequence_final = 130:10:140;
paramsArray.gainVoltageAngle = 700:50:900;
% Attention, les données relatives doivent être entre 0 et 1. Le UI va
% éventuellement protéger contre des valeurs autres, mais pas cet objet.

simulator = SystemSimulator(); % C'est lui qui connaît Simulink.
simulatorManager = SimulatorManager(simulator); % Il permet juste de coordonner les simulations.

NbSims = paramsArray.GetNumberOfSimulation();
results = simulatorManager.Simulate(paramsArray.EnumerateSimulationParameters()); 
%Accessible également par results = simulatorManager.resultsByParameter.
%Overwrite at each run of Simulate
%Je suis ouvert à changer le output results pour avoir un format plus
%pratique. Pour le moment, c'est un cell array de {parameter, result}


% save('RunPostProcessor');
% load('RunPostProcessor');


%Graphiques à produire
% - Pour un (ou plusieurs?) paramètres, afficher les courbes de
% performance.
% - Tableau des performances pour toutes les simulations. (directement dans
% le UI)
% - Autre chose???
