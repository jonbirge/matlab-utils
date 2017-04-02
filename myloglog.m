function h = myloglog(varargin)

hdls = myplot(varargin{:});

axh = gca;

set(axh, ...
  'XGrid', 'on', 'YGrid', 'on', ...
  'XMinorTick', 'on', 'YMinorTick', 'on', ...
  'XMinorGrid', 'on', 'YMinorGrid', 'on', ...
  'YScale', 'log', 'XScale', 'log')

xdat = get(hdls(1), 'XData');
xlim([min(xdat) max(xdat)])

if nargout > 0
  h = hdls;
end
