function D_spd = make_spd(D)
    % SPD projection helper
    D = real(0.5 * (D + D.'));

    [V,L] = eig(D);

    lambda = real(diag(L));

    lambda_min = 1e-8;
    lambda(lambda < lambda_min) = lambda_min;

    D_spd = V * diag(lambda) * V.';

    D_spd = real(0.5 * (D_spd + D_spd.'));
end