% hmtdenoise_tree.m
%
% 1-D
% Test denoise using HMT prior
% Usuage : xp = hmtdenoise_tree2D(x, h, nstd, ES, POS, MU, SI)
% ES, POS, MU, SI - model parameters
%
% Written by : Justin Romberg
% Created : 7/1/99

function xp = hmtdenoise_tree(xn, h, nstd, ES, POS, MU, SI)

N = length(xn);
L = log2(N);

nvar = nstd^2;
wn = mdwt(xn, h, L);
POS = POS(:,1);
wp = denoise_tree(wn, ES, POS, MU, SI+nvar, nvar);
xp = midwt(wp, h, L);













