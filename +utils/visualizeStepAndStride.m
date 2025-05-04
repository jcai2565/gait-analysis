function [avgStepTime, avgStrideTimeL, avgStrideTimeR, avgStepDistance, avgStrideDistanceL, avgStrideDistanceR]...
    = visualizeStepAndStride(time, output, treadmillSpeed, index)
% Input:
% [output], the struct resulting from processing
% [treadmillSpeed], a known scalar based on the data, either 1.8 or 2.5
% miles per hour according to the treadmill used
% [index], the index of the struct corresponding to the filename index in
% the test_script.m file. For this case, odd => 1.8 mph and even 2.5 mph

% Assumes: 
% - We walk in the +x direction, on a treadmill that moves in the -x
% - The step and stride is marked, in time, by the z position moving up and
%       then down.
% - The treadmill elapses distance at a constant rate.
%

% Steps:
% Step 1: Estimate step time from foot Y positions
fprintf('--- Trial %d (%.1f mph) ---\n', index, treadmillSpeed);

pairs = {
    'RFoot', 'LFoot';
    'RToe',  'LToe';
    'RShin', 'LShin'
};

for k = 1:size(pairs, 1)
    right = pairs{k, 1};
    left  = pairs{k, 2};

    if isfield(output, right) && isfield(output, left) && ...
       isfield(output.(right), 'Position_Y') && ...
       isfield(output.(left),  'Position_Y')

        yR = output.(right).Position_Y;
        yL = output.(left).Position_Y;
        dt = mean(diff(time));
        minProm = std([yR; yL]) * 0.3;

        % Detect peaks
        [~, locsR] = findpeaks(yR, 'MinPeakDistance', round(0.3/dt), 'MinPeakProminence', minProm);
        [~, locsL] = findpeaks(yL, 'MinPeakDistance', round(0.3/dt), 'MinPeakProminence', minProm);

        timeR = time(locsR);
        timeL = time(locsL);

        % STRIDE TIME (per foot)
        strideTimesR = diff(timeR);
        strideTimesL = diff(timeL);

        strideTimesR = strideTimesR(strideTimesR > 0.4 & strideTimesR < 2.5);
        strideTimesL = strideTimesL(strideTimesL > 0.4 & strideTimesL < 2.5);

        % STEP TIME (alternating)
        allSteps = sort([timeR; timeL]);
        stepIntervals = diff(allSteps);
        stepIntervals = stepIntervals(stepIntervals > 0.2 & stepIntervals < 2.0);

        % Report if we have valid data
        if ~isempty(strideTimesR) && ~isempty(strideTimesL) && ~isempty(stepIntervals)
            avgStrideTimeR = mean(strideTimesR);
            avgStrideTimeL = mean(strideTimesL);
            avgStepTime    = mean(stepIntervals);

            % fprintf('%s - Avg Stride Time: %.3f s\n', right, avgStrideR);
            % fprintf('%s - Avg Stride Time: %.3f s\n', left, avgStrideL);
            % fprintf('%s/%s - Avg Step Time (alternating): %.3f s\n\n', right, left, avgStep);
        else
            fprintf('%s/%s - Not enough valid peaks for stride/step timing.\n\n', right, left);
        end

    else
        fprintf('%s/%s - Missing Y-position data.\n\n', right, left);
    end
end

% Convert treadmill speed from mph to m/s
treadmillSpeed_mps = treadmillSpeed * 0.44704;

% Compute displacement for RIGHT foot
if numel(timeR) >= 2 && isfield(output.(right), 'Position_X')
    xR = output.(right).Position_X;
    dxR = [];

    for s = 1:(numel(timeR)-1)
        t1 = timeR(s);
        t2 = timeR(s+1);
        i1 = find(time >= t1, 1, 'first');
        i2 = find(time >= t2, 1, 'first');
        if isempty(i1) || isempty(i2), continue; end

        x_disp = xR(i2) - xR(i1);
        treadmill_disp = treadmillSpeed_mps * (t2 - t1);
        corrected_disp = x_disp + treadmill_disp;

        dxR(end+1) = corrected_disp;
    end

    if ~isempty(dxR)
        avgStrideDistanceR = mean(dxR);
        fprintf('%s - Avg Corrected Stride Displacement (X): %.3f m\n', right, avgStrideDistanceR);
    end
end

% Compute displacement for LEFT foot
if numel(timeL) >= 2 && isfield(output.(left), 'Position_X')
    xL = output.(left).Position_X;
    dxL = [];

    for s = 1:(numel(timeL)-1)
        t1 = timeL(s);
        t2 = timeL(s+1);
        i1 = find(time >= t1, 1, 'first');
        i2 = find(time >= t2, 1, 'first');
        if isempty(i1) || isempty(i2), continue; end

        x_disp = xL(i2) - xL(i1);
        treadmill_disp = treadmillSpeed_mps * (t2 - t1);
        corrected_disp = x_disp + treadmill_disp;

        dxL(end+1) = corrected_disp;
    end

    if ~isempty(dxL)
        avgStrideDistanceL = mean(dxL);
        fprintf('%s - Avg Corrected Stride Displacement (X): %.3f m\n', left, avgStrideDistanceL);
    end
