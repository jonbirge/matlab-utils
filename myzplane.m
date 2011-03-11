function varargout = zplane(z,p,varargin)
%ZPLANE Z-plane zero-pole plot.
%   ZPLANE(Z,P) plots the zeros Z and poles P (in column vectors) with the 
%   unit circle for reference.  Each zero is represented with a 'o' and 
%   each pole with a 'x' on the plot.  Multiple zeros and poles are 
%   indicated by the multiplicity number shown to the upper right of the 
%   zero or pole.  ZPLANE(Z,P) where Z and/or P is a matrix plots the zeros
%   or poles in different columns with different colors.
%
%   ZPLANE(B,A) where B and A are row vectors containing transfer function
%   polynomial coefficients plots the poles and zeros of B(z)/A(z).  Note
%   that if B and A are both scalars they will be interpreted as Z and P.
%
%   [H1,H2,H3] = ZPLANE(Z,P) returns vectors of handles to the lines and 
%   text objects generated.  H1 is a vector of handles to the zeros lines, 
%   H2 is a vector of handles to the poles lines, and H3 is a vector of 
%   handles to the axes / unit circle line and to text objects which are 
%   present when there are multiple zeros or poles.  In case there are no 
%   zeros or no poles, H1 or H2 is set to the empty matrix [].
%
%   ZPLANE(Z,P,AX) puts the plot into axes AX.
%
%   See also FREQZ, GRPDELAY, IMPZ.

%   Author(s): T. Krauss, 3-19-93
%   Copyright 1988-2001 The MathWorks, Inc.
%   $Revision: 1.18 $  $Date: 2001/04/02 20:20:39 $
%   Modifications by J. Birge, 11-01

error(nargchk(1,3,nargin))

if nargin < 2,
    p = [];
end

[z,p,msg] = parseinput(z,p);
error(msg);

[zh,ph,oh] = plotzp(z,p,varargin{:});

if (nargout==1),
   varargout = {zh};
   
elseif (nargout==2),
   varargout = {zh,ph};

elseif (nargout==3),
   varargout = {zh,ph,oh};
end



%-------------------------------------------------------------------
function [z,p,msg] = parseinput(z,p)

msg = '';

% If first arg is a row, second must be a row, empty or scalar, flag = 1
[test1flag,msg] = istf(z,p);
if ~isempty(msg),
    return
end

% If second arg is a row, first must be a row, empty or scalar, flag = 1
[test2flag,msg] = istf(p,z);
if ~isempty(msg),
    return
end


istfflag = test1flag | test2flag;
 
if istfflag,
    % Transfer function specified
    % Create a filter object
    h = df2t(z,p);
    
    % Compute the poles and zeros
    [z,p,k] = zpk(h);
end

%-------------------------------------------------------------------
function [flag,msg] = istf(b,a)

msg = '';
flag = 0; % Flag indicating whether a transfer function was specified

if isrow(b) & ~isscalar(b),
    % If first arg is a row, second must be row or empty
    if ~(isrow(a) | is0x0(a)),
        msg = 'When specifying polynomials, both vectors must be rows.';
        return
    else
        flag = 1;
    end
end

%-------------------------------------------------------------------
function flag = isrow(vec)
% Determine if vector is row vector
flag = 0;
if size(vec,1) == 1,
    flag = 1;
end

%-------------------------------------------------------------------
function flag = is0x0(A)
% Determine if argument is a zero by zero matrix
flag = 0;
if all(size(A) == 0),
    flag = 1;
end

%-------------------------------------------------------------------
function flag = isscalar(A)
% Determine if argument is a scalar (1 by 1)
flag = 0;
if all(size(A) == 1),
    flag = 1;
end

%-------------------------------------------------------------------
function [zh,ph,oh] = plotzp(z,p,ax)

if ~any(imag(z)),
   z = z + j*1e-50;
end;
if ~any(imag(p)),
   p = p + j*1e-50;
end;

if nargin < 3
   ax = newplot;
else
   axes(ax)
end

