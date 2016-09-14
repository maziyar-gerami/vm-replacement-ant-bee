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



serverProcessor = 40;                   % Number of CPUs
serverRam = 120;                         % Server Ram in Gigabyte
serverBandwidth = 200000;                % Server Bandwidth in Bytes

%% BBO Parameters
MaxIt=300;                       % Maximum Number of Iterations

nPop=100;                        % Number of Habitats (Population Size)


mu = linspace(1,0,nPop);       % Emigration Rate
lambda = 1-mu;                  %Imegration Rate
%% Initialization

% Empty Habitat
habitat.Position=[];
habitat.Wastage=[];

% Create Habitats Array
pop=repmat(habitat,nPop,1);

% Best Habitat
BestSol.Wastage=+inf;


% Initialize Habitats
for i=1:nPop
    
    feasible = false;
    while (~feasible)
        
        pop(i).Position=randi(nServer,1,nVms);
    
        feasible = Feasible( pop(i), nVms, VMs, CreatedVMs, nServer, serverProcessor, serverRam, serverBandwidth );
    end
    
    pop(i).Wastage = ObjectiveFunc( pop(i),nVms,nServer, VMs,CreatedVMs, serverProcessor, serverRam);
    
end

% Sort
[~, SortOrder]=sort([pop.Wastage]);
pop=pop(SortOrder);


% Best Solution Ever Found
BestSol=pop(1);

% Array to Hold Best Costs
BestCost=zeros(MaxIt,1);
%% BBO Main Loop

for it=1:MaxIt
    
    newpop=pop;
        
        for i=1:nPop
            
            for k=1:nVms
                % Migration
                if rand<=lambda(i)
                    % Emmigration Probabilities
                    EP=mu;
                    EP(i)=0;
                    EP=EP/sum(EP);
                    

                    % Select Source Habitat                                 
                    idx = RouletteWheelSelection(EP);

                    % Migration
                    newpop(i).Position(k) = pop(idx).Position(k);
                    
                end

                % Mutation                
                MutationRate = 0.2;
                
                if rand<MutationRate
                    
                    idx = randi(nServer);
                    newpop(i).Position(k)=idx;
            
                end
            end

            % Is Feasible?

            feasible = Feasible( newpop(i),nVms, VMs,CreatedVMs, nServer, serverProcessor, serverRam, serverBandwidth );

            if ~feasible
                
                i=i-1;
                break;

            end

%            Evaluation
            newpop(i).Wastage=...
                ObjectiveFunc( newpop(i),nVms, nServer, VMs,CreatedVMs, serverProcessor, serverRam);

        end
        pop = [pop;newpop];
        % Sort
        [~, SortOrder]=sort([pop.Wastage]);
        pop=pop(SortOrder);

        % Select Next Iteration Population
        pop=pop(1:nPop);
        

        % Update Best Solution Ever Found
        BestSol=pop(1);

        % Store Best Cost Ever Found
        BestCost(it)=BestSol.Wastage;

        % Show Iteration Information
        disp(['Iteration ' num2str(it) ': Best Cost BBO = ' num2str(BestCost(it))]);
    
end

%% Results

Cpu_Time = cputime -t

[acurance,index]=hist(CreatedVMs,unique(CreatedVMs));
numberOfeachVm = zeros(1,8);
numberOfeachVm(index) = acurance;
Wastage=BestSol.Wastage

figure;
plot (BestCost, 'LineWidth', 2);
xlabel ('Iteration');
ylabel ('Best Cost');
