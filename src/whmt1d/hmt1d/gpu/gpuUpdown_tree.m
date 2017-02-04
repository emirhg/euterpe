% updown_tree.m
%
% Upwards-Downwards probability propogation routine for coarse to fine
% trees.  Assumes the the model is scalewise constant.  Based on the Crouse,
% Nowak, Baraniuk paper. 
% Usuage : [gamma,alpha,beta,btpni,lk] = updown_tree(w, ES, POS, MU, SI, scl)
% w - wavelet coefficients of the signal to be analyzed, row vector 1xN
% ES, POS, MU, SI - HMT model parameters
% scl - if ~=0, scale alpha and beta to prevent underflow.  Default = 0;
% alpha - downward parameter (likelihood)
% beta - upward parameter (likelihood)
% btpni - upward parameter of parent without current subtree (likelihood)
% lk - likelihood of w given the model (log likelihood if scl~=0)
%
% Written by : Justin Romberg
% Created : 1/14/99

function [gamma,alpha,beta,btpni,lk] = updown_tree(w, ES, POS, MU, SI, scl)

% make sure that scl is defined
if (nargin < 6)
  scl = 0;
end

% number of data "nodes", number of levels in tree, and number of states
N = length(w);
L = size(MU,2);
M = size(MU,1);

% initialize posterior probs
gamma = gpuArray.zeros(M,N);

% upward (beta) and downward (alpha) parameters
alpha = gpuArray.zeros(M,N);
beta = gpuArray.zeros(M,N);
btpni = gpuArray.zeros(M,N);
betaipi = gpuArray.zeros(M,N);

% scaling coefficients, not in the wavelet sense, but in the preventing
% arithmetic underflow sense
c = gpuArray.zeros(1,N);

% ind. likelihood values for each wavelet coefficient in each state
f = gpuArray.zeros(M,N);

% "up" step

% intialization
inds1 = 2^(L-1)+1;
inds2 = 2^L;
for ii = inds1:inds2
  f(:,ii) = gaussian(repmat(w(ii),[M 1]), MU(:,L), SI(:,L));
  beta(:,ii) = f(:,ii);
  c(ii) = sum(beta(:,ii),1);
  if (scl ~= 0)
    beta(:,ii) = beta(:,ii)/c(ii);
  end
end
betaipi(:,inds1:inds2) = ES(:,:,L)'*beta(:,inds1:inds2);

% induction
for ll = (L-1):-1:1
  inds1 = 2^(ll-1)+1;
  inds2 = 2^ll;
  for ii = inds1:inds2
    f(:,ii) = gaussian(repmat(w(ii),[M 1]), MU(:,ll), SI(:,ll));
    beta(:,ii) = f(:,ii).*betaipi(:,leftChild(ii)).*...
	betaipi(:,rightChild(ii));
    btpni(:,leftChild(ii)) = beta(:,ii)./betaipi(:,leftChild(ii));
    btpni(:,rightChild(ii)) = beta(:,ii)./betaipi(:,rightChild(ii));
    c(ii) = sum(beta(:,ii),1);
    if (scl ~= 0)
      beta(:,ii) = beta(:,ii)/c(ii);
    end
  end
  betaipi(:,inds1:inds2) = ES(:,:,ll)'*beta(:,inds1:inds2);
end

% "down" step

% intialization
alpha(:,2) = POS;
if (scl ~= 0)
  alpha(:,2) = alpha(:,2)/c(2);
end
  
% induction
for ll = 2:L
  inds1 = 2^(ll-1)+1;
  inds2 = 2^ll;
  for ii = inds1:inds2
    alpha(:,ii) = ES(:,:,ll)*(alpha(:,parent(ii)).*btpni(:,ii));
    if (scl ~= 0)
      alpha(:,ii) = alpha(:,ii)/c(ii);
    end
  end
end

% calculate posterior distribution on the states
gamma(:,2:N) = (alpha(:,2:N).*beta(:,2:N))./...
    repmat(sum(alpha(:,2:N).*beta(:,2:N),1), [M 1]);
gamma(:,1) = zeros(M,1);
%disp('Ignore preceeding divide by 0 error');

if (scl ~= 0)
  lk = sum(log10(c(2:end))) - log10(2);
else 
  lk = sum(alpha(:,2).*beta(:,2));
end

%keyboard

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% function that returns the left child of a givend node
function lc = leftChild(ii)
lc = 2*ii - 1;

% function that returns the right child of a given node
function rc = rightChild(ii)
rc = 2*ii;

% function that returns the sibling of a given node
function s = sibling(ii)
if (rem(ii,2)==1)
  s = ii+1;
else
  s = ii-1;
end

% function that returns the parent of a given node
function p = parent(ii)
% robust?????
p = ceil(ii/2); 

% "robust" normpdf function.  It takes the mean and VARIANCE and returns the
% distribution value.  The variance is thresholded at 1e-5.  The return
% value is thresholded at 1e-20.
function f = gaussian(x, mui, vari)
inds1 = find(vari < 1e-5);
vari(inds1) = (1e-5)*ones(size(inds1));
f = normpdf(x, mui, sqrt(vari));
inds2 = find(f < 1e-20);
f(inds2) = (1e-20)*ones(size(inds2));
