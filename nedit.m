function nedit(k)
%NEDIT Open nth file

if ischar(k)
  k = str2double(k);
end

filelist = ls();
open(filelist{k});

end
