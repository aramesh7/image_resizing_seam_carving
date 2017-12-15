function Gmag = energy(im_input, type)
    if strcmp(type,'gradient')
        % Get magnitude and directions using grayscale image
        im_input = rgb2gray(im_input);
        [Gmag, ~] = imgradient(im_input, 'prewitt');
    elseif strcmp(type,'face')
        % get gradients for whole image
        im_gray = rgb2gray(im_input);
        [Gmag, ~] = imgradient(im_gray, 'prewitt');
        
        % do face detection, and overwrite energy values for the pixels
        % which constitute the face
        faceDetector = vision.CascadeObjectDetector();
        bbox = step(faceDetector, im_input);
        
        if ~isempty(bbox)
            x1 = ceil(bbox(1));
            x2 = round(x1 + bbox(3));
            y1 = ceil(bbox(2));
            y2 = round(y1 + bbox(4));

            Gmag(y1:y2, x1:x2) = inf;
        end
    end
end