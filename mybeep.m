function mybeep(d)
%MYBEEP Make a sound
%   MYBEEP(d) plays a tone for d seconds. If d is not specified, a short
%   sound will be played.
%
%   See also SOUND

fs = 8192/1.5;

if nargin < 1
  ns = 2048;
else
  ns = 8192*d;
end

wnd = sin(linspace(0, pi, ns)).^2;
snd = wnd.*((sin(1/2*(1:ns)) + sin(1/3*(1:ns))).^2)/5;

sound(snd, fs)
