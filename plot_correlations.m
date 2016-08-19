function [score_t score_s score_p h1 h2 h3] =  plot_correlations(Xdata)
% function [h1 h2] = plot_correlations(Xdata)
% This function plots the following figures
%   Figure 1a: Global Temporal Correlation (across all regions) per subject
%   Figure 1b: Functional Connectivity (spatial correlation) per subjects
%   Figure 3:   Mean ROI time-series stacked for multiple regions (approx. every other)
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
%  score_t,score_s - Influence like score (deletion diagnostics) that flags outlier subjects according to temporal and spatial correlation. (.75-1) maybe fishy, (>1) very fishy.
%  score_p - Influence like score that flags brain regions (or voxels) for showing unusual temporal structure. (.75-1) maybe fishy, (>1) very fishy.
% h1,h2,h3 - structures that contain handles to the main figure and subplots

  [m p n] = size(Xdata);
  [Sigmatb Sigmat] = covjackknife(Xdata,[2 1 3]);
  [Sigmasb Sigmas] = covjackknife(Xdata,[1 2 3]);
  score_t = influence(Sigmatb,Sigmat);
  score_s = influence(Sigmasb,Sigmas);

  % Mode: Separate Subject, Separable Spatio-Temporal Structure
  h1  = {};
  h1.figure = figure;
  set(gcf,'Position',[1 1200 3300 250]);
  children = [];
  for cc=1:n
    row_idx = cc;
    children(row_idx) = subplot(2,n+1,row_idx);
    set(children(row_idx),'PlotBoxAspectRatio',[5 5 1]);
    imagesc(Sigmat(:,:,cc));  colormap(parula);
    %set(children(row_idx),'XTick', [1 m],'YTick', [1 m]);
    xlabel(['Subject ' num2str(cc) num2str(score_t(cc),', %0.2f')]);

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
    row_idx = (n+1)+cc;
    children(row_idx) = subplot(2,n+1,row_idx);
    set(children(row_idx),'PlotBoxAspectRatio',[5 5 1]);
    imagesc(Sigmas(:,:,cc));
    %set(children(row_idx),'XTick', [1 m],'YTick', [1 m]);
    xlabel(['Subject ' num2str(cc) num2str(score_s(cc),', %0.2f')]);

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




   h3  = {};
   h3.figure = figure;
   set(gcf,'Position',[1 300 3500 800]);
   children = [];
   for cc=1:n
     row_idx = cc;
     children(row_idx) = subplot(4,ceil(n/4),row_idx);
     set(children(row_idx),'PlotBoxAspectRatio',[10 5 1]);
     hold on;
     Ydata = bsxfun(@minus,Xdata(:,:,cc),mean(Xdata(:,:,cc),1));
     %Ydata = bsxfun(@rdivide,Xdata(:,:,cc),std(Xdata(:,:,cc),1));
     if(cc<=ceil(n/4))
       title('Time-Series');
     end
     for pp=1:2:p
       hp = plot(10*pp+Ydata(:,pp),'k-');
       set(hp,'linewidth',2);
     end
     hold off;
     set(children(row_idx),'XTick', [1 m],'YTick', [0 10*(p+1)]);
     xlabel(['Subject ' num2str(cc)]); ylabel(['Stacked Regions'])
   end



 % Mode Non-separable Spatio-Temporal, Separate Regions
 [Sigmapb Sigmap] = covjackknife(Xdata,[3 1 2]);
 score_p = influence(Sigmapb,Sigmap);
 % Xdata = permute(Xdata, [1 3 2]);
%[m p n] = size(Xdata);
 h2 = {};
 h2.figure = figure;
 children = [];
 colormap(parula);
 n_alt = min(p,30);
 set(gcf,'Position',[1 150 3500 400]);
 for cc=1:n_alt
   row_idx = cc;
   children(row_idx) = subplot(2, ceil(n_alt/2+1),row_idx);
   set(children(row_idx),'PlotBoxAspectRatio',[2 2 1]);
   imagesc(Sigmap(:,:,cc));   axis image;
   set(children(row_idx),'XTick', [1 m],'YTick', [1 m])
   xlabel(['Region ' num2str(cc) num2str(score_p(cc),', %0.2f')]);
   if(cc==ceil(n_alt/4))
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
 subplot(2,ceil(n_alt/2+1),n_alt+1); tmph=	imagesc(Sigmap(:,:,n_alt));  axis off; colorbar; set(tmph,'visible','off');
