function stsWidth = getSideToSide(time, output)
% Computes side-to-side width as max - min of Z-position for each limb
% Returns struct of widths per body part

    fprintf('--- Side-to-Side Widths (Z axis) ---\n');

    parts = {'RFoot', 'LFoot', 'RToe', 'LToe'};
    stsWidth = struct();  % store output

    % Collect for plotting
    Zmat = [];
    labels = {};

    for i = 1:numel(parts)
        name = parts{i};

        if isfield(output, name) && isfield(output.(name), 'Position_Z')
            z = output.(name).Position_Z;
            width = max(z) - min(z);

            stsWidth.(name) = width;

            fprintf('%s - Side-to-Side Width: %.3f m\n', name, width);

            Zmat = [Zmat, z(:)];
            labels{end+1} = name;
        else
            fprintf('%s - Missing Z data.\n', name);
        end
    end

    % Optional: Plot all Z trajectories
    plotSideToSide(time, Zmat, labels);
end

function plotSideToSide(time, Zmat, labels)
% Helper to visualize Position_Z traces for limbs

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
