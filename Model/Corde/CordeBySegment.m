classdef CordeBySegment < handle
    properties
        N int32;
        L double;
        M double;
        b double;
        T double;
    end
    properties (SetAccess=protected)
        x;
        v;
        k;
        K;
        m double;
        l double;
    end
    methods
        function obj = CordeBySegment(N,L,M,b,T,positionInitiale,vitesseInitiale)
            if nargin < 5
                error('Wrong number of input arguments');
            end
            obj.N = N;
            obj.L = L;
            obj.M = M;
            obj.b(1:N) = b;
            %Set protected properties
            obj.m = M/N;
            obj.l = L/(N+1);
            if nargin < 7
                obj.v = zeros(N);
            else
                obj.v = vitesseInitiale;
            end
            if nargin < 6
                obj.x = zeros(N);
            else
                obj.x = positionInitiale;
            end
            obj.T = T; %At the end because it initialize the rest
        end
        
        function pos = CalculateNextPosition(obj,dt,f)
            if nargin == 1
                f = zeros(obj.N);
            end
            A = obj.K*obj.x-obj.b*obj.v/obj.m + f/obj.m;
            obj.v = obj.v + dt*A;
            obj.x = obj.x + dt*obj.v;
            pos = obj.x;
        end
        function set.T(obj, value)
            obj.T = value;
            obj.Calculate_k();
        end
    end
    methods (Access = private)
        function obj = Calculate_k(obj)
            obj.k = obj.T/(obj.m*obj.l);
            obj.K = diag(-2*obj.k*ones(1,obj.N)) + [zeros(obj.N-1,1) diag(obj.k*ones(1,obj.N-1)); zeros(1, obj.N)] + [zeros(1, obj.N);diag(obj.k*ones(1,obj.N-1)) zeros(obj.N-1,1)];
        end
    end
end