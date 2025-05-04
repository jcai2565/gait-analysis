%% Script to Analyze Gait Data
clear;

% Load the raw CSV data
filename1 = 'data/Emma_take01_walk.csv';
[timeArray, output] = utils.loadData(filename1);

% 1. Zeros mean from x, y position data so that origin is on person center
% (treadmill).
% names = fieldnames(output);
% for i = 1:numel(names)
%     name = names{i};
% 
%     if isfield(output.(name), 'Position_X')
%         output.(name).Position_X = zeroMean(output.(name).Position_X);
%     end
%     if isfield(output.(name), 'Position_Y')
%         output.(name).Position_Y = zeroMean(output.(name).Position_Y);
%     end
%     if isfield(output.(name), 'Position_Z')
%         output.(name).Position_Z = zeroMean(output.(name).Position_Z);
%     end
% end

% Final usage: output1.Hip.Rotation_X , etc...

%% 2. Graph angle and position

close all;

% Control what to plot
useWhitelist = true;
whitelist = ["Hip","RKNE","RTOE"];

% utils.graphPositionSubplots(output, whitelist, useWhitelist);
utils.visualizeStepAndStride(timeArray, output, 1.8);
%% 
% -------------------------Tiny Helper Functions-------------------------%

function out = zeroMean(x)
    out = x - mean(x, 'omitnan');  % omitnan in case of missing values
end

function out = subtractMin(z)
    % subtractMin - Shifts a Z vector so that its minimum value is 0
    %
    % Input:  z - 1D numeric vector
    % Output: out - z shifted so min(z) = 0

    if ~isvector(z)
        error('InputError:Not1DVector', 'Input must be a 1D vector.');
    end

    out = z - min(z);
end
