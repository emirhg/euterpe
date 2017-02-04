function x = rp_type1(L)
%Effect:        Generate the random process of length 2^L described in [1]
%(Page 12)
% Reference:
% [1] Wavelet-Based Statistical Signal Processing Using Hidden Markov Models:
% MS Crouse, RD Nowak, RG Baraniuk - IEEE transactions on signal processing, 1998 - dsp.rice.edu.
% Available at:
% http://scholarship.rice.edu/bitstream/handle/1911/19815/Cro1998Apr1Wavelet-Ba.PDF?sequence=1
%Function is written by Su Dongcai on 2009/11/27
x=basic_rp(L);