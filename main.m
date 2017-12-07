close all;

im1 = imread('sources/flowers1.jpg');
% im1 = imread('sources/img1.png');
imshow(im1);

% Gx is change in gradient from top to bottom
% Gy is change in gradient from left to right

% im1 = rgb2gray(im1);

% % Channel-wise
% [Gmag1, Gdir1] = imgradient(im1(:,:,1), 'prewitt');
% [Gmag2, Gdir2] = imgradient(im1(:,:,2), 'prewitt');
% [Gmag3, Gdir3] = imgradient(im1(:,:,3), 'prewitt');
% 
% Gmag = cat(3, Gmag1, Gmag2, Gmag3);
% Gdir = cat(3, Gdir1, Gdir2, Gdir3);

%% Get magnitude and directions using grayscale image
im1 = rgb2gray(im1);
[Gmag, Gdir] = imgradient(im1, 'prewitt');
figure (1), imagesc(Gmag), colormap jet;

%%

[rows, cols, ~] = size(im1);


% indices = zeros(size(
M = zeros(size(Gmag));
M(1, :) = Gmag(1, :);
for i = 2:rows
    for j = 1:cols  
        center = M(i-1, j);
        if j == 1
            left = inf;
            right = M(i-1, j+1);
        elseif j == cols
            left = M(i-1, j-1);
            right = inf;
        else
            left = M(i-1, j-1);
            right = M(i-1, j+1);
        end
        
        minVal = min(min(left, right), center);
        
        M(i, j) = Gmag(i, j) + minVal;
    end
end

[val, idx] = min(M(end, 2:cols-1));

im_path = im1;
im_path(rows,idx) = 255; 
for i = rows-1:-1:1
    
    left = M(i, idx-1);
    center = M(i, idx);
    right = M(i, idx+1);

    [val, j] = min(cat(3, left, center, right));
    im_path(i,idx+j-2) = 255;
    idx = idx+j-2;
end

figure(5), imshow(im_path);


figure(), imagesc(M), colormap jet;

% figure(1), imagesc(Gmag), colormap jet;
% figure(2), imshow(Gdir);
% 
% figure; imshowpair(Gmag1, Gdir1, 'montage');
% figure; imshowpair(Gmag2, Gdir2, 'montage');
% figure; imshowpair(Gmag3, Gdir3, 'montage');
