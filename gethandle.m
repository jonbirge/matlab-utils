function hdl = gethandle(tag)
%GETHANDLE  Retrieve handles of objects given a tag name.
%  Will retrieve a list of handles given a cell array of tags.

if iscell(tag)
   hdl = zeros(1, length(tag));
   parfor i = 1:length(tag),
      hdl(i) = findobj(gcbf, 'Tag', tag{i});
   end
else
   hdl = findobj(gcbf, 'Tag', tag);
end
