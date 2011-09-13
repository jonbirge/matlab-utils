function gitcom(logstr)
%GITCOM Commit all changes in current MATLAB directory to git
%  This prompts the user for a log string (also giving the option to abort)
%  and then commits all changes in the working directory to git.

if nargin == 0
  logstr = input('enter log message: ', 's');
end

if length(logstr) > 1
  gitcmd = ['git commit -a -m "' logstr '"'];
  fprintf('running command: %s\n', gitcmd);
  [status, result] = systemwpath(gitcmd);
  if status == 0
    fprintf('git commit:\n')
    fprintf(result)
  else
    error('gitcom:git', result)
  end
else
  fprintf('git commit aborted!\n');
end

end
