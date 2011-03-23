function svndumpoblit(exsuff, filein, fileout)

% Input handling.
if nargin < 1 || isempty(exsuff)
  exsuff = {'\.mexw32', '\.mexglx', '\.mexmac', '\.mexmaci64', '\.mexa64', 'mex\.dll'};
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

% Build regular expression.
if iscell(exsuff)
  testregexp = [exsuff{1} '$'];
  for k = 2:length(exsuff)
    testregexp = [testregexp '|' exsuff{k}];
  end
else
  testregexp = exsuff;
end

% Setup tokens.
revtoken = 'Revision-number:';
nodetoken = 'Node-path:';
contoken = 'Content-length';
revtoklen = length(revtoken);
nodetoklen = length(nodetoken);
contoklen = length(contoken);

% Open files.
fin = fopen([pathin fnamein]);
fout = fopen([pathout fnameout], 'w');

% Cycle through file.
saved = 0;
nodes = 0;
copyflag = true;  %#ok<*NASGU> % copy while true
changeflag = false;
contlen = 0;
if fin ~= -1
  dline = fgets(fin);
  while ischar(dline)
    % Limited parsing.
    if strncmp(dline, revtoken, revtoklen)
      rev = str2double(dline(revtoklen+2:end-1));
      fprintf('Revision: %d\n', rev);
      copyflag = true;
    elseif strncmp(dline, nodetoken, nodetoklen)  % test for node
      if isempty(regexp(dline, testregexp, 'once'))  % test for file
        copyflag = true;
      else
        fprintf('%s...\n', dline(nodetoklen+2:end-1));
        copyflag = false;
      end
    elseif strncmp(dline, contoken, contoklen)
      contlen = str2double(dline(contoklen+2:end-1));  % bytes
    end
    
    % Copy parsed line through?
    if copyflag
      fwrite(fout, dline, 'char');
    end
    
    % Fast forward?
    if contlen > 0
      if copyflag
        block = fread(fin, contlen, 'char');
        fwrite(fout, block, 'char');
      else
        saved = saved + ceil(contlen/1000);
        nodes = nodes + 1;
        fseek(fin, contlen, 'cof');
      end
      contlen = 0;
    end
    
    % Read in next line.
    dline = fgets(fin);
  end  % read while loop
  
  fclose(fin);
  fclose(fout);
  
  fprintf('Saved %d kB over %d nodes\n', saved, nodes)
end  % if file opened

end  % main function

