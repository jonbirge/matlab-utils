function makepretty(fig)

if nargin > 1
  setfig = true;
  oldfh = gcf;
  figure(fig)
else
  setfig = false;
end

black = [0 0 0];
white = [1 1 1];

axh = gca;
fh = gcf;

hdls = get(axh, 'Children');
set(hdls, 'LineWidth', 3)

set(fh, 'Color', white)

xdat = get(hdls, 'XData');
xlim([min(xdat) max(xdat)])

set(axh, ...
  'FontName', 'Arial', 'FontSize', 14, 'FontWeight', 'Bold', ...
  'GridLineStyle', '-', 'MinorGridLineStyle', '-', 'Color', white, 'LineWidth', 1, ...
  'XGrid', 'off', 'XColor', black, 'XMinorTick', 'on', ...
  'YGrid', 'off', 'YColor', black, 'YMinorTick', 'on')

labs = findall(gcf, 'Type', 'text');
set(labs, 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'Bold');

if setfig
  figure(oldfh);
end
