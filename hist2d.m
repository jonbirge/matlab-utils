function [phi, xc, yc] = hist2d(x, y, n, type)
%HIST2 Simple two-dimensional histogram
%  hist2d(x, y, n) plots the n x n histogram of the data contained in the x
%  and y vectors. This function has been rendered obsolute by the MATLAB
%  histogram2 function introduced in 2015.

if nargin < 4
  type = 'bar';
  if nargin < 3
    n = 10;  % default bins per dimension
  end
end

xmin = min(x);
xmax = max(x);
ymin = min(y);
ymax = max(y);

% Bin edges.
xedges = linspace(xmin, xmax, n + 1);
yedges = linspace(ymin, ymax, n + 1);

% Generate histograms along y-axis.
h = zeros(n);
for i = 1:n
  yi = y(x >= xedges(i) & x < xedges(i + 1));
  if ~isempty(yi)
    yhisti = histcounts(yi, yedges);
  else
    yhisti = zeros(1, n);
  end
  h(:,i) = fliplr(yhisti).';
end

xc = (xedges(1:end-1) + xedges(2:end))/2;
yc = (yedges(1:end-1) + yedges(2:end))/2;

% Plot or output mass matrix.
% Note: the matrix h is arranged as y->i, x->j
if (nargout == 0)
  if strcmp(type, 'image')
    imagesc(h)
    colorbar
    xcenters = (xedges(2:end) + xedges(1:end-1))/2;
    ycenters = (yedges(2:end) + yedges(1:end-1))/2;
    xlabels = xcenters(get(gca, 'XTick'));
    ylabels = ycenters(get(gca, 'YTick'));
    set(gca, 'XTickLabel', num2str(xlabels'));
    set(gca, 'YTickLabel', num2str(fliplr(ylabels)'));
    xlabel('\itX')
    ylabel('\itY')
  else
    bar3(xc, h, 1, 'hist')
    xtickn = length(get(gca, 'XTick'));
    ytickn = length(get(gca, 'YTick'));
    xcenters = linspace(xedges(1), xedges(end), xtickn);
    ycenters = linspace(yedges(1), yedges(end), ytickn);
    set(gca, 'XTickLabel', num2str(xcenters', 2));
    set(gca, 'YTickLabel', num2str(fliplr(ycenters)', 2));
    axis('tight')
  end
else
   phi = h;
end
