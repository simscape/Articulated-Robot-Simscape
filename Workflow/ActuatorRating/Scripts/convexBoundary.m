function [pointsCoordinatesFront, pointsOrientationFront] = convexBoundary(pointsCoordinates, pointsOrientation, plane, height, delta)
% CONVEXBOUNDARY Obtain the coordinates and orientation of the enclosing convex
% hull boundary of work envelope of an articulated robot.
%   [POINTSCOORDINATESFRONT, POINTSORIENTATIONFRONT] =
%   CONVEXBOUNDARY(POINTSCOORDINATES, POINTSORIENTATION, PLANE, HEIGHT,
%   DELTA) returns the coordinates and orientation of the enclosing convex 
%   hull boundary of motion of end effector of an articulated robot. 
%   The envelope will be calculated at a HEIGHT from the PLANE, with a 
%   threshold of DELTA.
%   Specify POINTSCOORDINATES and POINTSORIENTATION as [NUMPOINTS, 3]
%   arrays and PLANE as a string scalar or character vector.

% Copyright 2023 The MathWorks, Inc.


    % Find the fixed axis from the specified plane
    fixedAxisList = [1, 2, 3];
    fixedAxisNames = ['X', 'Y', 'Z'];
    fixedAxis = fixedAxisList(ismember(["YZ", "XZ", "XY" ], plane));
    planeAxis = fixedAxisList(~ismember(fixedAxisList, fixedAxis));

    % Remove even points to reduce close points at boundary
    pointsCoordinatesRed = pointsCoordinates(1:2:end,:) ;
    pointsOrientationRed = pointsOrientation(1:2:end,:);

    % Select points that are near to the XZ plane
    pointsCoordinatesRed = pointsCoordinatesRed(pointsCoordinatesRed(:, fixedAxis) >= height - delta & pointsCoordinatesRed(:, fixedAxis) <= height + delta, :);
    pointsOrientationRed = pointsOrientationRed(pointsCoordinatesRed(:, fixedAxis) >= height - delta & pointsCoordinatesRed(:, fixedAxis) <= height + delta, :);
    

    % Get the plane data
    PointsPlane = [pointsCoordinatesRed(:,1) pointsCoordinatesRed(:,3)];
    
    % Convex hull points index of plane data
    [boundaryPoints,~] = convhull(PointsPlane);
    boundaryPoints(1) = [];

    % Reorder points to start from the point closest to the origin
    closestPointToOrigin = dsearchn(abs(pointsCoordinatesRed(boundaryPoints, planeAxis)), [0, 0]);
    boundaryPoints = [boundaryPoints(closestPointToOrigin : end); boundaryPoints(1 : closestPointToOrigin - 1)];
    
    % Get the points coordinates of the boundary
    pointsCoordinatesFront =  pointsCoordinatesRed(boundaryPoints,:);
    pointsOrientationFront =  pointsOrientationRed(boundaryPoints,:);

    % Plot the envelope
    figure;
    plot(pointsCoordinatesRed(:, planeAxis(1)), pointsCoordinatesRed(:, planeAxis(2)), 'o');
    hold on
    plot(pointsCoordinatesRed(boundaryPoints, planeAxis(1)), pointsCoordinatesRed(boundaryPoints, planeAxis(2)), 'Color', 'black', 'LineWidth', 2);
    hold off
    legend(['2D Point Cloud for ' convertStringsToChars(plane) ' Motion of Robot (' num2str(length(pointsCoordinates(:, 1))) ' points)'], ...
           ['Boundary of ' convertStringsToChars(plane) ' Motion of Robot (' num2str(length(pointsCoordinatesRed(boundaryPoints, 1))) ' points)']);
    title(['Envelope for ' convertStringsToChars(plane) ' Motion of Robot'])
    xlabel([fixedAxisNames(planeAxis(1)) ' Axis (m)']);
    ylabel([fixedAxisNames(planeAxis(2)) ' Axis (m)']);
    axis equal
    
end