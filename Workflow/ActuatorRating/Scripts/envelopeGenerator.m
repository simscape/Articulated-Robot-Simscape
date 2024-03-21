function [outerParams, innerParams] = envelopeGenerator(robot, endEffectorName)
%%  Function for envelope generation of Parametric model 

% Copyright 2023 The MathWorks, Inc.


%% Read the joint angular position limits from the rigid body
% tree structure and assign to a variable. Workspace depends on the link
% lengths and orientation as well the joint angle limits. 

% Read the position limits of all joints in the robot
positionLimits = cellfun(@(x) x.Joint.PositionLimits, robot.Bodies, 'UniformOutput', false);

% Remove the joints that do not have any position limits
positionLimits(cell2mat(cellfun(@(x) x(1) == 0 && x(2) == 0, positionLimits, 'UniformOutput', false))) = [];

% Reshape the position limits to [numJoints, 2]
positionLimits = reshape(cell2mat(positionLimits), 2, length(positionLimits))';

% Extract the number of joints of the robot
numJoints = length(positionLimits);

%% Create a workspace with a random distribution of joint configuration. 
% This example uses 50000 random points to generate the workspace. 
% To generate a workspace with higher accuracy, you can select a higher 
% number of random joint configurations. 

% Number of random points
numRandomPoints = 20000;

%% The max reach of an articulated robot is the outer radius of the 
% spherical workspace. The manipulator cannot reach a certain region 
% because of the joint limits and the structure of the robot. Minimum 
% radius of this unreachable region is also an important design parameter
% for the robot. To get the minimum and maximum radius from the point 
% cloud of workspace, select a slice of the workspace. Specify width of 
% the slice of the workspace.

% Width of slice
delta = 0.03;

%% Generate the volume sphere of the robot.
[outerParams, innerParams] = volumeSphereGen(robot, positionLimits, ...
    endEffectorName, numJoints, numRandomPoints, delta,'plot');


%% Plot the front and top view of the workspace. Envelope for front and
% top view of workspace are slices of the 3-dimensional workspace which
% enable you to determine the maximum and the minimum reach for the robot arm. 

% Generate the envelope of front-view
disp('Generate the envelope of front-view')

[pointsCoordinatesFront, ~] = envelopeFrontGen(robot, positionLimits, ...
    endEffectorName, numJoints, numRandomPoints);
% Select points that are near to the XZ plane
% The envelope is calculated at a HEIGHT from the PLANE, with a threshold of DELTA.
height = 0;
delta =  0.1;
pointsCoordinatesFront = pointsCoordinatesFront(pointsCoordinatesFront(:, 2) ...
    >= height - delta & pointsCoordinatesFront(:, 2) <= height + delta, :);
% Plot the Front view 
figure;
plot(pointsCoordinatesFront(:,1),pointsCoordinatesFront(:,3), 'o');
title('Front slice of robot workspace')
xlabel('X Axis (m)');
ylabel('Z Axis (m)');
axis square


% Generate the envelope of the top-view
disp('Generate the envelope of top-view')

[pointsCoordinatesTop, ~] = envelopeTopGen(robot, ...
    positionLimits, endEffectorName, numJoints, numRandomPoints, outerParams, innerParams);
% Select points that are near to the XY plane
% The envelope is calculated at a HEIGHT from the PLANE, with a threshold of DELTA.
height = mean([outerParams(2), innerParams(2)]);
delta =  max([0.06, abs(outerParams(2) - innerParams(2))]);
pointsCoordinatesTop = pointsCoordinatesTop(pointsCoordinatesTop(:, 3) ...
    >= height - delta & pointsCoordinatesTop(:, 3) <= height + delta, :);
%Plot Top View
figure;
plot(pointsCoordinatesTop(:,1),pointsCoordinatesTop(:,2), 'o');
title('Top slice of robot workspace')
xlabel('X Axis (m)');
ylabel('Y Axis (m)');
axis square




