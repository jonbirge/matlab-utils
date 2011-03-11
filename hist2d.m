function [phi, xc, yc] = hist2(x, y, n)
%HIST2  Two-dimensional histogram.

if (nargin < 3)
   n = 10;  % default bins
end

xmin = min(x);
xmax = max(x);
ymin = min(y);
ymax = max(y);

% Bin edges.
xedges = linspace(xmin, xmax, n + 1);
yedges = linspace(ymin, ymax, n + 1);

% Generate histograms along y-axis.
for i = 1:n,
   yi = y(x >= xedges(i) & x < xedges(i + 1));
   if length(yi)
      yhisti = histc(yi, yedges);
   else
      yhisti = zeros(1, n+1);
   end
   h(:,i) = fliplr(yhisti(1:(end - 1)))';
end

xc = (xedges(1:end-1) + xedges(2:end))/2;
yc = (yedges(1:end-1) + yedges(2:end))/2;

% Plot or output mass matrix.
if (nargout == 0)
   % Note: the matrix h is arranged as y->i, x->j
   imagesc(h)
   colorbar
   
   xcenters = (xedges(2:end) + xedges(1:end-1))/2;
   ycenters = (yedges(2:end) + yedges(1:end-1))/2;
   xlabels = xcenters(get(gca, 'XTick'));
   ylabels = ycenters(get(gca, 'YTick'));
   set(gca, 'XTickLabel', num2str(xlabels'));
   set(gca, 'YTickLabel', num2str(fliplr(ylabels)'));
   xlabel('\itx')
   ylabel('\ity')
   %bar3(xc, h, 1, 'hist')
else
   phi = h
end
