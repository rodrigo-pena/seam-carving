function [img_obj_removed, dir_string, seams] = remove_obj(img, mask, ...
    h_energy, penalty)
% REMOVE_OBJ removes the object in the input image specified by the input
% mask
%
%   Usage:
%       [img_obj_removed, seams, dir_string] = remove_obj(img, mask)
%
%   Input:
%       img      : A n-by-m-by-d image.
%       mask     : A logical, n-by-m matrix with 1s on the positions of the
%                  object to be removed.
%       h_energy : (Optional) Function handle specifying a n-by-m-by-1
%                  energy map as a function of img.
%                  (DEFAULT: @(img) abs_gradient_map(img))
%       penalty  : (Optional) Energy penalty to apply to the points
%                  specified in the mask.
%                  (DEFAULT: 1000)
%
%   Output:
%       img_obj_removed : A copy of the input image, but with the object
%                         removed. It is smaller than img by N_SEAMS rows 
%                         or columns, depending on which dimension the
%                         marked object is smaller.
%       dir_string      : A string {'horizontal', 'vertical'}.
%           - 'horizontal': The object was removed by deleting horizontal
%           seams.
%           - 'vertical': The object was removed by deleting vertical
%           seams.
%       seams           : A matrix defining the removed seams.
%           - If dir_string = 'horizontal': A m-by-N_SEAMS matrix with the 
%           column indices of a path crossing img from left to right.
%           - If dir_string = 'vertical': A n-by-N_SEAMS matrix with the 
%           row indices of a path crossing img from top to bottom.
%
%   Example:
%       demo_obj_removal.m
%
%   See also: find_seam.m, delete_seam.m
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
[n, m, d] = size(img);
assert((d == 3) || (d == 1), ...
    'The third dimension of the input image must be 1 or 3.');

% mask
[nm, mm, dm] = size(mask);
assert((nm == n)||(mm == m)||(dm == 1), ...
    'The mask must be n-by-m matrix, where [n, m, ~] = size(img)');

% h_energy
if (nargin < 3) || isempty(h_energy); h_energy = @abs_gradient_map; end
assert(isa(h_energy, 'function_handle'), ...
    'h_energy must be a function handle');

% penalty
if (nargin < 4) || isempty(penalty); penalty = 1000; end
assert(length(penalty) == 1, 'penalty must be a scalar');
assert(isa(penalty, 'numeric'), 'penalty must be numeric');

%% Decide on which direction to perform seam carving:
vertical_sum = sum(mask,1);
horizontal_length = sum(vertical_sum ~= 0);
horizontal_sum = sum(mask,2);
vertical_length = sum(horizontal_sum ~= 0);

if (horizontal_length <= vertical_length)
    dir_string = 'vertical';
    seams = NaN*ones(n, m);
else
    dir_string = 'horizontal';
    seams = NaN*ones(m, n);
end

%% Initialization
pixels_to_be_removed = sum(mask(:));
img_obj_removed = img;
k = 0;

%% Remove the object(s) with seam carving:
while (pixels_to_be_removed ~= 0)
    
    k = k + 1;
    
    energy_map = h_energy(img_obj_removed) - penalty .* (double(mask));
    
    [seam, ~, ~] = find_seam(energy_map, dir_string);
    
    img_obj_removed = delete_seam(img_obj_removed, seam, dir_string);
    mask = delete_seam(mask, seam, dir_string);
    
    seams(:,k) = seam;
    
    pixels_to_be_removed = sum(mask(:));
end

%% Adjust seams's frame of reference
seams = seams(:,1:k);
for i = k:-1:2
    seams(:, i:k) = seams(:, i:k) + ...
        (seams(:, i:k) >= repmat(seams(:, i - 1), [1, k - i + 1] ) );
end

end

