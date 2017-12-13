function Gmag = energy(im, type)
    if strcmp(type,'gradient')
        % Get magnitude and directions using grayscale image
        im = rgb2gray(im);
        [Gmag, Gdir] = imgradient(im, 'prewitt');
    end
end