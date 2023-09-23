clc
clear
close all

t = cputime;
%% Problem Definition
nVms = 20;

VMs.Name = {'D1' 'D2' 'D3' 'D4' 'D11' 'D12' 'D13' 'D14'};
VMs.Cores = [ 1 2 4 8 2 4 8 16];
VMs.Ram = [3.5, 7, 14, 28, 14,28,56, 112];
VMs.Bandwidth = [1000, 1000, 1000, 1000, 1000,1000,1000, 1000];

VmsTypes = length (VMs.Cores);  
CreatedVMs= randi(VmsTypes, 1 , nVms);

nServer= 20;                                % Number of Servers
nVms = numel(CreatedVMs);

% Number of Provided Vms

serverProcessor = 40;                   % Number of CPUs
serverRam = 120;                         % Server Ram in Gigabyte
serverBandwidth = 200000;                % Server Bandwidth in Bytes


%% Bees Algorithm Parameters

MaxIt=50;          % Maximum Number of Iterations

nScoutBee=30;                           % Number of Scout Bees

nSelectedSite=round(0.5*nScoutBee);     % Number of Selected Sites

nEliteSite=round(0.4*nSelectedSite);    % Number of Selected Elite Sites

nSelectedSiteBee=round(0.5*nScoutBee);  % Number of Recruited Bees for Selected Sites

nEliteSiteBee=2*nSelectedSiteBee;       % Number of Recruited Bees for Elite Sites

r=ceil(0.1*nVms);	% Neighborhood Radius

rdamp=0.99;             % Neighborhood Radius Damp Rate

%% Initialization

% Empty Bee Structure
empty_bee.Position=[];
empty_bee.Wastage=[];

% Initialize Bees Array
bee=repmat(empty_bee,nScoutBee,1);

% Create New Solutions
for i=1:nScoutBee
    
    feasible = false;
    while (~feasible)
        
        bee(i).Position=randi(nServer,1,nVms);
    
        feasible = Feasible( bee(i).Position, nVms, VMs, CreatedVMs, nServer, serverProcessor, serverRam, serverBandwidth );
    end
    
    bee(i).Wastage = ...
        ObjectiveFunc( bee(i),nVms,nServer, VMs,CreatedVMs, serverProcessor, serverRam);
end

% Sort
[~, SortOrder]=sort([bee.Wastage]);
bee=bee(SortOrder);

% Update Best Solution Ever Found
BestSol=bee(1);

% Array to Hold Best Cost Values
BestCost=zeros(MaxIt,1);

%% Bees Algorithm Main Loop

for it=1:MaxIt
    
    % Elite Sites
    for i=1:nEliteSite
        
        bestnewbee.Wastage=inf;
        
        for j=1:nEliteSiteBee
            newbee.Position=UniformBeeDance(bee(i).Position,r, nVms, VMs, CreatedVMs, nServer, serverProcessor, serverRam, serverBandwidth);
            newbee.Wastage=ObjectiveFunc(newbee, nVms,nServer, VMs,CreatedVMs, serverProcessor, serverRam);
            if newbee.Wastage<bestnewbee.Wastage
                bestnewbee=newbee;
            end
        end

        if bestnewbee.Wastage<bee(i).Wastage
            bee(i)=bestnewbee;
        end
        
    end
    
    % Selected Non-Elite Sites
    for i=nEliteSite+1:nSelectedSite
        
        bestnewbee.Wastage=inf;
        
        for j=1:nSelectedSiteBee
            newbee.Position=UniformBeeDance(bee(i).Position,r, nVms, VMs, CreatedVMs, nServer, serverProcessor, serverRam, serverBandwidth);
            newbee.Wastage=ObjectiveFunc(newbee, nVms,nServer, VMs,CreatedVMs, serverProcessor, serverRam);
            if newbee.Wastage<bestnewbee.Wastage
                bestnewbee=newbee;
            end
        end

        if bestnewbee.Wastage<bee(i).Wastage
            bee(i)=bestnewbee;
        end
        
    end
    
    % Non-Selected Sites
    for i=nSelectedSite+1:nScoutBee
        feasible = false;
        while (~feasible)

            bee(i).Position=randi(nServer,1,nVms);

            feasible = Feasible( bee(i).Position, nVms, VMs, CreatedVMs, nServer, serverProcessor, serverRam, serverBandwidth );
        end

        bee(i).Wastage = ...
            ObjectiveFunc( bee(i),nVms,nServer, VMs,CreatedVMs, serverProcessor, serverRam);
    end
    
    % Sort
    [~, SortOrder]=sort([bee.Wastage]);
    bee=bee(SortOrder);
    
    % Update Best Solution Ever Found
    BestSol=bee(1);
    
    % Store Best Cost Ever Found
    BestCost(it)=BestSol.Wastage;
    
    % Display Iteration Information
    disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it))]);
    
    % Damp Neighborhood Radius
    %r=ceil(r*rdamp);
    
end

%% Results

Cpu_Time = cputime -t

[acurance,index]=hist(CreatedVMs,unique(CreatedVMs));
numberOfeachVm = zeros(1,8);
numberOfeachVm(index) = acurance;
Wastage = BestSol.Wastage  


figure;
plot(BestCost,'LineWidth',2);
semilogy(BestCost,'LineWidth',2);
xlabel('Iteration');
ylabel('Best Cost');

