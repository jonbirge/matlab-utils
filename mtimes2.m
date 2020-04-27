function A = mtimes2(varargin)
%MTIMES2 Multiply deep matrices.
%  C = mtimes2(A, ...) calculates the inner product of the matrices, vectorized
%  across a third dimension. The function will act just like mtimes
%  for two dimensional matrices.

N = length(varargin);
A = varargin{N};

for i = (N-1):-1:1
   
   B = varargin{i};
   
   [Am, An, Az] = size(A);
   [Bm, Bn, Bz] = size(B);
   
   if (Am ~= Bn && Am*An ~= 1 && Bm*Bn ~= 1)
      error('mtimes2:dim', 'The inner dimensions must be equal or one must be scalar.')
   end
   if (Az ~= Bz && Az ~= 1 && Bz ~= 1)
      error('mtimes2:dim', 'The third dimensions must be equal or one must be singleton.')
   end
   
   % Case I: A or B is a single matrix
   if (Az == 1)
      for z = 1:Bz
         C(:,:,z) = B(:,:,z) * A;
      end
   else
      if (Bz == 1)
         for z = 1:Az
            C(:,:,z) = B * A(:,:,z);
         end
      else  % Case II: A and B have the same size.
         for z = 1:Az
            C(:,:,z) = B(:,:,z) * A(:,:,z);
         end
      end
   end
   
   A = C;
   
end  % for
