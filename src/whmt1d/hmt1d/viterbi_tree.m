% viterbi_tree.m
%
% 1-D
% Finds the most likely (ML) sequece of state given the input data with a
% coarse to fine tree.
% Usuage : [qp, lk] = viterbi_tree(w, ES, POS, MU, SI, scl)
% w - input data
% ES, POS, MU, SI - model parameters.  ES is COLUMN STOICHASTIC
% scl - if ~=0, use scaling to prevent arithmetic underflow, default=0
% qp - ML estimate of the hidden state sequence
% lk - likelihood of qp (log likelihood if scl ~= 0)
% 
% Written by : Justin Romberg
% Created : 1/20/99

function [qp, lk] = viterbi_tree(w, ES, POS, MU, SI, scl)

% make sure scl is defined
if (nargin < 6)
  scl = 0;
end

% number of data points, number of state, and number of levels in the tree
N = length(w);
M = size(MU,1);
L = size(MU,2);

% delta(jj,ii) is the "best score" along a state path that ends in state jj
% at node ii (all paths that "branch off" of this path before node ii are
% independent of this path).
% psi(jj,kk,ii) is the most likely state at ii to have children jj
% and kk.
delta = zeros(M,N);
psi = zeros(M,M,N);

% allocate space for the state sequence
qp = zeros(1,N);

% individual data likelihoods to be in each state

% intialization
fl = gaussian(w(2), MU(:,2), SI(:,2));
if (scl == 0)
  delta(:,2) = POS.*fl;
else
  delta(:,2) = log(POS) + log(fl);
end
psi(:,:,1) = zeros(M,M);

% recursion
for ll = 2:L
  inds1 = 2^(ll-1)+1;
  inds2 = 2^ll;
  for ii = inds1:inds2
    for jj = 1:M
      f = gaussian(w(ii), MU(jj,ll), SI(jj,ll));
      if (scl == 0)
	delta(jj,ii) = max(delta(:,parent(ii)).*ES(jj,:,ll)')*f;
      else
	delta(jj,ii) = max(delta(:,parent(ii))+log(ES(jj,:,ll)')) + ...
	    log(f);
      end
      for kk = 1:M
	if (scl == 0)
	  psi(jj,kk,parent(ii)) = ...
	      argmax(delta(:,parent(ii)).*ES(jj,:,ll)'.*ES(kk,:,ll)');
	else
	  psi(jj,kk,parent(ii)) = ...
	      argmax(delta(:,parent(ii)) + log(ES(jj,:,ll)') + ...
	      log(ES(kk,:,ll)'));
	end
      end
    end
  end
end

% termination
% at level L
lk = max(delta(:, end));
for ii = inds1:inds2
  qp(ii) = argmax(delta(:,ii));
end

% path (state sequence) backtracking
for ll = (L-1):-1:1
  inds1 = 2^(ll-1)+1;
  inds2 = 2^ll;
  for ii = inds1:inds2
    qp(ii) = psi(qp(leftChild(ii)),qp(rightChild(ii)),ii);
  end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
% function that returns the left child of a givend node
function lc = leftChild(ii)
lc = 2*ii - 1;
 
% function that returns the right child of a given node
function rc = rightChild(ii)
rc = 2*ii;

% function that returns the parent of a given node
function p = parent(ii)
p = round(ii/2 + .1); 
 

% quick argmax function
% x - matrix to find argmax of
% dim - dimension to look along
function am = argmax(x, dim)
if (nargin <2)
  dim = 1;
end
[dummy, am] = max(x,[],dim);


% "robust" normpdf function.  It takes the mean and VARIANCE and returns the
% distribution value.  The variance is thresholded at 1e-5.  The return
% value is thresholded at 1e-20.
function f = gaussian(x, mui, vari)
inds1 = find(vari < 1e-5);
vari(inds1) = (1e-5)*ones(size(inds1));
f = normpdf(x, mui, sqrt(vari));
inds2 = find(f < 1e-20);
f(inds2) = (1e-20)*ones(size(inds2));
