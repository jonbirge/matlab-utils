function r = polishedroots(c)
%POLISHEDROOTS  Find polynomial roots.
%   POLISHEDROOTS(C) computes the roots of the polynomial whose
%   coefficients are the elements of the vector C, in descending order.
%   The algorithm used in the standard eigenvalue method followed by an
%   iterative polishing via Laguerre's method.


% Initialization.
if size(c, 1) > 1 && size(c, 2) > 1
    error('polishedroots:arg', 'Must be a vector.')
end
c = c(:).';
n = size(c, 2);
r = zeros(0, 1);

inz = find(c);
if isempty(inz),
    % All elements are zero
    return
end

% Strip leading zeros and throw away.  
% Strip trailing zeros, but remember them as roots at zero.
nnz = length(inz);
c = c(inz(1):inz(nnz));
tr = zeros(n-inz(nnz), 1);

% Polynomial roots via a companion matrix.
n = length(c);
if n > 1
    a = diag(ones(1,n-2), -1);
    a(1,:) = -c(2:n) ./ c(1);
    tr = [tr; eig(a)];  % tentative roots
end

% Polish roots via Laguerre iteration.
parfor i = 1:length(tr),
   r(i,:) = laguerre(c, tr(i));
end
