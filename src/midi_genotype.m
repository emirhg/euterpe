function [ chromosome ] = midi_genotype( nmat, ver )
%NMAT2BIN Creates a binary representation of the nmat input data
%   nmat: midi matrix
%   ver: is the versión of the binary codification

    if nargin < 2
        ver = 1;
    end
    
    switch ver
        case 1
            chromosome = midi_genotype_ver1(nmat);
        case 2
            chromosome = midi_genotype_ver2(nmat);
    end

end

function [ chromosome ] = midi_genotype_ver1( nmat )
    length_nmat = size(nmat);
    chromosome = cell(1,length_nmat(1)+1);
    %chromosome{1}.tempo = 1/min([nmat(find(nmat(:,2)),2) 1]);
    chromosome{1}.tempo = gettempo(nmat);
    %dur=[nmat(:,7);nmat(2:end,6)-nmat(1:end-1,6)];
    %chromosome{1}.durres = min([dur(find(dur)) 1])/2;
   
    for i=1:length_nmat(1)
        %Shape
        chromosome{i+1}.pitch = dec2bin(nmat(i,4));
        chromosome{i+1}.velocity = dec2bin(nmat(i,5));
        
        %Move
        chromosome{i+1}.dur = dec2bin(nmat(i,2)*chromosome{1}.tempo);
        chromosome{i+1}.onset = dec2bin(nmat(i,1)*chromosome{1}.tempo);
%        chromosome{i+1}.durSec = dec2bin(round(nmat(i,7)./chromosome{1}.durres));
%        chromosome{i+1}.onsetSec = dec2bin(round(nmat(i,6)./chromosome{1}.durres));
        
        %extra
        chromosome{i+1}.channel = dec2bin(nmat(i,3));
    end
    
    
    
end

function [ chromosome ] = midi_genotype_ver2( nmat )
    chromosome = zeros(20,1);
end
