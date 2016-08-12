function y=UniformBeeDance(x,r, nVms, VMs, CreatedVMs, nServer, serverProcessor, serverRam, serverBandwidth)

    nVar=numel(x);
    
    
    
    
    feasible = false;
    while (~feasible)
        
        k=randi([1 nVar], 1 , r);
        s = randi([1 nServer],1 , r);
        y=x;
        y(k)=s;
    
        feasible = Feasible( y, nVms, VMs, CreatedVMs, nServer, serverProcessor, serverRam, serverBandwidth );
    end


end