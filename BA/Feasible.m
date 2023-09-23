function [ result ] = Feasible( Position,nVms, VMs, CreatedVMs, nServer, serverProcessor, serverRam, serverBandwidth )
%ISFEASIBLE Summary of this function goes here
%   Detailed explanation goes here
server = zeros (nServer,3);
result = true;

for i=1:nVms
   
    server(Position(i),1) = server(Position(i),1) + VMs.Cores(CreatedVMs(i));
    server(Position(i),2) = server(Position(i),2) + VMs.Ram(CreatedVMs(i));
    server(Position(i),3) = server(Position(i),3) + VMs.Bandwidth(CreatedVMs(i));
    

end

for i=1:length(server)
    
    if server(i,1)>serverProcessor || server(i,2) > serverRam || server(i,3) >serverBandwidth
   
        result = false;
        break;
        
    end
    
end



