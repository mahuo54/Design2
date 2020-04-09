results = readmatrix('resultsSimulation2.txt');

%[L M T b N dt out.SimulationMetadata.TimingInfo.TotalElapsedWallTime expectedF locs(1) locs(2) ];

%I want to plot the two variables, N, dt and the resulting time and lambda error


y = [results( [5 6 7],:);results( 9,:)-results( 8,:);results(9,:)==0];

%
N = unique(y(1,:));
dt = unique(y(2,:));

for i= 1:length(N)
   for j = 1:length(dt)
       l(i,j) = y(4,y(1,:)==N(i) & y(2,:) == dt(j));
       t(i,j) = y(3,y(1,:)==N(i) & y(2,:) == dt(j));
   end
end


surf(N, dt, l' , t');
zlim( [ -10 10])
xlabel('Nombre de segments');
ylabel('Temps d''échantillonage (s)');
zlabel('Erreur sur la fréquence estimée (Hz)');
c = colorbar;
c.Label.String = 'Temps de calcul (s)';
