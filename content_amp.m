function img_out = content_amp(img, gain)
% CONTENT_AMP zooms in on the high-energy content in the input image, while
% maintaining the original image dimensions.
%
%   Usage:
%       img_out = content_amp(img, gain)
%
%   Input:
%       img     : A r-by-c-by-d image.
%       gain    : A number specifying the amplification (or zoom) level.
%
%   Output:
%       img_out : The output image
%
%   Example:
%       img = imread('img/5.jpg');
%       gain = 1.5;
%       img_out = content_amp(img, gain)
%       imshow(img);
%       imshow(img_out);
%
%   See also: seam_carving.m
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
% Date: 10 Dec 2014
% Testing:

%% Parse input:
% img
[r, c, ~] = size(img);

% gain
assert(length(gain) == 1, ...
    'The gain must be a scalar.');
assert(isnumeric(gain), ...
    'The gain must be numeric.');

%% Content amplification:
img_large = imresize(img, gain);
img_out = seam_carving(img_large, [r, c]);

end

