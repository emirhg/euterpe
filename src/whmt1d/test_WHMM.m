%This script is the implementation of Reference [1], including 2 parts:
%1. 1D signal denoising (page 9~11)
%2. 1D random process(RP) classification (page 12)
% Reference:
% [1] Wavelet-Based Statistical Signal Processing Using Hidden Markov Models:
% MS Crouse, RD Nowak, RG Baraniuk - IEEE transactions on signal processing, 1998 - dsp.rice.edu.
% Available at:
% http://scholarship.rice.edu/bitstream/handle/1911/19815/Cro1998Apr1Wavelet-Ba.PDF?sequence=1
% Acknoledgement:
% The author wish to thank Prof. Justin Romberg for his 'hmt1d' toolbox and
% his kindly help of using it.

%script is written by Su Dongcai on 2009/11/27

%add all needed path:
addpath('GenerateData', 'hmt1d');
%**************************Test denoising***********************************
%generate noisy doppler signal(of 2^10 length)
[xn, x] = noisyDoppler(10, .005);
%save WHMM for denosing:
trainWHMM_1d(xn, 0);
%denoising:
xp = modelBased_denoise_1d(xn);
%display the results:
figure,
subplot(3, 1, 1), plot(x), title('the original doppler signal');
subplot(3, 1, 2), plot(xn), title('the original doppler signal');
subplot(3, 1, 3), plot(xp), title('smoothed signal by WHMT');
%*************************End of testing denoising*************************

%*************************Test RP classification******************************
%generate 2 different types of random process 'rp1' and 'rp2':
rp1 = rp_type1(10);
rp2 = rp_type2(10);
%save the WHMM trained by rp1
trainWHMM_1d(rp1, 1);
%classifying:
[x_lkh, y_lkh] = modelBased_rp_classification(100);
%displaying results:
figure, 
subplot(3, 1, 1), plot(rp1), title('RP typeI');
subplot(3, 1, 2), plot(rp2), title('RP typeII');
subplot(3, 1, 3), plot(log(x_lkh), 'r+'), hold on, plot(log(y_lkh), 'bo'), hold off, title('The effect of classification');
%***********************End of testing RP classification********************