% Is this quaternion?
function graphQuaternions(x, y, z, w)
    % Create a new figure
    figure;
    hold on;
    
    % Plot each quaternion component
    plot(x, 'DisplayName', 'Rotation X');
    plot(y, 'DisplayName', 'Rotation Y');
    plot(z, 'DisplayName', 'Rotation Z');
    plot(w, 'DisplayName', 'Rotation W');
    
    % Add legend and labels
    legend show;
    xlabel('Time (samples)');
    ylabel('Rotation (units)');
    title('Rotation (Quaternion Components)');
    grid on;
    
    hold off;
end