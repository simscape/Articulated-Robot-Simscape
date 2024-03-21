% This script loads the parameters for the Parametric Robot.

% Copyright 2023 The MathWorks, Inc.

%% Load parameters for Rotating Base With Bracket 
% Base Cylinder
ParametricRobot.Robot.Base.Length = 0.29;
ParametricRobot.Robot.Base.Radius = 0.023/0.8;
ParametricRobot.Robot.Base.Mass = 6.215; % kg
ParametricRobot.Robot.Base.CM = [-0.0420, 8e-5, 0.0796]; % m
ParametricRobot.Robot.Base.MOI = [0.0247272, 0.0491285, 0.0472376]; %kg*m^2
ParametricRobot.Robot.Base.POI = [-8.0419e-06, 0.00130902, -8.0784e-05]; %kg*m^2
ParametricRobot.Robot.Base.Color = [0.8 0.4 0.2];

% Rotor
ParametricRobot.Robot.Rotor.Mass = 3.067;
ParametricRobot.Robot.Rotor.CM = [9.8e-5 1.2e-4 0.0218]; %[9.8e-5 1.2e-4 0.078];
ParametricRobot.Robot.Rotor.MOI = [0.0142175, 0.0144041, 0.0104533];
ParametricRobot.Robot.Rotor.POI = [1.93404e-05, -2.31364e-05, -1.28579e-05];
ParametricRobot.Robot.Rotor.Color = [0.7 0.7 0.9];

%% Load parameters for Link 1
ParametricRobot.Robot.Link1.Length = 0.27;
ParametricRobot.Robot.Link1.Radius = 0.023;
ParametricRobot.Robot.Link1.Mass = 3.909;
ParametricRobot.Robot.Link1.CM = [7.8e-4, -0.0021, 0.0338]; %[7.8e-4, -0.0021, 0.0733];
ParametricRobot.Robot.Link1.MOI = [0.0603111, 0.041569, 0.0259548];
ParametricRobot.Robot.Link1.POI = [-0.00050497, 5.72407e-05, 9.834310000000001e-06];
ParametricRobot.Robot.Link1.Color = [0.5 0.5 0.88];

%% Load parameters for Link 2 
ParametricRobot.Robot.Link2.VerticalLength = 0.07;
ParametricRobot.Robot.Link2.HorizontalLength = 0.134;
ParametricRobot.Robot.Link2.Radius = 0.023;
ParametricRobot.Robot.Link2.Mass = 2.944;
ParametricRobot.Robot.Link2.CM = [-0.0228, 0.0011, -0.0264]; %[0.0228, 0.0011, 0.0394];
ParametricRobot.Robot.Link2.MOI = [0.00835606, 0.016713, 0.0126984];
ParametricRobot.Robot.Link2.POI = [-0.000182227, 0.00142884, -8.01545e-05];
ParametricRobot.Robot.Link2.Color = [0.5 0.5 0.88];

%% Load parameters for Link 3 
ParametricRobot.Robot.Link3.Length = (0.302 - 0.134);
ParametricRobot.Robot.Link3.Radius = 0.023; 
ParametricRobot.Robot.Link3.Mass = 1.328;
ParametricRobot.Robot.Link3.CM = [1.5e-4, 4.1e-4, 0.0124]; %[0.0784, 1.5e-4, 4.1e-4];
ParametricRobot.Robot.Link3.MOI = [0.00284661, 0.00401346, 0.0052535];
ParametricRobot.Robot.Link3.POI = [1.31336e-05, -1.6435e-05, -2.12765e-05];
ParametricRobot.Robot.Link3.Color = [0.5 0.5 0.88];

%% Load parameters for Link 4 
ParametricRobot.Robot.Link4.Length = 0.042;
ParametricRobot.Robot.Link4.Radius = 0.023; 
ParametricRobot.Robot.Link4.Mass = 0.546;
ParametricRobot.Robot.Link4.CM = [3.7e-5, 6.2e-5, 0.0278]; %[-0.0192, 3.7e-5, 6.2e-5];
ParametricRobot.Robot.Link4.MOI = [0.000404891, 0.000892825, 0.000815468]; 
ParametricRobot.Robot.Link4.POI = [-1.51792e-08, 8.46805e-07, 1.61943e-06];
ParametricRobot.Robot.Link4.Color = [0.5 0.5 0.88];

%% Load parameters for Link 5 
ParametricRobot.Robot.Link5.Length = (0.072 - 0.042);
ParametricRobot.Robot.Link5.Radius = 0.023;
ParametricRobot.Robot.Link5.Mass = 0.137;
ParametricRobot.Robot.Link5.CM = [-1.7e-4, -1e-6, -0.0051]; %[0.0161, -1.7e-4, -1e-6];
ParametricRobot.Robot.Link5.MOI = [0.001, 0.001, 0.001];
ParametricRobot.Robot.Link5.POI = [0, 0, 0];
ParametricRobot.Robot.Link5.Color = [0.5 0.5 0.88];
