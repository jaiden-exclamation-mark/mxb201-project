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
disp("Creating brain mask...");
mask = S0 > 0.05 * max(S0(:));

if (plot_brain_mask)
    disp("Plotting brain mask...")
    figure;
    imagesc(mask);
    axis image;
    colorbar;
    title("Brain Mask");
end

disp("Creating diffusion tensors...");
[D_field, D_tensor] = make_diffusion_tensor(S, S0, g, b);

if (plot_gradient_directions)
    disp("Plotting gradient pulse directions...");
    figure
    quiver3(0*g(:,1),0*g(:,1),0*g(:,1),g(:,1),g(:,2),g(:,3))
    axis vis3d
    xlabel x
    ylabel y
    zlabel z
    title('Gradient pulse directions g_i')
end

% Coordinates
[nx, ny, ~] = size(S);
[X, Y] = ndgrid(1:nx, 1:ny);
all_points = [X(:), Y(:)];
mask_vector = mask(:);

points = all_points(mask_vector, :);
disp("Constructing Gaussian RBF...");
[A_data, A_pred] = construct_gaussian_rbf(points, epsilon, rho, D_tensor);
disp("Constructing fitted tensors...");
D_fit = construct_fitted_tensors(S, points, A_pred);
disp("Finding mean diffusivity maps...")
[MD_data, MD_fit] = find_MD(D_tensor, D_fit, nx, ny, length(points));