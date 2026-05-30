function [MD_data, MD_fit] = find_MD(D_tensor, D_fit, nx, ny, Nvox)
    % Mean diffusivity maps
    MD_data = nan(nx, ny);
    MD_fit  = nan(nx, ny);

    for n = 1:Nvox

        i = pts(n,1);
        j = pts(n,2);

        Dd = make_spd(squeeze(D_tensor(i,j,:,:)));
        Df = make_spd(squeeze(D_fit(i,j,:,:)));

        MD_data(i,j) = real(trace(Dd)/3);
        MD_fit(i,j)  = real(trace(Df)/3);
    end

    % Use same colour scale for MD
    clim_md = [min(MD_data(:),[],'omitnan'), ...
           max(MD_data(:),[],'omitnan')];

    figure

    subplot(1,2,1)
    imagesc(MD_data)
    axis image
    colorbar
    caxis(clim_md)
    title('Mean Diffusivity from Data')

    subplot(1,2,2)
    imagesc(MD_fit)
    axis image
    colorbar
    caxis(clim_md)
    title('Mean Diffusivity from RBF Model')

    % MD error map
    MD_error = abs(MD_fit - MD_data);

    figure
    imagesc(MD_error)
    axis image
    colorbar
    title('Mean Diffusivity Error')
end
