function [opt_nn_size] = optNESS(XYZ,k_min,k_max,delta_k)
% This is our tool optNESS for deriving optimal 3D neighborhoods via
% eigenentropy-based scale selection.
%
% DESCRIPTION
%
%   For each individual 3D point, this function calculates the optimal
%   neighborhood size formed by the respective k nearest neighbors. More
%   details can be found in the following paper:
%
%     M. Weinmann, B. Jutzi, and C. Mallet (2014): Semantic 3D scene
%     interpretation: a framework combining optimal neighborhood size
%     selection with relevant features. In: K. Schindler and N. Paparoditis
%     (Eds.), ISPRS Technical Commission III Symposium. ISPRS Annals of the
%     Photogrammetry, Remote Sensing and Spatial Information Sciences,
%     Vol. II-3, pp. 181-188. 
%
%
% INPUT VARIABLES (we omit checking input variables for useful values)
%
%   XYZ               -   [n x 3]-matrix containing XYZ coordinates
%                         (n: number of considered 3D points)
%   k_min             -   minimum number of neighbors to be considered
%   k_max             -   maximum number of neighbors to be considered
%   delta_k           -   stepsize within the interval [k_min,k_max]
%
%
% OUTPUT VARIABLES
%
%   opt_nn_size       -   vector describing the optimal neighborhood size
%                         for each individual 3D point
%
%
% USAGE
%
%   [opt_nn_size] = optNESS(XYZ,k_min,k_max,delta_k)
%
%
% LICENSE
%
%   Copyright (C) 2014  Martin Weinmann
%
%   This program is free software; you can redistribute it and/or
%   modify it under the terms of the GNU General Public License
%   as published by the Free Software Foundation; either version 2
%   of the License, or (at your option) any later version.
% 
%   This program is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
%   GNU General Public License for more details.
% 
%   You should have received a copy of the GNU General Public License
%   along with this program; if not, write to the Free Software
%   Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
%
%
% CONTACT
%
%   Martin Weinmann
%   Institute of Photogrammetry and Remote Sensing, Karlsruhe Institute of Technology (KIT)
%   email:   martin.weinmann@kit.edu
%

% get point IDs
point_ID_max = size(XYZ,1);
k = k_min:delta_k:k_max;

% get local neighborhoods consisting of k neighbors
data_pts = XYZ(:,1:3);
k_plus_1 = max(k)+1;
num_k = length(k);
[idx,~] = knnsearch(data_pts,data_pts,'Distance','euclidean','NSMethod','kdtree','K',k_plus_1);

% do some initialization stuff for incredible speed improvement
Shannon_entropy = zeros(point_ID_max,num_k);
opt_nn_size = zeros(point_ID_max,1);

% calculate Shannon entropy
for j=1:point_ID_max
    Shannon_entropy_real = zeros(1,num_k);  

    for j2=1:num_k

        % select neighboring points
        P = data_pts(idx(j,1:k(j2)+1),:);          % the point and its k neighbors ...
        [m,~] = size(P);

        % calculate covariance matrix C
        % 1.) Standard Matlab code (quite slow for small matrices):
        %        C = cov(P);
        % 2.) Fast Matlab code:
        P = P-ones(m,1)*(sum(P,1)/m);
        C = P.'*P./(m-1);

        % get the eigenvalues of C (sorting is already done by Matlab routine eig)
        % ... and remove negative eigenvalues (NOTE: THESE APPEAR ONLY BECAUSE OF NUMERICAL REASONS AND ARE VERY VERY CLOSE TO 0!)
        % ... and later avoid NaNs resulting for eigenentropy if one EV is 0
        [~, D] = eig(C);

        epsilon_to_add = 1e-8;
        EVs = [D(3,3) D(2,2) D(1,1)];
        if EVs(3) <= 0; EVs(3) = epsilon_to_add;
            if EVs(2) <= 0; EVs(2) = epsilon_to_add;
                if EVs(1) <= 0; EVs(1) = epsilon_to_add; end;
            end;
        end;

        % normalize EVs
        EVs = EVs./sum(EVs(:));

        % derive Shannon entropy based on eigenentropy
        Shannon_entropy_cal = -( EVs(1)*log(EVs(1)) + EVs(2)*log(EVs(2)) + EVs(3)*log(EVs(3)) );
        Shannon_entropy_real(j2) = real(Shannon_entropy_cal);

    end  % j2       

    Shannon_entropy(j,:) = Shannon_entropy_real;
    % select k with minimal Shannon entropy
    [~,min_entry_of_Shannon_entropy] = min(Shannon_entropy_real(:));
    opt_nn_size(j,1) = k(min_entry_of_Shannon_entropy);

end  % j


end  % function

