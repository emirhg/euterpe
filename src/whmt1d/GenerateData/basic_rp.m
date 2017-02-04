function x = basic_rp(L)
%Generate a random process (RP) of length 2^L, the RP was described in [1]
%(page 12)
%Reference:
%[1] Wavelet-Based Statistical Signal Processing Using Hidden Markov Models
%    MS Crouse, RD Nowak, RG Baraniuk - IEEE transactions on signal processing,
%    1998 - dsp.rice.edu
%    Available at http://scholarship.rice.edu/bitstream/handle/1911/19815/Cro1998Apr1Wavelet-Ba.PDF?sequence=1
N = 2^L;
noisy_rate = 1;
x = zeros(1, N);
x(1) = rand;

for i=2:N
    a = .4 + rand*.4;
    x(i) = a*x(i-1) +(rand-.5)*noisy_rate;
end