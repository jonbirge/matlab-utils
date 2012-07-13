function h = myplot(varargin)

%grey = [0.5 0.5 0.5];
black = [0 0 0];
white = [1 1 1];

hdls = plot(varargin{:});

axh = gca;
fh = gcf;

set(hdls, 'LineWidth', 4, 'Color', [0 .25 0.5])

set(fh, 'Color', white)

xdat = get(hdls, 'XData');
xlim([min(xdat) max(xdat)])

set(axh, ...
  'FontName', 'Arial', 'Color', white, 'FontSize', 18, 'FontWeight', 'Bold', ...
  'GridLineStyle', ':', ...
  'XGrid', 'off', 'XColor', black, 'XMinorTick', 'on', ...
  'YGrid', 'off', 'YColor', black, 'YMinorTick', 'on')

if nargout > 0
  h = hdls;
end
