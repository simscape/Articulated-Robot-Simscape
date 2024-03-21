function [pointsCoordinates, pointsOrientation] = envelopeTopGen(robot, positionLimits, endEffectorName, numJoints, numRandomPoints, outerParams, innerParams)
% ENVELOPETOPGEN Generate the envelope for the top-view of an articulated
% robot
%   [POINTSCOORDINATES, POINTSORIENTATION] = ENVELOPETOPGEN(ROBOT,
%   POSITIONLIMITS, ENDEFFECTORNAME, NUMJOINTS, NUMRANDOMPOINTS,
%   OUTERPARAMS, INNERPARAMS) returns the coordinates and orientation of
%   the end effector of the ROBOT, for the top-view envelope. Random
%   distrubtion of NUMRANDOMPOINTS is used to generate angles. Specify the
%   POSITIONLIMITS as a [NUMJOINTS, 2] array and ENDEFFECTORNAME as a
%   string scalar or character vector. Specify OUTERPARAMS and INNERPARAMS
%   as a [1, 2] vector, with the radius and height for the respective
%   curve, in that order. 

% Copyright 2023 The MathWorks, Inc.


    % Control whether the 4th joint till the last joint are given random
    % angles
    randomJointAngleEnable = 0;

    % Joint angles of all joints
    jointConfig = zeros(numJoints, numRandomPoints);

    % Coordinates and orientation of random target points generated
    pointsCoordinates = zeros(numRandomPoints, 3);
    pointsOrientation = zeros(numRandomPoints, 3);

    % Find orientation of end effector in the home configuration, and use
    % the same for finding joint angles of the 2nd and 3rd joint
    tform = getTransform(robot, robot.homeConfiguration, endEffectorName);
    endEffectorConfig = tform2eul(tform);

    % Get the joint angles for the 2nd and 3rd joint for the outer curve
    % and inner curve
    jointConfigOuter = waypointsGen(robot, endEffectorName, numJoints, [outerParams(1), 0, outerParams(2)], endEffectorConfig);
    jointConfigInner = waypointsGen(robot, endEffectorName, numJoints, [innerParams(1), 0, innerParams(2)], endEffectorConfig);
    joint2Config = [min([jointConfigOuter(2), jointConfigInner(2)]), max([jointConfigOuter(2), jointConfigInner(2)])];
    joint3Config = [min([jointConfigOuter(3), jointConfigInner(3)]), max([jointConfigOuter(3), jointConfigInner(3)])];

    % Get the direction in which the joint angles change when going from
    % inner curve to outer curve
    if jointConfigInner(2) > jointConfigOuter(2)
        joint2ConfigDir = 'descend';
    else
        joint2ConfigDir = 'ascend';
    end
    if jointConfigInner(3) > jointConfigOuter(3)
        joint3ConfigDir = 'descend';
    else
        joint3ConfigDir = 'ascend';
    end

    % Set the joint angles for the 1st joint till the 3rd joint
    % The distribution is split into 4 sections, with 35% of points in the
    % outer curve, 15% of points in the inner curve, 15% of points in the
    % maximum limit of the 1st joint, 15% of points in the minimum limit of
    % the 1st joint and 20% of points randomly distributed within +/- 5
    % degrees of the limits
    rng("shuffle");
    jointConfig(1, :) = [linspace(positionLimits(1, 1), positionLimits(1, 2), numRandomPoints * 0.35), ... 
                        linspace(positionLimits(1, 1), positionLimits(1, 2), numRandomPoints * 0.15), ...
                        positionLimits(1, 2) .* ones(1, numRandomPoints * 0.15), ...
                        positionLimits(1, 1) .* ones(1, numRandomPoints * 0.15), ...
                        (positionLimits(1, 1) + deg2rad(5)) + ((positionLimits(1, 2) - deg2rad(5)) - (positionLimits(1, 1) + deg2rad(5))) .* rand(1, numRandomPoints * 0.20)];
    jointConfig(2, :) = [jointConfigOuter(2) .* ones(1, numRandomPoints * 0.35), ...
                        jointConfigInner(2) .* ones(1, numRandomPoints * 0.15), ...
                        sort(linspace(joint2Config(1), joint2Config(2), numRandomPoints * 0.15), joint2ConfigDir), ...
                        sort(linspace(joint2Config(1), joint2Config(2), numRandomPoints * 0.15), joint2ConfigDir), ...
                        sort((joint2Config(1) + deg2rad(5)) + ((joint2Config(2) - deg2rad(5)) - (joint2Config(1) + deg2rad(5))) .* rand(1, numRandomPoints * 0.20), joint2ConfigDir)];
    jointConfig(3, :) = [jointConfigOuter(3) .* ones(1, numRandomPoints * 0.35), ...
                        jointConfigInner(3) .* ones(1, numRandomPoints * 0.15), ...
                        sort(linspace(joint3Config(1), joint3Config(2), numRandomPoints * 0.15), joint3ConfigDir), ...
                        sort(linspace(joint3Config(1), joint3Config(2), numRandomPoints * 0.15), joint3ConfigDir), ...
                        sort((joint3Config(1) + deg2rad(5)) + ((joint3Config(2) - deg2rad(5)) - (joint3Config(1) + deg2rad(5))) .* rand(1, numRandomPoints * 0.20), joint3ConfigDir)];
    
    % Set the joint angles for the 4th joint till the last joint
    if randomJointAngleEnable == 1
        for i = 4 : numJoints
            rng("shuffle")
            jointConfig(i, :) = positionLimits(i, 1) + (positionLimits(i, 2) - positionLimits(i, 1)) .* rand(1, numRandomPoints);
        end
    else
        for i = 4 : numJoints
            jointConfig(i, :) = zeros(1, numRandomPoints);
        end
    end

    % Get the end effector coordinates and orientation for each angle in
    % the joint configuration
    for i = 1 : numRandomPoints
        tform = getTransform(robot, jointConfig(:, i), endEffectorName);
        pointsCoordinates(i, :) = tform2trvec(tform);
        pointsOrientation(i, :) = tform2eul(tform);
    end
end

