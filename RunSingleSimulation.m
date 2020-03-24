
SimulationParams = SimulationParameterManager();
SimulationParams.SetToDefault();

simulator = SystemSimulator();
simulatorManager = SimulatorManager(simulator);

simulatorManager.Simulate(SimulationParams.EnumerateSimulationParameters());

result_1 = simulatorManager.resultsByParameter{1}{2};

parameters = SimulationParameter();
simulator = SystemSimulator();
result = simulator.RunSimulation(parameters);


