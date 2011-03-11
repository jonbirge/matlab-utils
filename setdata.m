function setdata(tag, prop, data)
if iscell(tag)
   for i = 1:length(tag),
      handle = findobj(gcbf, 'Tag', tag{i});
      set(handle, prop, data);
   end
else
   handle = findobj(gcbf, 'Tag', tag);
   set(handle, prop, data);
end