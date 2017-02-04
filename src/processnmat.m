function [ es,pos,mu,si ] = processnmat( nmat, varargin )
%PROCESSNMAT Summary of this function goes here
%   Executes de EM algorithm to adjust de data parameters until Max_iter is
%   achieved

    
    okargs =   {'iter','compression'};
    defaults = {30,100};
    [~,~,Max_iter,compression] = getargs(okargs,defaults,varargin{:});

    wave = nmat2snd(scale(nmat,'time',1/compression));
    L = log2(length(wave));
    wave= [wave, zeros(1,2^ceil(L) - length(wave))];

    %calculate the wavelet filter coefficients:
    h = daubcqf(6);
    %implement the wavelet transform:
    L = log2(length(wave));
    dwt = Idwt(wave,h,L);
    
    fprintf(1,'Normal Training: %d iterations\n', Max_iter);
    trainNormal=tic;
    [es, pos, mu, si]=trainEM_tree(dwt,2,Max_iter);
    toc(trainNormal);
    
    fprintf(1,'GPU Training: %d iterations\n', Max_iter);
    trainGPU = tic;
    [gpuES, gpuPOS, gpuMU, gpuSI]=gpuTrainEM_tree(dwt,2,Max_iter);
    toc(trainGPU);
    
    %data = [es,pos,mu,si];
end