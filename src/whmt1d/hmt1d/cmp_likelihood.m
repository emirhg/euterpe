function lk = cmp_likelihood(x,  ES, POS, MU, SI)
%Effect:        compute the liklihood probability of x given WHMM parameter
%Input:
%           x: the input signal
%           ES, POS, MU, SI: the parameters of WHMM
%Output:
%           lk: the liklihood probability of x given WHMM
%Function is written by Su Dongcai(suntree4152@gmail.com) on 2009/11/27
h = daubcqf(6);
L = log2(length(x));
w = Idwt(x,h,L);
[gamma,alpha,beta,btpni,lk] = updown_tree(w, ES, POS, MU, SI, 0);