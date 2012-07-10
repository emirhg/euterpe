%% Initialize
%    addpath(genpath('TesisCode'))
%    load KnowledgeBase
    
    if not(exist('session','var'))
        session=date;
    end
    
    
    p_mutate = 0.005;
    p_crossover = 0.001;

    MAX_population = 30;
    generation_count = 0;
    
    fps = 12;
    speedup = 2^7;
    
    if exist(['Population-', session, '.mat'], 'file')
        load(['Population-', session, '.mat']);
    else
        population(1).chromosome = newMIDIChromosome(50);
        population(1).label = '';
        population(1).fitness = 0;  
        population(1).hmt.iter=0;
    end
%    load KnowledgeBase;
    
    desired_style = 'Tarrega Francisco';
