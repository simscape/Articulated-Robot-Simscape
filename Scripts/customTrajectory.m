function customTrajectory(CustomWayPoints,numPoints,Stacking)
%% Script to create trajectory by defining waypoints and generating 
% joint configuration angles using inverse kinematic solver.
% Creates trajectory for different stacking operations and save trajectory
% in MAT-file for stacking model.

% Copyright 2023 - 2024 The MathWorks, Inc.


%% Waypoint definition 
% Custom waypoints are defined in this section for stacking operation. 
% Custom waypoints (X,Y,Z) coordinates Set using CustomTrajectoryApp
Stacking.wayPointsStackingCustom = CustomWayPoints(:,1:3);
waypointTime = 0.1;
Stacking.waypointGripCustom = CustomWayPoints(:,4);

% Create trajectory for the waypoints 3
% tWaypoints = [0,linspace(waypointTime/2,waypointTime,...
%     size(Stacking.wayPointsStackingCustom,1)-1)];
% Stacking.eePositionsStackingCustom = pchip(tWaypoints,...
%     Stacking.wayPointsStackingCustom',linspace(0,waypointTime,numPoints));
% 
% 

%% trajectory using cubic polynomial
% Example for Cubic polynomial trajectory
wpTimes = (0:size(Stacking.wayPointsStackingCustom,1)-1)*waypointTime;
trajTimes = linspace(0,wpTimes(end),numPoints);
[Stacking.eePositionsStackingCustom, eeVel, eeAcc] = cubicpolytraj(Stacking.wayPointsStackingCustom',wpTimes,trajTimes);



%% Kinematic Solver for inverse kinematics
% using Simscape Multibody kinematic solver
disp('Generating trajectory')
modelRobot = 'ParametricRobotModel';
load_system(modelRobot)

ks = simscape.multibody.KinematicsSolver(modelRobot,'DefaultAngleUnit','rad');
Stacking.trajectoryCustom = ksTrajectoryCreation(modelRobot, ks, ...
    Stacking.eePositionsStackingCustom);
Stacking.trajectoryCustom(7,:) = -1; % Gripper action default open


%% Set gripper position for trajectory

% Find points for gripper actions

Stacking.waypLocCustom = waypointLocation(Stacking.wayPointsStackingCustom,...
    Stacking.eePositionsStackingCustom);

% Set gripper action as per the stacking operation
for i = 1:size(Stacking.waypLocCustom,2)-1
    Stacking.trajectoryCustom(7,Stacking.waypLocCustom(i):Stacking.waypLocCustom(i+1)-1) ...
        = Stacking.waypointGripCustom(i);
end

%%  Save trajectory to mat file
disp('Done')
[filepath,~,~] = fileparts(mfilename('fullpath'));
save([filepath '/robotTrajectoryConfig.mat'],'Stacking','-append');

end