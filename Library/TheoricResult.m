%Continuous model
M = 0.00325; %kg
L = 0.443;  %m
T = 68.77; %N

n=1;
N=1;

f = GetFrequencyContinuousModel(n,T,M,L); %Expected empirical result. We had 110Hz
f2 = GetWDiscreteModel(n,N,T,M,L)/(2*pi);

N_vector = 1:100;

f_discrete = arrayfun(@(a) GetFDiscreteModel(n,a,T,M,L), N_vector);

plot(N_vector, f_discrete);
yline(f, 'r');

function f = GetFrequencyContinuousModel(n,T, M, L)
    f = n/(2*L)*sqrt(T*L/M);
end

function w = GetWDiscreteModel(n, N, T, M,L )
    m = M/N;
    l = L/(N+1);
    w = sqrt(T/(m*l))*sin(n*pi/(2*(N+1)));
end

function f = GetFDiscreteModel(n,N,T,M,L)
    f = GetWDiscreteModel(n,N,T,M,L)/(2*pi);
end