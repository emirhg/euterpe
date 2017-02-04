function data = readDir(knowledgePath, varargin)

okargs =   {'ext' 'fs'};
defaults = {'(mp3|mid)' 11025};
[~,~,ext, fs] = getargs(okargs,defaults,varargin{:});

if length(ext)==3
    ext = ['.' ext];
end

FILES = getFileNamesFromDir(knowledgePath, ext);

data = struct();
for (i=1:length(FILES))
	fprintf(1,'Reading file %d/%d: %s\n', i, length(FILES), FILES{i});
    if (strfind(FILES{i},'mid') > 0)
        nmat = readmidi_java(FILES{i});
            data(i).name = [FILES{i}];
            
            data(i).nmat = nmat;
            data(i).wave = nmat2snd(data(i).nmat, 'fm',fs);
            data(i).fs = fs;
    else
        data(i).name = FILES{i};
        [data(i).wave, data(i).fs] = mp3read(FILES{i});        
        [data(i).wave, data(i).fs] = subsampling(data(i).wave',data(i).fs,11025);
        %data(i).fs = fs*2;
    end
    data(i).label = findLabel(data(i).name);
end

%data=processData(data,'iter',25);
end

function [y, FFREQ] = subsampling(w, FREQ, FFREQ)
    y = w(1:FREQ/(FFREQ):end);
end