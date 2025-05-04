function visualizeStepAndStride(time, output, treadmillSpeed)
% Input:
% [output], the struct resulting from processing
% [treadmillSpeed], a known scalar based on the data, either 1.8 or 2.5
% miles per hour according to the treadmill used

% Assumes: 
% - We walk in the +x direction, on a treadmill that moves in the -x
% - The step and stride is marked, in time, by the z position moving up and
%       then down.
% - The treadmill elapses distance at a constant rate.
%

% Steps:
% 1a. Find out a pair of times when the right foot leaves the ground and foot
% lands on the ground again. We do this visually. 
% figure;
% hold on;
% plot(time, output.RShin.Position_Z, 'DisplayName', 'RShin');
% plot(time, output.RToe.Position_Z, 'DisplayName', 'RToe');
% plot(time, output.RFoot.Position_Z, 'DisplayName', 'RFoot');
% title("Right Leg Z Visualized");
% legend show;
% xlabel('Time (s)');
% ylabel('Z Position');
% hold off;
% 
% figure;
% hold on;
% plot(time, output.LShin.Position_Z, 'DisplayName', 'LShin');
% plot(time, output.LToe.Position_Z, 'DisplayName', 'LToe');
% plot(time, output.LFoot.Position_Z, 'DisplayName', 'LFoot');
% title("Left Leg Z Visualized");
% legend show;
% xlabel('Time (s)');
% ylabel('Z Position');
% hold off;

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



end