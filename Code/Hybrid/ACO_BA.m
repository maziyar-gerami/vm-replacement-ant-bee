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
VMs.Bandwidth = [1000, 1000, 1000, 1000, 1000,1000,1000, 1000];

nServer= 20;                                % Number of Servers
nVms = numel(CreatedVMs);

% Number of Provided Vms

serverProcessor = 40;                   % Number of CPUs
serverRam = 120;                         % Server Ram in Gigabyte
serverBandwidth = 200000;                % Server Bandwidth in Bytes


%% ACO Parameters

ACO_MaxIt=10;               % Maximum Number of Iterations

nAnt=100;              % Number of Ants (Population Size)


q0=0.4;             % Exploitation/Exploration Decition Factor

tau0=1;             % Initial Phromone

alpha=0.5;          % Phromone Exponential Weight
beta=0.5;           % Heuristic Exponential Weight

rho=0.6;           % Evaporation Rate

%% Bees Algorithm Parameters

Bees_MaxIt=20;          % Maximum Number of Iterations

nScoutBee=30;                           % Number of Scout Bees

nSelectedSite=round(0.5*nScoutBee);     % Number of Selected Sites

nEliteSite=round(0.4*nSelectedSite);    % Number of Selected Elite Sites

nSelectedSiteBee=round(0.5*nScoutBee);  % Number of Recruited Bees for Selected Sites

nEliteSiteBee=2*nSelectedSiteBee;       % Number of Recruited Bees for Elite Sites

r=ceil(0.1*nVms);	% Neighborhood Radius

%% ACO Initialization


eta=ones(nVms,nServer);      % Heuristic Information Matrix


tau=tau0*ones(nVms,nServer);         % Phromone Matrix

BestCost=zeros(ACO_MaxIt+Bees_MaxIt,1);       % Array to Hold Best Cost Values

% Empty Ant
empty_ant.Position=[];
empty_ant.Wastage=[];


% Ant Colony Matrix
ant=repmat(empty_ant,nAnt,1);

% Best Ant
BestAnt.Wastage=+inf;

% %% BA Initialization
% 
% % Empty Bee Structure
% empty_bee.Position=[];
% empty_bee.Wastage=[];
% 
% % Initialize Bees Array
% bee=repmat(empty_bee,nScoutBee,1);

%% ACO Main Loop
tic
for i=1:ACO_MaxIt
    
    %Move Ants
    for k=1:nAnt
        
        for n=1:nVms
            
            feasible = false;
            while (~feasible)

               q= rand;

                if(q<=q0)

                    [~, idx] = max((tau(n,:)).^alpha.*(eta(n,:)).^beta);

                else

                    P = (((tau(n,:)).^alpha.*(eta(n,:)).^beta)./sum((tau(n,:)).^alpha.*(eta(n,:)).^beta));

                    P = P/sum(P);

                    P = P';

                    idx = RouletteWheelSelection(P);

                end
                ant(k).Position(n) = idx;
                feasible = Feasible( ant(k).Position, nVms, VMs, CreatedVMs, nServer, serverProcessor, serverRam, serverBandwidth );
                
            end
            
            
        end
        
        ant(k).Wastage= ObjectiveFunc( ant(k),nVms,nServer, VMs,CreatedVMs, serverProcessor, serverRam);
        
    end
    
    
    [~, SortOrder]=sort([ant.Wastage], 'ascend');
    ant=ant(SortOrder);
    
    if ant(1).Wastage<BestAnt.Wastage
        BestAnt = ant(1);
    end

    update.Wastage = NormAntCosts(ant, BestAnt);
    
    update.Ants = [BestAnt; ant ];
    
    % update best path
    for j=1:nVms    
                
                tau(j, update.Ants(1).Position(j))= tau(j, update.Ants(1).Position(j))+ rho*(1/update.Ants(1).Wastage);
                
    end
    
    % update other paths
    for k=2:20
        
        for j=1:nVms    
                
                tau(j, update.Ants(k).Position(j))= tau(j, update.Ants(k).Position(j))+ 1/update.Ants(k).Wastage;
                
        end
        
    end
     
    
    
    % Evaporation
    tau=(1-rho)*tau;
    
    % Store Best Cost
    BestCost(i)=BestAnt.Wastage;
    
    % Show Iteration Information
    disp(['Iteration ' num2str(i) ': Best Cost = ' num2str(BestCost(i))]);
    
        
end

bee = ant(1:nScoutBee);

%BA Main Loop
for it=1:Bees_MaxIt
    
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
    BestCost(ACO_MaxIt+it)=BestSol.Wastage;
    
    % Display Iteration Information
    disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(ACO_MaxIt+it))]);
    
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
plot (BestCost, 'LineWidth', 2);
xlabel ('Iteration');
ylabel ('Best Cost');
