function x = linfill(x0, dx, n)
% LINFILL  Create linearly spaced vector
% x = LINFILL(x0, dx, n) creates a vector x of length n that starts at x0
% and increments by dx.

x = x0:dx:((n-1)*dx + x0);