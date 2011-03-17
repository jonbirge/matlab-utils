function y = dbtoreal(x)
%DBTOREAL Convert from decibel to linear scale.

y = 10.^(x/10);
