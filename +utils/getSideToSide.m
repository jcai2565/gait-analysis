function stsWidth = getSideToSide(time, output, index, plotFlag)
% Computes mean side-to-side width (Z) using mid-foot (average of Foot & Toe)
% Returns a single scalar and optionally plots it over time

fprintf('--- Trial %d : Side-to-Side Width (Mid-Foot: L - R, Z axis) ---\n', index);

requiredFields = {'LFoot', 'LToe', 'RFoot', 'RToe'};
for i = 1:numel(requiredFields)
    if ~isfield(output, requiredFields{i}) || ...
       ~isfield(output.(requiredFields{i}), 'Position_Z')
        error('Missing Z data for %s.', requiredFields{i});
    end
end

% Get individual Z signals
zL_foot = output.LFoot.Position_Z;
zL_toe  = output.LToe.Position_Z;
zR_foot = output.RFoot.Position_Z;
zR_toe  = output.RToe.Position_Z;

% Mid-foot Z (averaged)
zL_mean = (zL_foot + zL_toe) / 2;
zR_mean = (zR_foot + zR_toe) / 2;

% Difference signal: L - R
zDiff = zR_mean - zL_mean;

% Final reported metric
meanDiff = mean(zDiff, 'omitnan');
stsWidth = meanDiff;

fprintf('Mean Mid-Foot Width (L - R): %.3f m\n', meanDiff);


if plotFlag
    % Plot differences
    figure;
    plot(time, zDiff, 'b');
    xlabel('Time (s)');
    ylabel('L - R Z Difference (m)');
    title(sprintf('Trial %d -- Side-To-Side Width vs. Time (mid-foot)', index));
    grid on;

    % % Plot Z data raw
    % parts = {'RFoot', 'LFoot', 'RToe', 'LToe'};
    % Zmat = [];
    % labels = {};
    % 
    % for i = 1:numel(parts)
    %     part = parts{i};
    %     if isfield(output, part) && isfield(output.(part), 'Position_Z')
    %         Zmat = [Zmat, output.(part).Position_Z(:)];
    %         labels{end+1} = part;
    %     end
    % end
    % 
    % plotZData(time, Zmat, labels);
end
    
end


function plotZData(time, Zmat, labels)
% Plots Position_Z signals for multiple limbs
% Inputs:
% - time: time array
% - Zmat: matrix of Z signals, one per column
% - labels: cell array of corresponding labels

    if isempty(Zmat)
        disp('No Z data to plot.');
        return;
    end

    figure;
    hold on;
    for i = 1:size(Zmat, 2)
        plot(time, Zmat(:, i), 'DisplayName', labels{i});
    end
    legend show;
    xlabel('Time (s)');
    ylabel('Position Z (side-to-side)');
    title('Side-to-Side Motion of Limbs');
    grid on;
    hold off;
end
