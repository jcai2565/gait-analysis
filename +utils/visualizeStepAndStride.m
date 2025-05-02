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
figure;
plot(time, output.RShin.Position_Z);

end