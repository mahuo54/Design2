classdef CordeBySegment_SimulinkWrapper < handle
    properties (Access = private)
        corde CordeBySegment; %We could use an interface instead if we wanted multiple models.
        isCordeInitialized;
        stupidSampleTimeMightNotBeRealOne;
    end
    methods
        function obj = CordeBySegment_SimulinkWrapper(corde)
            obj.isCordeInitialized = false;
            obj.corde = corde; %Fuck. Not working. I want to create the corde from the parameter...
        end
    end
    methods(Static)
        function SetupBlock(block)
            %I need to initialize my model from the parameters. The way I'm
            %doing it you can't change the paramters through the simulation
            %though. Shouldn't happen unless going crazy.
            
            % Register parameters
            block.NumDialogPrms     = 5;%M, L, b, N
            M = block.DialogPrm(1).Data; %masse d'un segment
            L = block.DialogPrm(2).Data; %longueur d'un segment
            b = block.DialogPrm(3).Data; %frottement
            N = block.DialogPrm(4).Data; %N
            positionInitiale(1:N) = 0;
            vitesseInitiale(1:N) = 0;
            corde = CordeBySegment(N,L,M,b,0,positionInitiale,vitesseInitiale); %Initially, it's setup at 0, but it's gonna be updated on the first run.
            cordeWrapper = CordeBySegment_SimulinkWrapper(corde);
            cordeWrapper.stupidSampleTimeMightNotBeRealOne = block.DialogPrm(5).Data; %Not sure the time it takes to access the data, would rather have it in memory.
            
            %Register number of ports
            block.NumInputPorts  = 4;
            block.NumOutputPorts = 1;
            
            % Setup port properties to be inherited or dynamic
            block.SetPreCompInpPortInfoToDynamic;
            block.SetPreCompOutPortInfoToDynamic;
            
            % Override input port properties
            %Tension
            block.InputPort(1).Dimensions  = 1;
            block.InputPort(1).DatatypeID  = 0;  % double
            block.InputPort(1).Complexity  = 'Real';
            block.InputPort(1).DirectFeedthrough = true;
            
            %Force
            block.InputPort(2).Dimensions  = cordeWrapper.corde.N;
            block.InputPort(2).DatatypeID  = 0;  % double
            block.InputPort(2).Complexity  = 'Real';
            block.InputPort(2).DirectFeedthrough = true;
            
            %X_0
            block.InputPort(3).Dimensions  = cordeWrapper.corde.N;
            block.InputPort(3).DatatypeID  = 0;  % double
            block.InputPort(3).Complexity  = 'Real';
            block.InputPort(3).DirectFeedthrough = true;
            
            %V_0
            block.InputPort(4).Dimensions  = cordeWrapper.corde.N;
            block.InputPort(4).DatatypeID  = 0;  % double
            block.InputPort(4).Complexity  = 'Real';
            block.InputPort(4).DirectFeedthrough = true;
            
            % Override output port properties - Position
            block.OutputPort(1).Dimensions  = cordeWrapper.corde.N;
            block.OutputPort(1).DatatypeID  = 0; % double
            block.OutputPort(1).Complexity  = 'Real';
            
            % Register sample times
            %  [0 offset]            : Continuous sample time
            %  [positive_num offset] : Discrete sample time
            %
            %  [-1, 0]               : Inherited sample time
            %  [-2, 0]               : Variable sample time
            block.SampleTimes = [cordeWrapper.stupidSampleTimeMightNotBeRealOne 0]; %Might want to inherit it though, or we could pass it as an argument...
            % Specify the block simStateCompliance. The allowed values are:
            %    'UnknownSimState', < The default setting; warn and assume DefaultSimState
            %    'DefaultSimState', < Same sim state as a built-in block
            %    'HasNoSimState',   < No sim state
            %    'CustomSimState',  < Has GetSimState and SetSimState methods
            %    'DisallowSimState' < Error out when saving or restoring the model sim state
            block.SimStateCompliance = 'DefaultSimState';
            
            %% -----------------------------------------------------------------
            %% The MATLAB S-function uses an internal registry for all
            %% block methods. You should register all relevant methods
            %% (optional and required) as illustrated below. You may choose
            %% any suitable name for the methods and implement these methods
            %% as local functions within the same file. See comments
            %% provided for each function for more information.
            %% -----------------------------------------------------------------
            
            block.RegBlockMethod('PostPropagationSetup',    @cordeWrapper.DoPostPropSetup);
            %block.RegBlockMethod('InitializeConditions', @InitializeConditions);
            block.RegBlockMethod('Start', @cordeWrapper.Start);
            block.RegBlockMethod('Outputs', @cordeWrapper.Outputs);     % Required
            block.RegBlockMethod('Update', @cordeWrapper.Update);
            block.RegBlockMethod('Derivatives', @cordeWrapper.Derivatives);
            block.RegBlockMethod('Terminate', @cordeWrapper.Terminate); % Required
            
        end
    end
    methods (Access = protected)
        function DoPostPropSetup(obj, block)
            block.NumDworks = 1;
            
            block.Dwork(1).Name            = 'x';
            block.Dwork(1).Dimensions      = obj.corde.N;
            block.Dwork(1).DatatypeID      = 0;      % double
            block.Dwork(1).Complexity      = 'Real'; % real
            block.Dwork(1).UsedAsDiscState = true;
            
            %             block.Dwork(2).Name            = 'v'; %Not actually used..
            %             block.Dwork(2).Dimensions      = obj.corde.N;
            %             block.Dwork(2).DatatypeID      = 0;      % double
            %             block.Dwork(2).Complexity      = 'Real'; % real
            %             block.Dwork(2).UsedAsDiscState = true;
        end
        function Start(~, ~)
        end
        function Outputs(~, block)
            block.OutputPort(1).Data = block.Dwork(1).Data;
        end
        function Update(obj, block)
            if(~obj.isCordeInitialized)
                obj.corde.ForceInitialValue(block.InputPort(3).Data,block.InputPort(4).Data);
                obj.isCordeInitialized = true;
            end
            dt = obj.stupidSampleTimeMightNotBeRealOne;%block.SampleTimes(1); %I can't believe how hard it is to ge tthe fufdjsdfkasj sampel time. Inherited base itself from input, but input inherited too. Can't find a reference to the model name and even then not sure how to find it... ughhh
            T = block.InputPort(1).Data;
            if(T ~= obj.corde.T) %%When we set T, we recalculate internal matrix A.
                obj.corde.T = T;
            end            
            f = block.InputPort(2).Data; %force
            block.Dwork(1).Data = obj.corde.CalculateNextPosition(dt,f);
        end
        function Derivatives(~,~)
        end
        function Terminate(~,~)
        end
    end
end