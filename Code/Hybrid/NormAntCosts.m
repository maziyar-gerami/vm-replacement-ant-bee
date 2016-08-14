function Wastage = NormAntCosts( Ant, BestAnt )

    Ant = [BestAnt;Ant];
        
    Wastage=[];

    for i=1:length(Ant)
       
        Wastage = [Wastage; Ant(i).Wastage];
        
    end
    
    Wastage = 1./Wastage;
    
    normData = max(Wastage) - min(Wastage);               % this is a vector
    
    normData = repmat(normData, [length(Wastage) 1]);    % this makes it a matrix
    
    minmatrix= repmat(min(Wastage), [length(Wastage) 1]); % of the same size as A
                                                         
    Wastage = (Wastage-minmatrix)./normData;         % your normalized matrix

 
end

