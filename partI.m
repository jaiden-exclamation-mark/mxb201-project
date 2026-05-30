clear
load partI.mat
whos

% Construct linear DTI system
A1 = g .* g;
A2 = 2 * [g(:,1).*g(:,2), g(:,1).*g(:,3), g(:,2).*g(:,3)];
A = [A1, A2];   % 64 x 6

% Allocate storage
[nx, ny, ndirs] = size(S);

D_field  = zeros(nx, ny, 6);
D_tensor = zeros(nx, ny, 3, 3);