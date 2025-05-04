% Function calculating angles
% v = [x_knee(i) - x_hip(i), z_knee(i) - z_hip(i)], data from csv file
% axis_vec is the reference (z axis)
function angle_deg = vector_angle_to_axis(v, axis_vec) 
    if norm(v) == 0
        angle_deg = 0;
    else
        angle_deg = rad2deg(acos(dot(v, axis_vec) / (norm(v) * norm(axis_vec))));
    end
end

% Funtion returning all angles
function angles = get_angles(x_hip, y_hip, z_hip, ...
                             x_knee, y_knee, z_knee, ...
                             x_ankle, y_ankle, z_ankle, ...
                             x_toe, y_toe, z_toe)

    N = length(x_hip);
    angles = zeros(N, 3);  % [hip-knee, knee-ankle, ankle-toe]
    ref_axis = [0 0 1];  % Reference direction: vertical (z-axis)

    for i = 1:N
        hip_knee   = [x_knee(i) - x_hip(i), y_knee(i) - y_hip(i), z_knee(i) - z_hip(i)];
        knee_ankle = [x_ankle(i) - x_knee(i), y_ankle(i) - y_knee(i), z_ankle(i) - z_knee(i)];
        ankle_toe  = [x_toe(i) - x_ankle(i), y_toe(i) - y_ankle(i), z_toe(i) - z_ankle(i)];

        hip_angle = vector_angle_to_axis(hip_knee, ref_axis);
        knee_angle = vector_angle_to_axis(knee_ankle, ref_axis);
        foot_angle = vector_angle_to_axis(ankle_toe, ref_axis);

        angles(i, :) = [hip_angle, knee_angle, foot_angle];
    end
end
