function r = polynewton(p, r, n)

if (nargin < 3)
  n = 1;
end
dp = polyderiv(p);
for k = 1:n
  H1 = polyval(p, r);
  H2 = polyval(dp, r);
  r = r - H1./H2;
end
