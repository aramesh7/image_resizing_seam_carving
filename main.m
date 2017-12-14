%% Open image
close all;

im = imread('sources/enlarging_input.png');
%imshow(im);

%% Get energy of image
E = energy(im, 'gradient');
%figure (1), imagesc(E), colormap jet;

%% Calculate vertical seam

[vert_seam,~] = vertical_seam(im,E);
figure(5), imshow(vert_seam);

% figure(1), imagesc(Gmag), colormap jet;
% figure(2), imshow(Gdir);
% 
% figure; imshowpair(Gmag1, Gdir1, 'montage');
% figure; imshowpair(Gmag2, Gdir2, 'montage');
% figure; imshowpair(Gmag3, Gdir3, 'montage');

%% Calculate horizontal seam

[hor_seam,~] = horizontal_seam(im,E);
figure(6), imshow(hor_seam);

%% Decrease height
[rows, cols, ~] = size(im);
smaller_w_im = change_aspect(im,rows-100,cols);

%% Decrease width
smaller_h_im = change_aspect(im,rows,cols-100);

%% Decrease aspect ratio optimally
smaller_a_im = change_aspect(im,rows-30,cols-30);

%% enlarge
enlarged = enlarge(im,50,'width');
imshow(enlarged)