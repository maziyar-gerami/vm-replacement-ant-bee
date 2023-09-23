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

% Number of Provided Vms

serverProcessor = 40;                   % Number of CPUs
serverRam = 120;                         % Server Ram in Gigabyte
serverBandwidth = 200000;                % Server Bandwidth in Bytes

%% GA Parameters
MaxIt=100;      % Maximum Number of Iterations

nPop=30;        % Population Size

pc=0.8;                 % Crossover Percentage
nc=2*round(pc*nPop/2);  % Number of Offsprings (Parnets)

pm=0.3;                 % Mutation Percentage
nm=round(pm*nPop);      % Number of Mutants

mu=0.1;         % Mutation Rate

%% Initialization

% Empty Choromosome
Choromosome.Position=[];
Choromosome.Wastage=[];

% Create Habitats Array
pop=repmat(Choromosome,nPop,1);

% Best Habitat
bestQuality= -inf;


% Initialize Habitats
for i=1:nPop
    
    feasible = false;
    while (~feasible)
        
        pop(i).Position=randi(nServer,1,nVms);
    
        feasible = Feasible( pop(i).Position, nVms, VMs, CreatedVMs, nServer, serverProcessor, serverRam, serverBandwidth );
    end
    
    pop(i).Wastage= ObjectiveFunc( pop(i),nVms,nServer, VMs,CreatedVMs, serverProcessor, serverRam);
    
end

% Sort
[~, SortOrder]=sort([pop.Wastage]);
pop=pop(SortOrder);

% Best Solution Ever Found
BestSol=pop(1);

% Array to Hold Best Costs
BestCost=zeros(MaxIt,1);

%% GA Main Loop

for it=1:MaxIt
    
    
    P=[pop.Wastage]/sum([pop.Wastage]);
    
    % Crossover
    popc=repmat(Choromosome,nc/2,2);
    for k=1:nc/2
        
        %  Select Parents Indices
        i1=RouletteWheelSelection(P);
        i2=RouletteWheelSelection(P);

        % Select Parents
        p1=pop(i1);
        p2=pop(i2);
        
        % Apply Crossover
        [popc(k,1).Position, popc(k,2).Position]=Crossover(p1.Position,p2.Position, nVms, VMs, CreatedVMs, nServer, serverProcessor, serverRam, serverBandwidth);

        % Evaluate Offsprings
        popc(k,1).Wastage = ...
            ObjectiveFunc( popc(k,1),nVms,nServer, VMs,CreatedVMs, serverProcessor, serverRam);
        
        popc(k,2).Wastage = ...
            ObjectiveFunc( popc(k,2),nVms,nServer, VMs,CreatedVMs, serverProcessor, serverRam);
        
                 
    end
    
    popc = [popc(:,1); popc(:,2)];

    % Mutation
    popm=repmat(Choromosome,nm,1);
    for k=1:nm
        
        % Select Parent
        i=randi([1 nPop]);
        p=pop(i);
        
        % Apply Mutation
        
            
            popm(k).Position=Mutate(p.Position,mu ,nVms, VMs, CreatedVMs, nServer, serverProcessor, serverRam, serverBandwidth);
        
        popm(k).Wastage = ...
            ObjectiveFunc( popm(k),nVms,nServer, VMs,CreatedVMs, serverProcessor, serverRam);
        
        
        
    end  
    
    pop=[pop
         popc
         popm
         ]; %#ok
     
        % Sort
        [~, SortOrder]=sort([pop.Wastage]);
        pop=pop(SortOrder);


    % Update best quality
    bestQuality=max(bestQuality,pop(end).Wastage);
    
    % Truncation
    pop=pop(1:nPop);
    
    % Store Best Solution Ever Found
    BestSol=pop(1);
    
    % Store Best Cost Ever Found
    BestCost(it)=BestSol.Wastage;
    
    % Show Iteration Information
    disp(['Iteration ' num2str(it) ': Best Quality = ' num2str(BestSol.Wastage)]);
    
end


% Show Information
sumCores = zeros (nServer,1);
sumRam = zeros (nServer,1);

for i=1:length(CreatedVMs)
   
    sumCores(BestSol.Position(i)) = sumCores(BestSol.Position(i))+ VMs.Cores(CreatedVMs(i));
    sumRam(BestSol.Position(i)) = sumRam(BestSol.Position(i))+ VMs.Ram(CreatedVMs(i));
    
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
