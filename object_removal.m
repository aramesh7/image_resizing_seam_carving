function output = object_removal(im,energy_type)
    removal_mask = roipoly(im);
    [h,w,~] = size(im);
    %protection_mask = roipoly(im);
    figure(1), imshow(removal_mask);
    %total_mask = removal_mask.*(1-protection_mask);
    im_i = im;
    while not(isempty(find(removal_mask,1)))
    % Region of interest
        [r,c] = find(removal_mask==1);

        E = energy(im_i, energy_type);
        E(removal_mask==1) = -max(h,w)*max(E(:));
        % E(protection_mask==1) = inf;
        figure(2), imagesc(E), colormap jet
        figure(3)
        %Find the maximum of the vertical and horizontal diameters
        if max(r) - min(r) > max(c) - min(c)
            [vert_seam,~] = vertical_seam(im_i, E);
            im_i = cut(im_i, vert_seam, 'vertical');
            removal_mask = cut(removal_mask, vert_seam,'vertical');
            imshow(im_i)
        else
            % horizontal seam removal
            [horz_seam,~] = horizontal_seam(im_i, E);
            im_i = cut(im_i, horz_seam, 'horizontal');
            removal_mask = cut(removal_mask, horz_seam, 'horizontal');
            imshow(im_i)
        end
    end
    
    [h_new, w_new, ~] = size(im_i);
    output = enlarge(im_i,w-w_new,'width');
    output = enlarge(output,h-h_new,'height');
end