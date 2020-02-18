N = 25; %nb segments
L = 0.443; %m
M = 0.00325; %g
T = 68.77; %N;
b = 0;
positionInitiale(1:N) = 0;
positionInitiale(round(N/2)) = 0.001; %m
vitesseInitiale(1:N) = 0;

corde = CordeBySegment(N,L,M,b,T,positionInitiale,vitesseInitiale);

dt = 0.0001;
f(1:N) = 0;

x = corde.CalculateNextPosition(dt,f);

x;