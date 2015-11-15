function [seam, cum_energy, edges_from] = find_seam(energy_map, dir_string)
% FIND_SEAM finds the least energy path (with respect to the entries of
% energy_map) when traversing the image in the direction indicated by 
% dirString.
%
%   Input:
%       energy_map :   A n-by-m matrix with numeric entries 
%       dir_string :   A string.
%                      - 'horizontal': Traverse the energy_map from left to
%                                      right.
%                      - 'vertical': Traverse the energy_map from top to
%                                    bottom.
%
%   Output:
%       seam       :   - If dir_string = 'horizontal', it's a m-by-1 vector 
%                      with the column indices of the least energy path when 
%                      traversing energy_map from left to right.
%                      - If dir_string = 'vertical', it's a n-by-1 vector 
%                      with the row indices of the least energy path when 
%                      traversing energy_map from top to bottom.
%       cum_energy :   A n-by-m matrix with the cumulative energy when
%                      traversing energy_map in the direction indicated by 
%                      dir_string.
%       edges_from :   A n-by-m matrix encoding the links between each
%                      pixel in the paths found when traversing energy_map.
%                   
%
%   Example:
%         [seam, ~, ~] = findSeam(energyMap, 'vertical');
%
%   See also: seam_carving.m
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

% dir_string
assert(strcmp(dir_string,'horizontal') || strcmp(dir_string,'vertical'),...
    'dir_string must be ''horizontal'' or ''vertical''.');
if strcmp(dir_string,'horizontal')
    energy_map = energy_map.';
end

% energy_map
[N, M, d] = size(energy_map);
assert(d == 1, 'energy_map should be a n-by-m-by-1 matrix.');

%% Initialization
cum_energy = repmat(energy_map(1,:),N,1);
edges_from = zeros(N,M);

%% Dynamic programming to find the paths of less energy
for i = 2:N
    for j = 1:M
        if j == 1
            origiNodes = cum_energy(i-1,1:2);
        elseif j == M
            origiNodes = cum_energy(i-1,end-1:end);
        else
            origiNodes = cum_energy(i-1,j-1:j+1);
        end
        
        [cum_energy(i,j), index] = min(energy_map(i,j) + origiNodes);
        
        edges_from(i,j) = j + index - 2 + (j == 1);
    end
end

%% Backtrack and compute seam vector
[~, index] = min(cum_energy(end,:)); 
seam = index*ones(N,1);
for i = N:-1:2
    seam(i-1) = edges_from(i, seam(i));
end

end

