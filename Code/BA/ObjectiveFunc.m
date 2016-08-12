function [ WA ] = ObjectiveFunc( pop,nVms, nServer, VMs, CreatedVMs, serverProcessor, serverRam)
%OBJECTIVEFUNC calculate effectiveness of a response
server = zeros (nServer,3);
%resource wastage modeling

for i=1:nVms
   
    server(pop.Position(i),1) = server(pop.Position(i),1) + VMs.Cores(CreatedVMs(i));
    server(pop.Position(i),2) = server(pop.Position(i),2) + VMs.Ram(CreatedVMs(i));
    server(pop.Position(i),3) = server(pop.Position(i),3) + VMs.Bandwidth(CreatedVMs(i));

end


Up = server(:,1) / serverProcessor;
Um = server(:,2) / serverRam;

Lp = 1-Up;
Lm = 1 - Um;

for i=1:nServer
   
    if Up(i) > 0
        
        Wastage(i) = (abs((Lp(i) -Lm(i))))/ (Up(i) +Um(i));
        
    else
        
        Wastage(i) = 0;
        
    end
    
end


WA = sum(Wastage);