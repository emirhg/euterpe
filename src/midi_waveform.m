function [ wave ] = midi_waveform( nmat, speed_up )
%MIDI_WAVEFORM Summary of this function goes here
%   nmat Note matrix with the midi infomation
%   speed_up   Accelerates the waveform signal, fewer duration per sample.

    Fs = 8192;
    
    nmat(:,1) = nmat(:,1)/speed_up;
    nmat(:,2) = nmat(:,2)/speed_up;
    nmat(:,6) = nmat(:,6)/speed_up;
    nmat(:,7) = nmat(:,7)/speed_up;

    wave= nmat2snd(nmat,'fm',Fs);
    wave= wave(find(wave,1):find(wave,1,'last'));
end

