%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Seam carving - Image retargetting %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all 
clc

img = imread('img/5.jpg');
[r, c, d] = size(img);

%% Interactive mask creation:
fprintf('* Interactive mask creation *\n');
fprintf('Use mouse clicks to define the vertices of a polygon\n');
fprintf('enclosing the object to be removed.\n');
fprintf('When finished, double click the image.\n');
mask = roipoly(img);

%% Object Removal:
tic;
[img_obj_removed, dir_string, seams] = remove_obj(img, mask);
t = toc;
fprintf('Time to execute remove_obj.m: %1.2f\n', t);

%% Show figures:
figure(1)
show_seams(img, seams, dir_string);

figure(2)
imshow(img_obj_removed);
