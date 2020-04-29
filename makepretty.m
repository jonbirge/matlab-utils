function makepretty(fig)

% input handling
if nargin > 1
  setfig = true;
  oldfh = gcf;
  figure(fig)
else
  setfig = false;
end

% color definitions;
foregnd = [0 0 0];
backgnd = [1 1 1];

% figure settings
axh = gca;
fh = gcf;
set(fh, 'Color', backgnd)

% dynamically set linewidths
hdls = get(axh, 'Children');
for kline = 1:length(hdls)
	ndat = length(hdls(kline).XData);
	tline = min(ceil(3*512/ndat), 4);
	hdls(kline).LineWidth = tline;
end

% axis limits
xdat = get(hdls, 'XData');
if iscell(xdat)
	xlim([min(xdat{1}) max(xdat{1})])
else
	xlim([min(xdat) max(xdat)])
end

% axis line and text styling
set(axh, ...
  'FontName', 'Arial', 'FontSize', 14, 'FontWeight', 'Bold', ...
  'GridLineStyle', '-', 'MinorGridLineStyle', '-', 'Color', backgnd, 'LineWidth', 1, ...
  'XGrid', 'off', 'XColor', foregnd, 'XMinorTick', 'on', ...
  'YGrid', 'off', 'YColor', foregnd, 'YMinorTick', 'on')

% axis label styling
labs = findall(gcf, 'Type', 'text');
set(labs, 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'Bold');

% reset current figure
if setfig
  figure(oldfh);
end
