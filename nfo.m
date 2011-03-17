function nfo(v)
%NFO Summary information about vector.
%  nfo(v) prints summary information about the vector v, including the mean,
%  extremes, standard deviation, mode, etc.

[m, n] = size(v);
if min(m, n) > 1
  error('nfo:size', 'nfo must be called with a vector, not a matrix')
end
fprintf('size \t= \t%d x %d\nmin \t= \t%f\nmax \t= \t%f\nmean \t= \t%f\nstd \t= \t%f\n', ...
  m, n, min(v), max(v), mean(v), std(v))

end

