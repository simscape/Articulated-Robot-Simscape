function [radiusOutput] = parametricRobotSensitivityReachObjective(parameterVector, ExperimentObject, numRandomPoints, positionLimits)
% PARAMETRICROBOTSENSITIVITYREACHOBJECTIVE Evaluate robot horizontal reach 
% objective function for a parameter sensitivity analysis.
%
% Inputs:
%   parameterVector - vector of parameters and/or states
%   ExperimentObject - Experiment object
%   numRandomPoints - number of random points to generate angles
%   positionLimits - matrix of joint angular position limits
%

% Copyright 2023 - 2024 The MathWorks, Inc.

%% Envelope Determination - Outer Radius (Horizontal Reach) and Inner Radius (Unreachable Radius)

ExperimentObject = setEstimatedValues(ExperimentObject, parameterVector);   % use vector of parameters/states

% Iteration count
if evalin('base','exist("counter","var")')
    counter = evalin('base','counter');
    counter=counter+1;
else
    counter=1;
end
assignin('base','counter',counter)
%disp(['Iteration no ' , num2str(counter)])
save('LastLogFile.mat','counter')

% Setting parameters in robot model
basePath = [ExperimentObject.ModelName,'/ParametricRobotSubsystem/Rotating Base With Bracket'];
link1Path = [ExperimentObject.ModelName,'/ParametricRobotSubsystem/Link1'];
link2Path = [ExperimentObject.ModelName,'/ParametricRobotSubsystem/Link2'];
link3Path = [ExperimentObject.ModelName,'/ParametricRobotSubsystem/Link3'];
link4Path = [ExperimentObject.ModelName,'/ParametricRobotSubsystem/Link4'];
link5Path = [ExperimentObject.ModelName,'/ParametricRobotSubsystem/Link5'];

set_param(basePath,'baseTotalLength',num2str(ExperimentObject.Parameters(1,1).Value));
set_param(link1Path,'linkLength',num2str(ExperimentObject.Parameters(2,1).Value));
set_param(link2Path,'member1TotalLength',num2str(ExperimentObject.Parameters(3,1).Value));
set_param(link2Path,'member2TotalLength',num2str(ExperimentObject.Parameters(4,1).Value));
set_param(link3Path,'linkLength',num2str(ExperimentObject.Parameters(5,1).Value));
set_param(link4Path,'linkLength',num2str(ExperimentObject.Parameters(6,1).Value));
set_param(link5Path,'linkLength',num2str(ExperimentObject.Parameters(7,1).Value));

% Creates a KinematicsSolver object for the robot model suitable for kinematic analysis
robot = ExperimentObject.ModelName;
ks = simscape.multibody.KinematicsSolver(robot,'DefaultAngleUnit','rad');

% List joints
ks.jointPositionVariables;

% Add frame variable for end effector relative to world
base = [robot '/World Frame/W'];
follower = [robot '/ParametricRobotSubsystem/Link3/R'];
addFrameVariables(ks,'HandL','Translation',base,follower);
addFrameVariables(ks,'HandL','Rotation',base,follower);
frameVariables(ks);
targetIDsL = ["j1.Rz.q";"j2.Rz.q";"j3.Rz.q";"j4.Rz.q";"j5.Rz.q";"j6.Rz.q"];
addTargetVariables(ks,targetIDsL);
jointPositionVariables(ks);
outputIDsL = ["HandL.Translation.x";"HandL.Translation.y";"HandL.Translation.z"];
addOutputVariables(ks,outputIDsL);

delta = 0.03;
% Extract the number of joints of the robot
numJoints = length(positionLimits);
for i = 1 : numJoints
    jointConfig(i, :) = positionLimits(i, 1) + (positionLimits(i, 2) - ...
        positionLimits(i, 1)) .* rand(1, numRandomPoints);
end
pointsCoordinates = zeros(numRandomPoints, 3);

for i = 1 : numRandomPoints
    Psol = ks.solve(jointConfig(:, i));
    pointsCoordinates(i, :) = Psol';
end

% Find the outer radius of the volume sphere
% Positive X axis
[maxXPoint, maxXPointIdx] = max(pointsCoordinates(:, 1));
maxXPointZ = pointsCoordinates(maxXPointIdx, 3);

% Negative X axis
[maxNXPoint, maxNXPointIdx] = min(pointsCoordinates(:, 1));
maxNXPointZ = pointsCoordinates(maxNXPointIdx, 3);

% Positive Y axis
[maxYPoint, maxYPointIdx] = max(pointsCoordinates(:, 2));
maxYPointZ = pointsCoordinates(maxYPointIdx, 3);

% Negative Y axis
[maxNYPoint, maxNYPointIdx] = min(pointsCoordinates(:, 2));
maxNYPointZ = pointsCoordinates(maxNYPointIdx, 3);

outerRadius = max(abs([maxXPoint, maxNXPoint, maxYPoint, maxNYPoint]));
outerRadiusHeight = mean([maxXPointZ, maxNXPointZ, maxYPointZ, maxNYPointZ]);

% Find the inner radius of the volume sphere
% Positive X axis
subPoints = pointsCoordinates(pointsCoordinates(:, 1) >= 0 & pointsCoordinates(:, 2) >= 0 - delta & pointsCoordinates(:, 2) <= 0 + delta & pointsCoordinates(:, 3) >= outerRadiusHeight - delta & pointsCoordinates(:, 3) <= outerRadiusHeight + delta, :);
[minXPoint, minXPointIdx] = min(abs(subPoints(:, 1)));
minXPointZ = subPoints(minXPointIdx, 3);

% Negative X axis
subPoints = pointsCoordinates(pointsCoordinates(:, 1) <= 0 & pointsCoordinates(:, 2) >= 0 - delta & pointsCoordinates(:, 2) <= 0 + delta & pointsCoordinates(:, 3) >= outerRadiusHeight - delta & pointsCoordinates(:, 3) <= outerRadiusHeight + delta, :);
[minNXPoint, minNXPointIdx] = min(abs(subPoints(:, 1)));
minNXPointZ = subPoints(minNXPointIdx, 3);

% Positive Y axis
subPoints = pointsCoordinates(pointsCoordinates(:, 2) >= 0 & pointsCoordinates(:, 1) >= 0 - delta & pointsCoordinates(:, 1) <= 0 + delta & pointsCoordinates(:, 3) >= outerRadiusHeight - delta & pointsCoordinates(:, 3) <= outerRadiusHeight + delta, :);
[minYPoint, minYPointIdx] = min(abs(subPoints(:, 2)));
minYPointZ = subPoints(minYPointIdx, 3);

% Negative Y axis
subPoints = pointsCoordinates(pointsCoordinates(:, 2) <= 0 & pointsCoordinates(:, 1) >= 0 - delta & pointsCoordinates(:, 1) <= 0 + delta & pointsCoordinates(:, 3) >= outerRadiusHeight - delta & pointsCoordinates(:, 3) <= outerRadiusHeight + delta, :);
[minNYPoint, minNYPointIdx] = min(abs(subPoints(:, 2)));
minNYPointZ = subPoints(minNYPointIdx, 3);

innerRadius = min([minXPoint, minNXPoint, minYPoint, minNYPoint]);
innerRadiusHeight = mean([minXPointZ, minNXPointZ, minYPointZ, minNYPointZ]);

outerParams = [outerRadius, outerRadiusHeight];
innerParams = [innerRadius, innerRadiusHeight];

outerRadius = outerParams(1);
innerRadius = innerParams(1);

radiusOutput.radius(1) = innerRadius;
radiusOutput.radius(2) = outerRadius;

end