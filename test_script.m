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
    % Final usage: outputs{i}.Hip.Rotation_X , etc...

    %% 2. Calculate relevant metrics - uncomment to use

    % Calculate stride metrics
    %utils.visualizeStepAndStride(timeArrays{j}, outputs{j}, treadmillSpeeds(j), j, true);
    %utils.getSideToSide(timeArrays{j}, outputs{j}, j, true);
    
    % Compute Stance and SLS data
    %[stanceR, stanceL, slsR, slsL] = utils.computeStanceAndSLS(timeArrays{j}, outputs{j});

end


