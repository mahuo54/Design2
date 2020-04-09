
L = 0.443; %m
M = 0.00325; %g
T = 68.77; %N;
b = 0;

N_vector = [3 5 15 25 40 60 80 100];
dt_vector = [0.001 0.0005 0.00025 0.0001 0.00005 0.00001];

i = 1;

for N = N_vector
    for dt = dt_vector
        results(:,i) = RunModel(L,M,T,b,N,dt);
        i = i+1;
    end
end
writematrix(results,'resultsSimulation2.txt');



function result = RunModel(L,M,T,b,N,dt)
expectedF = sqrt(T*L/M)/2/L;

modelname = sprintf('SimulationCorde_%i_%i',N, dt*1000000);
model = createModel_CordeBySegment(modelname,N,M,L,T,b,dt) ;
% in = Simulink.SimulationInput(modelname);
cs = getActiveConfigSet(modelname);
mdl_cs = cs.copy;
set_param(mdl_cs,  'StartTime','0','StopTime','10','SolverType','Fixed-step', 'FixedStep',num2str(dt));
%          'SaveState','on','StateSaveName','xoutNew',...
%          'SaveOutput','on','OutputSaveName','youtNew',...
out = sim(modelname, mdl_cs); %'StartTime','0','StopTime','10','FixedStep',num2str(dt));

idx = round(N/2);
[PSD,f] = FT_FromVector(out.simout.Data(:,idx),out.simout.Time);

% plot(out.simout.Time(1000:1500), out.simout.Data(1000:1500,idx));
% plot(f,PSD);
[~,locs] = findpeaks(PSD,f,'MinPeakDistance',5, 'MinPeakHeight',max(PSD)/10);
if (isempty(locs))
    result = [L M T b N dt out.SimulationMetadata.TimingInfo.TotalElapsedWallTime expectedF 0 0 ];
else
    result = [L M T b N dt out.SimulationMetadata.TimingInfo.TotalElapsedWallTime expectedF locs(1) locs(2) ];
end

% text(locs+.02,pks,num2str((1:numel(pks))'))

end
