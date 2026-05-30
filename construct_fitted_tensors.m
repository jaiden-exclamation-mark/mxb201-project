function fitted = construct_fitted_tensors(nx, ny, points, prediction_matrix)
    fitted = zeros(nx, ny, 3, 3);
    num_voxels = length(points);

    for index = 1:num_voxels
        i = points(index, 1);
        j = points(index, 2);

        prediction_vector = prediction_matrix(index, :);
        fitted_vector = [
            prediction_vector(1), prediction_vector(4), prediction_vector(5);
            prediction_vector(4), prediction_vector(2), prediction_vector(6);
            prediction_vector(5), prediction_vector(6), prediction_vector(3)
        ];

        fitted(i, j, :, :) = make_spd(expm(fitted_vector));
    end
end