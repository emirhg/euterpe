function [ midi_gen ] = readMIDIChromosome( file )
%READMIDICHROMOSOME Reads a midi file and codifies it's genotype
%   file    Midi file to read
    midi_org = readmidi_java(file);
    midi_gen = midi_genotype(midi_org);
end

