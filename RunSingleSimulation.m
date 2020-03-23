
SimulationParams = SimulationParameterManager();
SimulationParams.SetToDefault();

simulator = SystemSimulator();
simulatorManager = SimulatorManager(simulator);

simulatorManager.Simulate(SimulationParams.EnumerateSimulationParameters());


result = simulatorManager.resultsByParameter{1}{2};

