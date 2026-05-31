function [D_field, D_tensor] = make_diffusion_tensor(S, S0, g, b)
    % Allocate storage
    [nx, ny, ~] = size(S);

    % Construct linear DTI system
    A1 = g .* g;
    A2 = 2 * [g(:,1).*g(:,2), g(:,1).*g(:,3), g(:,2).*g(:,3)];
    A = [A1, A2];   % 64 x 6

    D_field  = zeros(nx, ny, 6);
    D_tensor = zeros(nx, ny, 3, 3);

    for i = 1:nx
        for j = 1:ny

            S_voxel = squeeze(S(i,j,:));
            S0_voxel = S0(i,j);

            if S0_voxel <= 0
                continue
            end

            B = -log((S_voxel + 1e-12) ./ (S0_voxel + 1e-12)) ./ b;

            D_vec = A \ B;

            D_field(i,j,:) = D_vec;

            D_raw = [D_vec(1), D_vec(4), D_vec(5);
                    D_vec(4), D_vec(2), D_vec(6);
                    D_vec(5), D_vec(6), D_vec(3)];

            D_tensor(i,j,:,:) = make_spd(D_raw);
        end
    end
end

