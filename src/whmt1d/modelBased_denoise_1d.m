function xp = modelBased_denoise_1d(x, nsi)
%Effect:        smooth the noisy signal x
%Input:         x: the original noisy signal
%Output:        xp: the smoothed signal by WHMT
%Function is written by Su Dongcai(suntree4152@gmail.com) on 2009/11/27
load .\whmm\noisyDoppler.mat;
%calculate the wavelet filter coefficients:
h = daubcqf(6);
%implement the wavelet transform:
L = log2(length(x));
w = Idwt(x,h,L);
%denoising based on the wavelet coefficients:
if nargin > 1
    wp = denoise_tree(w, ES, POS, MU_VAL, SI, nsi);
else
    wp = denoise_tree(w, ES, POS, MU_VAL, SI);
end

%Recovering:
xp = Iidwt(wp,h,L);