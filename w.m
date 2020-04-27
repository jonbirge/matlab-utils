function vartabout = w()
%W Print workspace information as a table
%  The main difference between this and the standard whos command is that
%  this returns the variables as a MATLAB table object.

vars = evalin('caller', 'whos()');
n = length(vars);
NameC = cell(n, 1);
SizeC = cell(n, 1);
MemC = cell(n, 1);
ClassC = cell(n, 1);
for k = 1:n
  v = vars(k);
  NameC{k} = v.name;
  SizeC{k} = [num2str(v.size(1)) ' x ' num2str(v.size(2))];
  MemC{k} = makesizestr(ceil(v.bytes/1024));
  ClassC{k} = v.class;
end
Size = categorical(SizeC);
Mem = categorical(MemC);
Class = categorical(ClassC);

vartab = table(Size, Mem, Class, 'RowNames', NameC);

if nargout == 0
  disp(vartab)
  fprintf('\n')
else
  vartabout = vartab;
end
