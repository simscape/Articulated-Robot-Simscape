% This script loads the parameters for the Parametric Two Finger Gripper and Payloads.

% Copyright 2023 - 2024 The MathWorks, Inc.

%% Load parameters for Two Finger Gripper 
ParametricRobot.Gripper.FingerWidth = 3*0.02;                                           % Gripper finger width
ParametricRobot.Gripper.FingerLength = 1.2*2*0.03;                                      % Gripper finger length
ParametricRobot.Gripper.FingerMaxOpening = 2*0.028;                                     % Gripper finger width
ParametricRobot.Gripper.FingerColor = [0.2 0.1 0.8];                                    % Gripper finger color
ParametricRobot.Gripper.Density = 7780;                                                 % Gripper density
ParametricRobot.Gripper.JointStiffness = 1000;                                          % Spring stiffness of Prismatic Joint of gripper 
fingerPointCloudDensity = 6;                                                            % Gripper finger point cloud density

%% Load parameters for payloads 
ParametricRobot.Payloads.Length = 3*6*0.004;                                            % Payload length
ParametricRobot.Payloads.Width = 2*6*0.003;                                             % Payload width
ParametricRobot.Payloads.Thickness = 5*6*0.002;                                         % Payload thickness
ParametricRobot.Payloads.Density = 1000;                                                % Payload density
ParametricRobot.Payloads.Mass = ParametricRobot.Payloads.Length * ...
    ParametricRobot.Payloads.Width * ParametricRobot.Payloads.Thickness * ...
    ParametricRobot.Payloads.Density;                                                   % Payload mass
ParametricRobot.Payloads.Position1 = [0 0 0.5*ParametricRobot.Payloads.Thickness];      % Payload 1 position
ParametricRobot.Payloads.Position2 = [-0.1 0.1 0.5*ParametricRobot.Payloads.Thickness]; % Payload 2 position

pointCloudPayload = ...
    pointCloudDataBrick(ParametricRobot.Payloads.Length,...
    ParametricRobot.Payloads.Width,ParametricRobot.Payloads.Thickness,'full');          % Payload point cloud matrix

%% Calculate Gripper Finger Force or Grip Force
coeffStatFric = 0.5;                                                                    % Coefficient of static friction in Spatial Contact Force block
forceApplied = (ParametricRobot.Payloads.Mass*9.80665)/coeffStatFric;                   % Normal force applied by gripper on payload
forceRetention = 0.5*(ParametricRobot.Gripper.FingerMaxOpening - ...
    ParametricRobot.Payloads.Width)*ParametricRobot.Gripper.JointStiffness;             % Spring force or Retention force of Prismatic Joint between palm and fingers
gripForce = (forceRetention + forceApplied)*(1 + 0.2);                                  % 0.2 is a safety factor to ensure strong grip

