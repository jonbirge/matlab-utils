function nedit(k)
%NEDIT Open nth file

if ischar(k)
  k = str2double(k);
end

filelist = ls();


filename = filelist(k);
open(filename);

end
