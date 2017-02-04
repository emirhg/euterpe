function [ data ] = processData( data, varargin )
%PROCESSDATA Summary of this function goes here
%   Executes de EM algorithm to adjust de data parameters until Max_iter is
%   achieved

    
    okargs =   {'iter'};
    defaults = {30};
    totalData = length(data);
    [~,~,Max_iter] = getargs(okargs,defaults,varargin{:});

    for(iter=1:Max_iter)
        fprintf(1, '[%d-%d-%d %d:%d:%d] Iteration %d\n', fix(clock), iter);
        for (i=1:totalData)
            if (~isfield(data(i),'hmt'))
                fprintf(1, '[%d-%d-%d %d:%d:%d] Training Data HMT DATA %d/%d at iteration %d\n', fix(clock), i,totalData, iter);
                [data(i).hmt.es, data(i).hmt.pos, data(i).hmt.mu, data(i).hmt.si]=trainEM_tree(data(i).dwt,2,iter);
                data(i).hmt.iter = iter;
            else
                if (~isfield(data(i).hmt,'iter'))
                    fprintf(1, '[%d-%d-%d %d:%d:%d] Training Data HMT DATA %d/%d at iteration %d\n', fix(clock), i,totalData, iter);
                    [data(i).hmt.es, data(i).hmt.pos, data(i).hmt.mu, data(i).hmt.si]=trainEM_tree(data(i).dwt,2,iter);
                    data(i).hmt.iter = iter;
                else
                    if (data(i).hmt.iter < iter)
                        fprintf(1, '[%d-%d-%d %d:%d:%d] Training Data HMT DATA %d/%d at iteration %d\n', fix(clock), i,totalData, iter);
                        [data(i).hmt.es, data(i).hmt.pos, data(i).hmt.mu, data(i).hmt.si]=trainEM_tree(data(i),2,iter-data(i).hmt.iter);
                        data(i).hmt.iter = iter;
                    end
                end
            end
        end

    end
end