function phi = construct_gaussian_rbf(points, centres, epsilon)
    num_voxels = length(points);
    num_centres = length(centres);
    phi = zeros(num_voxels, num_centres);

    for index = 1:num_centres

        dx = points(:,1) - centres(a,1);
        dy = points(:,2) - centres(a,2);

        r_squared = dx.^2 + dy.^2;

        phi(:,a) = exp(-(epsilon^2) * r_squared);
    end
end