end

% STEP DISTANCE (alternating feet with X correction)
if numel(timeR) >= 1 && numel(timeL) >= 1 && ...
   isfield(output.(right), 'Position_X') && isfield(output.(left), 'Position_X')

    allSteps = sort([timeR; timeL]);
    dxStep = [];

    % Determine origin of each time point (right or left)
    allFootLabels = [repmat({'R'}, numel(timeR), 1); repmat({'L'}, numel(timeL), 1)];
    allFootTimes = [timeR; timeL];
    [sortedTimes, sortIdx] = sort(allFootTimes);
    sortedFeet = allFootLabels(sortIdx);

    for s = 1:(length(sortedTimes) - 1)
        t1 = sortedTimes(s);
        t2 = sortedTimes(s+1);
        f1 = sortedFeet{s};
        f2 = sortedFeet{s+1};

        % Skip if same foot (not a step)
        if strcmp(f1, f2), continue; end

        i1 = find(time >= t1, 1, 'first');
        i2 = find(time >= t2, 1, 'first');
        if isempty(i1) || isempty(i2), continue; end

        % Get correct X values
        x1 = output.([f1 'Foot']).Position_X(i1);
        x2 = output.([f2 'Foot']).Position_X(i2);

        treadmill_disp = treadmillSpeed_mps * (t2 - t1);
        corrected_step = x2 - x1 + treadmill_disp;
        dxStep(end+1) = corrected_step;
    end

    if ~isempty(dxStep)
        avgStepDistance = mean(dxStep);
        fprintf('Interleaved Step Distance (X): %.3f m\n', avgStepDistance);
    else
        fprintf('No valid alternating step distances computed.\n');
    end
end


% Optional: plot for visual inspection
%plotFeetSubplots(time, output, index, treadmillSpeed)

end

%% Helper plot function

function plotFeetSubplots(time, output, index, treadmillSpeed)

figure;
% Row 1: X Axis
subplot(3,2,1); hold on;
plot(time, output.RShin.Position_X, 'DisplayName', 'RShin');
plot(time, output.RToe.Position_X, 'DisplayName', 'RToe');
plot(time, output.RFoot.Position_X, 'DisplayName', 'RFoot');
title('Right Leg X');
ylabel('X Position'); legend show; grid on; hold off;

subplot(3,2,2); hold on;
plot(time, output.LShin.Position_X, 'DisplayName', 'LShin');
plot(time, output.LToe.Position_X, 'DisplayName', 'LToe');
plot(time, output.LFoot.Position_X, 'DisplayName', 'LFoot');
title('Left Leg X');
ylabel('X Position'); legend show; grid on; hold off;

% Row 2: Y Axis
subplot(3,2,3); hold on;
plot(time, output.RShin.Position_Y, 'DisplayName', 'RShin');
plot(time, output.RToe.Position_Y, 'DisplayName', 'RToe');
plot(time, output.RFoot.Position_Y, 'DisplayName', 'RFoot');
title('Right Leg Y');
ylabel('Y Position'); legend show; grid on; hold off;

subplot(3,2,4); hold on;
plot(time, output.LShin.Position_Y, 'DisplayName', 'LShin');
plot(time, output.LToe.Position_Y, 'DisplayName', 'LToe');
plot(time, output.LFoot.Position_Y, 'DisplayName', 'LFoot');
title('Left Leg Y');
ylabel('Y Position'); legend show; grid on; hold off;

% Row 3: Z Axis
subplot(3,2,5); hold on;
plot(time, output.RShin.Position_Z, 'DisplayName', 'RShin');
plot(time, output.RToe.Position_Z, 'DisplayName', 'RToe');
plot(time, output.RFoot.Position_Z, 'DisplayName', 'RFoot');
title('Right Leg Z');
xlabel('Time (s)'); ylabel('Z Position'); legend show; grid on; hold off;

subplot(3,2,6); hold on;
plot(time, output.LShin.Position_Z, 'DisplayName', 'LShin');
plot(time, output.LToe.Position_Z, 'DisplayName', 'LToe');
plot(time, output.LFoot.Position_Z, 'DisplayName', 'LFoot');
title('Left Leg Z');
xlabel('Time (s)'); ylabel('Z Position'); legend show; grid on; hold off;

sgtitle(sprintf('Feet Position - Trial %d, Speed %.1f mph', index, treadmillSpeed));

end