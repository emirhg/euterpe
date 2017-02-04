% idwtlevel1.m
%
% Inverse of one level of the discrete wavelet transform (dwtlevel1).
%
% Written by : Justin Romberg
% Created : 5/1/2001

function x = idwtlevel1(w, g0, g1)

N = length(w);
m0 = length(g0);
m1 = length(g1);

% upsample
c0 = reshape([w(1:N/2); zeros(1,N/2)], [1 N]);
c1 = reshape([w(N/2+1:N); zeros(1,N/2)], [1 N]);

% center on the middle of the wavelet filter
% odd length - hole at (m1-1)/2
% even length - hole at m1/2
x = cconv(c0, g0, floor(m1/2)) + cconv(c1, g1, floor(m1/2));