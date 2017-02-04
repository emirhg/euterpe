function [ waveform ] = waveform_padding( waveform )
%WAVEFORM_PADDING Summary of this function goes here
%   Detailed explanation goes here

    waveform= waveform(find(waveform,1):find(waveform,1,'last'));

    L = log2(length(waveform));
    waveform(end+1:2^ceil(L)) = 0;

end

