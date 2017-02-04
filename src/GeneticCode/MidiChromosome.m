classdef MidiChromosome
    %% player= audioplayer(nmat2snd(nmat),22050);
    % play(player);
    % stop(player);

    properties (GetAccess='private', ReadAccess='private')
        nmat;
        midifile;
    end
end