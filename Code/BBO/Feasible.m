function [ result ] = Feasible( pop,nVms, VMs, CreatedVMs, nServer, serverProcessor, serverRam, serverBandwidth )
%ISFEASIBLE Summary of this function goes here
%   Detailed explanation goes here
server = zeros (nServer,3);
result = true;

for i=1:nVms
   
    server(pop.Position(i),1) = server(pop.Position(i),1) + VMs.Cores(CreatedVMs(i));
    server(pop.Position(i),2) = server(pop.Position(i),2) + VMs.Ram(CreatedVMs(i));
    server(pop.Position(i),3) = server(pop.Position(i),3) + VMs.Bandwidth(CreatedVMs(i));
    

end

for i=1:length(server)
    
    if server(i,1)>serverProcessor || server(i,2) > serverRam || server(i,3) >serverBandwidth
   
        result = false;
        break;
        
    end
    
end



