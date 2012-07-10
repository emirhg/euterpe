function [ nmat ] = midi_phenotype( chromosome, ver )
%NMAT2BIN Creates the nmat matrix representation of genotype
%   nmat: midi matrix
%   ver: is the versión of the binary codification

    if nargin < 2
        ver = 1;
    end
    
   % chromosome
    
    switch ver
        case 1
            nmat = midi_phenotype_ver1(chromosome);
        case 2
            nmat = midi_phenotype_ver2(chromosome);
    end

end

function [ nmat ] = midi_phenotype_ver1( chromosome )
    nmat = zeros(length(chromosome)-1,7);
    [length_nmat, ~] = size(nmat);
    %chromosome
    %chromosome{3}
    for i=1:length_nmat
        %Shape
        nmat(i,4) = bin2dec(chromosome{i+1}.pitch);
        nmat(i,5) = bin2dec(chromosome{i+1}.velocity);
        
        %Move
        
        nmat(i,2) = bin2dec(chromosome{i+1}.dur) /chromosome{1}.tempo;
        nmat(i,1) = bin2dec(chromosome{i+1}.onset) /chromosome{1}.tempo;
        
        nmat(i,7) = bin2dec(chromosome{i+1}.dur) /(chromosome{1}.tempo^2/60);
        nmat(i,6) = bin2dec(chromosome{i+1}.onset)/(chromosome{1}.tempo^2/60);
        
        %extra
        nmat(i,3) = bin2dec(chromosome{i+1}.channel);
    end
end

function [ nmat ] = midi_phenotype_ver2( chromosome )
    nmat = zeros(length(chromosome)-1,7);
    [length_nmat, ~] = size(nmat);
    %chromosome
    %chromosome{3}
    last_onset = 0;
    for i=1:length_nmat
        %Shape
        nmat(i,4) = mod(bin2dec(chromosome{i+1}.pitch),87)+21;
        nmat(i,5) = bin2dec(chromosome{i+1}.velocity);
        
        %Move
        % 4 bits para la duración
        %nmat(i,2) =  2^(mod(bin2dec(chromosome{i+1}.dur), 12)-8);
        
        
        if length(bin2dec(chromosome{i+1}.dur)) > 3
            nmat(i,2) =  2^(mod(bin2dec(chromosome{i+1}.dur(end-2:end)),7)-6);
            nmat(i,2) = nmat(i,2) + nmat(i,2)*0.5*bin2dec(chromosome{i+1}.dur(1));
        else
            nmat(i,2) =  2^(mod(bin2dec(chromosome{i+1}.dur),7)-6);
        end
        
        if (strcmp(chromosome{i+1}.next,'1') || nmat(i,5) == 0)&& i > 1 
            last_onset = last_onset + nmat(i-1,2);
        end
        
        nmat(i,1) = last_onset;
        
        %nmat(i,1) = bin2dec(chromosome{i+1}.onset) /chromosome{1}.tempo;
        
        nmat(i,7) = nmat(i,2) * chromosome{1}.tempo/60;
        nmat(i,6) = nmat(i,1)* chromosome{1}.tempo/60;
        
        %extra
        nmat(i,3) = bin2dec(chromosome{i+1}.channel);
    end
    
    k=1;
    while k<=length_nmat
        if nmat(k, 5)==0
            nmat(k,:)=[];
        else
            k = k+1;
        end
        
        [length_nmat, ~] = size(nmat);
    end
end
