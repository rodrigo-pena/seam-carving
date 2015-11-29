function img_sc = seam_carving( img, dims )
% SEAM_CARVING retargets the input image os that the output image has the
% specified dimensions.
%
%   Usage:
%       img_sc = seam_carving(img, dims)
%
%   Input:
%       img       : A n-by-m-by-d image.
%       dims      : A scalar indicating the expansion factor in both rows
%                   and columns, OR a vector of length 2 indicating the 
%                   number of rows and columns of the output image.
%
%   Output:
%         img_sc  : Retargetted image. 
%
%   Example:
%       img = imread('img/5.jpg');
%       [r, c, ~] = size(img);
%       img_sc = seam_carving( img, [r, c - 100] );
%       imshow(img);
%       figure;
%       imshow(img_sc);
%
%   See also: find_k_seams.m, delete_seam.m, expand_seam.m
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

%% Parse input
% img
[r, c, d] = size(img);
assert((d==3) || (d==1), ...
    'The third dimmension of the input image must be 1 or 3.');

% dims
if (length(dims) == 1)
    dims = [round(dims*r), round(dims*c)];
elseif (length(dims) == 2)
    dims = round(dims);
else
    error('dims must be a scalar or a two-dimensional vector.');
end

%% Initialization
img_sc = img;

%% Seam carving across the rows:
k = r - dims(1);
dir_string = 'horizontal';

switch sign(k)
    case 0 % Do nothing
        
    case 1 % Remove rows
        [~, img_sc] = find_k_seams(img_sc, abs(k), dir_string);
        
    case -1 % Add rows
        % Max number of seams to expand per iteration (to avoid artefacts):
        max_k = round(0.1 .* r);
        
        iterations = floor(abs(k./max_k));
        for i = 1:iterations
            [seams, ~] = find_k_seams(img_sc, max_k, dir_string);
            img_sc = expand_seam(img_sc, seams, dir_string);
        end
        
        rest = abs(k) - iterations .* max_k;
        if (rest ~= 0)
            [seams, ~] = find_k_seams(img_sc, rest, dir_string);
            img_sc = expand_seam(img_sc, seams, dir_string);
        end
end

%% Seam carving across the columns:
k = c - dims(2);
dir_string = 'vertical';

switch sign(k)
    case 0 % Do nothing
        
    case 1 % Remove columns
        [~, img_sc] = find_k_seams(img_sc, abs(k), dir_string);
        
    case -1 % Add columns
        % Max number of seams to expand per iteration (to avoid artefacts):
        max_k = round(0.1 .* c);
        
        iterations = floor(abs(k./max_k));
        for i = 1:iterations
            [seams, ~] = find_k_seams(img_sc, max_k, dir_string);
            img_sc = expand_seam(img_sc, seams, dir_string);
        end
        
        rest = abs(k) - iterations .* max_k;
        if (rest ~= 0)
            [seams, ~] = find_k_seams(img_sc, rest, dir_string);
            img_sc = expand_seam(img_sc, seams, dir_string);
        end
end

end

