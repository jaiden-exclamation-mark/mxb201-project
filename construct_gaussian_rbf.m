function [data, prediction] = construct_gaussian_rbf(points, epsilon, rho, diffusion_tensors)
    num_voxels = length(points);
    data = zeros(num_voxels, 6);

    for index = 1:num_voxels

        i = points(index, 1);
        j = points(index, 2);

        D_b = squeeze(diffusion_tensors(i, j, :, :));
        D_b = make_spd(D_b);

        A_b = logm(D_b);
        A_b = real(0.5 * (A_b + A_b.'));

        data(index, :) = [A_b(1,1), A_b(2,2), A_b(3,3), ...
                          A_b(1,2), A_b(1,3), A_b(2,3)];
    end

    phi = zeros(num_voxels, num_voxels);

    for index = 1:num_voxels
        dx = points(:, 1) - points(index, 1);
        dy = points(:, 2) - points(index, 2);

        r_squared = dx.^2 + dy.^2;

        phi(:, index) = exp(-(epsilon^2) * r_squared);
    end
    
    % Solve regularized least squares
    M = phi.' * phi + rho * eye(num_voxels);

    coefficients = M \ (phi.' * data);
    prediction = phi * coefficients;
end