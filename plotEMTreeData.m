function [hmm_matrix] = plotEMTreeData( data, last_hmm_matrix )
%PLOTEMTREEDATA Summary of this function goes here
%   Detailed explanation goes here

    hmm_matrix = assambleTrainingData(data);
    figmatrix= figure();
    if exist('last_hmm_matrix','var')
        subplot(2,1,1);
        delta = hmm_matrix - last_hmm_matrix;
        surf(delta);
        xlabel('Variable');
        ylabel('Song');
        zlabel('Value');
        subplot(2,1,2);
    end
    
    surf(hmm_matrix);
    
    xlabel('Variable');
    ylabel('Song');
    zlabel('Value');
end

