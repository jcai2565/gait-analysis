function graphAngles(x, y, z, w)
    % Create a new figure
    figure;
    hold on;
    
    % Returns [nx3] representing XYZ euler angles
    eulerAngles = quaternionToEuler(x,y,z,w);

    % Plot each quaternion component
    plot(eulerAngles(1,:), 'DisplayName', 'Roll');
    plot(eulerAngles(2,:), 'DisplayName', 'Pitch');
    plot(eulerAngles(3,:), 'DisplayName', 'Yaw');
    
    % Add legend and labels
    legend show;
    xlabel('Time (samples)');
    ylabel('Rotation (Radians)');
    title('Rotation (Euler Angles)');
    grid on;
    
    hold off;
end

% Just in case
function eulerAngles = quaternionToEuler(x, y, z, w)
    % Converts quaternion (x, y, z, w) to Euler angles (XYZ convention)
    % Inputs: x, y, z, w arrays
    % Output: eulerAngles [Nx3] matrix: [X_angle, Y_angle, Z_angle] in radians
    
    % Preallocate
    n = numel(x);
    eulerAngles = zeros(n, 3);
    
    for i = 1:n
        % Extract single quaternion
        qx = x(i);
        qy = y(i);
        qz = z(i);
        qw = w(i);
        
        % --- XYZ (Roll-Pitch-Yaw) formula ---
        % Roll (X-axis rotation)
        sinr_cosp = 2 * (qw * qx + qy * qz);
        cosr_cosp = 1 - 2 * (qx^2 + qy^2);
        roll = atan2(sinr_cosp, cosr_cosp);

        % Pitch (Y-axis rotation)
        sinp = 2 * (qw * qy - qz * qx);
        if abs(sinp) >= 1
            pitch = sign(sinp) * (pi/2); % use 90 degrees if out of range
        else
            pitch = asin(sinp);
        end

        % Yaw (Z-axis rotation)
        siny_cosp = 2 * (qw * qz + qx * qy);
        cosy_cosp = 1 - 2 * (qy^2 + qz^2);
        yaw = atan2(siny_cosp, cosy_cosp);

        % Store
        eulerAngles(i, :) = [roll, pitch, yaw];
    end
end
