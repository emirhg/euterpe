function [ data ] = processData( data, Max_iter )
%PROCESSDATA Summary of this function goes here
%   Executes de EM algorithm to adjust de data parameters until Max_iter is
%   achieved
tmptime = 0;

if (nargin < 2)
    Max_iter = data{end}.hmt.iter + 1;
end

totaliter = 0;
for i=1:length(data)
    totaliter = totaliter + (Max_iter - data(i).hmt.iter);
end

elapsedIter = 0;
parfor (i=1:length(data))
    if isfield(data(i),'name')
        fprintf(1,'Processing file %s\n', data(i).name);
    end
    while (data(i).hmt.iter<Max_iter)
        elapsedIter = elapsedIter +1;
        [data(i).hmt.es, data(i).hmt.pos, data(i).hmt.mu, data(i).hmt.si]=trainEM_tree(data(i).dwt,2,1);
        data(i).hmt.iter = data(i).hmt.iter +1;
    end
end
end

