N = 25; %nb segments
L = 0.443; %m
M = 0.00325; %g
T = 68.77; %N;
b = 0;

corde = CordeBySegment(N,L,M,b,T);

dt = 0.001;
f(1:N) = 0;


for i = 1:(round(10/dt))
    x = corde.CalculateNextPosition(dt,f);
end

