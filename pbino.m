function p = pbino(r, n, pi)
%PBINO Exact binomial distribution.
%  Compute binomial PDF in parallel, and in a simpler way that in the stats
%  toolbox. This does not have all the input checking of the stats toolbox
%  version, however, nor is it valid for very large n.

p = zeros(size(r));
parfor i = 1:length(r),
   p(i) = nchoosek(n, r(i))*pi^r(i)*(1 - pi)^(n - r(i));
end
