%% Reconocimiento de covers
% Metodología:
%   Se entrena el sistema con una coleccion de artistas que tengan
%   interpretaciones de la misma canción. Uno de los artistas en el
%   conjunto será el compositor original.
%   Sea el conjunto A = {Las melodias que conforman la base de
%   conocimeinto} y B={Diferentes interpretaciones de la misma canción}
%   ¿Qué resultado se obtiene al identificar el estilo musical de los covers usando A en el entrenamiento?


load('/home/shanti/music-style-imitator/25-Feb-2013.mat');


test=[64, 107, 162];

for i=1:length(data)
    if (~isempty(find(i == test)==1))
        if (exist('testData','var'))
            testData(end+1) = data(i);
        else
            testData(1) = data(i);
        end
    else
        if (exist('knowledge','var'))
            knowledge(end+1) = data(i);
        else
            knowledge(1) = data(i);
        end
    end
end



for i=1:length(testData)
    [result, conffidence, votes]=evaluateSample(testData(i), knowledge);
    fprintf(1,'\n\nMuestra: %s\nReconocimiento:\n', testData(i).name);
    for (j=1:length(votes))
        fprintf(1, '%s:\t%.2f%%\n', votes(j).label, votes(j).votesP*100.0);
    end
end

[fitnessFig, fitnessHistFig] = plotDataFitness(data);

brush on;
paint=zeros(1,length(data));
paint(test)=1;
hB = findobj(fitnessFig,'-property','BrushData');
set(hB,'BrushData', paint);
brush off;

clear('knowledge', 'testData', 'test', 'votes', 'paint', 'labels', 'i', 'j', 'hB', 'fitnessFig', 'fitnessHistFig', 'result', 'conffidence');
