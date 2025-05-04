function inStruct = zeroMeansFromStruct(inStruct)
% Function that returns the same struct with all X, Z positions zero-mean'd
% Should not modify the input struct from original file because of MATLAB's
% pass by value

    %1. Zeros mean from x, z position data (ground plane) so that origin is on person center
    % @(treadmill).
    names = fieldnames(inStruct);
    % Index for struct names
    for i = 1:numel(names)
        name = names{i};
        if isfield(inStruct.(name), 'Position_X')
            inStruct.(name).Position_X = zeroMean(inStruct.(name).Position_X);
        end
        if isfield(inStruct.(name), 'Position_Z')
            inStruct.(name).Position_Z = zeroMean(inStruct.(name).Position_Z);
        end
    end

end

function out = zeroMean(x)
    out = x - mean(x, 'omitnan');  % omitnan in case of missing values
end
