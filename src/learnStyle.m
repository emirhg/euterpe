function data = learnStyle(knowledgePath, varargin)

okargs =   {'ext' 'compression' 'duration'};
defaults = {'mid' 1 -1};
[~,~,ext,compression,duration] = getargs(okargs,defaults,varargin{:});

startP= tic;

if length(ext)==3
    ext = ['.' ext];
end

FILES = getFileNamesFromDir(knowledgePath, ext);

data = cell(1,length(FILES));

%i = 1;
parfor (i=1:length(FILES))
    
    nmat = readmidi_java(FILES(i));
    if duration>-1
        nmat=truncateMIDI(nmat,duration);
    end
%    for j=unique(channel(nmat))'
        data{i}.hmt.iter=0;
        %data{k}.name = [FILES{i} '_ch' int2str(j)];
        data{i}.name = [FILES{i}];
        data{i}.label = findLabel(data{i}.name);
        data{i}.nmat = nmat;%getmidich(nmat,j);%readmidi_java(FILES(i));
        %Se acelera la canci�n en un factor de 100 y se muestrea a 8400Hz > 2(Frecuencia de la nota 88)
        %data{k}.wave = nmat2snd(scale(data{k}.nmat,'time',1/110),'fm',8400);
        data{i}.wave = nmat2snd(scale(data{i}.nmat,'time',1/compression));
        data{i}.wave = waveform_padding(data{i}.wave);
        data{i}.dwt = wavelet_transform(data{i}.wave);
        %i = i + 1;
%    end
    
end

%data = processData(data,20);

toc(startP);
