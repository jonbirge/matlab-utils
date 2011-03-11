function mybeep(d)

fs = 8192;
if nargin < 1
  d = 2048;
end
wnd = window(@gausswin, d).';
snd = wnd.*(sin(1/2*(1:d)) + sin(1/3*(1:d)))/2;
sound(snd, fs)
