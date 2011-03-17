function y = dbtoreal(x)
%DBTOREAL Comvert from decibel to linear scale.

y = 10.^(x/10);
