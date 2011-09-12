function nls(files)

if nargin == 0
  files = '.';
end

ls(files, true)
