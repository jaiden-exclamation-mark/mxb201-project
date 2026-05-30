clear
% Parameters

plot_brain_mask = true;


% END Parameters

% Load data from file
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

% Brain mask
mask = S0 > 0.05 * max(S0(:));

if (plot_brain_mask)
    figure;
    imagesc(mask);
    axis image;
    colorbar;
    title("Brain Mask");
end
