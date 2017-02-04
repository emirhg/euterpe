function [ trainingData, labelIndex, labelData ] = assambleTrainingData( seeds )
%GROWFOREST Summary of this function goes here
%   Detailed explanation goes here

%[esl, posl, mul, sil] = getMinHMTLength( [seeds.hmt] );
[esl, posl, mul, sil] = getMaxHMTLength( [seeds.hmt] );

labelData = cell(length(seeds),1);

for i=1:length(seeds)
    hmt = seeds(i).hmt;
    labelData(i) = {seeds(i).label};
%    tam = size(labelData);

    %for i:1:length(hmt)

%        hmt.array = [hmt.es(1:esl) hmt.pos(1:posl)' hmt.mu(1:mul) hmt.si(1:sil)];
        hmt.array = [hmt.es(:)' NaN(1, esl - length(hmt.es(:)')) hmt.pos(:)' NaN(1, posl - length(hmt.pos(:)')) hmt.mu(:)' NaN(1, mul - length(hmt.mu(:)')) hmt.si(:)' NaN(1, sil - length(hmt.si(:)'))];
        trainingData(i,:) = hmt.array;    
        
%    if tam(2)<length(seeds{i}.label)
%        labelData = [labelData, repmat(' ',length(seeds),length(seeds{i}.label)-tam(2))];
%    else
%        seeds{i}.label = [seeds{i}.label, repmat(' ',1,tam(2) - length(seeds{i}.label))];
%    end
    
end
size(trainingData);
[~, ~, labelIndex]= unique(labelData);

end

function [esl, posl, mul, sil] = getMaxHMTLength( hmt_array )
%getMinHMTLength Summary of this function goes here
%   Detailed explanation goes here

for  i=1:length(hmt_array)
    hmt = hmt_array(i);
    if (not(exist('esl','var')))
        esl = length(hmt.es(:)');
    else
        if length(hmt.es(:)')>esl
            esl = length(hmt.es(:)');
        end
    end
    
    if (not(exist('posl','var')))
        posl = length(hmt.pos(:)');
    else
        if length(hmt.pos(:)')>posl
            posl = length(hmt.pos(:)');
        end
    end
    if (not(exist('mul','var')))
        mul = length(hmt.mu(:)');
    else
        if length(hmt.mu(:)')>mul
            mul = length(hmt.mu(:)');
        end
    end
    if (not(exist('sil','var')))
        sil = length(hmt.si(:)');
    else
        if length(hmt.si(:)')>sil
            sil = length(hmt.si(:)');
        end
    end
end
end
