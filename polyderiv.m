function dc = polyderiv(c)

n = length(c) - 1;
dc = c(1:n) .* (n:-1:1);