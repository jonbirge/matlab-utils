function sizestr = makesizestr(thesize)
%MAKESIZESTR Format size string in human-readable form.
%  Returns a string given a number, thesize, expressed in kB.

if thesize/1000 > 1
  sizestr = [num2str(floor(thesize/100)/10) 'M'];
else
  sizestr = [num2str(floor(thesize)) 'k'];
end

end

