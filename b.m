function p = b(r, n, pi)
%B  Binomial distribution.

p = zeros(length(r),1);
parfor i = 1:length(r),
   p(i) = nchoosek(n, r(i))*pi^r(i)*(1 - pi)^(n - r(i));
end
