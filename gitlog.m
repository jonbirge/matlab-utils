function gitlog
%GITST Trivial function to get git status
%  Obtains the status and information about the current directory from the
%  system git command. Useful only in that it lets you check git status
%  without having to go to a terminal.

[status, result] = systemwpath('git log --graph --oneline --decorate --all');
if status == 0
  fprintf('git log:\n')
  fprintf(result)
else
  error('gitlog:git', result)
end

end
