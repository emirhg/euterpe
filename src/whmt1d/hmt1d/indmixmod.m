% indmixmod.m
%
% Uses the EM algorithm to fit an independent, zero mean, mixture model to
% the input data with the specified number of states. 
%
% function [epsi,mui,vari] = indmixmod(dat,nmix,niter,zeromean)
%
% Outputs:
%   epsi  --- mixture probabilities
%   mui   --- mixture means
%   vari  --- mixture variances
%
%
% Inputs:
%   dat   --- data to be fit
%   nmix  --- number of mixture components
%   niter --- max number of iters for em algorithm
%   zeromean -- if ~= 0, constrains means to be 0
%
% Written by : Matt Crouse and Justin Romberg

function [epsi, mui, vari] = indmixmod(dat, nmix, niter, zm)

L = length(dat);
[epsi,mui,vari]=initem(dat,nmix);

% default is zero mean
if (nargin < 4)
  zm = 1;
end

datmat=repmat(dat',1,nmix);
varimat=repmat(vari,L,1);
muimat=repmat(mui,L,1);
epsimat=repmat(epsi,L,1);
%keyboard

for iter=1:niter
   pst=  exp(-(datmat-muimat).^2.0./(2*varimat))./sqrt(varimat).*epsimat;
   scale = sum(pst',1)' + eps;
   scalemat=repmat(scale,1,nmix);	

   %keyboard
   
   pst = pst./scalemat;

   epsi = mean(pst)+eps; 
   epsimat = repmat(epsi,L,1);

   % For denoising, constraint mui to be 0 so skip next statement
   if (zm ~= 0)
     mui = zeros(1,nmix);
   else
     mui = mean(pst.*datmat)./epsi;
   end
   
   muimat=repmat(mui,L,1);
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   vari	= mean(pst.*(datmat-muimat).^2)./epsi;

   % Constrain variances > 0, so no singular solutions
   % Minimum value depends on application
   vartol = 1e-5;
   vari = vari .* (vari > vartol) +vartol .*(vari<=vartol);
   varimat=repmat(vari,L,1);

   %keyboard
end

% return columns
epsi = epsi';
vari = vari';
mui = mui';

% sort the states by size of variance
[vari,ind] = sort(vari);
epsi = epsi(ind);
mui = mui(ind);

% initialization
function [p, mui, sig] = initem(dat,nmix)
%p = (1/nmix)*ones(1,nmix);
maxdat = max(dat);
mindat = min(dat);
div = linspace(mindat, maxdat, nmix+1);
mui = diff(div)/2 + div(1:end-1);
div(end) = div(end) + 1e-3;
if (length(mui) < 2)
  sig = diff(div);
else
  sig = (mui(2) - mui(1))^2*ones(1,nmix);
end

for ii = 1:nmix
  p(ii) = sum((dat>=div(ii)) & (dat<div(ii+1)))/length(dat);
end

%keyboard




