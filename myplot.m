function h = myplot(varargin)

%grey = [0.5 0.5 0.5];
black = [0 0 0];
white = [1 1 1];

hdls = plot(varargin{:});

axh = gca;
fh = gcf;

set(hdls, 'LineWidth', 2.5, 'Color', [0 .25 0.5])

set(axh, ...
  'FontName', 'Helvetica', 'Color', white, 'FontSize', 12, 'FontWeight', 'Normal', ...
  'GridLineStyle', ':', ...
  'XGrid', 'off', 'XColor', black, 'XMinorTick', 'on', ...
  'YGrid', 'off', 'YColor', black, 'YMinorTick', 'on')

set(fh, 'Color', white)

xdat = get(hdls, 'XData');
xlim([min(xdat) max(xdat)])

if nargout > 0
  h = hdls;
end
