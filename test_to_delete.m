paramManager =  SimulationParameterManager();

paramManager.Frequence = 80:10:120; %5
paramManager.LinearDensity = 0.0032:0.001:0.0065; %4
paramManager.Length = 0.30:0.05:0.52; %5
paramManager.Duration = 10;

SimulationParametersArray = paramManager.EnumerateSimulationParameters();


test =  SystemSimulator('ModeleCompletSimple');
p = SimulationParametersArray(1);
p.pos_actuateur_relative = 0.6;
p.pos_capteur_relative = 0.4;
results = test.RunSimulation(p);

