function [Sigmab Sigma] = covjackknife(X,varargin)
% function [Sigmab] = jackknife(X,varargin);
% Create jacknife estimates of the covariance using sample covariance or Tyler MLE
%
% Inputs:
%  X		: Data matrix of size m x p x n, with following dimensions
% 				(1 time, 2 space, 3 subjects)
%  permdim  : [1 2 3] by default. Argument for permute function
% 				permdim shuffles X to ensure that third dimension of X is jacknife dimension. 	
%									  
% Outputs:  									  
% 	Sigmab 	: Jackknifed sample covariance of size p x p
% 	Sigma	: Sample covariance of size p x p					
%

  dim = length(size(X));

  switch nargin
    case 2
    	permdim = [1 2 3]; 
    case 3
	  	permdim = varargin{1};
	otherwise
    	disp('3 or more inputs not yet supported');
      	permdim = [1 1 1]; 
  end
  X = permute(X,permdim);  
  [m p n] = size(X);
  % Check that jackknife dimension is greater than 1   
  if(dim==3 & n==1)
    error('No samples in the 3rd matrix dimension to resample');
  end

  useRobust = 0;
  useTemporal = 0;

  % Options other than 3 not being used
  switch dim
    case 1
      n_resamples = m;
    case 2
      disp('This is the variable dimension, no resampling');
    case 3
      n_resamples = n;
    end

 Sigma = zeros(p,p,n); 
 for cc=1:n
	 Sigma(:,:,cc) = corr(X(:,:,cc)); 
 end

 
 Sigmab = zeros(p,p,n_resamples);
 all_n = [1:n_resamples];
  for r=1:n_resamples
    Sigmab(:,:,r) = mean(Sigma(:,:,setdiff(all_n,r)),3);
  end

end
