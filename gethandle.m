function hdl = gethandle(tag)
if iscell(tag)
   parfor i = 1:length(tag),
      hdl(i) = findobj(gcbf, 'Tag', tag{i});
   end
else
   hdl = findobj(gcbf, 'Tag', tag);
end
