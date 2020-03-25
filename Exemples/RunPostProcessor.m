%Exemples de plusieurs simulations.

paramsArray = SimulationParameterManager();
%Celui-ci contient des arrays des diff�rents param�tres � tester et permet
%d'�num�rer l'ensemble des combinaisons. Par d�faut, il tient seulement les
%param�tres par SimulationParameter.

paramsArray.pos_actuateur_relative = 0:0.05:1; 
% Attention, les donn�es relatives doivent �tre entre 0 et 1. Le UI va
% �ventuellement prot�ger contre des valeurs autres, mais pas cet objet.


simulator = SystemSimulator(); % C'est lui qui conna�t Simulink.
simulatorManager = SimulatorManager(simulator); % Il permet juste de coordonner les simulations.

NbSims = paramsArray.GetNumberOfSimulation();
results = simulatorManager.Simulate(paramsArray.EnumerateSimulationParameters());
%Je suis ouvert � changer le output results pour avoir un format plus
%pratique.



%Graphiques � produire
% - Pour un (ou plusieurs?) param�tres, afficher les courbes de
% performance.
% - Tableau des performances pour toutes les simulations. (directement dans
% le UI)
% - Autre chose???
