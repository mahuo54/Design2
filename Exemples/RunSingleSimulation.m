%Exemple pour rouler une simulation. Le constructeur de SimulationParameter
%retourner les param�tres par d�faut.

parameters = SimulationParameter();
parameters.f_final = 120;
parameters.f_start = 80;
% parameters.duration = 1;

simulator = SystemSimulator(); %Rien n'est modifiable sur le simulator.
% open_system('SystemeCompletProcedural/Position_corde'); 
% open_system('SystemeCompletProcedural/Position_capt�e'); 
% open_system('SystemeCompletProcedural/Tension_corde'); %Je vais
% open_system('SystemeCompletProcedural/Freq'); %Je vais
result = simulator.RunSimulation(parameters);

%Quel est l'index de l'actuateur???
idx_actuateur = parameters.GetIndexActuateur();

% save('RunSingleSim.mat');
% 
% load('RunSingleSim.mat');

%Graphique � g�n�rer et r�sultats � obtenir - Ces graphiques appara�tront
%seulement lorsqu'il y a une seule simulation
%
% - Performances : Justesse, Vitesse d'accord (Justesse et pr�cision si on
% r�p�tait plusieurs mesures avec du bruit, mais je ne crois pas que ce
% soit n�cessaire)
% - Animation de la corde : C'est pas mal fait par Jean. V�rifier si on
% peut modifier la vitesse d'affichage
% - Oscillation des segments en fct du temps : D�j� fait par Jean
% - Liste des inputs/outputs du syst�me : Il faut ajouter les outputs aux
% syst�mes Simulinks pour obtenir les r�sultats. Simple � faire par la
% suite.

%{'Id' 'Succ�s' 'Temps' 'Justesse' 'Vitesse d''accord'}



