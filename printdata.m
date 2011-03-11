function printdata(M, headers)

% Settings
stops = 10;

% Preparation
headerline = headers{1};
for k = 2:length(headers)
  spaces = repmat(' ', 1, stops*(k-1) - length(headerline));
  headerline = [headerline spaces headers{k}]; %#ok<AGROW>
end
headlen = length(headerline);
doubleline = repmat('=', 1, headlen);
singleline = repmat('-', 1, headlen);
if sum(chop(M(:,1) - round(M(:,1)), 8)) == 0
  intx = true;
else
  intx = false;
end

% Output header
fprintf('\n%s\n', doubleline)
fprintf('%s\n', headerline)
fprintf('%s\n', singleline)

% Output data
for m = 1:size(M, 1)
  if intx
    linestr = sprintf('%d', M(m,1));
  else
    linestr = sprintf('%f', M(m,1));
  end
  for k = 2:length(headers)
    spaces = repmat(' ', 1, stops*(k-1) - length(linestr));
    linestr = [linestr spaces sprintf('%f', M(m, k))]; %#ok<AGROW>
  end
  fprintf('%s\n', linestr)
end
  
% Output trailer
fprintf('%s\n\n', doubleline)
