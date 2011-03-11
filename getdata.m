function data = getdata(tag, prop)
handle = findobj(gcbf, 'Tag', tag);
data = get(handle, prop);
