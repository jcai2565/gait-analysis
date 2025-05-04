function plotSneakersVsHeels(time1, out1, time2, out2, speed)
% Plots joint comparison between sneakers and heels for hip, knee, toe

sides = {'R', 'L'};
joints = {'ASI', 'KNE', 'TOE'};  % e.g. RASI, RKNE, RTOE
coords = {'Position_X', 'Position_Y', 'Position_Z'};

titles = {'X Axis', 'Y Axis', 'Z Axis'};

for c = 1:3
    coord = coords{c};
    figure;
    for s = 1:2
        subplot(1,2,s); hold on;
        side = sides{s};

        for j = 1:3
            marker = [side joints{j}]; 
            % Sneakers
            if isfield(out1, marker)
                plot(time1, out1.(marker).(coord), '-', 'DisplayName', [marker ' (Sneakers)']);
            end
            % Heels
            if isfield(out2, marker)
                plot(time2, out2.(marker).(coord), '--', 'DisplayName', [marker ' (Heels)']);
            end
        end
        title([side ' Side - ' titles{c}]);
        xlabel('Time (s)');
        ylabel(strrep(coord, '_', ' '));
        legend show; grid on;
    end
    sgtitle(sprintf('Joint Comparison (Sneakers vs Heels) - %.1f mph - %s', speed, titles{c}));
end
end
