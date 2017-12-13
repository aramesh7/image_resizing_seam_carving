%% Open image
close all;

im = imread('sources/img1.png');
%imshow(im);

%% Get energy of image
E = energy(im, 'gradient');
%figure (1), imagesc(E), colormap jet;

%% Calculate vertical seam

vert_seam = vertical_seam(im,E);
figure(5), imshow(vert_seam);

% figure(1), imagesc(Gmag), colormap jet;
% figure(2), imshow(Gdir);
% 
% figure; imshowpair(Gmag1, Gdir1, 'montage');
% figure; imshowpair(Gmag2, Gdir2, 'montage');
% figure; imshowpair(Gmag3, Gdir3, 'montage');

%% Calculate horizontal seam

hor_seam = horizontal_seam(im,E);
figure(6), imshow(hor_seam);