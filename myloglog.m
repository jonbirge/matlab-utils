function h = myloglog(varargin)

black = [0 0 0];
white = [1 1 1];

hdls = loglog(varargin{:});

axh = gca;
fh = gcf;

set(hdls, 'LineWidth', 2.5, 'Color', [0 .25 0.5], 'MarkerSize', 3)

set(axh, ...
  'FontName', 'Helvetica', 'Color', white, 'FontSize', 16, 'FontWeight', 'Bold', ...
  'GridLineStyle', ':', ...
  'XGrid', 'off', 'XColor', black, 'XMinorTick', 'on', ...
  'YGrid', 'off', 'YColor', black, 'YMinorTick', 'on')

set(fh, 'Color', white)

xdat = get(hdls, 'XData');
xlim([min(xdat) max(xdat)])

if nargout > 0
  h = hdls;
end
