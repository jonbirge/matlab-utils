 x = randn(1, 10000);
 y = x + randn(1, 10000);
 
 figure(1)
 histogram2(x, y, 31)
 
 figure(2)
 hist2d(x, y, 31)
 