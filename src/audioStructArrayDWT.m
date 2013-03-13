function [ data ] = audioStructArrayDWT( data, varargin )
%PROCESSDATA Summary of this function goes here
%   Executes de EM algorithm to adjust de data parameters until Max_iter is
%   achieved

    okargs =   {'compression'};
    defaults = {1};

    [~,~,cf] = getargs(okargs,defaults,varargin{:});

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
        if size(data(i).wave,1) > 1
            data(i).wave = data(i).wave';
        end

        if not (length(data(i).wave) == maxLength)
            %fprintf(1,'Wave padding\n');
            data(i).wave = [data(i).wave zeros(1,maxLength-length(data(i).wave))];
        end
        fprintf(1,' %d/%d Wavelet Transform with %f%% of the samples\n', i, totalData, 100/cf);
        %calculate the wavelet filter coefficients:
        h = daubcqf(6);
        %implement the wavelet transform:
        L = log2(length(data(i).wave));
        data(i).dwt = Idwt(data(i).wave,h,L);
        data(i).dwt = data(i).dwt(1:ceil(length(data(i).dwt)/cf));
    end        
end