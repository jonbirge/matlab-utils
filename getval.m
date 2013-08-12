function val = getval(tag)
%GETVAL  Retrieve numeric value associated with GUI object given its tag.
%  This returns the number in the 'Value' property, if present,
%  or converts the 'String' property into a number, in the case of an
%  Edit or Text box. In the latter case, if the string cannot be converted
%  this function just passes along the NaN given by str2double.

handle = findobj(gcbf, 'Tag', tag);
style = get(handle, 'Style');
if (strcmp(style, 'edit') || strcmp(style, 'text'))
   val = str2double(get(handle, 'String'));
else
   val = get(handle, 'Value');
end
