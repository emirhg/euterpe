% dwtlevel1.m
%
% One level of the discrete wavelet transform.  Periodic extension (for now)
% and the wavelets are lined up the best way for "tree structure".
% Usage : w = dwtlevel1(x, h0, h1)
%
% Written by : Justin Romberg
% Created : 5/1/2001

function w = dwtlevel1(x, h0, h1)

N = length(x);
m0 = length(h0);
m1 = length(h1);

% center on the middle of the "wavelet" filter
% odd length - hole at  (m1-1)/2
% even length - hole at m1/2 - 1
c0 = cconv(x, h0, floor((m1+1)/2)-1);
c1 = cconv(x, h1, floor((m1+1)/2)-1);
w = [c0(1:2:N) c1(1:2:N)];


