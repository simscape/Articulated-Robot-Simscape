function [pointsCoordinatesScaled, pointsOrientationScaled] = boundaryPathGen(pointsCoordinates, pointsOrientation, plane, height, delta, shrinkFactor, numRequiredPoints)
% BOUNDARYPATHGEN Generate the boundary path for an envelope of an
% articulated robot
%   [POINTSCOORDINATESSCALED, POINTSORIENTATIONSCALED] =
%   BOUNDARYPATHGEN(POINTSCOORDINATES, POINTSORIENTATION, PLANE, HEIGHT,
%   DELTA, SHRINKFACTOR, NUMREQUIREDPOINTS) returns the coordinates and
%   orientation of the end effector of an articulated robot, with the
%   number of points scaled down to NUMREQUIREDPOINTS. The envelope will be
%   calculated at a HEIGHT from the PLANE, with a threshold of DELTA.
%   Specify POINTSCOORDINATES and POINTSORIENTATION as [NUMPOINTS, 3]
%   arrays and PLANE as a string scalar or character vector. Specify
%   SHRINKFACTOR as value between 0 and 1, for how much the boundary
%   shrinks to the curve.

% Copyright 2023 The MathWorks, Inc.


    % Find the fixed axis from the specified plane
    fixedAxisList = [1, 2, 3];
    fixedAxisNames = ['X', 'Y', 'Z'];
    fixedAxis = fixedAxisList(ismember(["YZ", "XZ", "XY" ], plane));
    planeAxis = fixedAxisList(~ismember(fixedAxisList, fixedAxis));

    % Select points that are near to the XZ plane
    pointsCoordinates = pointsCoordinates(pointsCoordinates(:, fixedAxis) >= height - delta & pointsCoordinates(:, fixedAxis) <= height + delta, :);
    pointsOrientation = pointsOrientation(pointsCoordinates(:, fixedAxis) >= height - delta & pointsCoordinates(:, fixedAxis) <= height + delta, :);
    
    % Find points that are on the boundary
    boundaryPoints = boundary(pointsCoordinates(:, planeAxis), shrinkFactor);
    
    % Reorder points to start from the point closest to the origin
    closestPointToOrigin = dsearchn(abs(pointsCoordinates(boundaryPoints, planeAxis)), [0, 0]);
    boundaryPoints = [boundaryPoints(closestPointToOrigin : end); boundaryPoints(1 : closestPointToOrigin - 1)];
    
    % Scale the number of generated points to the required number of points
    scaledPoints = spline(linspace(-2 * pi, 2 * pi, length(boundaryPoints)), pointsCoordinates(boundaryPoints, planeAxis)', linspace(-2 * pi, 2 * pi, numRequiredPoints));
    
    % Plot the envelope
    figure;
    plot(pointsCoordinates(:, planeAxis(1)), pointsCoordinates(:, planeAxis(2)), 'o');
    hold on
    plot(pointsCoordinates(boundaryPoints, planeAxis(1)), pointsCoordinates(boundaryPoints, planeAxis(2)), 'Color', 'black', 'LineWidth', 2);
    plot(scaledPoints(1, :), scaledPoints(2, :), 'Color', 'red', 'LineWidth', 3);
    hold off
    legend(['2D Point Cloud for ' convertStringsToChars(plane) ' Motion of Robot (' num2str(length(pointsCoordinates(:, 1))) ' points)'], ...
           ['Boundary of ' convertStringsToChars(plane) ' Motion of Robot (' num2str(length(pointsCoordinates(boundaryPoints, 1))) ' points)'], ...
           ['Spline Curve of ' convertStringsToChars(plane) ' Motion of Robot (' num2str(length(scaledPoints(1, :))) ' points)']);
    title(['Envelope for ' convertStringsToChars(plane) ' Motion of Robot'])
    xlabel([fixedAxisNames(planeAxis(1)) ' Axis (m)']);
    ylabel([fixedAxisNames(planeAxis(2)) ' Axis (m)']);
    axis equal
    
    % Match the scaled down points with the closest original points
    closestPointsToScaledPoints = dsearchn(pointsCoordinates(boundaryPoints, planeAxis), [scaledPoints(1, :)', scaledPoints(2, :)']);
    pointsOrientationScaled = pointsOrientation(boundaryPoints(closestPointsToScaledPoints), :);
    pointsCoordinatesScaled = zeros(length(scaledPoints), 3);
    pointsCoordinatesScaled(:, planeAxis) = [scaledPoints(1, :)', scaledPoints(2, :)'];
    pointsCoordinatesScaled(:, fixedAxis) = height .* ones(length(scaledPoints), 1);
end

