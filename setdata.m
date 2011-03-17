function setdata(tag, prop, data)
%SETDATA Set property of a handle object given its tag.

if iscell(tag)
   for i = 1:length(tag),
      handle = findobj(gcbf, 'Tag', tag{i});
      set(handle, prop, data);
   end
else
   handle = findobj(gcbf, 'Tag', tag);
   set(handle, prop, data);
end