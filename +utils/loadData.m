function [timeArray, output] = loadData(filename)

% Skip first two junk rows
opts = detectImportOptions(filename, 'NumHeaderLines', 2);
rawData = readcell(filename, opts);

% Time values are under the second column, starting from row 6
timeArray = cell2mat(rawData(6:end, 2));

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
        output.(part).(fieldName) = data(1:length(timeArray), j);
    end
end

end

function out = getLastSplit(c)
    parts = split(c, ':');
    out = parts{end};
end