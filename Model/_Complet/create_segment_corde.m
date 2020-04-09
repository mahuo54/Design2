function create_segment_corde(modelname,N,M,L,T,b) 
load_system('simulink');
autoOption = 'on';

blockname = 'segment_corde';
% create and open the model
model = new_system(modelname);

%Parameters. We need to create block for each of them...
add_block('simulink/Sources/Constant', sprintf('%s/%s',modelname,'N'), 'Value',num2str(N));
add_block('simulink/Sources/Constant', sprintf('%s/%s',modelname,'M'), 'Value',num2str(M));
add_block('simulink/Sources/Constant', sprintf('%s/%s',modelname,'L'), 'Value',num2str(L));
add_block('simulink/Sources/Constant', sprintf('%s/%s',modelname,'T'), 'Value',num2str(T));
add_block('simulink/Sources/Constant', sprintf('%s/%s',modelname,'b'), 'Value',num2str(b));

add_block('simulink/Sources/Constant', sprintf('%s/%s',modelname','1'), 'Value','1');

add_block('simulink/Math Operations/Add',sprintf('%s/%s',modelname,'N+1'));
add_line(modelname, sprintf('%s/%i','N',1), sprintf('%s/%i','N+1',1),'autorouting',autoOption); 
add_line(modelname, sprintf('%s/%i','1',1), sprintf('%s/%i','N+1',2),'autorouting',autoOption);

add_block('simulink/Math Operations/Divide',sprintf('%s/%s',modelname,'l'));
add_line(modelname, sprintf('%s/%i','L',1), sprintf('%s/%i','l',1),'autorouting',autoOption); 
add_line(modelname, sprintf('%s/%i','N+1',1), sprintf('%s/%i','l',2),'autorouting',autoOption); 

add_block('simulink/Math Operations/Divide',sprintf('%s/%s',modelname,'m'));
add_line(modelname, sprintf('%s/%i','M',1), sprintf('%s/%i','m',1),'autorouting',autoOption); 
add_line(modelname, sprintf('%s/%i','N',1), sprintf('%s/%i','m',2),'autorouting',autoOption); 

%Set initial block
firstBlockName = sprintf('%s/%s%i',modelname , blockname, 1);
add_block('simulink/User-Defined Functions/Level-2 M-file S-Function',firstBlockName);
set_param(firstBlockName,'FunctionName',blockname);
ConnectBlock(modelname, sprintf('%s%i',blockname,1),autoOption);

param = get_param(firstBlockName, 'Position');
width = param(3) - param(1);
height = param(4) - param(2);

last_right = param(3);
% precedentBlockName = firstBlockName;
for i = 2:N
    %Create block
    currentBlockName = sprintf('%s/%s%i',modelname , blockname, i);
    add_block('simulink/User-Defined Functions/Level-2 M-file S-Function',currentBlockName);
    set_param(currentBlockName,'FunctionName',blockname);
    
    %Set position
    pos = [last_right+width/2  param(2) last_right+3*width/2 param(4)];
    last_right = pos(3);
    set_param(currentBlockName, 'Position', pos);
    
    %Link both block;
    add_line(modelname, sprintf('%s%i/%i',blockname, i-1,1), sprintf('%s%i/%i',blockname, i,1),'autorouting',autoOption); %pos
    add_line(modelname, sprintf('%s%i/%i',blockname, i,1), sprintf('%s%i/%i',blockname, i-1,2),'autorouting',autoOption); %pos
    ConnectBlock(modelname, sprintf('%s%i',blockname,i),autoOption);
    
end
%Set position input to limit blocks 
add_block('simulink/Sources/Constant', sprintf('%s/%s',modelname','Extrémité'), 'Value','0');
add_line(modelname, sprintf('%s/%i','Extrémité',1), sprintf('%s%i/%i',blockname, 1,1),'autorouting',autoOption); 
add_line(modelname, sprintf('%s/%i','Extrémité',1), sprintf('%s%i/%i',blockname, N,2),'autorouting',autoOption); 

%Add mux force - We also should be able to set the initial position, no?
add_block('simulink/Sources/Constant', sprintf('%s/%s',modelname','Force'), 'Value','0');
add_block('simulink/Signal Routing/Mux',sprintf('%s/%s',modelname, 'ForceMux'),'inputs',num2str(N));
for i = 1:N
    add_line(modelname,sprintf('%s/%i','Force',1), sprintf('%s/%i','ForceMux', i),'autorouting',autoOption); 
    add_line(modelname, sprintf('%s/%i','ForceMux', 1),sprintf('%s%i/%i',blockname, i,3),'autorouting',autoOption); 
end

%output
add_block('simulink/Signal Routing/Mux',sprintf('%s/%s',modelname, 'PositionMux'),'inputs',num2str(N));
add_block('simulink/Signal Routing/Mux',sprintf('%s/%s',modelname, 'VitesseMux'),'inputs',num2str(N));
for i = 1:N
    add_line(modelname, sprintf('%s%i/%i',blockname, i,1), sprintf('%s/%i','PositionMux', i),'autorouting',autoOption); 
    add_line(modelname, sprintf('%s%i/%i',blockname, i,2), sprintf('%s/%i','VitesseMux', i),'autorouting',autoOption); 
end
add_block('simulink/Sinks/To Workspace',sprintf('%s/%s',modelname,'y_out'));
add_line(modelname, sprintf('%s/%i','PositionMux', 1),sprintf('%s/%i','y_out',1) ,'autorouting',autoOption); 

add_block('simulink/Sinks/To Workspace',sprintf('%s/%s',modelname,'v_out'));
add_line(modelname, sprintf('%s/%i','VitesseMux', 1),sprintf('%s/%i','v_out',1) ,'autorouting',autoOption);

open_system(model);
save_system(modelname);
end

function ConnectBlock(modelname, blockname, autoOption)
    %Add line to T, m, b,l
    add_line(modelname, sprintf('%s/%i','m',1), sprintf('%s/%i',blockname,4),'autorouting',autoOption); 
    add_line(modelname, sprintf('%s/%i','T',1), sprintf('%s/%i',blockname,5),'autorouting',autoOption); 
    add_line(modelname, sprintf('%s/%i','l',1), sprintf('%s/%i',blockname,6),'autorouting',autoOption); 
    add_line(modelname, sprintf('%s/%i','b',1), sprintf('%s/%i',blockname,7),'autorouting',autoOption); 
%     if ~( missing(precedentblockname) || precedentblockname == "")
%         add_line(modelname, sprintf('%s/%i',precedentblockname,1), sprintf('%s/%i',blockname,1),'autorouting',autoOption); 
%     end
end
