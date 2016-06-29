function [y1, y2]=UniformCrossover(x1,x2, nVms, VMs, CreatedVMs, nServer, serverProcessor, serverRam, serverBandwidth)

    
    
    
    feasible = true;
    
    while (feasible)
    
        alpha=randi([0 1],size(x1));
    
        y1=alpha.*x1+(1-alpha).*x2;
        y2=alpha.*x2+(1-alpha).*x1;
        
        if(Feasible(y1,nVms, VMs, CreatedVMs, nServer, serverProcessor, serverRam, serverBandwidth) ...
                && Feasible(y2,nVms, VMs, CreatedVMs, nServer, serverProcessor, serverRam, serverBandwidth))
            
            feasible = false;
            
        end
    
    end
    
end