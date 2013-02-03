function  trainWHMM_1d(x, model)
%Inputs:
%       x: the observing data for training WHMM
%       model: 0-->denoising model, otherwise is random process
%       classification model
%Effect:  Train WHMM and save its parameters
%Function is written by Su Dongcai on 2009/11/22

%calculate the wavelet filter coefficients:
h = daubcqf(6);
%implement the wavelet transform:
L = log2(length(x));
w = Idwt(x,h,L);
%training HMM using EM:
[ES, POS, MU_VAL, SI] = trainEM_tree(w, 2, 30);
if model==0
    %WHMM for denoising
    save('.\whmm\noisyDoppler.mat', 'ES', 'POS', 'MU_VAL', 'SI');
else
    %WHMM for random process classification
    save('.\whmm\rp.mat', 'ES', 'POS', 'MU_VAL', 'SI');
end