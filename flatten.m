function y = flatten(x)
%FLATTEN Flatten a matrix to a vector.
%  v = flatten(m) takes a matrix m and turns it into a row vector.

[m, n] = size(x);
y = zeros(m*n, 1);
for k = 1:m,
  start = (k-1)*n + 1;
  y(start + (0:n-1)) = x(k, :);
end
