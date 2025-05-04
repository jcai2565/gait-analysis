%% Script to Analyze Gait Data
clear;
close all;

% Load the raw CSV data
filenames = {
    'data/Emma_take01_walk.csv',
    'data/Emma_take02_walk.csv',
    'data/Emma_take03_walkH.csv',
    'data/Emma_take04_walkH.csv',
    %'data/Emma_take05_skates.csv', 
    % skate data has unknown speed, just for fun
    %'data/Emma_take06_skates.csv'
};

% mph
treadmillSpeeds = [
    1.8, 
    2.5, 
    1.8, 
    2.5
    ];

n = numel(filenames);
timeArrays = cell(1, n);
outputs = cell(1, n);

for i = 1:n
    [timeArrays{i}, outputs{i}] = utils.loadData(filenames{i});
end

% Index for filenames
for j = 1:n
    %1. Zeros mean from x, z position data (ground plane) so that origin is on person center
    % @(treadmill).
    names = fieldnames(outputs{j});
    % Index for struct names
    for i = 1:numel(names)
        name = names{i};
        if isfield(outputs{j}.(name), 'Position_X')
            outputs{j}.(name).Position_X = zeroMean(outputs{j}.(name).Position_X);
        end
        if isfield(outputs{j}.(name), 'Position_Z')
            outputs{j}.(name).Position_Z = zeroMean(outputs{j}.(name).Position_Z);
        end
    end
    
    % Final usage: outputs{i}.Hip.Rotation_X , etc...
    
    %% 2. Calculate stride metrics
    utils.visualizeStepAndStride(timeArrays{j}, outputs{j}, treadmillSpeeds(j), j);

end

%% 
% -------------------------Tiny Helper Functions-------------------------%

function out = zeroMean(x)
    out = x - mean(x, 'omitnan');  % omitnan in case of missing values
end

