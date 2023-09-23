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


%% ACO Parameters

MaxIt=50;               % Maximum Number of Iterations

nAnt=100;              % Number of Ants (Population Size)

Q=1;

q0=0.7;             % Exploitation/Exploration Decition Factor

tau0=1;             % Initial Phromone

alpha=0.5;          % Phromone Exponential Weight
beta=0.5;           % Heuristic Exponential Weight

rho=0.1;           % Evaporation Rate

%% Initialization

N=[0 1];

eta=ones(nServer,nVms);      % Heuristic Information Matrix


tau=tau0*ones(nServer, nVms);         % Phromone Matrix

BestCost=zeros(MaxIt,1);       % Array to Hold Best Cost Values

% Empty Ant
empty_ant.Position=[];
empty_ant.Wastage=[];


% Ant Colony Matrix
ant=repmat(empty_ant,nAnt,1);

% Best Ant
BestAnt.Wastage=+inf;

%% ACO Main Loop
tic
for i=1:MaxIt
    
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
    
    if (i==1)
        TimeOfEachIteration = toc;
        
    end
        
end


%% Results
Cpu_Time = cputime -t

[acurance,index]=hist(CreatedVMs,unique(CreatedVMs));
numberOfeachVm = zeros(1,8);
numberOfeachVm(index) = acurance;
Wastage = BestAnt.Wastage    

figure;
plot (BestCost, 'LineWidth', 2);
xlabel ('Iteration');
ylabel ('Best Cost');
