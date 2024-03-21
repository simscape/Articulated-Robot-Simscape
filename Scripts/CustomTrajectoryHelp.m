%% Custom Trajectory Generator App
% 
% This app saves the inverse kinematic solution of the robot arm trajectory 
% in a mat file used in the 'StackingRobotModel.slx' for simulating custom 
% trajectory for parametric robot. 
%
% You can give the 'Number of Waypoints' and the 'Number of Trajectory Points'
% as input. Data from 'robotTrajectoryConfig.mat' to populate the waypoints
% table which has (X,Y,Z) coordinate in (m) and the gripper action (-1 = Open, 1 = Close). 
% Cells in table can be edited, new rows can be added or deleted from the table. 
% Workspace Plot shows the 3D plot of the waypoints in order from the table, 
% cell selection highlights the waypoint in the plot for ease of tracking. 
%
% The 'Generate Trajectory' push button runs the script for IK solution for parametric 
% robot in the stacking model and saves solution in the mat file 'robotTrajectoryConfig'. 
%

% Copyright 2023-2024 The MathWorks, Inc.
