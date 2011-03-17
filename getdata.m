function data = getdata(tag, prop)
%GETDATA Retrieve property from GUI given a tag name.
%  This function is mean to be called from a callback, as it uses gcbf.

handle = findobj(gcbf, 'Tag', tag);
data = get(handle, prop);
