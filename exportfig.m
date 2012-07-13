function exportfig(filename, figh)

if nargin < 2
  figh = gcf;
end

print(figh, filename, '-depsc2')

end

