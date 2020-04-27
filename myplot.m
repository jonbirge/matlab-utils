function h = myplot(varargin)
%MYPLOT 2D plot using custom settings
%  myplot(...) takes the same parameters as the default MATLAB plot
%  routine. In addition, the command form 'myplot x y' will plot the
%  variables named x and y from the workspace, labeling the axes of the
%  plot as such.

if ischar(varargin{1}) && ischar(varargin{2}) % command form
  xname = varargin{1};
  yname = varargin{2};
  xval = evalin('caller', xname);
  yval = evalin('caller', yname);
  hdls = plot(xval, yval, varargin{3:end});
  xlabel(['\it ' xname])
  ylabel(['\it ' yname])
else % normal form
  hdls = plot(varargin{:});
end

% make it look nice
fh = gcf;
makepretty(fh);

if nargout > 0
  h = hdls;
end
