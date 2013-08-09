function [status, result] = systemwpath(command)
%SYSTEMWPATH Execute system shell command with common paths set
% This command is used to solve a bug on the Mac where the system command
% doesn't use the user's environment variables. Thus, many commands are not
% available to the MATLAB version of the system() command.

fullcommand = ['PATH=/opt/local/bin:/usr/local/bin:$PATH && ' command];
[status, result] = system(fullcommand);

end

