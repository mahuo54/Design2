paramManager =  SimulationParameterManager();

paramManager.Frequence = 80:10:120; %5
paramManager.LinearDensity = 0.0032:0.001:0.0065; %4
paramManager.Length = 0.30:0.05:0.52; %5
paramManager.Duration = 10;

NSim = paramManager.GetNumberOfSimulation(); %100
SimulationParametersArray = paramManager.EnumerateSimulationParameters();

assert(length(SimulationParametersArray)==NSim);

