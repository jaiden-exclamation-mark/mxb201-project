function [MD_data, MD_fit] = find_MD(D_tensor, D_fit)
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
end
