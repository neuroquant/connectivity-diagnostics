function [score] = influence(Sigmab,Sigma)
% influence.m
% Compute Cook's Distance or the influence of each observation. 
% CD2 = (s(−i) − s)T (cov s)^{-1}(s(−i) − s)
% Specify observation dimension for multi-subject spatio temporal data
% Use the jackknifed estimates within this function 

	[p1 p2 n] = size(Sigmab); 
	score = zeros(1,n);  
	
	meanCov = mean(Sigma,3); 
	
	%varCov = squeeze(sum(sum(bsxfun(@minus, meanCov,Sigma).^2,1),2));	
	for cc=1:n
		score(cc) = frob_err(Sigmab(:,:,cc),meanCov);
	end
	%score = score/(2*mean(varCov));


	% Toman's estimate? varCov definition not eclear; 
	% Sigmab = reshape(Sigmab, [p1*p2 n]);
	% varCov = (meanCov(:)*meanCov(:)');	
	% for cc=1:n
	% 	score(cc) = (Sigmab(:,cc)-meanCov(:))' * pinv(varCov)  * (Sigmab(:,cc)-meanCov(:));
	% end
	
end


function error = frob_err(A1,A2)
	
	error = sum(sum(abs(A1-A2).^2)); 
	
end