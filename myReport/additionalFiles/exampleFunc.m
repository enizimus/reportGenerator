function [M1, M2] = matFun(n, V)
% [M1, M2] = exampleFunc(n, V)
% 
% Input:
% n :: double  :: scalar, determines the size of the output matrices;
% V :: double  :: 1-D vector of length n 
% Output:
% M1 :: double :: Sum of matrices with V on main and anti diagonal
% M2 :: double  :: Repeated vector V
%
% Eniz Museljic

M1 = diag(V) + fliplr(diag(V));
M2 = repmat(V,[n 1]);