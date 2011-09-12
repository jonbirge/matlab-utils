function nedit(k)
%NEDIT Open nth file

if ischar(k)
  k = str2double(k);
end

% Get directory list from OS.
ds = dir(pwd);
n = length(ds);

% Cull files.
hitlist = true(1,n);
for i = 1:n,
  d = ds(k);
  namestr = d.name;
  if strcmp(namestr,'.') || strcmp(namestr,'..')
    hitlist(i) = false;
  elseif namestr(1) == '.'
    hitlist(i) = false;
  elseif (strcmp(namestr(max(end-3,1):end),'.asv') || strcmp(namestr(end), '~'))
    hitlist(i) = false;
  end
end
ds = ds(hitlist);

filename = ds(k).name;
open(filename);

end

