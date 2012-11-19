function [ data ] = processData( data, Max_iter, varargin )
%PROCESSDATA Summary of this function goes here
%   Executes de EM algorithm to adjust de data parameters until Max_iter is
%   achieved

okargs =   {'extend' 'dummy'};
defaults = {0 1};
[~,~,extend,dummy] = getargs(okargs,defaults,varargin{:});

    totalData = length(data);
    maxLength=0;
    minLength = length(data(1).wave);
    
	for (i=1:totalData)
        if (length(data(i).wave)>maxLength)
            maxLength = length(data(i).wave);
        end
        
        if (length(data(i).wave)< minLength)
            minLength = length(data(i).wave);
        end
        
    end

    maxLength = 2^ceil(log2(maxLength));
    minLength = 2^floor(log2(minLength));
  
    for(i=1:totalData)


        if (extend==1)
            data(i).wave = [data(i).wave zeros(1,maxLength-length(data(i).wave))];
        else
            data(i).wave = data(i).wave(1:minLength);
        end
        
        if ~isfield(data(i),'dwt')
             data(i).dwt = wavelet_transform(data(i).wave);
        else
            data(i).dwt = [data(i).dwt zeros(1,maxLength-length(data(i).dwt))];
        end
        
        if ~isfield(data(i),'hmt')
            [data(i).hmt.es, data(i).hmt.pos, data(i).hmt.mu, data(i).hmt.si] = trainEM_tree(data(i).dwt,2,1);
            data(i).hmt.iter = 1;
            fprintf(1, '[Preparing DATA] %d/%d checkpoint saved as %s\n', i, totalData, date);
            save(date, 'data', '-v7.3');
        else
            if (~isfield(data(i).hmt, 'iter'))
                [data(i).hmt.es, data(i).hmt.pos, data(i).hmt.mu, data(i).hmt.si] = trainEM_tree(data(i).dwt,2,1);
                data(i).hmt.iter = 1;
                fprintf(1, '[Preparing DATA] %d/%d checkpoint saved as %s\n', i, totalData, date);
                save(date, 'data', '-v7.3');                
            end
        end
    end


    if (nargin < 2)
        Max_iter = data(end).hmt.iter + 1;
    end

    
    
    for (i=1:totalData)
        save(date, 'data', '-v7.3');
        fprintf(1, '[Processing HMT DATA] %d/%d checkpoint saved as %s\n', i, totalData, date);
        
        if (data(i).hmt.iter<Max_iter)
            [data(i).hmt.es, data(i).hmt.pos, data(i).hmt.mu, data(i).hmt.si]=trainEM_tree(data(i).dwt,2,Max_iter-data(i).hmt.iter,data(i).hmt);
            data(i).hmt.iter = Max_iter;
        end
    end
end

