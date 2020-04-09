function model = createModel_CordeBySegment(modelname,N,M,L,T,b,dt) 
load_system('simulink');
autoOption = 'on';

%So, what is this doing. It adds one ms function, one mux, constant, set
%sample time and returns the model. Then another functions run the
%simulations and everyone is happy.

blockname = 'CordeBySegment_SetupSimulink';
% create and open the model
model = new_system(modelname);

%Input ports
add_block('simulink/Sources/Constant', sprintf('%s/%s',modelname,'T'), 'Value',num2str(T)); %En vrai, ce ne sera pas constant...
add_block('simulink/Sources/Constant', sprintf('%s/%s',modelname,'Force'), 'Value',num2str(b));

add_block('simulink/Signal Routing/Mux',sprintf('%s/%s',modelname, 'ForceMux'),'inputs',num2str(N));
for i = 1:N
    add_line(modelname,sprintf('%s/%i','Force',1), sprintf('%s/%i','ForceMux', i),'autorouting',autoOption); 
end

%Add main block
cordeBlockName = sprintf('%s/%s',modelname , blockname);
add_block('simulink/User-Defined Functions/Level-2 M-file S-Function',cordeBlockName);
set_param(cordeBlockName,'FunctionName',blockname,'Parameters',sprintf('%d, %d, %d, %i, %d',M,L,b,N,dt));
% set_param(cordeBlockName,'Parameters',sprintf('%d, %d, %d, %i, %d',M,L,b,N,dt));
add_line(modelname, sprintf('%s/%i','T', 1),sprintf('%s/%i',blockname, 1),'autorouting',autoOption); 
add_line(modelname, sprintf('%s/%i','ForceMux', 1),sprintf('%s/%i',blockname, 2),'autorouting',autoOption); 

%Now, output.
add_block('simulink/Sinks/To Workspace',sprintf('%s/%s',modelname,'y_out'));
add_line(modelname, sprintf('%s/%i',blockname, 1),sprintf('%s/%i','y_out',1) ,'autorouting',autoOption); 

save_system(modelname);
end
