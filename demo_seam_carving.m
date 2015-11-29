%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Seam carving - Image retargetting
%
% Author: Rodrigo Pena
% Date: 10 Dec 2014
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Setup
close all 
clc

%% Input image
img = imread('img/5.jpg');
[r, c, d] = size(img);
n_seams = round(0.05 * c);

%% Image reducing:

fprintf('* Image reducing *\n');

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

fprintf('\n* Image enlarging *\n');

tic;
img_resized_large = imresize(img, [r , c + n_seams]);
t4 = toc;
fprintf('Time to execute imresize.m: %1.2f\n', t4);

tic;
img_sc_large = uint8(seam_carving(img, [r , c + n_seams]));
t5 = toc;
fprintf('Time to execute seam_carving.m: %1.2f\n', t5);

%% Content amplification:

fprintf('\n* Image content amplification *\n');

tic;
img_content_amp = content_amp(img, 1.1);
t6 = toc;
fprintf('Time to execute content_amp.m: %1.2f\n', t6);

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

figure(7)
imshow(img_content_amp);
title('content amp')