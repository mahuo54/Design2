classdef CordeBySegment < handle
    properties
        N int32;
        L double;
        M double;
        b double;
        T double;
    end
    properties (SetAccess=protected)
%         i = 0;
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
            obj.b = b;
            %Set protected properties
            obj.m = M/N;
            obj.l = L/(N+1);
            if nargin < 7
                obj.v(1:N,1) = 0;
            else
                obj.v = vitesseInitiale(:);
            end
            if nargin < 6
                obj.x(1:N,1) = 0;
            else
                obj.x = positionInitiale(:);
            end
            obj.T = T; %At the end because it initialize the rest
        end
        function pos = CalculateNextPosition(obj,dt,f)
            if nargin == 1
                f(1:obj.N,1) = 0;
            else
                f = f(:);
            end
            A = obj.K*obj.x-obj.b*obj.v/obj.m + f/obj.m;
            obj.v = obj.v + dt*A;
            obj.x = obj.x + dt*obj.v;
            pos = obj.x;
        end
        function ForceInitialValue(obj,x0, v0)
            obj.x = x0;
            obj.v = v0;
        end
        function set.T(obj, value)
            obj.T = value;
            obj.Calculate_k();
        end
    end
    methods (Access = private)
        function obj = Calculate_k(obj)
            obj.k = obj.T/(obj.m*obj.l);
            obj.K = obj.k*(diag(-2*ones(1,obj.N)) + [zeros(obj.N-1,1) diag(ones(1,obj.N-1)); zeros(1, obj.N)] + [zeros(1, obj.N);diag(ones(1,obj.N-1)) zeros(obj.N-1,1)]);
        end
    end
end