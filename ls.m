function ls(files, showi)
%LS list directory with formatting.
%  ls returns a directory listing in the current directory, or in an
%  optional path given. The output is sorted into columns, ASV files are
%  supressed, and common MATLAB file types are highlighten. In addition M
%  files are entered and displayed with a different symbol depending on
%  whether it be object, function, or script. A summary shows the total
%  size of the contents, including a sum of the MATLAB code lines
%  contained in the directory tree.
%
%  See also CD, DIR, WHAT, TYPE.


% Hard coded settings.
ncols = 3;
maxlen = 28;
colwidth = 90;
marginstr = ' ';
fillstr = '.';  % MUST be only one character
contstr = '__';
hidedots = true;
hideasv = true;
summary = false;
countdir = true;  % count directory size
depthlimit = 1;  % how far to recurse directories

% Input handling.
if nargin == 0
  files = '.';
end
if nargin < 2
  showi = false;
end

% Variable init.
sizesum = 0;
filecount = 0;
dircount = 0;
contlen = length(contstr);

% Display directory first.
cdir = pwd;
if length(cdir) > colwidth;
    slashes = find((cdir == '\') | (cdir == '/'));
    wd = cdir(slashes(end-1):end);
    head = cdir(1:slashes(3));
    cdir = [head '...' wd];
end
if ~strcmp(files, '.')
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
for k = 1:n,
  d = ds(k);
  namestr = d.name;
  if strcmp(namestr,'.') || strcmp(namestr,'..')
    hitlist(k) = 0;
  elseif hidedots && namestr(1) == '.'
    hitlist(k) = 0;
  elseif hideasv && ...
      (strcmp(namestr(max(end-3,1):end),'.asv') || strcmp(namestr(end), '~'))
    hitlist(k) = 0;
  end
end
n = sum(hitlist);
hitks = find(hitlist);

%%% Make individual strings by type and decide sorting.
%nameline = char(zeros(n, maxlen));
nameline = cell(1,n);
types = zeros(n,1);  % sorting priority
for k = 1:n,
  d = ds(hitks(k));
  filestr = d.name;
  
  % Decide on symbol and sorting to use.
  dolink = false; %#ok<*NASGU>
  if d.isdir
    types(k) = -1000;
    dirsym = '/';
    namestr = filestr;
  else
    typestr = parsesuffix(filestr);
    if ~isempty(typestr)
      dolink = true;
      typelen = length(typestr);
      switch typestr
        case 'm',
          f = fopen(filestr);
          mline = fgets(f);
          firstline = mline;
          fclose(f);
          if strfind(firstline, 'classdef')
            types(k) = 99;
            dirsym = '@';
          elseif strfind(firstline, 'function')
            types(k) = 95;     
            dirsym = '*';
          else
            types(k) = 90;
            dirsym = '$';
          end
        case 'mat',
          types(k) = 80;
          dirsym = '#';
        case 'fig',
          types(k) = 70;
          dirsym = '+';
        case 'mdl',
          types(k) = 60;
          dirsym = '&';
        otherwise,
          dolink = false;
          types(k) = -int8(typestr(1));
          dirsym = ['.' typestr];
      end
      namestr = filestr(1:end-typelen-1);
    else
      dirsym = '';
      namestr = filestr;
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
    if strcmp(typestr, 'm')  % m file
      lcount = countmlines(filestr);
      sizestr = [num2str(lcount) 'L '];
    else
      sizestr = [makesizestr(filesize) ' '];
    end
  end
  sizesum = sizesum + filesize;
  
  % Build lines and add links.
  sizelen = length(sizestr);
  if dolink
    opentag = ['<a href="matlab:open ' filestr '">'];
    closetag = '</a>';
  else
    opentag = '';
    closetag = '';
  end
  if showi
    countstr = [num2str(k) ' '];
    countlen = length(countstr);
  else
    countstr = '';
    countlen = 0;
  end
	if (namelen + sizelen) > (maxlen - 1),  % filename too big
		nameline{k} = [countstr opentag ...
      namestr(1:max(maxlen-countlen-sizelen-symlen-contlen-1,1)) ...
      closetag contstr dirsym ' ' sizestr];
  else  % filename fits
		nameline{k} = [countstr opentag namestr closetag dirsym ...
      repmat(fillstr, 1, maxlen-countlen-sizelen-namelen) sizestr];
  end
end  % for each individual file string

% Sort.
[~, p] = sort(-types);
nameline = nameline(p);

% Output into columns.
nrows = ceil(n/ncols);
npad = nrows*ncols - n;
blankpad = {repmat(' ', 1, size(nameline, 2))};
nameline = [nameline repmat(blankpad, 1, npad)];  % ensure we have enough
for k = 1:nrows,
  for m = 1:(ncols - 1),
    fprintf(nameline{k + (m-1)*nrows})
    fprintf(marginstr);
  end
  fprintf(nameline{k + (ncols-1)*nrows});
  fprintf('\n')
end

% Write summary.
if summary
  [mlinecount, mfilecount] = msize('.', 2);
  sumstr = sprintf('mfiles: %d lines in %d files', ...
    mlinecount, mfilecount);
  fprintf([repmat(' ', 1, colwidth - 5 - length(sumstr)) '[' sumstr ']\n'])
  
  sumstr = sprintf([makesizestr(sizesum) ' in %d files, %d dirs'], ...
    filecount, dircount);
  fprintf([repmat(' ', 1, colwidth - 5 - length(sumstr)) '[' sumstr ']\n'])
  
  % Output SVN status, if available.
  if ~isempty(dir('.svn'))
    [stat, res] = system('svn info');
    if stat == 0
      s = regexp(res, 'URL: (\S*)\n', 'tokens', 'once');
      fprintf('svn url:\n')
      fprintf(s{1})
      fprintf('\n')
    end
    [stat, res] = system('svn status --ignore-externals');
    if stat == 0
      fprintf('svn status:\n')
      fprintf(res)
    end
  end
else
  fprintf('\n')
end

%%% Recursive directory size subroutine. Should be replaced (along with the
%%% above) with a single routine that travels the whole tree and is given a
%%% functional to apply to each file, which is then summed. Sort of a
%%% directory summary function that acts recursively.
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
