%Exemple pour rouler une simulation. Le constructeur de SimulationParameter
%retourner les paramètres par défaut.

parameters = SimulationParameter();
parameters.f_final = 120;
parameters.f_start = 100;

simulator = SystemSimulator(); %Rien n'est modifiable sur le simulator.
open_system('SystemeCompletProcedural/Tension_corde');
result = simulator.RunSimulation(parameters);

%Quel est l'index de l'actuateur???
idx_actuateur = parameters.GetIndexActuateur();

save('RunSingleSim.mat');

% load('RunSingleSim.mat');

%Graphique à générer et résultats à obtenir - Ces graphiques apparaîtront
%seulement lorsqu'il y a une seule simulation
%
% - Performances : Justesse, Vitesse d'accord (Justesse et précision si on
% répétait plusieurs mesures avec du bruit, mais je ne crois pas que ce
% soit nécessaire)
% - Animation de la corde : C'est pas mal fait par Jean. Vérifier si on
% peut modifier la vitesse d'affichage
% - Oscillation des segments en fct du temps : Déjà fait par Jean
% - Liste des inputs/outputs du système : Il faut ajouter les outputs aux
% systèmes Simulinks pour obtenir les résultats. Simple à faire par la
% suite.

