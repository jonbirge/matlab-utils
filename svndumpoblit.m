function svndumpoblit(exsuff, filein, fileout)

if nargin < 1 || isempty(exsuff)
  exsuff = {'\.mexw32', '\.mexglx', '\.mexmac', '\.mexmaci64', '\.mexa64', '\.pdf'};
end

if nargin < 2
  [fnamein, pathin] = uigetfile('*', 'Pick a dump file');
  [fnameout, pathout] = uiputfile('*.dump', 'Select output file');
else
  pathin = '';
  pathout = '';
  fnamein = filein;
  fnameout = fileout;
end

if iscell(exsuff)
  testregexp = [exsuff{1} '$'];
  for k = 2:length(exsuff)
    testregexp = [testregexp '|' exsuff{k} '$'];
  end
else
  testregexp = [exsuff '$'];
end

fin = fopen([pathin fnamein]);
fout = fopen([pathout fnameout], 'w');

copyflag = true;  % copy while true
if fin ~= -1
  dline = fgets(fin);
  while ischar(dline)
    if strncmp(dline, 'Revision-number:', 16)
      copyflag = true;
      rev = str2double(dline(17:end));
      fprintf('Revision: %d\n', rev);
    elseif strncmp(dline, 'Node-path:', 10)  % quick test for add
      if ~isempty(regexp(dline, testregexp, 'once'))  % test for file
        copyflag = false;
      else
        copyflag = true;
      end
    end
    if copyflag
      fprintf(fout, '%s', dline);
    end
    dline = fgets(fin);
  end
  fclose(fin);
  fclose(fout);
end
