p = SimulationParameter();
p.pos_actuateur_relative = 0.6;
p.pos_capteur_relative = 0.4;


test =  SystemSimulator();
results = test.RunSimulation(p);

    