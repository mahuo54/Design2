function ex_masse_ressort(block)
%ex_masse_ressort Une S-Function Level-2 simulant le comportement d'un
%                 systeme masse-ressort.
%
%   E Poulin 2019.
setup(block);

% end function

function setup(block)
% Register number of ports
block.NumInputPorts  = 1;
block.NumOutputPorts = 1;

% Setup port properties to be inherited or dynamic
block.SetPreCompInpPortInfoToDynamic;
block.SetPreCompOutPortInfoToDynamic;

% Override input port properties
for i = 1:block.NumInputPorts
    block.InputPort(i).Dimensions  = 1;
    block.InputPort(i).DatatypeID  = 0;  % double
    block.InputPort(i).Complexity  = 'Real';
    block.InputPort(i).DirectFeedthrough = false;
    block.InputPort(i).SamplingMode = 'Sample';
end

% Override output port properties
for i = 1:block.NumOutputPorts
    block.OutputPort(i).Dimensions  = 1;
    block.OutputPort(i).DatatypeID  = 0; % double
    block.OutputPort(i).Complexity  = 'Real';
    block.OutputPort(i).SamplingMode = 'Sample';
end

% Register parameters
block.NumDialogPrms = 5;

% Set up the continuous states
block.NumContStates = 2;

% Register sample times
block.SampleTimes = [0 0];

% Specify the block simStateCompliance
block.SimStateCompliance = 'DefaultSimState';

% Register methods
block.RegBlockMethod('InitializeConditions', @InitializeConditions);
block.RegBlockMethod('Outputs', @Outputs);
block.RegBlockMethod('Derivatives', @Derivatives);

%end setup

function InitializeConditions(block)
% Position initiale
block.ContStates.Data(1) = block.DialogPrm(4).Data;

% Vitesse initiale
block.ContStates.Data(2) = block.DialogPrm(5).Data;

%end InitializeConditions

function Outputs(block)
% Postion
x1  = block.ContStates.Data(1);

block.OutputPort(1).Data = x1;

%end Outputs

function Derivatives(block)
% Parametres 
m = block.DialogPrm(1).Data;
b = block.DialogPrm(2).Data;
k = block.DialogPrm(3).Data;

% Force appliquee
f = block.InputPort(1).Data;

% Etats
x1  = block.ContStates.Data(1);
x2  = block.ContStates.Data(2);

% Derivees
block.Derivatives.Data(1) = x2;
block.Derivatives.Data(2) = -(k/m)*x1 - (b/m)*x2 + (1/m)*f;

%end Derivatives
