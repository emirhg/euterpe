function [xn_t, x_t] = noisyDoppler(L, nsi)
%Effect:        generate doppler signal with gaussian noise
%Inputs:
%           L: 2^L is the length of the output signal
%           nsi: the sigma of noise
%Outputs:
%           xn_t: the doppler signal with noise
%           x_t: the original doppler signal
%Function is written by Su Dongcai on 2009/11/27
x_t = makesig('Doppler',2^L);
n_t = randn(size(x_t))*sqrt(nsi);
xn_t = x_t + n_t;