function img_crop = crop(img, dims)
% CROP crops the inout image. The output image is of size dims (a vector 
% indicating a number of rows and columns).
%
%   Usage:
%       img_crop = crop(img, dims)
%
%   Input:
%       img       : Input image
%       dims      : A vector of length 2 indicating the number of rows 
%                   and columns of the output image.
%
%   Output:
%       img_crop  : Output image, with size(img_crop) = dims.
%
%   Example:
%       img = imread('img/5.jpg');
%       [r, c, ~] = size(img);
%       dims = [r, c - 200];
%       img_crop = crop(img, dims);
%       imshow(img);
%       figure;
%       imshow(img_crop);
%
%   See also: seam_carving.m
%
%   Requires:
%
%   References:
%
% Author: Rodrigo Pena
% Date: 19 Nov 2014
% Testing: 

%% Parse input
% img
[r, c, d] = size(img);

% dims
assert(length(dims) == 2, ...
    'dims must be a two-dimensional vector.');

assert( (dims(1) <= r) && (dims(2) <= c), ...
    'img_crop''s dimensions must be less or equal to img''s.');

%% Initialization
img_crop = uint8(zeros( dims(1), dims(2), d));

%% Crop image
% Amount of rows to remove on top
cropU = round( (r - dims(1))/2 );

% Amount of rows to remove on bottom
cropD = (r - dims(1)) - cropU;

% Amount of colums to remove on the left
cropL = round( (c - dims(2))/2 );

% Amount of columns to remove on the right
cropR = (c - dims(2)) - cropL;

for i = 1:d
    img_crop(:,:,i) = ...
        img((cropU + 1):(r - cropD), (cropL + 1):(c - cropR), i);
end

end

