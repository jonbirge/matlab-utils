function svndumpoblit(exsuff, filein, fileout)

% Need to handle Node-action: change properly.

% Should we use maximize size blocks during fast copy?


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

if iscell(exsuff)
  testregexp = [exsuff{1} '$'];
  for k = 2:length(exsuff)
    testregexp = [testregexp '|' exsuff{k}];
  end
else
  testregexp = exsuff;
end

revtoken = 'Revision-number:';
nodetoken = 'Node-path:';
sizetoken = 'Text-content-length:';
actiontoken = 'Node-action:';
contoken = 'Content-length';
revtoklen = length(revtoken);
nodetoklen = length(nodetoken);
sizetoklen = length(sizetoken);
actiontoklen = length(actiontoken);
contoklen = length(contoken);

fin = fopen([pathin fnamein]);
fout = fopen([pathout fnameout], 'w');

copyflag = true;  %#ok<*NASGU> % copy while true
changeflag = false;
contlen = 0;
if fin ~= -1
  dline = fgets(fin);
  while ischar(dline)
    if strncmp(dline, revtoken, revtoklen)
      copyflag = true;
      rev = str2double(dline(revtoklen+1:end));
      fprintf('Revision: %d\n', rev);
    elseif strncmp(dline, nodetoken, nodetoklen)  % test for node
      if isempty(regexp(dline, testregexp, 'once'))  % test for file
        copyflag = true;
      else
        fprintf('obliterating %s... ', dline(nodetoklen+2:end-1));
        copyflag = false;
      end
    elseif strncmp(dline, actiontoken, actiontoklen)
      if strcmp(dline, 'Node-action: change')
        changeflag = true;
      else
        changeflat = false;
      end
    elseif strncmp(dline, sizetoken, sizetoklen)
      contlen = str2double(dline(sizetoklen+1:end));
    end
    
    if copyflag
      fprintf(fout, '%s', dline);
    end

    if contlen > 0 && strncmp(dline, contoken, contoklen)  % handle content
      if changeflag
        contlen = contlen + 11;  % include PROPS-END and EOL
      else
        contlen = contlen + 1;  % just EOL
      end
      if copyflag
        copynbytes(fin, fout, contlen)
      else
        fprintf('saved %d kB\n', ceil(contlen/1000));
        fseek(fin, contlen, 'cof');
      end
      contlen = 0;
    end
    
    dline = fgets(fin);
  end
  
  fclose(fin);
  fclose(fout);
end


function copynbytes(fin, fout, n)
block = fread(fin, n, 'char');
fwrite(fout, block, 'char');
