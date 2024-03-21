function [wayPoints,eePositions] = createWaypoints(scenarioSelection,trajSelection,numPoints)
% Define waypoints and trajectory based on the provided scenario and
% trajectory type

% Copyright 2017-2024 The MathWorks, Inc.

%% Create waypoints 
% wayPoints are the XYZ coordinates for the trajectory waypoints
% waypointVels is the velocity of the end effector at the waypoints
switch scenarioSelection
    case 1 % % Stacking waypoints 1
                wayPoints = [0.3, 0, 0.630;
                    0.5, 0, 0.4;0.5, 0, 0.1; ...
                     0.5, 0, 0.2; ...
                     0.4, 0.1, 0.2; ...
                     0.4, 0.1, 0.16; ...
                     0.4, 0.1, 0.4];

        waypointTime = .5;
        wayPointVels = [0 0 0; 0 0 0; 0 0 0; 0 0 0; 0 0 0; 0 0 0;0 0 0];

    case 2 % Stacking waypoints 2
                wayPoints = [0.3, 0.1, 0.630; ...
                    0.4, 0.1, 0.4; ...
                    0.4, 0.1, 0.1; ...
                    0.4, 0.1, 0.2; ...
                    0.5, 0, 0.2; ...
                    0.5, 0, 0.16; ...
                    0.5, 0, 0.40];

        waypointTime = 0.5;
        wayPointVels = [0 0 0; 0 0 0; 0 0 0; 0 0 0; 0 0 0; 0 0 0;0 0 0];

    case 3 % % Stacking waypoints 3
                wayPoints = [0.3, 0, 0.630;
                             0.5, 0, 0.40;
                             0.5, 0, 0.1; ...
                             0.5, 0, 0.2; ...
                             0.5, 0.2, 0.2; ...
                             0.5, 0.2, 0.1; ...
                             0.5, 0.2, 0.2; ...
                             0.4, 0.1, 0.2; ...
                             0.4, 0.1, 0.1; ...
                             0.4, 0.1, 0.2; ...
                             0.5, 0.2, 0.2; ...
                             0.5, 0.2, 0.17; ...
                             0.5, 0.2, 0.4];

        waypointTime = .5;
        wayPointVels = [0 0 0; 0 0 0; 0 0 0; 0 0 0; 0 0 0; 0 0 0;0 0 0 ...
            ;0 0 0;0 0 0;0 0 0;0 0 0;0 0 0;0 0 0];

end

%% Use Robotics System Toolbox to create a trajectory from the waypoints
switch trajSelection
    case 1
        wpTimes = (0:size(wayPoints,1)-1)*waypointTime;
        trajTimes = linspace(0,wpTimes(end),numPoints);
        eePositions = cubicpolytraj(wayPoints',wpTimes,trajTimes,'VelocityBoundaryCondition',wayPointVels');

    case 2
        tWaypoints = [0,linspace(waypointTime/2,waypointTime,size(wayPoints,1)-1)];
        eePositions = pchip(tWaypoints,wayPoints',linspace(0,waypointTime,numPoints));

end

%% Set gripper state as 4th column of waypoints
if scenarioSelection == 3 % stacking case 3
    % Enable grip in 2 places
    wayPoints(:,4) = -1;
    wayPoints(3:5,4) = 1;
    wayPoints(9:11,4) = 1;
else
    % Enable grip between the two payloads
    wayPoints(:,4) = -1;
    wayPoints(3:5,4) = 1;
    
end

end

