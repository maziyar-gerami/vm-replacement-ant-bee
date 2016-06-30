function x=Mutate(x,mu,nVms, VMs, CreatedVMs, nServer, serverProcessor, serverRam, serverBandwidth)

    
    
    feasible = true;
    
    while (feasible)
    

    nVar=numel(x);
    
    nmu=ceil(mu*nVar);
    
    j=randsample(nVar,nmu);
    
    x(j)=randi(nServer,nmu,1);
    
        
        if(Feasible(x,nVms, VMs, CreatedVMs, nServer, serverProcessor, serverRam, serverBandwidth))
            
            feasible = false;
            
        end
    
    end
    
    
    

end