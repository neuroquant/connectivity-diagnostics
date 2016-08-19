function test_suite = test_GGM
        initTestSuite;
end

function test_chain_graph
        addpath(genpath('ggm-external'));
        load('test_lattice');

        % load simulation parameters
        m = 100;
        p = simulation.simopts.p;
        n = 10;

        % Check test paramters
        Data = [];
        for cc=1:n-1
          Data(:,:,cc) = mvnSim.generateNormal(m,p,simulation.Theta);
        end
		simulation.Theta = eye(p)*6 ...
						- triu(ones(p,p),3) + triu(ones(p,p),6) ...
						- tril(ones(p,p),-3) + tril(ones(p,p),-6); 

		Data(:,:,n) = mvnSim.generateNormal(m,p,simulation.Theta) + trnd(2,m,p);

        % Test whether jacknife works. 
		[Sigmab Sigma] = covjackknife(Data,[1 2 3]);
		
		% Test whether influence score works
		score = influence(Sigmab,Sigma); 
		
		% Test whether leverage works
		
		
end		