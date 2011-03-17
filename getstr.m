function str = getstr(tag)
%GETSTR Retrieve string of edit box object given its tag.

handle = findobj(gcbf, 'Tag', tag);
str = get(handle, 'String');
