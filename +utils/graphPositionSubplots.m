% Graphs 3 horizontally stacked subplots for X, Y, and Z for every struct
% field that is in [whitelist].

function graphPositionSubplots(output)

%%% Usage:
% Control what to plot
    useWhitelist = true;
    whitelist = ["LToe","LFoot","RToe", "RFoot"];

% Construct a cell array of X, Y, and Z for elements in whitelist
if useWhitelist
    N = numel(whitelist);
    X_list = cell(1, N);
    Y_list = cell(1, N);
    Z_list = cell(1, N);
    labels = cell(1, N);

    for i = 1:N
        name = whitelist(i);
        if isfield(output, name)
            X_list{i} = output.(name).Position_X;
            Y_list{i} = output.(name).Position_Y;
            Z_list{i} = output.(name).Position_Z;
            labels{i} = char(name);  % convert string to char for label
        else
            error('MissingField:Whitelist', ...
                  'The field "%s" is in the whitelist but not in the output struct.', name);
        end
    end

else
    names = fieldnames(output); 
    N = numel(names);
    X_list = cell(1, N);
    Y_list = cell(1, N);
    Z_list = cell(1, N);
    labels = cell(1, N);

    for i = 1:N
        name = names{i};
        X_list{i} = output.(name).Position_X;
        Y_list{i} = output.(name).Position_Y;
        Z_list{i} = output.(name).Position_Z;
        labels{i} = name;
    end
end

graphPositionSubplotsHelper(X_list, Y_list, Z_list, labels);

% --- Optional: Also graph angles if available ---
angleFields = {};
RX_list = {}; RY_list = {}; RZ_list = {}; RW_list = {};

for i = 1:N
    name = labels{i};  % either whitelist name or fieldname
    if isfield(output.(name), 'Rotation_X') && isfield(output.(name), 'Rotation_Y') && ...
       isfield(output.(name), 'Rotation_Z') && isfield(output.(name), 'Rotation_W')
        angleFields{end+1} = name;
        RX_list{end+1} = output.(name).Rotation_X;
        RY_list{end+1} = output.(name).Rotation_Y;
        RZ_list{end+1} = output.(name).Rotation_Z;
        RW_list{end+1} = output.(name).Rotation_W;
    end
end

if ~isempty(angleFields)
    graphAngleSubplotsHelper(RX_list, RY_list, RZ_list, RW_list, angleFields);
end

end

function graphPositionSubplotsHelper(X_list, Y_list, Z_list, labels)
    % graphMultiple1DPositionSubplots - Plots X, Y, Z positions in subplots
    %
    % Inputs:
    %   - X_list, Y_list, Z_list: cell arrays of 1D position vectors
    %   - labels: cell array of strings (same length as X_list)
    
    % --- Assertions ---
    if ~iscell(X_list) || ~iscell(Y_list) || ~iscell(Z_list) || ~iscell(labels)
        error('InputError:InvalidType', 'All inputs must be cell arrays.');
    end

    n = numel(X_list);
    if numel(Y_list) ~= n || numel(Z_list) ~= n || numel(labels) ~= n
        error('InputError:MismatchedLengths', ...
              'X_list, Y_list, Z_list, and labels must have the same length.');
    end

    for i = 1:n
        if ~isvector(X_list{i}) || ~isvector(Y_list{i}) || ~isvector(Z_list{i})
            error('InputError:Not1DVector', ...
                  'Each entry in X_list, Y_list, and Z_list must be a 1D vector.');
        end
    end

    % --- Plotting ---
    figure;
    
    % Subplot for Position X
    subplot(3,1,1); hold on;
    for i = 1:n
        plot(X_list{i}, 'DisplayName', sprintf('Position X - %s', labels{i}));
    end
    xlabel('Time (samples)');
    ylabel('X Position');
    title('Position X');
    legend show; grid on;

    % Subplot for Position Y
    subplot(3,1,2); hold on;
    for i = 1:n
        plot(Y_list{i}, 'DisplayName', sprintf('Position Y - %s', labels{i}));
    end
    xlabel('Time (samples)');
    ylabel('Y Position');
    title('Position Y');
    legend show; grid on;

    % Subplot for Position Z
    subplot(3,1,3); hold on;
    for i = 1:n
        plot(Z_list{i}, 'DisplayName', sprintf('Position Z - %s', labels{i}));
    end
    xlabel('Time (samples)');
    ylabel('Z Position');
    title('Position Z');
    legend show; grid on;
end

function graphAngleSubplotsHelper(RX_list, RY_list, RZ_list, RW_list, labels)
    % graphAngleSubplotsHelper - Plots 4D rotation components in 2x2 subplot grid

    n = numel(labels);
    figure;

    % Subplot 1: Rotation X
    subplot(2,2,1); hold on;
    for i = 1:n
        plot(RX_list{i}, 'DisplayName', sprintf('Rotation X - %s', labels{i}));
    end
    title('Rotation X'); xlabel('Time (samples)'); ylabel('X'); legend show; grid on;

    % Subplot 2: Rotation Y
    subplot(2,2,2); hold on;
    for i = 1:n
        plot(RY_list{i}, 'DisplayName', sprintf('Rotation Y - %s', labels{i}));
    end
    title('Rotation Y'); xlabel('Time (samples)'); ylabel('Y'); legend show; grid on;

    % Subplot 3: Rotation Z
    subplot(2,2,3); hold on;
    for i = 1:n
        plot(RZ_list{i}, 'DisplayName', sprintf('Rotation Z - %s', labels{i}));
    end
    title('Rotation Z'); xlabel('Time (samples)'); ylabel('Z'); legend show; grid on;

    % Subplot 4: Rotation W
    subplot(2,2,4); hold on;
    for i = 1:n
        plot(RW_list{i}, 'DisplayName', sprintf('Rotation W - %s', labels{i}));
    end
    title('Rotation W'); xlabel('Time (samples)'); ylabel('W'); legend show; grid on;
end