initialize;

while population(end).fitness < 0.98
    %% Generaci�n de la poblaci�n
    
    %% Eliminaci�n de la poblaci�n indeseable, Vasconselos los n/2 mejores y los n/2 peores
    if length(population) > MAX_population
        head_size = floor(MAX_population/2);
        tail_size = ceil(MAX_population/2);
        population(1+head_size:end-tail_size) = [];
    end
    
    %% Cruzamientos
    population_size = length(population);
    middle_point = ceil(population_size/2);
    if middle_point>1
        for i=1:middle_point
            population(end+1).chromosome = crossover(population(i).chromosome, population(population_size - i).chromosome,p_crossover);
            population(end).nmat = midi_phenotype(population(end).chromosome, 2);
            population(end).hmt.iter=0;
            population(end).wave = waveform_padding(midi_waveform(population(end).nmat,speedup));
            population(end).dwt = wavelet_transform(population(end).wave);
        end
    end
    
    %% Mutaciones
    population_size = length(population);
    for i=1:population_size
        population(end+1).chromosome = mutate(population(i).chromosome, p_mutate);
        population(end).nmat = midi_phenotype(population(end).chromosome, 2);
        if length(population(end).nmat)> 0
            population(end).hmt.iter=0;
            population(end).wave = waveform_padding(midi_waveform(population(end).nmat,speedup));
            population(end).dwt = wavelet_transform(population(end).wave);
        else
            population(end)=[];
        end
    end
    
    population = processData(population, 20);

    for i=1:length(population)
        [index, conffidence, labels]= evaluateSample(population(i), Knowledge);
        population(i).label = labels(index).label;
        population(i).fitness = evaluateFitness(population(i), Knowledge,desired_style);
    end
    fprintf(1,'Ordenando la poblaci�n\n');
    population = sortstruct(population,3);
    
    generation_count = generation_count + 1;
    fprintf(1,'El mejor individuo en la generacion %d es una melod�a de %s con un fitness de %0.4f respecto %s\n', generation_count, population(end).label, population(end).fitness,desired_style);
    
    fig=figure;
    pianoroll(population(end).nmat);
    title(['Generaci�n: ' num2str(generation_count) ' Melod�a de ' population(end).label ' con ' num2str(population(end).fitness*100) '% de similitud con ' desired_style]);
    if exist('M','var')
        M(end+1) = getframe(fig);
    else
        M = getframe(fig);
    end
    close(fig);
    
    if exist('best_fitness', 'var')
        if(best_fitness < population(end).fitness)
            savemidi(population(end).nmat, [desired_style '_' session '_' int2str(generation_count) '_' int2str(population(end).fitness*100)]);
        end
    end;
    p_mutate = abs((0.9 - population(end).fitness)^2);
    
    best_fitness= population(end).fitness;
    save(['Population-', session], 'population', 'M', 'session', 'generation_count', 'best_fitness');
end