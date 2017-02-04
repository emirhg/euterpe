function [ chromosome ] = newMIDIChromosome( n, tempo )
%%NEWMIDICHROMOSOME Generates a new random MIDI chromosome of size n
%   n   Number of genes in the chromosome
%   Given a n number of chromosomes generates a new chromosome of size n,
%   where n is the number of notes in the MIDI

    if nargin == 1
        tempo = 60;
    end

    chromosome = cell(1,n+1);
    chromosome{1}.tempo = tempo;
    
    for i=1:n
        if i>1
            chromosome{i+1}.pitch=dec2bin(mod(bin2dec(chromosome{i}.pitch)+1,2^7));
        else
            chromosome{i+1}.pitch='0111100';
        end
        chromosome{i+1}.velocity='1111111';
        chromosome{i+1}.dur='0111';
        %chromosome{i+1}.onset='111100';
        chromosome{i+1}.next='1';
        chromosome{i+1}.channel='1';
    end
end

