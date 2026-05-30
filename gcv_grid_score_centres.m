function G = gcv_grid_score_centres( ...
    pts, centres, Z, eps_vals, rho_vals)

    Z = double(Z);

    N = size(pts,1);
    q = size(Z,2);

    Mcentres = size(centres,1);

    G = nan(length(eps_vals), length(rho_vals));

    I = eye(Mcentres);

    % distances only computed once
    D = pdist2(pts, centres);

    for i = 1:length(eps_vals)

        eps = eps_vals(i);

        Phi = exp(-(eps * D).^2);

        PtP = Phi.' * Phi;
        PtZ = Phi.' * Z;

        % eigendecomposition once per epsilon
        [V, Lam] = eig(PtP, 'vector');

        Lam = real(Lam);

        B = V.' * PtZ;

        for j = 1:length(rho_vals)

            rho = rho_vals(j);

            d = Lam + rho;

            if min(abs(d)) / max(abs(d)) < 1e-16
                continue
            end

            C = V * ((1 ./ d) .* B);

            Zhat = Phi * C;

            Res = Z - Zhat;

            rss = sum(Res(:).^2);

            trA = sum(Lam ./ d);

            denom = (1 - trA/N)^2;

            if denom <= 0 || ~isfinite(denom)
                continue
            end

            G(i,j) = (rss / (N*q)) / denom;

        end
    end
end
