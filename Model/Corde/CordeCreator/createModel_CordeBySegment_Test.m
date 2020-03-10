N = 25; %nb segments
L = 0.443; %m
M = 0.00325; %g
T = 68.77; %N;
b = 0;


dt = 0.0001;
modelname = 'KillmeAlready4';

model = createModel_CordeBySegment(modelname,N,M,L,T,b,dt) ;

in = Simulink.SimulationInput(modelname);
cs = getActiveConfigSet(modelname);
mdl_cs = cs.copy;
set_param(mdl_cs,...
         'StartTime','0','StopTime','10','SolverType','Fixed-step', 'FixedStep',num2str(dt));
     %          'SaveState','on','StateSaveName','xoutNew',...
%          'SaveOutput','on','OutputSaveName','youtNew',...
% 'AbsTol','1e-5',
out = sim(modelname, mdl_cs); %'StartTime','0','StopTime','10','FixedStep',num2str(dt));


plot(out.Time, out.Data(6,:))

