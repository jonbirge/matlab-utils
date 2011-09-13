function gitst
%GITST Trivial function to get git status
%  Obtains the status and information about the current directory from the
%  system git command. Useful only in that it lets you check git status
%  without having to go to a terminal.

[status, result] = system('git status');
if status == 0
  fprintf('git status:\n')
  fprintf(result)
else
  error('gitst:git', 'git command not found in system')
end

end
