function [ result,conffidence,labels ] = evaluateSample( fileData, seeds )
%EVALUATESAMPLE Summary of this function goes here
%   Detailed explanation goes here
    hmt = fileData.hmt;
    [trainingData,labelData] = assambleTrainingData(seeds);
    forest = Stochastic_Bosque(trainingData,labelData);
    
    [esl, posl, mul, sil] = getMinHMTLength( [seeds.hmt, fileData.hmt ]);

    hmt.array = [hmt.es(1:esl) hmt.pos(1:posl)' hmt.mu(1:mul) hmt.si(1:sil)];
    
    [result, votes] = eval_Stochastic_Bosque(hmt.array,forest);
    
    votes = tabulate(votes);
    votes = votes(:,3)/100;
    
    conffidence = 1;
    for i=1:length(votes)
        if i ~= result
            conffidence = conffidence*(1-votes(i));
        else
            conffidence = conffidence*(votes(i));
        end
    end
    
    
    for i=1:length(labelData)
        labels(labelData(i)).label = seeds(i).label;
    end
    
end

