%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Seam carving - Image retargetting
%
% Author: Rodrigo Pena
% Date: 19 Nov 2014
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Setup
close all 
clc

%% Input image
img = imread('img/more-img/bicycle2.png');
[r, c, d] = size(img);
n_seams = round(0.1 * c);

%% Image reducing:

fprintf('* Image reducing tests *\n');

tic;
img_crop = crop(img, [r , c - n_seams]);
t1 = toc;
fprintf('Time to execute crop.m: %1.2f\n', t1);

tic;
img_resized_small = imresize(img, [r , c - n_seams]);
t2 = toc;
fprintf('Time to execute imresize.m: %1.2f\n', t2);

tic;
img_sc_small = uint8(seam_carving(img, [r , c - n_seams]));
t3 = toc;
fprintf('Time to execute seam_carving.m: %1.2f\n', t3);

%% Image enlargement:

fprintf('\n* Image enlarging tests *\n');

tic;
img_resized_large = imresize(img, [r , c + n_seams]);
t4 = toc;
fprintf('Time to execute imresize.m: %1.2f\n', t4);

tic;
img_sc_large = uint8(seam_carving(img, [r , c + n_seams]));
t5 = toc;
fprintf('Time to execute seam_carving.m: %1.2f\n', t5);

%% Display results
figure(1)
imshow(img);

figure(2)
imshow(img_sc_small);
title('seam carving')

figure(3)
imshow(img_crop);
title('crop')

figure(4)
imshow(img_resized_small);
title('imresize')

figure(5)
imshow(img_sc_large);
title('seam carving')

figure(6)
imshow(img_resized_large);
title('imresize')
