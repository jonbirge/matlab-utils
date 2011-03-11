function str = getstr(tag)
handle = findobj(gcbf, 'Tag', tag);
str = get(handle, 'String');
