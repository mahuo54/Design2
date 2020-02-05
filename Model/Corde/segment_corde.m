function segment_corde(block)
%ex_masse_ressort Une S-Function Level-2 simulant le comportement d'un
%                 systeme masse-ressort.
%
%   E Poulin 2019.
setup(block);

% end function

function setup(block)

% Register number of ports
block.NumInputPorts  = 7;
block.NumOutputPorts = 2;

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
block.NumDialogPrms = 0;

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
block.ContStates.Data(1) = 0;

% Vitesse initiale
block.ContStates.Data(2) = 0;

%end InitializeConditions

function Outputs(block)
% Postion
x1  = block.ContStates.Data(1);
v = block.ContStates.Data(2);
block.OutputPort(2).Data = v;
block.OutputPort(1).Data = x1;


%end Outputs

function Derivatives(block)
% Parametres 
m = block.InputPort(4).Data;%masse du segment
T = block.InputPort(5).Data;
l = block.InputPort(6).Data;%longueur du segment
b = block.InputPort(7).Data;
% Force appliquee
f = block.InputPort(3).Data;
y1 = block.InputPort(1).Data;
y2 = block.InputPort(2).Data;
% Etats
x1  = block.ContStates.Data(1);
v  = block.ContStates.Data(2);

% Derivees
block.Derivatives.Data(1) = v;
block.Derivatives.Data(2) = -(T/(m*l))*(2*x1-y1-y2) - (b/m)*v + (1/m)*f;

%end Derivatives
