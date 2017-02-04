% idwtmult1.m
%
% Inverts dwtmult1.
%
% Written by : Justin Romberg
% Created : 5/1/2001

function x = idwtmult1(w, g0, g1, L)

N = length(w);
m0 = length(g0);
m1 = length(g1);
% delay to line up tree structure
z = floor((m1-m0)/4)+1;

for ll = L:-1:1
  w(1:N*2^(-ll)) = cshift(w(1:N*2^(-ll)),z,'r');
  w(1:N*2^(-ll+1)) = idwtlevel1(w(1:N*2^(-ll+1)), g0, g1);
end
x = w;
  