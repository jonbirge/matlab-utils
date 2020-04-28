function gitlog
%GITST Trivial function to get git status
%  Obtains the status and information about the current directory from the
%  system git command. Useful only in that it lets you check git status
%  without having to go to a terminal. Only works on Linux or Mac OS X.

[status, result] = systemwpath('git --no-pager log --graph --oneline --decorate --all | head -n 16');

if status == 0
  disp(result)
else
  error('gitlog:git', result)
end

end
