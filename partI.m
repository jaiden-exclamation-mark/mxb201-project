clear; clf;
% Parameters

% Generated with a gcv score test (will be added in future)
epsilon = 0.45;
rho = 1e-9;

plot_brain_mask = true;
plot_gradient_directions = true;
plot_md_maps = true;
plot_fa_maps = true;
plot_eigendirection_fields = true;
plot_anisotropy_strength = true;

% END Parameters

% Load data from file
load partI.mat
whos

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
[MD_data, MD_fit] = find_MD(D_tensor, D_fit, nx, ny, points);

if plot_md_maps
    disp("Plotting mean diffusivity maps...");
    % Use same colour scale for MD
    clim_md = [min(MD_data(:),[],'omitnan'), ...
           max(MD_data(:),[],'omitnan')];

    figure;

    subplot(1,2,1);
    imagesc(MD_data);
    axis image;
    colorbar;
    caxis(clim_md);
    title('Mean Diffusivity from Data');

    subplot(1,2,2);
    imagesc(MD_fit);
    axis image;
    colorbar;
    caxis(clim_md);
    title('Mean Diffusivity from RBF Model');

    % MD error map
    MD_error = abs(MD_fit - MD_data);

    figure;
    imagesc(MD_error);
    axis image;
    colorbar;
    title('Mean Diffusivity Error');
    % Use same colour scale for MD
    clim_md = [min(MD_data(:),[],'omitnan'), ...
           max(MD_data(:),[],'omitnan')];

    figure;

    subplot(1,2,1);
    imagesc(MD_data);
    axis image;
    colorbar;
    caxis(clim_md);
    title('Mean Diffusivity from Data');

    subplot(1,2,2);
    imagesc(MD_fit);
    axis image;
    colorbar;
    caxis(clim_md);
    title('Mean Diffusivity from RBF Model');

    % MD error map
    MD_error = abs(MD_fit - MD_data);

    figure;
    imagesc(MD_error);
    axis image;
    colorbar;
    title('Mean Diffusivity Error');
end

disp("Constructing fractional anisotropy maps...");
[FA_data, FA_fit] = construct_FA_maps(D_tensor, D_fit, nx, ny, points);

if plot_fa_maps
    disp("Plotting fractional anisotropy maps...");
    figure;

    subplot(1, 2, 1);
    imagesc(FA_data);
    axis image;
    colorbar;
    clim([0, 1]);
    title('FA from Data');

    subplot(1,2,2);
    imagesc(FA_fit);
    axis image;
    colorbar;
    clim([0, 1]);
    title('FA from RBF Model');
end

disp("Getting eigendirection field and anisotropy strength...");
[anis2D, v1x, v1y] = get_anisotropy_strength(nx, ny, D_fit, mask);

if plot_eigendirection_fields
    disp("Plotting eigendirection fields...");
    skip = 3;

    [Xg,Yg] = ndgrid(1:nx,1:ny);

    sample = false(nx,ny);
    sample(1:skip:end,1:skip:end) = true;
    sample = sample & mask & isfinite(v1x) & isfinite(v1y);

    figure
    imagesc(FA_fit)
    axis image
    colormap gray
    colorbar
    hold on

    quiver(Yg(sample), Xg(sample), ...
        v1y(sample), v1x(sample), ...
        0.6, 'r')

    title('Raw principal eigendirection field')
    xlabel('y')
    ylabel('x')

    % Plot as unoriented line field

    figure
    imagesc(FA_fit)
    axis image
    colormap gray
    colorbar
    hold on

    quiver(Yg(sample), Xg(sample), ...
        v1y(sample), v1x(sample), ...
        0.5, 'r')

    quiver(Yg(sample), Xg(sample), ...
        -v1y(sample), -v1x(sample), ...
        0.5, 'r')

    title('Principal eigendirection line field: v ~ -v')
    xlabel('y')
    ylabel('x')
end

if plot_anisotropy_strength
    disp("Plotting anisotropy strength...");
    figure;
    imagesc(anis2D);
    axis image;
    colorbar;
    clim([0 1]);
    title('2D anisotropy strength');
    xlabel('y');
    ylabel('x');
end