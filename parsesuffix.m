function suffix = parsesuffix(filename)
%PARSESUFFIX  Get suffix from file name string

dotks = find(filename == '.');
if ~isempty(dotks)
  suffix = filename(dotks(end)+1:end);
else
  suffix = [];
end