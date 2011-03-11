function val = getval(tag)
handle = findobj(gcbf, 'Tag', tag);
style = get(handle, 'Style');
if (strcmp(style, 'edit') || strcmp(style, 'text'))
   val = str2double(get(handle, 'String'));
else
   val = get(handle, 'Value');
end