kids = get(ax,'Children');
for i = 1:length(kids)
   delete(kids(i));
end
set(ax,'box','on')
set(ax,'xlimmode','auto','ylimmode','auto')
% equivalent of 'hold on':
set(ax,'nextplot','add')
set(get(ax,'parent'),'nextplot','add')

if ~isempty(z),
  zmin = z(abs(z) <= 1);
  zmax = z(abs(z) > 1);
  zh = [plot(zmin,'b.','markersize',7), plot(zmax,'bo','markersize',7)]; 
else
   zh = []; 
end
if ~isempty(p),
   ph = plot(p,'rx','markersize',8); 
else
   ph = []; 
end

theta = linspace(0,2*pi,70);
oh = plot(cos(theta),sin(theta),'k:');

% inline 'axis equal'
units = get(ax,'Units'); set(ax,'Units','Pixels')
apos = get(ax,'Position'); set(ax,'Units',units)
set(ax,'DataAspectRatio',[1 1 1],...
   'PlotBoxAspectRatio',apos([3 4 4]))

%  zoom out ever so slightly (5%)

if apos(3) < apos(4)
   yl=get(ax,'ylim');
   d=diff(yl);
   yl = [yl(1)-.05*d  yl(2)+.05*d]; 
   set(ax,'ylim',yl);
   xl = get(ax,'xlim');
else
   xl=get(ax,'xlim');
   d=diff(xl);
   xl = [xl(1)-.05*d  xl(2)+.05*d]; 
   set(ax,'xlim',xl); 
   yl = get(ax,'ylim');
end

set(oh,'xdat',[get(oh,'xdat') NaN ...
      xl(1)-diff(xl)*100 xl(2)+diff(xl)*100 NaN 0 0]);
set(oh,'ydat',[get(oh,'ydat') NaN 0 0 NaN ...
      yl(1)-diff(yl)*100 yl(2)+diff(yl)*100]);

handle_counter = 2;	
fuzz = diff(xl)/80; % horiz spacing between 'o' or 'x' and number
fuzz=0;
[r,c]=size(z);
if (r>1)&(c>1),  % multiple columns in z
   ZEE=z;
else
   ZEE=z(:); c = min(r,c);
end;
for which_col = 1:c,      % for each column of ZEE ...
   z = ZEE(:,which_col);
   [mz,z_ind]=mpoles(z);
   for i=2:max(mz),
      j=find(mz==i);
      for k=1:length(j),
         x = real(z(z_ind(j(k)))) + fuzz;
         y = imag(z(z_ind(j(k))));
         if (j(k)~=length(z)),
            if (mz(j(k)+1)<mz(j(k))),
               oh(handle_counter) = text(x,y,num2str(i)); 
               handle_counter = handle_counter + 1;
            end
         else
            oh(handle_counter) = text(x,y,num2str(i));
            handle_counter = handle_counter + 1;
         end
      end
   end
end
[r,c]=size(p);
if (r>1)&(c>1),  % multiple columns in z
   PEE=p;
else
   PEE=p(:); c = min(r,c);
end;
for which_col = 1:c,      % for each column of PEE ...
   p = PEE(:,which_col);
   [mp,p_ind]=mpoles(p);
   for i=2:max(mp),
      j=find(mp==i);
      for k=1:length(j),
         x = real(p(p_ind(j(k)))) + fuzz;
         y = imag(p(p_ind(j(k))));
         if (j(k)~=length(p)),
            if (mp(j(k)+1)<mp(j(k))),
               oh(handle_counter) = text(x,y,num2str(i)); 
               handle_counter = handle_counter + 1;
            end
         else
            oh(handle_counter) = text(x,y,num2str(i));
            handle_counter = handle_counter + 1;
         end
      end
   end
end
set(oh(2:length(oh)),'vertical','bottom');

set(get(ax,'xlabel'),'string','Real Part')
set(get(ax,'ylabel'),'string','Imaginary Part')
set(ax,'nextplot','replace')
set(get(ax,'parent'),'nextplot','replace')
