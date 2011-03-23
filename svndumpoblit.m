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
sizetoken = 'Text-content-length:';
changetoken = 'Node-action: change';
contoken = 'Content-length';
proptoken = 'PROPS-END';
revtoklen = length(revtoken);
nodetoklen = length(nodetoken);
sizetoklen = length(sizetoken);
changetoklen = length(changetoken);
contoklen = length(contoken);
proptoklen = length(proptoken);

% Open files.
fin = fopen([pathin fnamein]);
fout = fopen([pathout fnameout], 'w');

% Cycle through file.
saved = 0;
copyflag = true;  %#ok<*NASGU> % copy while true
changeflag = false;
contlen = 0;
if fin ~= -1
  dline = fgets(fin);
  while ischar(dline)
    % Limited parsing.
    if strncmp(dline, revtoken, revtoklen)
      rev = str2double(dline(revtoklen+1:end));
      fprintf('Revision: %d\n', rev);
      copyflag = true;
    elseif strncmp(dline, nodetoken, nodetoklen)  % test for node
      changeflag = false;
      if isempty(regexp(dline, testregexp, 'once'))  % test for file
        copyflag = true;
      else
        fprintf('%s...\n', dline(nodetoklen+2:end-1));
        copyflag = false;
      end
    elseif strncmp(dline, changetoken, changetoklen)
        changeflag = true;
    elseif strncmp(dline, sizetoken, sizetoklen)
      contlen = str2double(dline(sizetoklen+1:end));
    end
    
    % Copy line through.
    if copyflag
      fprintf(fout, '%s', dline);  %% try fwrite for speed
    end
    
    % Fast forwards.
    if changeflag && contlen > 0 && strncmp(dline, contoken, contoklen)  % change
      contlen = contlen + 1;  % include EOL
      if copyflag
        copynbytes(fin, fout, contlen)
      else
        saved = saved + ceil(contlen/1000);
        fseek(fin, contlen, 'cof');
      end
      contlen = 0;
    elseif ~changeflag && contlen > 0 && strncmp(dline, proptoken, proptoklen)  % add/del
      if copyflag
        copynbytes(fin, fout, contlen)
      else
        saved = saved + ceil(contlen/1000);
        fseek(fin, contlen, 'cof');
      end
      contlen = 0;
    end
    
    % Read in next line.
    dline = fgets(fin);
  end  % read while loop
  
  fclose(fin);
  fclose(fout);
  
  fprintf('Saved %d kB\n', saved)
end  % if file opened

end  % main function

function copynbytes(fin, fout, n)
block = fread(fin, n, 'char');
fwrite(fout, block, 'char');
end
