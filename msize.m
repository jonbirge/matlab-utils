function [mlinesout, mfilesout] = msize(dirname, depthlimit, level)
%MSIZE  Recursive m-file line counting subroutine

if nargin < 3
  level = 0;
end

mlines = 0;
mfiles = 0;
if (level <= depthlimit) && (dirname(end) ~= '.' || level == 0)
  ds = dir(dirname);
  for k = 1:length(ds),
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
        mlines = mlines + countmlines([dirname '/' filename]);
        mfiles = mfiles + 1;
      end
    end
  end
end

mfilesout = mfiles;
mlinesout = mlines;