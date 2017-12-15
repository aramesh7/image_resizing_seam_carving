%% Open image
close all;

%im = imread('sources/me1.jpg');
im = imread('sources/img1.png');

[rows, cols, ~] = size(im);
%imshow(im);

% Get energy of image
energy_type = 'gradient';
%energy_type = 'face';

%% Calculate vertical seam

[vert_seam,~] = forward_vertical_seam(im);
figure(5), imshow(vert_seam);

figure();
smaller_h_im = change_aspect_forward(im,rows,cols-100, energy_type);

%% Calculate horizontal seam
[hor_seam,~] = forward_horizontal_seam(im);
figure(6), imshow(hor_seam);

smaller_w_im = change_aspect_forward(im,rows-100,cols,energy_type);

