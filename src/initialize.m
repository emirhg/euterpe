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
    speedup = 1;
    
    if exist(['Population-', session, '.mat'], 'file')
        load(['Population-', session, '.mat']);
    else
        population(1).chromosome = newMIDIChromosome(50);
        population(1).label = '';
        population(1).fitness = 0;  
        population(1).hmt.iter=0;
        population(1).nmat = midi_phenotype(population(end).chromosome, 2);
        population(1).wave = waveform_padding(midi_waveform(population(1).nmat,speedup));
        population(1).dwt = wavelet_transform(population(end).wave);
    end
%    load KnowledgeBase;
    
    desired_style = 'Francisco Tarrega';
