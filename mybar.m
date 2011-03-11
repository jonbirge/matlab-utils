function [xo,yo] = mybar(varargin)
%BAR Bar graph.
%    BAR(X,Y) draws the columns of the M-by-N matrix Y as M groups of N
%    vertical bars.  The vector X must be monotonically increasing or
%    decreasing.
%
%    BAR(Y) uses the default value of X=1:M.  For vector inputs, BAR(X,Y)
%    or BAR(Y) draws LENGTH(Y) bars.  The colors are set by the colormap.
%
%    BAR(X,Y,WIDTH) or BAR(Y,WIDTH) specifies the width of the bars. Values
%    of WIDTH > 1, produce overlapped bars.  The default value is WIDTH=0.8
%
%    BAR(...,'grouped') produces the default vertical grouped bar chart.
%    BAR(...,'stacked') produces a vertical stacked bar chart.
%    BAR(...,LINESPEC) uses the line color specified (one of 'rgbymckw').
%
%    H = BAR(...) returns a vector of patch handles.
%
%    Use SHADING FACETED to put edges on the bars.  Use SHADING FLAT to
%    turn them off.
%
%    Examples: subplot(3,1,1), bar(rand(10,5),'stacked'), colormap(cool)
%              subplot(3,1,2), bar(0:.25:1,rand(5),1)
%              subplot(3,1,3), bar(rand(2,3),.75,'grouped')
%
%    See also HIST, PLOT, BARH.


error(nargchk(1,4,nargin)); %#ok<ERTAG>

[msg,x,~,xx,yy,linetype,~,~,equal] = makebars(varargin{:});
if ~isempty(msg), error('mybar:err', msg); end

if nargout==2,
  warning('mybar:args', ...
     ['BAR with two output arguments is obsolete.  Use H = BAR(...) \n',...
      '         and get the XData and YData properties instead.'])
  xo = xx; yo = yy; % Do not plot; return result in xo and yo
else % Draw the bars
  cax = newplot;
  next = lower(get(cax,'NextPlot'));
  hold_state = ishold;
  edgec = get(gcf,'defaultaxesxcolor');
  facec = [0.5 0.75 0.95];
  h = []; 
  cc = ones(size(xx,1),1);
  if ~isempty(linetype), facec = linetype; end
  for i=1:size(xx,2)
    numBars = (size(xx,1)-1)/5;
    f = 1:(numBars*5);
    f(1:5:(numBars*5)) = [];
    f = reshape(f, 4, numBars);
    f = f';

    v = [xx(:,i) yy(:,i)];

    h=[h patch('faces', f, 'vertices', v, 'cdata', i*cc, ...
        'FaceColor',facec,'EdgeColor',edgec)];
  end
  if length(h)==1, set(cax,'clim',[1 2]), end
  if ~equal, 
    hold on,
    plot(x(:,1),zeros(size(x,1),1),'*')
  end
  if ~hold_state, 
    % Set ticks if less than 16 integers
    if all(all(floor(x)==x)) & (size(x,1)<16),   %#ok<AND2>
      set(cax,'xtick',x(:,1))
    end
    hold off, view(2), set(cax,'NextPlot',next);
    set(cax,'Layer','Bottom','box','on')
    % Turn off edges when they start to overwhelm the colors
    if size(xx,2)*numBars > 150, 
       set(h,{'edgecolor'},get(h,{'facecolor'}));
    end
  end
  if nargout==1, xo = h; end
end
