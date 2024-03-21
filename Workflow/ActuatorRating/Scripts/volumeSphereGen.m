function [outerParams, innerParams] = volumeSphereGen(robot, positionLimits, endEffectorName, numJoints, numRandomPoints, delta, varargin)
% VOLUMESPHEREGEN Generate the volume sphere of an articulated robot
%   [OUTERPARAMS, INNERPARAMS] = VOLUMESPHEREGEN(ROBOT, POSITIONLIMITS,
%   ENDEFFECTORNAME, NUMJOINTS, NUMRANDOMPOINTS, DELTA, PLOT) returns the 
%   outer and inner curve radius and height, in that order, for a ROBOT. 
%   Specify the POSITIONLIMITS as a [NUMJOINTS, 2] array and 
%   ENDEFFECTORNAME as a string scalar or character vector. Random 
%   distrubtion of NUMRANDOMPOINTS is used to generate angles. The 
%   threshold of distance used for slicing is determined by DELTA. Specify 
%   value of plot as 1 to plot the volume sphere.

% Copyright 2023 The MathWorks, Inc.

    % Check if plot should be produced
    if (isempty(varargin))
        showplot = 'n';
    else
        showplot = varargin;
    end

    % Joint angles of all joints
    jointConfig = zeros(numJoints, numRandomPoints);
    
    % Coordinates and orientation of random target points generated
    pointsCoordinates = zeros(numRandomPoints, 3);
    pointsOrientation = zeros(numRandomPoints, 3);
    
    % Generate the joint angles from random distribution
    for i = 1 : numJoints
        rng("shuffle","threefry")
        jointConfig(i, :) = positionLimits(i, 1) + (positionLimits(i, 2) - positionLimits(i, 1)) .* rand(1, numRandomPoints);
    end
    
    % Create the volume sphere
    for i = 1 : numRandomPoints
        tform = getTransform(robot, jointConfig(:, i), endEffectorName);
        pointsCoordinates(i, :) = tform2trvec(tform);
        pointsOrientation(i, :) = tform2eul(tform);
    end
    
    
    % Plot the volume sphere
    if (strcmpi(showplot,'plot'))
        figure;
        plot3(pointsCoordinates(:, 1), pointsCoordinates(:, 2), pointsCoordinates(:, 3), 'o');
        title('3D Point Cloud for Volume Sphere of Robot')
        xlabel('X Axis (m)');
        ylabel('Y Axis (m)');
        zlabel('Z Axis (m)');
        axis square
    end

    % Find the outer radius of the volume sphere
    % Positive X axis
    [maxXPoint, maxXPointIdx] = max(pointsCoordinates(:, 1));
    maxXPointZ = pointsCoordinates(maxXPointIdx, 3);
    % Negative X axis
    [maxNXPoint, maxNXPointIdx] = min(pointsCoordinates(:, 1));
    maxNXPointZ = pointsCoordinates(maxNXPointIdx, 3);
    % Positive Y axis
    [maxYPoint, maxYPointIdx] = max(pointsCoordinates(:, 2));
    maxYPointZ = pointsCoordinates(maxYPointIdx, 3);
    % Negative Y axis
    [maxNYPoint, maxNYPointIdx] = min(pointsCoordinates(:, 2));
    maxNYPointZ = pointsCoordinates(maxNYPointIdx, 3);
    
    outerRadius = max(abs([maxXPoint, maxNXPoint, maxYPoint, maxNYPoint]));
    outerRadiusHeight = mean([maxXPointZ, maxNXPointZ, maxYPointZ, maxNYPointZ]);

    % Find the inner radius of the volume sphere
    % Positive X axis
    subPoints = pointsCoordinates(pointsCoordinates(:, 1) >= 0 & pointsCoordinates(:, 2) >= 0 - delta & pointsCoordinates(:, 2) <= 0 + delta & pointsCoordinates(:, 3) >= outerRadiusHeight - delta & pointsCoordinates(:, 3) <= outerRadiusHeight + delta, :);
    [minXPoint, minXPointIdx] = min(abs(subPoints(:, 1)));
    minXPointZ = subPoints(minXPointIdx, 3);
    % Negative X axis
    subPoints = pointsCoordinates(pointsCoordinates(:, 1) <= 0 & pointsCoordinates(:, 2) >= 0 - delta & pointsCoordinates(:, 2) <= 0 + delta & pointsCoordinates(:, 3) >= outerRadiusHeight - delta & pointsCoordinates(:, 3) <= outerRadiusHeight + delta, :);
    [minNXPoint, minNXPointIdx] = min(abs(subPoints(:, 1)));
    minNXPointZ = subPoints(minNXPointIdx, 3);
    % Positive Y axis
    subPoints = pointsCoordinates(pointsCoordinates(:, 2) >= 0 & pointsCoordinates(:, 1) >= 0 - delta & pointsCoordinates(:, 1) <= 0 + delta & pointsCoordinates(:, 3) >= outerRadiusHeight - delta & pointsCoordinates(:, 3) <= outerRadiusHeight + delta, :);
    [minYPoint, minYPointIdx] = min(abs(subPoints(:, 2)));
    minYPointZ = subPoints(minYPointIdx, 3);
    % Negative Y axis
    subPoints = pointsCoordinates(pointsCoordinates(:, 2) <= 0 & pointsCoordinates(:, 1) >= 0 - delta & pointsCoordinates(:, 1) <= 0 + delta & pointsCoordinates(:, 3) >= outerRadiusHeight - delta & pointsCoordinates(:, 3) <= outerRadiusHeight + delta, :);
    [minNYPoint, minNYPointIdx] = min(abs(subPoints(:, 2)));
    minNYPointZ = subPoints(minNYPointIdx, 3);

    innerRadius = min([minXPoint, minNXPoint, minYPoint, minNYPoint]);
    innerRadiusHeight = mean([minXPointZ, minNXPointZ, minYPointZ, minNYPointZ]);

    outerParams = [outerRadius, outerRadiusHeight];
    innerParams = [innerRadius, innerRadiusHeight];

end

