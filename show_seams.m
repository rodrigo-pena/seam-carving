function img_marked = show_seams(img, seams, dir_string)
% SHOW_SEAMS paints the specified seams on the input image.
%
%   Usage:
%       img_marked = show_seams(img, seams, dir_string)
%
%   Input:
%       img        : A n-by-m-by-d image. If d = 3, the color space must
%                    be RGB.
%       seam       : A matrix defining the seams.
%           - If dir_string = 'horizontal': Must be a m-by-N_SEAMS matrix
%             with the column indices of a path crossing img from left to
%             right.
%           - If dir_string = 'vertical': Must be a n-by-N_SEAMS matrix
%             with the row indices of a path crossing img from top to
%             bottom.
%       dir_string : A string {'horizontal',  'vertical'} (cf. seam info
%                    above).
%
%   Output:
%       img_marked : (Optional) A n-by-m image. It's a copy of the input 
%                    image, but with the specified seams painted. If not
%                    given, the function will display the marked image.
%
%   Example:
%       img = imread('img/5.jpg');
%       dir_string = 'vertical';
%       k = 10;
%       seams = find_k_seams(img, k, dir_string);
%       img_marked = show_seams(img, seams, dir_string);
%       imshow(img);
%       imshow(img_marked);
%
%   See also: find_k_seams.m
%
%   Requires:
%
%   References:
%
% Author: Rodrigo Pena
% Date: 10 Dec 2014
% Testing:

%% Parse input:
% img
[~, ~, d] = size(img);
assert((d == 3) || (d == 1), ...
    'The third dimmension of the input image must be 1 or 3.');

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
[rs, N_SEAMS, ds] = size(seams);
assert(rs == r, ...
    'The first dimension of seams must be the same as the dimension of the input image on the direction dir_string');
assert(ds == 1, ...
    'The third dimension of seams must be 1.');

%% Initialization
if (d == 3)
    R = img(:,:,1);
    G = img(:,:,2);
    B = img(:,:,3);
else
    R = img(:,:,1);
    G = img(:,:,1);
    B = img(:,:,1);
end

%% Mark image pixels on seam locations:
r_ind = (1:r)';
r_ind = repmat(r_ind, [N_SEAMS, 1]);
seams = seams(:);

% Mark the seams' pixels with red:
mask = logical(sparse(r_ind, seams, 1, r, c));
R(mask) = 255;
G(mask) = 0; 
B(mask) = 0;

% Mark the first seam's pixels with green:
mask = logical(sparse(r_ind(1:r), seams(1:r), 1, r, c));
R(mask) = 0;
G(mask) = 255; 
B(mask) = 0;

% Create marked image
img_marked = cat(3, R, G, B);

%% Correct for the transpose
if strcmp(dir_string,'horizontal')
    if d == 3
        img_marked = cat(3, img_marked(:,:,1).', img_marked(:,:,2).', ...
            img_marked(:,:,3).');
    else
        img_marked = img_marked.';
    end
end

%% Display result
if (nargout < 1)
   imshow(img_marked);
   title('Green: first seam; Red: rest of the seams');
end
end