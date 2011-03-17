function p = pbino(r, n, pi)
%PBINO  Binomial distribution.
%  Compute binomial PDF in parallel, and in a simpler way that in the stats
%  toolbox. This does not have all the input checking of the stats toolbox
%  version, however.

p = zeros(size(r));
parfor i = 1:length(r),
   p(i) = nchoosek(n, r(i))*pi^r(i)*(1 - pi)^(n - r(i));
end
