function ls(files)
%LS list directory
%   ls returns a directory listing in the current directory, or in an
%   optional path given. The output is sorted into columns, ASV files are
%   supressed, and common MATLAB file types are highlighten. In addition M
%   files are entered and displayed with a different symbol depending on
%   whether it be object, function, or script. A summary shows the total
%   size of the contents, including a sum of the MATLAB code lines
%   contained in the directory tree.
%
%   See also CD, DIR, WHAT, TYPE.

% TODO: Maybe the columns should have headings showing the type before each
% group.
% Include summary count of MATLAB code lines in the directory and
% subdirectories by just keeping a list of all M-files during the directory
% tree recurse. Then we can just scan through it linearly. Use a recursive
% subfunction which writes to a variable in the top level function.

% Hard coded settings.
ncols = 3;
maxlen = 26;
colwidth = 80;
marginstr = ' ';
fillstr = '.';  % MUST be only one character
contstr = '__';
hidedots = true;
hideasv = true;
summary = true;
countdir = true;  % count directory size
depthlimit = 2;  % how far to recurse directories


% Input handling.
if nargin == 0
  files = '.';
end

% Variable init.
sizesum = 0;
filecount = 0;
dircount = 0;
contlen = length(contstr);

% Display directory first.
cdir = pwd;
if length(cdir) > colwidth;
    slashes = find((cdir == '\') | (cdir == '/'));  % should also check other separators?
    wd = cdir(slashes(end-1):end);
    head = cdir(1:slashes(3));
    cdir = [head '...' wd];
end
if (nargin)
  fprintf('\n%s\n', [cdir '/' files])
else
  fprintf('\n%s\n', cdir)
end
linestr = repmat('=', 1, maxlen*ncols + length(marginstr)*(ncols-1));
fprintf([linestr '\n'])

% Get directory list from OS.
ds = dir(files);
n = length(ds);

% Cull files.
hitlist = ones(1,n);
parfor k = 1:n,
  d = ds(k);
  namestr = d.name;
  if strcmp(namestr,'.') || strcmp(namestr,'..')
    hitlist(k) = 0;
  elseif hidedots && namestr(1) == '.'
    hitlist(k) = 0;
  elseif hideasv && strcmp(namestr(max(end-3,1):end),'.asv')
    hitlist(k) = 0;
  end
end
n = sum(hitlist);
hitks = find(hitlist);

%%% Make individual strings by type and decide sorting.
nameline = char(zeros(n, maxlen));
types = zeros(n,1);  % sorting priority
for k = 1:n,
  d = ds(hitks(k));
  namestr = d.name;
  
  % Decide on symbol and sorting to use.
  if d.isdir
    types(k) = -1000;
    dirsym = '/';
  else
    typestr = parsesuffix(namestr);
    if ~isempty(typestr)
      typelen = length(typestr);
      switch typestr
        case 'm',
          f = fopen(namestr);
          mline = fgets(f);
          firstline = mline;
          fclose(f);
          if strfind(firstline, 'classdef')
            types(k) = 99;
            dirsym = '@';
          elseif strfind(firstline, 'function')
            types(k) = 95;     
            dirsym = '()';
          else
            types(k) = 90;
            dirsym = '$';
          end
        case 'mat',
          types(k) = 80;
          dirsym = '+';
        case 'fig',
          types(k) = 70;
          dirsym = '#';
        otherwise,
          types(k) = -int8(typestr(1));
          dirsym = ['.' typestr];
      end
      namestr = namestr(1:end-typelen-1);
    else
      dirsym = '';
    end
  end
  symlen = length(dirsym);
  namelen = length(namestr) + symlen;
  
  % Compute file size.
  if d.isdir
    dircount = dircount + 1;
    if countdir
      filesize = dirsize(namestr, depthlimit);
      sizestr = ['(' makesizestr(filesize) ')'];
    else
      filesize = 0; %#ok<*UNRCH>
      sizestr = '-- ';
    end
  else
    filecount = filecount + 1;
    filesize = ceil(d.bytes/1024);
    sizestr = [makesizestr(filesize) ' '];
  end
  sizesum = sizesum + filesize;
  
  % Build lines.
  sizelen = length(sizestr);
	if (namelen + sizelen) > (maxlen - 1),
		nameline(k,:) = [namestr(1:max(maxlen-sizelen-symlen-1-contlen,1)) ...
      contstr dirsym ' ' sizestr];
	else
		nameline(k,:) = [namestr dirsym ...
      repmat(fillstr, 1, maxlen-sizelen-namelen) sizestr];
  end
end  % for each individual file string

% Sort.
[tmp, p] = sort(-types); %#ok<ASGLU>
nameline = nameline(p,:);

% Output into columns.
nrows = ceil(n/ncols);
npad = nrows*ncols - n;
nameline = [nameline; repmat(' ', npad, size(nameline, 2))];
for k = 1:nrows,
  for m = 1:(ncols - 1),
    fprintf(nameline(k + (m-1)*nrows,:))
    fprintf(marginstr);
  end
  fprintf(nameline(k + (ncols-1)*nrows,:));
  fprintf('\n')
end

% Write summary.
if summary
  [mlinecount, mfilecount] = msize('.', 2);
  sumstr = sprintf('mfiles: %d lines in %d files', ...
    mlinecount, mfilecount);
  fprintf([repmat(' ', 1, 78 - length(sumstr)) '[' sumstr ']\n'])
  
  sumstr = sprintf([makesizestr(sizesum) ' in %d files, %d dirs'], ...
    filecount, dircount);
  fprintf([repmat(' ', 1, 78 - length(sumstr)) '[' sumstr ']\n'])
end


%%% Get suffix from file name string.
function suffix = parsesuffix(filename)
dotks = find(filename == '.');
if ~isempty(dotks)
  suffix = filename(dotks(end)+1:end);
else
  suffix = [];
end

%%% Recursive m-file size subroutine.
function [mlinesout, mfilesout] = msize(dirname, depthlimit, level)
if nargin < 3
  level = 0;
end
mlines = 0;
mfiles = 0;
if (level <= depthlimit) && (dirname(end) ~= '.' || level == 0)
  ds = dir(dirname);
  parfor k = 1:length(ds),
    d = ds(k);
    filename = d.name;
    if d.isdir
      [mlinesdir, mfilesdir] = ...
        msize([dirname '/' filename], depthlimit, level + 1);
      mlines = mlines + mlinesdir;
      mfiles = mfiles + mfilesdir;
    else
      typestr = parsesuffix(d.name);
      if typestr == 'm'
        mfiles = mfiles + 1;
        f = fopen([dirname '/' filename]);
        mline = fgets(f);
        while ischar(mline)
          if ~isempty(regexp(mline, '\w+', 'once'))
            mlines = mlines + 1;
          end
          mline = fgets(f);
        end
        fclose(f);
      end
    end
  end
end
mfilesout = mfiles;
mlinesout = mlines;

%%% Recursive directory size subroutine.
function sout = dirsize(dirname, depthlimit, level)
if nargin < 3
  level = 0;
end
s = 0;
if (level <= depthlimit) && (dirname(end) ~= '.')
  ds = dir(dirname);
  parfor k = 1:length(ds),
    d = ds(k);
    if d.isdir
      sdir = dirsize([dirname '\' d.name], depthlimit, level + 1);
      s = s + sdir;
    else
      s = s + d.bytes;
    end
  end
  s = ceil(s/1024);
end
sout = s;

%%% Make size string from size in kB.
function sizestr = makesizestr(thesize)
if thesize/1000 > 1
  sizestr = [num2str(floor(thesize/100)/10) 'M'];
else
  sizestr = [num2str(floor(thesize)) 'k'];
end
