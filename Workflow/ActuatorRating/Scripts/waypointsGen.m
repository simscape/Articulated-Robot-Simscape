function waypoints = waypointsGen(robot, endEffectorName, numJoints, pointsCoordinates, pointsOrientation)
% WAYPOINTSGEN Generate the waypoints/angles for each joint in the
% articulated robot, to follow a path
%   WAYPOINTS = WAYPOINTSGEN(ROBOT, ENDEFFECTORNAME, NUMJOINTS,
%   POINTSCOORDINATES, POINTSORIENTATION) returns the joint angles for each
%   target location specified by POINTSCOORDINATES and POINTSORIENTATION,
%   for the end effector of the ROBOT. Specify POINTSCOORDINATES and
%   POINTSORIENTATION as [NUMJOINTS, NUMPOINTS] arrays.

% Copyright 2023 The MathWorks, Inc.


    % Joint angles of all joints for trajectory
    waypoints = zeros(numJoints, size(pointsCoordinates, 1));
    
    ik = inverseKinematics('RigidBodyTree', robot);
    weights = [1e-2, 1e-2, 1e-2, 1, 1, 1];

    % Calaculate initial guess for trajectory
    initialGuess = robot.homeConfiguration;
    tform_trvec = trvec2tform(pointsCoordinates(1, :));
    tform_eul = eul2tform(pointsOrientation(1, :));
    tform = tform_trvec * tform_eul;
    QSol = ik(endEffectorName, tform, weights, initialGuess);
    initialGuess = QSol;

    % Suppress Inverse kinematics auto adjust warning
    warning('off','robotics:robotmanip:rigidbodytree:ConfigJointLimitsViolationAutoAdjusted');
    % Generate the joint angles for each coordinate in the trajectory
    for i = 1 : size(pointsCoordinates, 1)
        tform_trvec = trvec2tform(pointsCoordinates(i, :));
        tform_eul = eul2tform(pointsOrientation(i, :));
        tform = tform_trvec * tform_eul;
    
        QSol = ik(endEffectorName, tform, weights, initialGuess);
    
        waypoints(:, i) = QSol;
    
        initialGuess = QSol;
    end

end