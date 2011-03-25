function svnst
%SVNSTAT Trivial function to get simple svn info
%  Obtains the status and information about the current directory from the
%  system svn command.

[status, result] = system('svn info');
if status == 0
  fprintf('svn info:\n')
  fprintf(result)
else
  error('svnst:svn', 'svn command not found in system')
end

[status, result] = system('svn status');
if status == 0
  bls = regexp(result, '\n\n');
  result(bls) = [];  % remove annoying blank lines that svn always puts in
  fprintf('svn status:\n')
  fprintf(result)
end

end

