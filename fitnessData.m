function [ fitness ] = fitnessData( data )

fitness = zeros(1,length(data));

    parfor i=1:length(fitness)
        fitness(i) = evaluateFitness(data(i),data, data(i).label);
    end

end