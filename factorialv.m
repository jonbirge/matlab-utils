function p = factorial(n)
%FACTORIAL Vectorized factorial function.
%   FACTORIAL(N) is the product of all the integers from 1 to N,
%   i.e. prod(1:N). Since double precision numbers only have about
%   15 digits, the answer is only accurate for N <= 21. For larger N,
%   the answer will have the right magnitude, and is accurate for 
%   the first 15 digits.
%
%   See also PROD.

N = length(n);
for k = 1:N,
  p(k) = prod(1:n(k));
end