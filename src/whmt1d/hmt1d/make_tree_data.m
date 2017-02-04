% make_tree_data.m
%
% Make 1-D data for downwards causal (coarse to fine) hidden markov tree.
% Usuage : [w, q] = make_tree_data(ES, P0S, MU, SI)
% ES - transition matrix, MxMxL where M is the number of states and L is the
%      number of levels in the HMTree.  COLUMN STOICHASTIC
% POS - initial distribution on the state of the coarsest wavelet
%      coefficient, Mx1
% MU - mixture means at each level of the tree, MxL
% SI - mixture variances at each level of the tree, MxL
% w - data produced
% q - states from which w was drawn
%
% Written by : Justin Romberg
% Created : 1/14/99

function [w, q] = make_tree_data(ES, POS, MU, SI)

% number of levels, number of data points, and number of states
L = size(MU,2);
N = 2^L;
M = size(MU,1);

w = zeros(1,N);
q = zeros(1,N);

% draw states

% get cdf of state distribution at coarsest resolution
cdfPOS = cumsum(POS);

% choose initial state for "root" of tree
s = rand(1);
cut = find(cdfPOS >= s);
q(2) = cut(1);

% choose states for the rest of the tree
for ll = 2:L
  inds1 = 2^(ll-1)+1;
  inds2 = 2^ll;
  for ii = inds1:inds2
    % choose the column of the transition matrix that we need, i.e. the
    % state of the parent coefficient
    pii = ES(:,q(parent(ii)),ll);
    % calculate the cdf of the state distribution
    cdfpii = cumsum(pii);
    % draw a state
    s = rand(1);
    cut = find(cdfpii >= s);
    q(ii) = cut(1);
  end
end

% generate data points depending on the states
for ii = 2:N
  % level of the node we are at
  l = nextpow2(ii);
  w(ii) = sqrt(SI(q(ii),l))*randn(1) + MU(q(ii),l);
end



% quick function to calculate the parent of a given node
function p = parent(ii)
p = ceil(ii/2);