function filelist = ls(files, showi)
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


%%% Hard coded settings.
ncols = 3;
maxlen = 32;
colwidth = ncols*maxlen;
marginstr = '  ';
fillstr = '.';  % MUST be only one character or an escape sequence
contstr = ':';
hidedots = true;
hideasv = true;
summary = true;
countdir = true;  % count directory size
depthlimit = 1;  % how far to recurse directories
showvc = false;

%%% Input handling.
if nargin == 0
  files = '.';
end
if nargin < 2
  showi = false;
end
if nargout > 0
  printq = false;
else
  printq = true;
end

%%% Variable init.
sizesum = 0;
filecount = 0;
dircount = 0;
contlen = length(contstr);

%%% Display directory first.
cdir = pwd;
if length(cdir) > colwidth;
  slashes = find((cdir == '\') | (cdir == '/'));
  wd = cdir(slashes(end-1):end);
  head = cdir(1:slashes(3));
  cdir = [head '...' wd];
end
if printq
  if ~strcmp(files, '.')
    fprintf('\n%s\n', [cdir '/' files])
  else
    fprintf('\n%s\n', cdir)
  end
  linestr = repmat('-', 1, maxlen*ncols + length(marginstr)*(ncols-1));
  fprintf([linestr '\n'])
end

%%% Get directory list from OS.
ds = dir(files);
n = length(ds);

%%% Cull files.
hitlist = true(1,n);
for krow = 1:n,
  d = ds(krow);
  namestr = d.name;
  if strcmp(namestr,'.')
    hitlist(krow) = false;
  elseif hidedots && namestr(1) == '.' && ~strcmp(namestr, '..')
    hitlist(krow) = false;
  elseif hideasv && ...
      (strcmp(namestr(max(end-3,1):end),'.asv') || strcmp(namestr(end), '~'))
    hitlist(krow) = false;
  end
end
n = sum(hitlist);
ds = ds(hitlist);

%%% Check type and do type relevent processing.
filenames = cell(1,n);
namestrs = cell(1,n);
typestrs = cell(1,n);
sizestrs = cell(1,n);
isdir = false(n,1);
dolink = false(n,1);
typeindex = zeros(n,1);  % sorting priority
for k = 1:n,
  d = ds(k);
  filestr = d.name;
  
  % Decide on symbol and sorting to use.
  if d.isdir
    typeindex(k) = -1000;
    dirsym = '/';
    namestr = filestr;
    isdir(k) = true;
    dolink(k) = true;
  else
    typestr = parsesuffix(filestr);
    if ~isempty(typestr)
      dolink(k) = true;
      typelen = length(typestr);
      switch typestr
        case 'm',
          f = fopen(filestr);
          mline = fgets(f);
          firstline = mline;
          fclose(f);
          if strfind(firstline, 'classdef')
            typeindex(k) = 99;
            dirsym = '@';
          elseif strfind(firstline, 'function')
            typeindex(k) = 95;
            dirsym = '*';
          else
            typeindex(k) = 90;
            dirsym = '$';
          end
        case 'mat',
          typeindex(k) = 80;
          dirsym = '#';
        case 'fig',
          typeindex(k) = 70;
          dirsym = '+';
        case 'mdl',
          typeindex(k) = 60;
          dirsym = '&';
        otherwise,
          dolink(k) = false;
          typeindex(k) = -int8(typestr(1));
          dirsym = ['.' typestr];
      end
      namestr = filestr(1:end-typelen-1);
    else
      dirsym = '';
      namestr = filestr;
    end
  end
  typestrs{k} = dirsym;
  namestrs{k} = namestr;
  filenames{k} = filestr;

  % Compute file size.
  if d.isdir
    dircount = dircount + 1;
    if countdir
      filesize = dirsize(namestr, depthlimit);
      sizestrs{k} = ['(' makesizestr(filesize) ')'];
    else
      filesize = 0; %#ok<*UNRCH>
      sizestrs{k} = '-- ';
    end
  else
    filecount = filecount + 1;
    filesize = ceil(d.bytes/1024);
    if strcmp(typestr, 'm')  % m file
      lcount = countmlines(filestr);
      sizestrs{k} = [num2str(lcount) 'L '];
    else
      sizestrs{k} = [makesizestr(filesize) ' '];
    end
  end
  sizesum = sizesum + filesize;
end  % each file

%%% Sort by type.
[~, p] = sort(-typeindex);

%%% Output.
if printq  % write to terminal
  nrows = ceil(n/ncols);
  for krow = 1:nrows,
    for kcol = 1:ncols,
      ksort = krow + (kcol-1)*nrows;  % which sorted element we're on
      if ksort <= n
        k = p(ksort);
        namelen = length(namestrs{k});
        if showi
          countstr = [num2str(ksort) ' '];
          countlen = length(countstr);
        else
          countstr = '';
          countlen = 0;
        end
        if dolink(k)
          if isdir(k)
            opentag = ['<a href="matlab:cd ''' filenames{k} '''; ls">'];
            closetag = '</a>';
          else
            opentag = ['<a href="matlab:open ' filenames{k} '">'];
            closetag = '</a>';
          end
        else
          opentag = '';
          closetag = '';
        end
        varlen = countlen + length(sizestrs{k}) + length(typestrs{k});
        if (namelen + varlen) > (maxlen - 1),  % filename too big
          nameline = [countstr opentag ...
            namestrs{k}(1:max(maxlen-varlen-contlen-1,1)) ...
            closetag contstr typestrs{k} ' ' sizestrs{k}];
        else  % filename fits
          nameline = [countstr opentag namestrs{k} closetag typestrs{k} ...
            repmat(fillstr, 1, maxlen-varlen-namelen) sizestrs{k}];
        end
        fprintf(nameline)
        fprintf(marginstr);
      end
    end  % each column
    fprintf('\n')  % ching-zip!
  end  % each row
else  % write to variable
  filelist = filenames(p);
end

%%% Write summary information.
if printq
  if summary
    [mlinecount, mfilecount] = msize('.', 2);
    sumstr = sprintf('mfiles: %d lines in %d files', ...
      mlinecount, mfilecount);
    fprintf([repmat(' ', 1, colwidth + 2 - length(sumstr)) '[' sumstr ']\n'])
    
    sumstr = sprintf([makesizestr(sizesum) ' in %d files, %d dirs'], ...
      filecount, dircount);
    fprintf([repmat(' ', 1, colwidth + 2 - length(sumstr)) '[' sumstr ']\n'])
  else
    fprintf('\n')
  end
  
  % Output SVN status, if available.
  if ~isempty(dir('.svn')) && showvc
    svnst()
  end
  
  % Output git status, if available.
  if ~isempty(dir('.git')) && showvc
    gitst()
  end
  
end % function


%%% Recursive directory size subroutine.
% TODO: See comment in sn.m...
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
