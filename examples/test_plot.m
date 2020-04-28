% test plotting routines on a 2D plot with weird limits

Time = linspace(0, 1.12, 256);
Signal = sin(4*pi*Time.^2)*0.94;

figure(1)
plot(Time, Signal)

figure(2)
myplot Time Signal
