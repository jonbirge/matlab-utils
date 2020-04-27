function w()
%W Print workspace information as a table

vars = evalin('caller', 'whos()');
n = length(vars);
fprintf('name\t\t size\t mem\t class\n\n');
for k = 1:n
  v = vars(k);
  fprintf('%s\t %d x %d\t %s\t %s\n', v.name, ...
    v.size(1), v.size(2), makesizestr(v.bytes/1024), v.class);
end
