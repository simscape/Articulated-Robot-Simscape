function [pointsCoordinates, pointsOrientation] = envelopeFrontGen(robot, positionLimits, endEffectorName, numJoints, numRandomPoints)
% ENVELOPEFRONTGEN Generate the envelope for the front-view of an
% articulated robot
%   [POINTSCOORDINATES, POINTSORIENTATION] = ENVELOPEFRONTGEN(ROBOT,
%   POSITIONLIMITS, ENDEFFECTORNAME, NUMJOINTS, NUMRANDOMPOINTS,
%   NUMREQUIREDPOINTS) returns the coordinates and orientation of the end
%   effector of the ROBOT, for the front-view envelope. Specify the
%   POSITIONLIMITS as a [NUMJOINTS, 2] array and ENDEFFECTORNAME as a string
%   scalar or character vector. Random distrubtion of NUMRANDOMPOINTS is
%   used to generate angles.

% Copyright 2023 The MathWorks, Inc.


% Control whether the 4th joint till the last joint are given random
% angles
randomJointAngleEnable = 0;

% Joint angles of all joints
jointConfig = zeros(numJoints, numRandomPoints);

% Coordinates and orientation of random target points generated
pointsCoordinates = zeros(numRandomPoints, 3);
pointsOrientation = zeros(numRandomPoints, 3);

% Set the joint angles for the 1st joint and the 4th joint till the
% last joint
jointConfig(1, :) = zeros(1, numRandomPoints);
if randomJointAngleEnable == 1
    for i = 4 : numJoints
        jointConfig(i, :) = positionLimits(i, 1) + (positionLimits(i, 2) - positionLimits(i, 1)) .* rand(1, numRandomPoints);
    end
else
    for i = 4 : numJoints
        jointConfig(i, :) = zeros(1, numRandomPoints);
    end
end


% Generate the joint angles for the 2nd and 3rd joint from linear
% distribtion
Q2 = linspace(positionLimits(2, 1),positionLimits(2, 2) ,100);
Q3 = linspace(positionLimits(3, 1),positionLimits(3, 2) ,100);
% nd grid for Q2 and Q3
[theta2,theta3] = ndgrid(Q2,Q3);

for i = 2 : 3
    jointConfig(i, :) = positionLimits(i, 1) + (positionLimits(i, 2) - positionLimits(i, 1)) .* rand(1, numRandomPoints);
end

for i = 1:size(theta2,1)
    for j = 1:size(theta2,2)
    jointConfig = [jointConfig [0 theta2(i,j) theta3(i,j) 0 0 0]'] ;
    end
end


% Get the end effector coordinates and orientation for each angle in
% the joint configuration
for i = 1 : size(jointConfig,2)
    tform = getTransform(robot, jointConfig(:, i), endEffectorName);
    pointsCoordinates(i, :) = tform2trvec(tform);
    pointsOrientation(i, :) = tform2eul(tform);
end
end

