function [strength, eig_x, eig_y] = get_anisotropy_strength(nx, ny, fitted_tensors, brain_mask)
    eig_x = nan(nx,ny);
    eig_y = nan(nx,ny);
    strength = nan(nx,ny);

    for i = 1:nx
        for j = 1:ny

            if ~brain_mask(i, j)
                continue
            end

            D_local = squeeze(fitted_tensors(i, j, :, :));
            D_2 = D_local(1:2, 1:2);
            D_2 = real(0.5 * (D_2 + D_2.'));

            [V, L] = eig(D_2);

            [lambda, indices] = sort(real(diag(L)), 'descend');

            v = real(V(:, indices(1)));

            % Normalize
            v = v / norm(v);

            eig_x(i, j) = v(1);
            eig_y(i, j) = v(2);

            % 2D anisotropy measure
            strength(i,j) = (lambda(1) - lambda(2)) ...
                          / (lambda(1) + lambda(2) + eps);
        end
    end
end