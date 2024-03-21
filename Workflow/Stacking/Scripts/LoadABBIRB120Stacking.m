% Set the reference model for the ABB IRB 120 robot subsystem
% reference ABBIRB120Robot

% Copyright 2023 - 2024 The MathWorks, Inc.


disp("Configuring the Stacking model with ABB IRB 120 robot...")

% Set reference subsystem for robot
robotSystem=find_system('StackingModel','Name', ...
    'Robot Arm');
set(getSimulinkBlockHandle(robotSystem),'ReferencedSubsystem', ...
    'ABBIRB120Robot');
% Load robot tree
run('CADRobotLoader');

%% Suppress library warnings
warning('off','Simulink:Commands:SetParamLinkChangeWarn')

%% Controller parameter settings

set_param('StackingModel/Control System/Controller/Inverse Kinematics', ...
    'robotTree','robotABB');
set_param('StackingModel/Control System/Controller/Inverse Kinematics/Inverse Kinematics', ...
    'EndEffector','Body7');
set_param('StackingModel/Control System/Controller/Inverse Kinematics', ...
    'EForient','[pi/2  0 -pi/2]');

set_param('StackingModel/Control System/Controller/Joint Controller Configuration Space', ...
    'robotTree','robotABB');
set_param('StackingModel/Control System/Controller/Joint Controller Configuration Space', ...
    'ExForce','zeros(6,8)');

%% Forward Kinematics block parameter settings
set_param('StackingModel/ForwarKinematics', ...
    'robotTree','robotABB');
set_param('StackingModel/ForwarKinematics/Get Transform', ...
    'SourceBody','Body7');

%% Library warnings reset
warning('on','Simulink:Commands:SetParamLinkChangeWarn')

