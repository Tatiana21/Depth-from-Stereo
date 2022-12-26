function [cost] = get_matching_cost(row, loc_1, loc_2, img_1, img_2, mode)
    %% Get cost of matching the features at specified locations in a pair of images

    %% init
    if (nargin < 6)
        mode = 'pixel';
    end
    
    if strcmp(mode, 'pixel')
        % Computing distances assuming uncorrelated covariance matrix
        cost = (img_1(row, loc_1) - img_2(row, loc_2)) ^ 2;
    elseif strcmp(mode, 'patch')
        % Using patches around the feature to compute matching cost
        cost = NaN;
    end
end