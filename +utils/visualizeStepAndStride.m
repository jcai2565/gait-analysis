function visualizeStepAndStride(time, output, treadmillSpeed, index)
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

        % % Report if we have valid data
        % if ~isempty(strideTimesR) && ~isempty(strideTimesL) && ~isempty(stepIntervals)
        %     avgStrideR = mean(strideTimesR);
        %     avgStrideL = mean(strideTimesL);
        %     avgStep    = mean(stepIntervals);
        % 
        %     fprintf('%s - Avg Stride Time: %.3f s\n', right, avgStrideR);
        %     fprintf('%s - Avg Stride Time: %.3f s\n', left, avgStrideL);
        %     fprintf('%s/%s - Avg Step Time (alternating): %.3f s\n\n', right, left, avgStep);
        % else
        %     fprintf('%s/%s - Not enough valid peaks for stride/step timing.\n\n', right, left);
        % end

    else
        fprintf('%s/%s - Missing Y-position data.\n\n', right, left);
    end
end


% Optional: plot for visual inspection
plotFeetSubplots(time, output, index, treadmillSpeed)

end

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