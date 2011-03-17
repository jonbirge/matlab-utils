function sn(varargin)
%SN Show notes in director of M files.
%  Searches each .M file in the current directory, and an optional
%  number of subdirectories recursively, and displays each comment that is
%  preceded by the words TODO: or FIX:, with the colon neccesary. This is
%  to facilitate the use of notes within source files themselves.


% Hard coded settings.
depthlimit = 1;  % how far to recurse directories

% Input handling.
if nargin == 0
  files = {'.'};
else
  files = varargin;
end

% Scan directories and print found lines.
for k = 1:length(files)
  dirscan(files{k}, 'm', depthlimit)
end
fprintf('\n')

end


%%% Get suffix from file name string.
function suffix = parsesuffix(filename)
dotks = find(filename == '.');
if ~isempty(dotks)
  suffix = filename(dotks(end)+1:end);
else
  suffix = [];
end
end

%%% Comment listing subroutine.
function mcommentparse(filename)
printedheader = false;
lineno = 1;
f = fopen(filename);
if f ~= -1
  mline = fgets(f);
  while ischar(mline)
    match =  regexp(mline, '\%.*(TODO:[^\n^\r]*)', 'tokens', 'once');
    if ~isempty(match)
      if ~printedheader
        fprintf('\n%s:\n', filename)
        printedheader = true;
      end
      fprintf('%d: %s\n', lineno, match{1})
    end
    mline = fgets(f);
    lineno = lineno + 1;
  end
  fclose(f);
end
end

%%% Recursive directory listing subroutine.
function dirscan(dirname, suffix, depthlimit, level)
if nargin < 4
  level = 0;
end
if (level <= depthlimit) && (dirname(end) ~= '.' || level == 0)
  ds = dir(dirname);
  if length(ds) == 1 && strcmp(ds.name, dirname)
    dirname = '.';
  end
  for k = 1:length(ds),
    d = ds(k);
    if d.isdir
      dirscan([dirname '/' d.name], suffix, depthlimit, level + 1);
    elseif strcmp(parsesuffix(d.name), 'm')
      if strcmp(dirname, '.')
        filename = d.name;
      else
        filename = [dirname '/' d.name];
      end
      mcommentparse(filename)
    end
  end
end
end
