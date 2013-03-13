% trainEM_tree.m
%
% Fit a coarse to fine scale HMT model to the given data using the EM
% algorithm.  Based on the Crouse, Nowak, Baraniuk paper.
% Usage : [ES, POS, MU, SI] = trainEM_tree(w, M, maxIter)
% w - wavelet transform to model, row vector
% M - number of states (mixture components)
% maxIter (optional) - maximum number of iterations to run
% ES, POS, MU, SI - HMT model parameters, constant by scale
%
% Written by : Justin Romberg
% Created : 1/14/99

function [ES, POS, MU, SI] = trainEM_tree(w, M, maxIter)



% make sure maxIter is defined
    if nargin<3
        maxIter = 30;
    end
    
% get starting points for model parameters
    if isfield(w,'hmt')
        ES = w.hmt.es;
        POS = w.hmt.pos;
        MU = w.hmt.mu;
        SI = w.hmt.si;
        iter = w.hmt.iter;
        maxIter = iter + maxIter;
        w = w.dwt;
        N = length(w);
        L = log2(N);
    else
        N = length(w);
        L = log2(N);
        [ES, POS, MU, SI] = startPoints(w, L, M);
        iter = 0;
    end
% number of data points and resolutions

% loop until we have converged
    pS = zeros(M,L);
    pSi = zeros(M,N);
    converged = 0;
    
    while (converged == 0)
        pSio = pSi;

        % "E step"
        [pSi, alpha, beta, btpni] = updown_tree(w, ES, POS, MU, SI, 1);

        % "M step"
        ESo = ES; POSo = POS; MUo = MU; SIo = SI; pSo = pS;
      for ll = 1:L
        % temporary variables to make notation more managable
        inds1 = 2^(ll-1)+1;
        inds2 = 2^ll;
        Nll = inds2-inds1+1;
        pSiSp = zeros(M,M,Nll);
        btl = beta(:,inds1:inds2);
        al = alpha(:,inds1:inds2);
        alpl = alpha(:,parent(inds1:inds2));
        btpil = btpni(:,inds1:inds2);

        % update the scale constant mixture probabilities
        pS(:,ll) = mean(pSi(:,inds1:inds2),2);

        % calculate joint pmf between child and parent states to update the 
        % transition matrix
        % inefficient right now, change later 
        if (ll > 1)
          for mm = 1:M
        for nn = 1:M
          pSiSp(mm,nn,:)=ESo(mm,nn,ll)*btl(mm,:).*alpl(nn,:).*btpil(nn,:);
          %./...sum(al.*btl,1);
        end
          end
          pSiSp = pSiSp./repmat(sum(sum(pSiSp,1),2),[M M 1]);
          ES(:,:,ll) = mean(pSiSp,3)./repmat(pS(:,ll-1)',[M 1]);
        end

        % update the transition matrix
        %if (ll > 1)
        %  ES(:,:,ll) = mean(pSiSp,3)./repmat(pS(:,ll-1)',[M 1]);
        %end

        % update the mixture means
        %MU(:,ll) = mean(repmat(w(inds1:inds2),[M 1]).*pSi(:,inds1:inds2))./...
        %pS(:,ll);
        MU(:,ll) = zeros(M,1);

        % update the mixture variances
        SI(:,ll) = mean(pSi(:,inds1:inds2).*...
        (repmat(w(inds1:inds2),[M 1]) - ...
        repmat(MU(:,ll),[1 Nll])).^2, 2)./pS(:,ll);

      end

      % update the initial state distribution
      POS = pS(:,1);

      % test for convergence
      iter = iter + 1;
    if (iter >= maxIter)
        converged = 1;
      end
        err1 = abs(SI-SIo);
        err2 = abs(pS-pSo);
        err3 = abs(pSi-pSio);
        max(err1(:));
        max(err2(:));
        max(err3(:));
        fprintf(1,'\t Error: %d\t%d\t%d\n', max(err1(:)), max(err2(:)), max(err3(:)));

      %keyboard
    end   % while loop
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% quick function to calculate the parents of given nodes
function p = parent(ii)
    p = ceil(ii/2);
end

% function to pick starting points for the EM alg by fitting independent
% mixture models
function [ES, POS, MU, SI] = startPoints(w, L, M)

% allocate space for model parameters
ES = zeros(M,M^2,L);
POS = zeros(M,1);
MU = zeros(M,L);
SI = zeros(M,L);

% pick starting points for the EM alg by fitting independent mixture models
    for ll = 2:L
        inds1 = 2^(ll-1)+1;
        inds2 = 2^ll;
        [ps,mu,si] = indmixmod(w(inds1:inds2), M, 30, 1);
        MU(:,ll) = mu;
        SI(:,ll) = si;
    end
    SI(:,1) = SI(:,2);
    POS = .5*ones(M,1);
    es = .5*ones(M,M);
    ES = repmat(es,[1 1 L]);
end