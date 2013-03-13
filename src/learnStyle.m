function data = learnStyle(knowledgePath, varargin)

okargs =   {'ext' 'compression' 'duration'};
defaults = {'(mp3|mid)' 1 -1};
[~,~,ext,compression,duration] = getargs(okargs,defaults,varargin{:});

startP= tic;

if length(ext)==3
    ext = ['.' ext];
end

FILES = getFileNamesFromDir(knowledgePath, ext);

data = struct();
for (i=1:length(FILES))
	fprintf(1,'Reading file %d/%d: %s\n', i, length(FILES), FILES{i});
    if (strfind(FILES{i},'mid') > 0)
        nmat = readmidi_java(FILES{i});
%        if duration>-1
%            nmat=truncateMIDI(nmat,duration);
%        end
    %    for j=unique(channel(nmat))'
            data(i).hmt.iter=0;
            %data{k}.name = [FILES{i} '_ch' int2str(j)];
            data(i).name = [FILES{i}];
            
            data(i).nmat = nmat;%getmidich(nmat,j);%readmidi_java(FILES{i});
            %Se acelera la canci�n en un factor de 100 y se muestrea a 8400Hz > 2(Frecuencia de la nota 88)
            %data{k}.wave = nmat2snd(scale(data{k}.nmat,'time',1/110),'fm',8400);
            data(i).wave = nmat2snd(scale(data(i).nmat,'time',1/compression));

%            data(i).dwt = wavelet_transform(data(i).wave);
            %i = i + 1;
    %    end
    else
        data(i).name = FILES{i};
        [data(i).wave, data(i).fs] = mp3read(FILES{i});        
        [data(i).wave, data(i).fs] = subsampling(data(i).wave',data(i).fs,data(i).fs/compression);
    end
    data(i).label = findLabel(data(i).name);
end

toc(startP);
tic();

data=processData(data,'iter',25);

toc;
end
function [y, FFREQ] = subsampling(w, FREQ, FFREQ)

y = w(1:FREQ/(FFREQ/2):end);

end