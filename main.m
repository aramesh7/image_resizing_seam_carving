%% Open image
close all;

im = imread('sources/bigger.png');
%im = imread('sources/bigger.png');

%imshow(im);

%% Get energy of image
energy_type = 'gradient';
%energy_type = 'face';
%edited_image = object_removal(im, energy_type);
E = energy(im, energy_type);
%figure(10), imagesc(E), colormap jet;

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
smaller_w_im = change_aspect(im,rows-100,cols,energy_type);

%% Decrease width
<<<<<<< HEAD
smaller_h_im = change_aspect(im,rows,cols-15);
=======
smaller_h_im = change_aspect(im,rows,cols-30,energy_type);
>>>>>>> bdc1dfe8c5abba3b96fc88cba5691cf36a79dbe4

%% Decrease aspect ratio optimally
smaller_a_im = change_aspect(im,rows-30,cols-30,energy_type);

%% enlarge
enlarged = enlarge(im,150,'width');
imshow(enlarged)

%% content amplification (just scaling + seam carving back to original)
[rows, cols, ~] = size(im);
enlarged = imresize(im,[rows cols+50]);
amplified = change_aspect(enlarged,rows,cols);

%% seam carving in the gradient domain
% Decrease width
smaller_g_im = change_aspect_gradient(im,rows,cols-30,energy_type);

%% Object removal
%edited_image = object_removal(im, energy_type);
