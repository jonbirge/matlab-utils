% test plotting routines on a 2D plot with weird limits

t = linspace(0, 1.12, 256);
y = sin(4*pi*t.^2)*0.94;

figure(1)
plot(t, y)

figure(2)
myplot t y
