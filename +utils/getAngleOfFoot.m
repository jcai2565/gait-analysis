function [angleR, avgYawR, angleL, avgYawL] = getAngleOfFoot(time, output, index, plotFlag)
% Computes foot yaw angles (heel → toe) in X-Z plane for both feet.
% Returns:
% - angleR, angleL: angle vectors (NaN where not in stance)
% - avgYawR, avgYawL: average yaw over stance frames

    % --- Right Foot ---
    [angleR, avgYawR] = computeFootYaw('RFoot', 'RToe', time, output, index, plotFlag);

    % --- Left Foot ---
    [angleL, avgYawL] = computeFootYaw('LFoot', 'LToe', time, output, index, plotFlag);
end

function [angleDeg, avgYaw] = computeFootYaw(footName, toeName, time, output, index, plotFlag)
    % Ensure required fields are present
    for part = {footName, toeName}
        if ~isfield(output, part{1}) || ...
           ~isfield(output.(part{1}), 'Position_X') || ...
           ~isfield(output.(part{1}), 'Position_Z') || ...
           ~isfield(output.(part{1}), 'Position_Y')
            error('Missing position data for %s.', part{1});
        end
    end

    % Positions
    xFoot = output.(footName).Position_X;
    zFoot = output.(footName).Position_Z;
    yFoot = output.(footName).Position_Y;
    xToe  = output.(toeName).Position_X;
    zToe  = output.(toeName).Position_Z;

    % Vector heel → toe
    dx = xToe - xFoot;
    dz = zToe - zFoot;

    % Yaw angle in degrees (negate Z if rightward is +Z and CCW is +)
    angleDeg = rad2deg(atan2(-dz, dx));

    % Stance detection: Y below median
    yThresh = median(yFoot);
    stanceMask = yFoot < yThresh;

    % Masked version (for plotting)
    maskedAngle = angleDeg;
    maskedAngle(~stanceMask) = NaN;

    % Plotting
    if plotFlag
        figure;
        plot(time, angleDeg, '--', 'Color', [0.6 0.6 0.6]); hold on;
        plot(time, maskedAngle, 'b-', 'LineWidth', 1.5);
        footSide = footName(1);  % 'R' or 'L'
        xlabel('Time (s)');
        ylabel('Foot Angle (deg)');
        title(sprintf('Trial %d -- %s Foot Yaw (Heel → Toe)', index, footSide));
        legend('All Frames', 'Stance Phase Only');
        grid on;
    end

    % Average yaw over stance
    avgYaw = mean(angleDeg(stanceMask), 'omitnan');
    fprintf('Trial %d -- Avg %s Foot Yaw: %.2f degrees\n', index, footName(1), avgYaw);
end
