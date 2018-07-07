function [L,R,r] = myTestFunc(M)

% [L,R,r] = myTestFunc(M)
% 
% Input:
% M :: double  :: 2-dimensionale Matrix; quadratisch; alle Werte ungleich Null
%
% Output:
% L :: logical :: Stern in der gleichen Größe wie {\tt M} (siehe Beispiel)
% R :: double  :: gleich wie {\tt M} aber mit Nullen wo {\tt L} {\tt false} ist 
% (siehe Beispiel)
% r :: double  :: Skalar; Summe aller 
% Werte in {\tt M} wo {\tt L} {\tt true} ist
%
% Winfried Kernbichler

    L = logical(eye(size(M))) | logical(flipud(eye(size(M))));
    R = M; R(~L) = 0;
    r = sum(M(L));