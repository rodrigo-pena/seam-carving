function [seams, img_reduced] = find_k_seams(img, k, dir_string, h_energy)
% FIND_K_SEAMS finds the k least energy paths (with respect to an energy 
% map) when traversing the image in the direction indicated by dir_string.
%
%   Usage:
%       [seams, img_reduced] = find_k_seams(img, k, dir_string)
%
%   Input:
%       img         : A n-by-m-by-d image.
%       k           : Number of seams (or least energy paths) to find.
%       dir_string  : A string {'horizontal', 'vertical'}.
%           - 'horizontal': Traverse the energy map from left to right.
%           - 'vertical': Traverse the energy map from top to bottom.
%       h_energy    : (Optional) Function handle specifying the n-by-m-by-1
%                     energy map as a function of img.
%                     (DEFAULT: @(img) abs_gradient_map(img))
%
%   Output:
%       seams       : A matrix defining the seams.
%           - If dir_string = 'horizontal': A m-by-k matrix with the column
%           indices of a path crossing img from left to right.
%           - If dir_string = 'vertical': A n-by-k matrix with the row 
%           indices of a path crossing img from top to bottom.
%       img_reduced : A copy of img, but with the k seams removed. A
%                     by-product of finding the first k seams, can be 
%                     useful later. 
%
%   Example:
%       img = imread('img/5.jpg');
%       dir_string = 'vertical';
%       k = 10;
%       [seams, img_reduced] = find_k_seams(img, k, dir_string)
%       img_marked = show_seams(img, seams, dir_string);
%       imshow(img);
%       figure;
%       imshow(img_marked);
%       figure;
%       imshow(img_reduced);
%
%   See also: find_k_seams.m, show_seams.m, seam_carving.m
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

%% Parse input:
% img
[n, m, d] = size(img);
assert((d == 3) || (d == 1), ...
    'The third dimension of the input image must be 1 or 3.');

% k
assert(isnumeric(k), 'k must be numeric');
k = round(k);

% dir_string
assert(strcmp(dir_string,'horizontal') || strcmp(dir_string,'vertical'),...
    'dir_string must be ''horizontal'' or ''vertical''.');
if strcmp(dir_string,'horizontal')
    seams = NaN*ones(m, k);
else
    seams = NaN*ones(n, k);
end

% h_energy
if (nargin < 4) || isempty(h_energy)
    h_energy = @abs_gradient_map;
end
assert(isa(h_energy, 'function_handle'), ...
    'h_energy must be a function handle');

%% Initialization
img_reduced = img;

%% Find k seams:
for iteration = 1:k
    energy_map = h_energy(img_reduced);
    
    [seam, ~, ~] = find_seam(energy_map, dir_string);
    
    img_reduced = delete_seam(img_reduced, seam, dir_string);
    
    seams(:,iteration) = seam;  
end

%% Adjust seams's frame of reference
for i = k:-1:2
    seams(:,i:k) = seams(:,i:k) + ...
        (seams(:, i:k) >= repmat(seams(:, i - 1), [1, k - i + 1]));
end

end