function h = mylogplot(varargin)
%MYLOGPLOT Custom log plotting

hdls = myplot(varargin{:});

axh = gca;

set(axh, ...
  'XGrid', 'on', 'YGrid', 'on', ...
  'XMinorTick', 'on', 'YMinorTick', 'on', ...
  'XMinorGrid', 'off', 'YMinorGrid', 'on', ...
  'YScale', 'log')

xdat = get(hdls(1), 'XData');
xlim([min(xdat) max(xdat)])

if nargout > 0
  h = hdls;
end
