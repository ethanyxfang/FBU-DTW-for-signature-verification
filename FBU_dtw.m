function [Dist_forward, Dist_backward] = FBU_dtw(t, r, C)

if nargin < 3
    C = 3; 
end

[N, dim] = size(t);
[M, ~] = size(r);

d = zeros(N, M);
for i = 1 : dim
    d = bsxfun(@minus, t(:, i), r(:, i)').^2 + d ;
end
g = rot90(d, 2);

D_forward = zeros(size(d));
D_forward(1, 1) = d(1, 1);

D_backward = zeros(size(g));
D_backward(1, 1) = g(1, 1);
for n = 2 : N
    D_forward(n,1) = D_forward(n-1,1) + C;
    D_backward(n,1) = D_backward(n-1,1) + C;
end
for m = 2 : M
    D_forward(1,m) = D_forward(1,m-1) + C;
    D_backward(1,m) = D_backward(1,m-1) + C;
end
for n = 2 : N
    for m = 2 : M
         D_forward(n,m) = min([D_forward(n-1,m)+C, D_forward(n-1,m-1)+d(n,m), D_forward(n,m-1)+C]);
         D_backward(n,m) = min([D_backward(n-1,m)+C, D_backward(n-1,m-1)+g(n,m), D_backward(n,m-1)+C]);
    end
end

Dist_forward = D_forward(N,M);
Dist_backward = D_backward(N,M);