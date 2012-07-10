function [ trainingData, labelIndex, labelData ] = assambleTrainingData( seeds )
%GROWFOREST Summary of this function goes here
%   Detailed explanation goes here

[esl, posl, mul, sil] = getMinHMTLength( seeds );

labelData = cell(length(seeds),1);

for i=1:length(seeds)
    hmt = seeds{i}.hmt;
    
    tam = size(labelData);
    hmt.array = [hmt.es(1:esl) hmt.pos(1:posl)' hmt.mu(1:mul) hmt.si(1:sil)];
    
    trainingData(i,:) = hmt.array;
    
%    if tam(2)<length(seeds{i}.label)
%        labelData = [labelData, repmat(' ',length(seeds),length(seeds{i}.label)-tam(2))];
%    else
%        seeds{i}.label = [seeds{i}.label, repmat(' ',1,tam(2) - length(seeds{i}.label))];
%    end
    labelData{i} = seeds{i}.label;
end

[labelData, I, labelIndex]= unique(labelData);

end