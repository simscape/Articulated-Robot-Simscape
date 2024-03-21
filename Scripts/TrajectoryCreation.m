%% Script to create trajectory by defining waypoints and generating 
% joint configuration angles using inverse kinematic solver.
% Creates trajectory configuration for different stacking operation and
% saves trajectory in MAT-file for stacking model.

% Copyright 2023 - 2024 The MathWorks, Inc.


%% Waypoint definition 
numPoints = 300;

%% Three different waypoints are defined in this section for stacking operation. 
% Stacking 1 - Stack payload 1 on top of payload 2 location.
% Stacking 2 - Stack payload 2 on top of payload 1 location.

% Stacking 1 waypoints (X,Y,Z) coordinates
Stacking.wayPointsStacking1 = [0.3, 0, 0.630; ...
                               0.5, 0, 0.40; ...
                               0.5, 0, 0.1; ...
                               0.5, 0, 0.2; ...
                               0.4, 0.1, 0.2; ...
                               0.4, 0.1, 0.17; ...
                               0.4, 0.103, 0.4];

waypointTime = 1;
Stacking.waypointGrip1 = [-1;-1;1;1;1;-1;-1];
% Create trajectory for the waypoints 1
tWaypoints = [0,linspace(waypointTime/2,waypointTime,size(Stacking.wayPointsStacking1,1)-1)];
Stacking.eePositionsStacking1 = pchip(tWaypoints,Stacking.wayPointsStacking1',linspace(0,waypointTime,numPoints));


% Stacking 2  waypoints (X,Y,Z) coordinates

Stacking.wayPointsStacking2 = [0.3, 0.1, 0.630; ...
                               0.4, 0.1, 0.4; ...
                               0.4, 0.1, 0.1; ...
                               0.4, 0.1, 0.2; ...
                               0.5, 0, 0.2; ...
                               0.5, 0, 0.17; ...
                               0.5, 0, 0.40];
waypointTime = 1;
Stacking.waypointGrip2 = [-1;-1;1;1;1;-1;-1];
% Create trajectory for the waypoints 2
tWaypoints = [0,linspace(waypointTime/2,waypointTime,size(Stacking.wayPointsStacking2,1)-1)];
Stacking.eePositionsStacking2 = pchip(tWaypoints,Stacking.wayPointsStacking2',linspace(0,waypointTime,numPoints));



%% trajectory using cubic polynomial
% Example for Cubic polynomial trajectory
% wpTimes = (0:size(wayPoints,1)-1)*waypointTime;
% trajTimes = linspace(0,wpTimes(end),numPoints);
% [eePositions, eeVel, eeAcc] = cubicpolytraj(wayPoints',wpTimes,trajTimes,'VelocityBoundaryCondition',wayPointVels');



%% Kinematic Solver for inverse kinematics
% using simscape multibody kinematic sover

modelRobot = 'ParametricRobotModel';
load_system(modelRobot)
ks = simscape.multibody.KinematicsSolver(modelRobot,'DefaultAngleUnit','rad');

Stacking.trajectory1 = ksTrajectoryCreation(modelRobot, ks, Stacking.eePositionsStacking1);
Stacking.trajectory1(7,:) = -1; % Gripper action default open

ks = simscape.multibody.KinematicsSolver(modelRobot,'DefaultAngleUnit','rad');
Stacking.trajectory2 = ksTrajectoryCreation(modelRobot, ks, Stacking.eePositionsStacking2);
Stacking.trajectory2(7,:) = -1; % Gripper action default open


%% Set gripper position for trajectory

% Find points for gripper actions
Stacking.waypLoc1 = waypointLocation(Stacking.wayPointsStacking1, Stacking.eePositionsStacking1);
Stacking.waypLoc2 = waypointLocation(Stacking.wayPointsStacking2, Stacking.eePositionsStacking2);

% Set gripper action as per the stacking operation
% Set gripper action as per the stacking operation
for i = 1:size(Stacking.waypLoc1,2)-1
    Stacking.trajectory1(7,Stacking.waypLoc1(i):Stacking.waypLoc1(i+1)-1) ...
        = Stacking.waypointGrip1(i);
end

% Set gripper action as per the stacking operation
for i = 1:size(Stacking.waypLoc2,2)-1
    Stacking.trajectory2(7,Stacking.waypLoc2(i):Stacking.waypLoc2(i+1)-1) ...
        = Stacking.waypointGrip2(i);
end

%%  Save trajectory to mat file

[filepath,~,~] = fileparts(mfilename('fullpath'));
save([filepath '\robotTrajectoryConfig.mat'],"Stacking",'-append');