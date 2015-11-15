function img_sc = seam_carving( img, dims )
% SEAM_CARVING performs seam carving on the img.
%
%   Input:
%         img       : Input image
%         dims      : A scalar indicating the expansion factor in both rows
%                     and columns, or a vector of length 2 indicating the 
%                     number of rows and columns of the output image.
%
%   Output:
%         img_sc    : Output image
%
%   Example:
%         img = imread('img/5.jpg');
%         [r, c, ~] = size(img);
%         img_sc = seam_carving( img, [r, c - 200] );
%
%   See also: find_seam.m, delete_seam.m, expand_seam.m
%
%   Requires:
%
%   References:
%         [1] Avidan, S. and Shamir, A. "Seam Carving for Content-Aware
%          Image Resizing". Mitsubishi Electric Research Laboratories.
%          Technical Report TR2007-087. August 2008.
%         [2] Rubinstein, M. et al. "Improved Seam Carving for Video 
%          Retargeting". Mitsubishi Electric Research Laboratories.
%          Technical Report TR2008-064. August 2008.
%
% Author: Rodrigo Pena
% Date: 19 Nov 2014
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
img_sc = double(img);

%% Seam carving across the rows:
while (r ~= dims(1))
    
    % Compute energy map (absolute value of the gradient)
    if d == 3
        [Ix, Iy] = gradient(rgb2gray(img_sc));
    else
        [Ix, Iy] = gradient(img_sc);
    end
    energy_map = abs(Ix) + abs(Iy);
    
    % Find seams
    [seam, ~, ~] = find_seam(energy_map, 'horizontal');
    
    % Remove or duplicate seam
    if (r > dims(1))
        img_sc = delete_seam(img_sc, seam, 'horizontal');
    else
        img_sc = expand_seam(img_sc, seam, 'horizontal');
    end
    
    % Update image info
    [r, ~, d] = size(img_sc);
end

%% Seam carving across the columns:
while (c ~= dims(2))
    
    % Compute energy map (absolute value of the gradient)
    if d == 3
        [Ix, Iy] = gradient(rgb2gray(img_sc));
    else
        [Ix, Iy] = gradient(img_sc);
    end
    energy_map = abs(Ix) + abs(Iy);
    
    % Find seams
    [seam, ~, ~] = find_seam(energy_map, 'vertical');
    
    % Remove or duplicate seam
    if (c > dims(2))
        img_sc = delete_seam(img_sc, seam, 'vertical');
    else
        img_sc = expand_seam(img_sc, seam, 'vertical');
    end
    
    % Update image info
    [~, c, d] = size(img_sc);
end


end

