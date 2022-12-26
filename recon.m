%% A Maximum Likelihood Stereo Algorithm
% Our implementation of the ML-based stereo reconstruction algorithm
% proposed by Cox et al. (1996)

tic;
clear all; close all;

img_path = '../stereo-recon-ml-master-old/stereo-recon-ml-master/images/';
img_name = 'SOM';
I_l = imread(strcat(img_path, img_name, '_right.jpg'));
I_r = imread(strcat(img_path, img_name, '_left.jpg'));
[h, w, c] = size(I_l);
if (c == 3)
    % Convering to grayscale
    I_l = im2double(rgb2gray(I_l));
    I_r = im2double(rgb2gray(I_r));
end

% Disparity maps
disp_left = zeros(h, w);
disp_right = zeros(h, w);

occl = 0.0009; % Occlusion constant (thresh)
disp_max = 64; % Maximum allowed disparity (in pixels)

for row = 1:h
    disp(row)
    % Computing for each row (epipolar line)
    cum_cost = NaN(w, w); % Cumulative cost
    m = NaN(w, w); % Matching ID
    
    % Populating the edges
    cum_cost(:, 1) = ([1:w] * occl);
    cum_cost(1, :) = ([1:w] * occl)';
    
    % Computing the matching costs
    for i = [2:w]
%         for j = [2:w]
        for j = [i:min(w, i + disp_max)]
            % Since depth is unidirectional
            
            cost_ij = get_matching_cost(row, i, j, I_l, I_r, 'pixel');
            match = cum_cost(i - 1, j - 1) + cost_ij;
            vert = cum_cost(i - 1, j) + occl;
            horz = cum_cost(i, j - 1) + occl;
            
            [cum_cost(i, j), m(i, j)] = min([match, vert, horz]);
        end
    end
    
    % Generating disparity maps
    p = w; q = w;
    
    
    while ((p ~= 1) && (q ~= 1))
        switch(m(p, q))
            case 1
                % Updating disparity values
                disp_left(row, p) = abs(p - q);
                disp_right(row, q) = abs(p - q);
                p = p - 1; q = q - 1;
            case 2
                % left is unmatched
                disp_left(row, p) = NaN;
                p = p - 1;
            case 3
                % right is unmatched
                disp_right(row, q) = NaN;
                q = q - 1;
        end
        
    end
end
toc