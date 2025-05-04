function [stanceR, stanceL, slsR, slsL] = computeStanceAndSLS(time, output)

% Z positions
RHeelZ = output.RHEE.Position_Z;
RToeZ = output.RTOE.Position_Z;
LHeelZ = output.LHEE.Position_Z;
LToeZ = output.LTOE.Position_Z;

% Heel strikes ≈ local minima in heel Z
[~, hsR] = findpeaks(-RHeelZ, 'MinPeakDistance', 20);
[~, hsL] = findpeaks(-LHeelZ, 'MinPeakDistance', 20);

% Toe offs ≈ local maxima in toe Z
[~, toR] = findpeaks(RToeZ, 'MinPeakDistance', 20);
[~, toL] = findpeaks(LToeZ, 'MinPeakDistance', 20);

% Match heel strikes with next toe offs
rStanceDur = [];
lStanceDur = [];

for i = 1:length(hsR)
    nextTO = toR(toR > hsR(i));
    if ~isempty(nextTO)
        rStanceDur(end+1) = time(nextTO(1)) - time(hsR(i));
    end
end

for i = 1:length(hsL)
    nextTO = toL(toL > hsL(i));
    if ~isempty(nextTO)
        lStanceDur(end+1) = time(nextTO(1)) - time(hsL(i));
    end
end

stanceR = mean(rStanceDur);
stanceL = mean(lStanceDur);

% Single Limb Support
rSLSDur = [];
lSLSDur = [];

for i = 1:length(toR)
    nextHS = hsR(hsR > toR(i));
    if ~isempty(nextHS)
        rSLSDur(end+1) = time(nextHS(1)) - time(toR(i));
    end
end

for i = 1:length(toL)
    nextHS = hsL(hsL > toL(i));
    if ~isempty(nextHS)
        lSLSDur(end+1) = time(nextHS(1)) - time(toL(i));
    end
end

slsR = mean(rSLSDur);
slsL = mean(lSLSDur);

% Print
fprintf('Right Stance Time: %.3f s\n', stanceR);
fprintf('Left  Stance Time: %.3f s\n', stanceL);
fprintf('Right SLS Time:    %.3f s\n', slsR);
fprintf('Left  SLS Time:    %.3f s\n', slsL);

end

% [stanceR, stanceL, slsR, slsL] = utils.computeStanceAndSLS(timeArray, output);
