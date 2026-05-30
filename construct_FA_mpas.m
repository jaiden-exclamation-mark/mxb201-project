function [FA_data,FA_fit] = construct_FA_mpas(D_tensor, D_fit, nx, ny, Nvox)
    FA_data = nan(nx, ny);
    FA_fit  = nan(nx, ny);

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

    figure

    subplot(1,2,1)
    imagesc(FA_data)
    axis image
    colorbar
    clim([0 1])
    title('FA from Data')

    subplot(1,2,2)
    imagesc(FA_fit)
    axis image
    colorbar
    clim([0 1])
    title('FA from RBF Model')
end
