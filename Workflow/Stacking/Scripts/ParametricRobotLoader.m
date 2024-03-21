% Load the robot configuration

% Copyright 2023 - 2024 The MathWorks, Inc.

load_system('ParametricRobotModel.slx');
run('ParametricRobotParameters');
run('ParametricGripperPayloadsParameters');
[robotParametric,importInfo] = importrobot('ParametricRobotModel');
