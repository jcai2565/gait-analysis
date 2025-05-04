function plotSneakersVsHeels(time1, out1, time2, out2, speed)
% Plots joint comparison between sneakers and heels for hip, knee, toe

% Limit data to first 10 seconds
maxT = 10;
time1 = time1(time1 <= maxT);
time2 = time2(time2 <= maxT);

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
                y = out1.(marker).(coord);
                plot(time1, y(1:length(time1)), '-', 'DisplayName', [marker ' (Sneakers)']);
            end

            % Heels
            if isfield(out2, marker)
                y = out2.(marker).(coord);
                plot(time2, y(1:length(time2)), '--', 'DisplayName', [marker ' (Heels)']);
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


% %% Compare Sneakers vs Heels in test_script.m
% % 1.8 mph
% utils.plotSneakersVsHeels(timeArrays{1}, outputs{1}, timeArrays{3}, outputs{3}, 1.8);
% 
% % 2.5 mph
% utils.plotSneakersVsHeels(timeArrays{2}, outputs{2}, timeArrays{4}, outputs{4}, 2.5);