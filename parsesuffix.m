function [suffix, filebase] = parsesuffix(filename)
%PARSESUFFIX  Get suffix from file name string

dotks = find(filename == '.');
if ~isempty(dotks)
  suffix = filename(dotks(end)+1:end);
else
  suffix = [];
  dotks = length(filename) + 1;
end

if nargout > 1
  filebase = filename(1:dotks(end)-1);
end