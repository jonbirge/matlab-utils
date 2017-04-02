function h = myplot(varargin)
% MYPLOT Plot
% grey = [0.5 0.5 0.5];
black = [0 0 0];
white = [1 1 1];
% blue = [0.2 0.7 0.9];
% darkblue = [0 .25 0.5];

hdls = plot(varargin{:});

axh = gca;
fh = gcf;

set(hdls, 'LineWidth', 4)
% if length(hdls) == 1
%   set(hdls, 'Color', blue)
% end
% set(hdls, 'LineWidth', 3, 'Color', black)

set(fh, 'Color', white)

xdat = get(hdls(1), 'XData');
xlim([min(xdat) max(xdat)])

set(axh, ...
  'FontName', 'Arial', 'Color', white, 'FontSize', 18, 'FontWeight', 'Bold', ...
  'GridLineStyle', '-', 'GridColor', 0.5*ones(1,3), ...
  'MinorGridLineStyle', '-', 'MinorGridColor', 0.5*ones(1,3), ...
  'XGrid', 'off', 'XColor', black, 'XMinorTick', 'off', ...
  'YGrid', 'off', 'YColor', black, 'YMinorTick', 'off', ...
  'LineWidth', 2)

if nargout > 0
  h = hdls;
end
