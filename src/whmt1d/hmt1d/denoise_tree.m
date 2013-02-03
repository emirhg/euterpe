% denoise_tree.m
%
% 1-D
% Denoising algorithm for coarse to fine hmt model.
% Usuage : wp = denoise_tree(w, ES, POS, MU, SI, nsi)
% w - noisy data
% ES, POS, MU, SI - hmt model parameters
% nsi - noise variance (optional).  default = MAD/.67
%
% Written by : Justin Romberg
% Created : 1/18/99

function wp = denoise_tree(w, ES, POS, MU, SI, nsi)

N = length(w);
L = size(MU,2);
M = size(MU,1);

startlevel = 1;
tmp = w(floor(N/2):end);
if (nargin < 6)
  nsi = median(abs(tmp(:)))/.67; %tmp should be finest scale of w
  %error('Enter noise varaince (for now)');
end

% adjust variance
SIo = SI-nsi;
inds = find(SIo<0);
SIo(inds) = zeros(size(inds));

% get the posterior likelihood of each state
[PS,a,b,bt,LK] = updown_tree(w, ES, POS, MU, SI, 1);

% find conditional mean
w2 = repmat(w, [M 1]);
wp = zeros(size(w));
wp(1) = w(1);
for ll = 1:L
  inds1 = 2^(ll-1)+1;
  inds2 = 2^ll;
  if (ll < startlevel)
    wp(inds1:inds2) = w(inds1:inds2);
  else
    sf = repmat(SIo(:,ll)./(SIo(:,ll) + nsi), [1 inds2-inds1+1]);
    wp(inds1:inds2) = sum(PS(:,inds1:inds2).*w2(:,inds1:inds2).*sf, 1);
  end
end
