function w = wavelet_transform(x)
% Performs the default Discrate Wavelet Transform for variable x

h = daubcqf(6);
L = log2(length(x));
w = Idwt(x,h,L);
end