%% Script to Analyze Gait Data

clear;

% Load the raw CSV data
filename = 'data/SampleGaitData.csv';

% Skip first two junk rows
opts = detectImportOptions(filename, 'NumHeaderLines', 2);
rawData = readcell(filename, opts);

% Time values are under the first column, starting from row 6
timeArray = cell2mat(rawData(6:end, 1));

% Cut out the first 2 columns to get the non-time data
rawData = rawData(:,3:end);

% Strip the name Skeleton003 out of string
rawData(1,:) = cellfun(@(c) strtrim(getLastSplit(c)), rawData(1,:), 'UniformOutput', false);

% Combine data into struct
% Extract the header info
bodyParts = rawData(1,:);  % 'Hip', 'LThigh', etc
types = rawData(3,:);      % 'Rotation' or 'Position'
axes = rawData(4,:);       % 'X', 'Y', 'Z', or 'W'

% Extract the actual numeric data (starting from row 5)
data = cell2mat(rawData(5:end,:));  % Convert the rest to a numeric matrix

% Find unique body parts
uniqueParts = unique(bodyParts);

% Initialize output structs
output = struct();

% Loop through each unique body part
for i = 1:numel(uniqueParts)
    part = uniqueParts{i};
    
    % Find columns belonging to this part
    cols = strcmp(bodyParts, part);
    
    % For each matching column
    for j = find(cols)
        % Create the field name: e.g., 'Rotation_X'
        fieldName = [types{j}, '_', axes{j}];
        
        % Store the data under the field
        output.(part).(fieldName) = data(:, j);
    end
end

% Final usage: output.Hip.Rotation_X , etc...
% Analysis code here

% 1. Scale data relative to person (not sure what that means)
%%%

% 2. Graph angle and position
close all;
graphQuaternions(output.Hip.Rotation_X, output.Hip.Rotation_Y, output.Hip.Rotation_Z, output.Hip.Rotation_W);
graphPositions(output.Hip.Position_X, output.Hip.Position_Y, output.Hip.Position_Z)

% 2. Functions to plot angle and position

function graphAngles(x, y, z, w)
    % Create a new figure
    figure;
    hold on;
    
    % Returns [nx3] representing XYZ euler angles
    eulerAngles = quaternionToEuler(x,y,z,w);

    % Plot each quaternion component
    plot(eulerAngles(1,:), 'DisplayName', 'Roll');
    plot(eulerAngles(2,:), 'DisplayName', 'Pitch');
    plot(eulerAngles(3,:), 'DisplayName', 'Yaw');
    
    % Add legend and labels
    legend show;
    xlabel('Time (samples)');
    ylabel('Rotation (Radians)');
    title('Rotation (Euler Angles)');
    grid on;
    
    hold off;
end

% Is this quaternion?
function graphQuaternions(x, y, z, w)
    % Create a new figure
    figure;
    hold on;
    
    % Plot each quaternion component
    plot(x, 'DisplayName', 'Rotation X');
    plot(y, 'DisplayName', 'Rotation Y');
    plot(z, 'DisplayName', 'Rotation Z');
    plot(w, 'DisplayName', 'Rotation W');
    
    % Add legend and labels
    legend show;
    xlabel('Time (samples)');
    ylabel('Rotation (units)');
    title('Rotation (Quaternion Components)');
    grid on;
    
    hold off;
end

function graphPositions(x, y, z)
    % Create a new figure
    figure;
    hold on;
    
    % Plot each position component
    plot(x, 'DisplayName', 'Position X');
    plot(y, 'DisplayName', 'Position Y');
    plot(z, 'DisplayName', 'Position Z');
    
    % Add legend and labels
    legend show;
    xlabel('Time (samples)');
    ylabel('Position (units)');
    title('Position (X, Y, Z)');
    grid on;
    
    hold off;
end

% Just in case
function eulerAngles = quaternionToEuler(x, y, z, w)
    % Converts quaternion (x, y, z, w) to Euler angles (XYZ convention)
    % Inputs: x, y, z, w arrays
    % Output: eulerAngles [Nx3] matrix: [X_angle, Y_angle, Z_angle] in radians
    
    % Preallocate
    n = numel(x);
    eulerAngles = zeros(n, 3);
    
    for i = 1:n
        % Extract single quaternion
        qx = x(i);
        qy = y(i);
        qz = z(i);
        qw = w(i);
        
        % --- XYZ (Roll-Pitch-Yaw) formula ---
        % Roll (X-axis rotation)
        sinr_cosp = 2 * (qw * qx + qy * qz);
        cosr_cosp = 1 - 2 * (qx^2 + qy^2);
        roll = atan2(sinr_cosp, cosr_cosp);

        % Pitch (Y-axis rotation)
        sinp = 2 * (qw * qy - qz * qx);
        if abs(sinp) >= 1
            pitch = sign(sinp) * (pi/2); % use 90 degrees if out of range
        else
            pitch = asin(sinp);
        end

        % Yaw (Z-axis rotation)
        siny_cosp = 2 * (qw * qz + qx * qy);
        cosy_cosp = 1 - 2 * (qy^2 + qz^2);
        yaw = atan2(siny_cosp, cosy_cosp);

        % Store
        eulerAngles(i, :) = [roll, pitch, yaw];
    end
end


function out = getLastSplit(c)
    parts = split(c, ':');
    out = parts{end};
end

