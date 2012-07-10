function [esl, posl, mul, sil] = getMinHMTLength( seeds )
%getMinHMTLength Summary of this function goes here
%   Detailed explanation goes here

for  i=1:length(seeds)
    hmt = seeds{i}.hmt;
    if (not(exist('esl','var')))
        esl = length(hmt.es(:)');
    else
        if length(hmt.es(:)')<esl
            esl = length(hmt.es(:)');
        end
    end
    
    if (not(exist('posl','var')))
        posl = length(hmt.pos(:)');
    else
        if length(hmt.pos(:)')<posl
            posl = length(hmt.pos(:)');
        end
    end
    if (not(exist('mul','var')))
        mul = length(hmt.mu(:)');
    else
        if length(hmt.mu(:)')<mul
            mul = length(hmt.mu(:)');
        end
    end
    if (not(exist('sil','var')))
        sil = length(hmt.si(:)');
    else
        if length(hmt.si(:)')<sil
            sil = length(hmt.si(:)');
        end
    end
end
end
