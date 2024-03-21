% Set the reference model for the parametric robot subsystem
% reference ParametricRobotSubsystem

% Copyright 2023 - 2024 The MathWorks, Inc.


disp("Configuring the Stacking model with Parametric robot...")

robotSystem=find_system('StackingModel','Name', ...
    'Robot Arm');
set(getSimulinkBlockHandle(robotSystem),'ReferencedSubsystem', ...
    'ParametricRobotSubsystem');

run('ParametricRobotLoader');
run('ParametricRobotParameters');
run('ParametricGripperPayloadsParameters');

%% Suppress library warnings
warning('off','Simulink:Commands:SetParamLinkChangeWarn')

%% Controller parameter settings
set_param('StackingModel/Control System/Controller/Inverse Kinematics', ...
    'robotTree','robotParametric');
set_param('StackingModel/Control System/Controller/Inverse Kinematics/Inverse Kinematics', ...
    'EndEffector','Body6');
set_param('StackingModel/Control System/Controller/Inverse Kinematics', ...
    'EForient','[pi 0 pi]');

set_param('StackingModel/Control System/Controller/Joint Controller Configuration Space', ...
    'robotTree','robotParametric');
set_param('StackingModel/Control System/Controller/Joint Controller Configuration Space', ...
    'ExForce','zeros(6,6)');

%% Forward Kinematics block parameter settings
set_param('StackingModel/ForwarKinematics', ...
    'robotTree','robotParametric');
set_param('StackingModel/ForwarKinematics/Get Transform', ...
    'SourceBody','Body6');

%% Library warnings reset
warning('on','Simulink:Commands:SetParamLinkChangeWarn')
