function visualizeHipKneeFoot(time, output, trialIndex, treadmillSpeed)

figure;

%% ---- RIGHT SIDE ----

% X
subplot(3,2,1); hold on;
plot(time, output.RASI.Position_X, 'DisplayName', 'RHip (RASI)');
plot(time, output.RKNE.Position_X, 'DisplayName', 'RKnee');
plot(time, output.RTOE.Position_X, 'DisplayName', 'RToe');


title('Right X'); ylabel('X Position'); legend show; grid on;

% Y
subplot(3,2,3); hold on;
plot(time, output.RASI.Position_Y, 'DisplayName', 'RHip (RASI)');
plot(time, output.RKNE.Position_Y, 'DisplayName', 'RKnee');
plot(time, output.RTOE.Position_Y, 'DisplayName', 'RToe');
title('Right Y'); ylabel('Y Position'); legend show; grid on;

% Z
subplot(3,2,5); hold on;
plot(time, output.RASI.Position_Z, 'DisplayName', 'RHip (RASI)');
plot(time, output.RKNE.Position_Z, 'DisplayName', 'Rknee');
plot(time, output.RTOE.Position_Z, 'DisplayName', 'RToe');
title('Right Z'); xlabel('Time (s)'); ylabel('Z Position'); legend show; grid on;

%% ---- LEFT SIDE ----

% X
subplot(3,2,2); hold on;
plot(time, output.LASI.Position_X, 'DisplayName', 'LHip (LASI)');
plot(time, output.LKNE.Position_X, 'DisplayName', 'LKnee');
plot(time, output.LTOE.Position_X, 'DisplayName', 'LToe');
title('Left X'); ylabel('X Position'); legend show; grid on;

% Y
subplot(3,2,4); hold on;
plot(time, output.LASI.Position_Y, 'DisplayName', 'LHip (LASI)');
plot(time, output.LKNE.Position_Y, 'DisplayName', 'LKnee');
plot(time, output.LTOE.Position_Y, 'DisplayName', 'LToe');
title('Left Y'); ylabel('Y Position'); legend show; grid on;

% Z
subplot(3,2,6); hold on;
plot(time, output.LASI.Position_Z, 'DisplayName', 'LHip (LASI)');
plot(time, output.LKNE.Position_Z, 'DisplayName', 'LKnee');
plot(time, output.LTOE.Position_Z, 'DisplayName', 'LToe');
title('Left Z'); xlabel('Time (s)'); ylabel('Z Position'); legend show; grid on;

sgtitle(sprintf('Joint Comparison - Trial %d, Speed %.1f mph', trialIndex, treadmillSpeed));



end
