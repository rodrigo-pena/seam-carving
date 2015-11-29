function img_out = expand_seam(img, seam, dir_string)
% EXPAND_SEAM expands a seam from img, outputting an image that is a row or
% a column larger than the input image.
%
%   Usage:
%       img_out = expand_seam(img, seam, dir_string)
%
%   Input:
%       img        : A n-by-m-by-d image.
%       seam       : A vector defining the seam.
%           - If dir_string = 'horizontal': Must be a m-by-1 vector
%             with the column indices of a path crossing img from left to
%             right.
%           - If dir_string = 'vertical': Must be a n-by-1 vector
%             with the row indices of a path crossing img from top to
%             bottom.
%       dir_string : A string {'horizontal',  'vertical'} (cf. seam info
%                      above).
%
%   Output:
%       img_out    : The input image with a seam removed.
%           - If dir_string = 'horizontal': A (n+1)-by-m image.
%           - If dir_string = 'vertical': A n-by-(m+1) image.
%
%   Example:
%       img = imread('img/5.jpg');
%       dir_string = 'vertical';
%       seam = find_seam(img, dir_string);
%       img_out = expand_seam(img, seam, dir_string);
%       imshow(img);
%       figure;
%       imshow(img_out);
%
%   See also: find_seam.m, find_k_seams.
%
%   Requires:
%
%   References:
%       [1] Avidan, S. and Shamir, A. "Seam Carving for Content-Aware
%       Image Resizing". Mitsubishi Electric Research Laboratories.
%       Technical Report TR2007-087. August 2008.
%       [2] Rubinstein, M. et al. "Improved Seam Carving for Video
%       Retargeting". Mitsubishi Electric Research Laboratories.
%       Technical Report TR2008-064. August 2008.
%
% Author: Rodrigo Pena
% Date: 19 Nov 2014
% Testing:

%% Parse input

% img
[~, ~, d] = size(img);
assert((d == 3) || (d == 1), ...
    'The third dimension of the input image must be 1 or 3.');

% dir_string
assert(strcmp(dir_string,'horizontal') || strcmp(dir_string,'vertical'),...
    'dir_string must be ''horizontal'' or ''vertical''.');
if strcmp(dir_string,'horizontal')
    if (d == 3)
        img = cat(3, img(:,:,1).', img(:,:,2).', img(:,:,3).');
    else
        img = img.';
    end
end

% seam
[r, c, ~] = size(img);
assert(length(seam) == r, ...
    'seam must be the same size as the input image in the direction dir_string');

%% Initialization
img_out = uint8(zeros(r, c + 1, d));

%% Expand pixels on the seam
for i = 1:r
    current_line_left = img(i, 1:seam(i), :);
    current_line_right = img(i, (seam(i) + 1):end, :);
    img_out(i,:,:) = cat(2, current_line_left, ...
        current_line_left(1, end, :), current_line_right);
end

%% Correct for the transpose
if strcmp(dir_string,'horizontal')
    if (d == 3)
        img_out = cat(3, img_out(:,:,1).', img_out(:,:,2).', ...
            img_out(:,:,3).');
    else
        img_out = img_out.';
    end
end

end