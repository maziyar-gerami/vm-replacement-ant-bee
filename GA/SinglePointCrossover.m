function [y1, y2]=SinglePointCrossover(x1,x2, nVms, VMs, CreatedVMs, nServer, serverProcessor, serverRam, serverBandwidth)

    nVar=numel(x1);

    feasible = true;
    
    while (feasible)
    
        c=randi([1 nVar-1]);

        y1=[x1(1:c) x2(c+1:end)];
        y2=[x2(1:c) x1(c+1:end)];
        
        if(Feasible(y1,nVms, VMs, CreatedVMs, nServer, serverProcessor, serverRam, serverBandwidth) &&...
                Feasible(y2,nVms, VMs, CreatedVMs, nServer, serverProcessor, serverRam, serverBandwidth))
            
            feasible = false;
            
        end
    
    end

end