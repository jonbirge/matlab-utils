function setval(tag, val)
handle = findobj(gcbf, 'Tag', tag);
style = get(handle, 'Style');
if (strcmp(style, 'edit') | strcmp(style, 'text'))
   set(handle, 'String', num2str(val));
else
   set(handle, 'Value', val);
end
