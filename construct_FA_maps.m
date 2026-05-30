function [FA_data,FA_fit] = construct_FA_maps(D_tensor, D_fit, nx, ny, pts)
    FA_data = nan(nx, ny);
    FA_fit  = nan(nx, ny);
    Nvox = length(pts);

    for n = 1:Nvox

        i = pts(n,1);
        j = pts(n,2);

        % DATA
        Dd = make_spd(squeeze(D_tensor(i,j,:,:)));

        lambdad = real(eig(Dd));
        MDd = mean(lambdad);

        if norm(lambdad) > 0
            FA_data(i,j) = sqrt(3/2) * norm(lambdad - MDd) / norm(lambdad);
        end

        % FIT
        Df = make_spd(squeeze(D_fit(i,j,:,:)));

        lambdaf = real(eig(Df));
        MDf = mean(lambdaf);

        if norm(lambdaf) > 0
            FA_fit(i,j) = sqrt(3/2) * norm(lambdaf - MDf) / norm(lambdaf);
        end
    end
end