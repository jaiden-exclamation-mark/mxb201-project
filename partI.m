clear; clf;
% Parameters

% Generated with a gcv score test (will be added in future)
epsilon = 0.45;
rho = 1e-9;

plot_brain_mask = true;
plot_gradient_directions = true;

% END Parameters

% Load data from file
load partI.mat
whos

% Construct linear DTI system
A1 = g .* g;
A2 = 2 * [g(:,1).*g(:,2), g(:,1).*g(:,3), g(:,2).*g(:,3)];
A = [A1, A2];   % 64 x 6

% Brain mask
mask = S0 > 0.05 * max(S0(:));

if (plot_brain_mask)
    figure;
    imagesc(mask);
    axis image;
    colorbar;
    title("Brain Mask");
end

[D_field, D_tensor] = make_diffusion_tensor(S, S0, g, b);

if (plot_gradient_directions)
    figure
    quiver3(0*g(:,1),0*g(:,1),0*g(:,1),g(:,1),g(:,2),g(:,3))
    axis vis3d
    xlabel x
    ylabel y
    zlabel z
    title('Gradient pulse directions g_i')
end

