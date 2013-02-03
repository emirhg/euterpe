function [x_lkh, y_lkh] = modelBased_rp_classification(N)
%Effect:    show how well the WHMT describing 2 different types of random
%           process x, y. More precisely,  the WHMT was trained by x, and
%           stored in '.\whmm\rp.mat', the x_lkh, y_lkh represent how well
%           the WHMT describing x, y respectively
%Inputs:
%           N: the number of elements in x_lkh and y_lkh;
%Function is written by Su Dongcai(suntree4152@gmail.com) on 2009/11/27

%load the WHMT model
load .\whmm\rp.mat
x_lkh = zeros(1, N);
y_lkh = x_lkh;
for i=1:N
    x = rp_type1(10); lk_x = cmp_likelihood(x,  ES, POS, MU_VAL, SI);
    y = rp_type2(10); lk_y = cmp_likelihood(y,  ES, POS, MU_VAL, SI);
    x_lkh(i) = lk_x;
    y_lkh(i) = lk_y;
end