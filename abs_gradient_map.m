function energy_map = abs_gradient_map(img)
% ABS_GRADIENT_MAP computes the absolute gradient map of the input image.
%
%   Usage:
%       energy_map = abs_gradient_map(img)
%
%   Input:
%       img        : A n-by-m-by-d uint8 image. If d = 3, the color space
%                    must be RGB.
%
%   Output:
%       energy_map : A n-by-m energy map computed from the gradient of img.
%
%   Example:
%       img = imread('img/5.jpg');
%       energy_map = abs_gradient_map(img);
%       imshow(img);
%       figure;
%       imagesc(energy_map);
%
%   See also: find_k_seams.m
%
%   Requires:
%
%   References:
%
% Author: Rodrigo Pena
% Date: 29 Nov 2015
% Testing:

%% Parse input
assert(isa(img, 'uint8'), 'Image must be uint8');

%% Initialization
[~, ~, d] = size(img);

%% Compute map
if (d == 3)
    [Ix, Iy] = gradient(double(rgb2gray(img)));
else
    [Ix, Iy] = gradient(double(img_reduced));
end

energy_map = abs(Ix) + abs(Iy);

end