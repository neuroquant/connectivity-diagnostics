function [h1 h2] =  plot_correlations(Xdata)
% function [h1 h2] = plot_correlations(Xdata)
% This function plots the following figures
%   Figure 1a: Global Temporal Correlation (across all regions) per subject
%   Figure 1b: Functional Connectivity (spatial correlation) per subjects
%   Figure 2:   Group Temporal Correlation per brain region
%
% Inputs
% Xdata is a data matrix of size m x p x n
%   where
%     - m is the number of time-points (TR)
%     - p is the number of voxels or brain regions
%     - n is the number of subjects
%
% Outputs
% h1,h2 - structures that contain handles to the main figure and subplots

  [m p n] = size(Xdata);

  % Mode: Separate Subject, Separable Spatio-Temporal Structure
  h1  = {};
  h1.figure = figure;
  set(gcf,'Position',[1 500 3300 250]);
  children = [];
  for cc=1:n
    row_idx = cc;
    children(row_idx) = subplot(2,n+1,row_idx);
    set(children(row_idx),'PlotBoxAspectRatio',[5 5 1]);
    imagesc(corr(Xdata(:,:,cc)'));  colormap(parula); axis image;
    set(children(row_idx),'XTick', [1 m],'YTick', [1 m]);
    xlabel(['Subject ' num2str(cc)]);

    if(cc==n)
      % set(children(row_idx),'PlotBoxAspectRatio',[5 8 1]);
      % colorbar('EastOutside');
      axis image;
    else
      axis image;
    end
    if(cc==floor(n/2))
      title('Temporal Correlation');
    end

    %figure(3)
    row_idx = n+1+cc;
    children(row_idx) = subplot(2,n+1,row_idx);
    set(children(row_idx),'PlotBoxAspectRatio',[5 5 1]);
    imagesc(corr(Xdata(:,:,cc)));
    xlabel(['Subject ' num2str(cc)]);

    if(cc==n)
      % set(children(row_idx),'PlotBoxAspectRatio',[5 8 1]);
      %colorbar('EastOutside');
      axis image;
    else
      axis image;
    end
    if(cc==floor(n/2))
      title('Spatial Correlation');
    end
  end
  h1.children = children;
  subplot(2,n+1,n+1); tmph=	imagesc(corr(Xdata(:,:,n)'));  axis off; colorbar; set(tmph,'visible','off');
  subplot(2,n+1,2*(n+1)); tmph =	imagesc(corr(Xdata(:,:,n)'));  axis off; colorbar; set(tmph,'visible','off');


 % Mode Non-separable Spatio-Temporal, Separate Regions
 Xdata = permute(Xdata, [1 3 2]);
 [m p n] = size(Xdata);
 h2 = {};
 h2.figure = figure;
 children = [];
 colormap(parula);
 n_alt = min(n,30);
 set(gcf,'Position',[1 800 3500 250]);
 for cc=1:n_alt
   row_idx = cc;
   children(row_idx) = subplot(1,n_alt+1,row_idx);
   set(children(row_idx),'PlotBoxAspectRatio',[2 2 1]);
   imagesc(corr(Xdata(:,:,cc)'));   axis image;
   set(children(row_idx),'XTick', [1 m],'YTick', [1 m])
   xlabel(['Region ' num2str(cc)]);
   if(cc==n_alt)
     % set(children(row_idx),'PlotBoxAspectRatio',[5 8 1]);
     % colorbar('EastOutside');
     axis image;
   else
     axis image;
   end
   if(cc==floor(n_alt/2))
     title('Temporal Correlation');
   end
 end
 h2.children = children;
 subplot(1,n_alt+1,n_alt+1); tmph=	imagesc(corr(Xdata(:,:,n_alt)'));  axis off; colorbar; set(tmph,'visible','off');
