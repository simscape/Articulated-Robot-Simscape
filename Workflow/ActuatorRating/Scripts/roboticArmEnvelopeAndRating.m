function [] = roboticArmEnvelopeAndRating(modelRobot,modelName,endEffectorName,simTime)
% roboticArmEnvelopeAndRating - This function is used for creating the envelope 
% of a robotic arm and calculating actuator ratings.
% Inputs:
%   modelRobot - The robot subsystem to get the rigidbody tree.
%   modelName - The model for actuator rating with payload.
%   endEffectorName - The name of the end effector.
%   simTime - Simulation time for traversing the envelope
% Output:
%   The function saves the calculated rating in a mat file.

% Copyright 2023 - 2024 The MathWorks, Inc.

% Initialize variables
positionLimits = [];
pointsOrientationFront =[];
pointsOrientationFront = [];
waypoints = [];
pointsCoordinatesTop = [];
pointsOrientationTop = [];

% Import the robot
load_system(modelRobot)
robot = importrobot(modelRobot);
close_system(modelRobot);

robot.DataFormat = 'column';

% Read the position limits of all joints in the robot
positionLimits = cellfun(@(x) x.Joint.PositionLimits, robot.Bodies, 'UniformOutput', false);

% Remove the joints that do not have any position limits
positionLimits(cell2mat(cellfun(@(x) x(1) == 0 && x(2) == 0, positionLimits, 'UniformOutput', false))) = [];

% Reshape the position limits to [numJoints, 2]
positionLimits = reshape(cell2mat(positionLimits), 2, length(positionLimits))';

% Read the velocity limits of all joints from the datasheet
velocityLimits = deg2rad([250; 250; 250; 320; 320; 420]);

% Extract the number of joints of the robot
numJoints = length(positionLimits);

% Select the envelope parameters
numRandomPoints = 20000;

% Select the simulation parameters
% Trajectory options: "Trapezoidal Velocity Profile Trajectory", 
% "Polynomial Trajectory", "Minimum Jerk Polynomial Trajectory" and 
% "Minimum Snap Polynomial Trajectory"
choiceTrajectory = "Minimum Jerk Polynomial Trajectory";

% Joint data bus
jointDataBus = jointDataBusCreator;

% Generate the volume sphere of the robot
disp('Generate the volume sphere of the robot')
delta = 0.03;
[outerParams, innerParams] = volumeSphereGen(robot, positionLimits, endEffectorName, numJoints, numRandomPoints, delta);

% Generate the envelope of front-view
disp('Generate the envelope of front-view')
[pointsCoordinatesFront, pointsOrientationFront] = envelopeFrontGen(robot, positionLimits, endEffectorName, numJoints,  1);

% Generate the boundary of front-view
disp('Generate the boundary of front-view')
plane = "XZ";
height = 0;
delta =  1e-10;

% Convex Hull for front outer boundary
[pointsCoordinatesFront, pointsOrientationFront] = convexBoundary(pointsCoordinatesFront, pointsOrientationFront, plane, height, delta);


% Generate the waypoints for front-view motion
disp('Generate the waypoints for front-view motion')
waypoints = waypointsGen(robot, endEffectorName, numJoints, pointsCoordinatesFront, pointsOrientationFront);
waypoints(4:end,:) = 0; % Make joint other than 1-3 as zero
waypoints(:,1) = []; % Remove the initial solution 

% Simulate the front-view motion
% Simulation input

simIn = Simulink.SimulationInput(modelName);
timeScale = simTime / length(waypoints); 
SimT = length(waypoints) * timeScale - 2*timeScale;
simIn = setModelParameter(simIn,"StopTime",string(SimT)); % Set stop time for simulation
simIn = setVariable(simIn,"waypoints",waypoints);
simIn = setVariable(simIn,'timeScale',timeScale);
simIn = setVariable(simIn,'choiceTrajectory',choiceTrajectory);
simIn = setVariable(simIn,'positionLimits',positionLimits);
simIn = setVariable(simIn,'jointDataBus',jointDataBus);
simIn = setVariable(simIn,'velocityLimits',velocityLimits);
simIn = setVariable(simIn,'ParametricRobot.Payloads.Density',12000);

warning('off','MATLAB:timeseries:timeseries:VEDeprecate');
ParamRobotOut = sim(simIn);
  
% Calculate the power consumed by each joint from the simulation of the
% PrePreProcess data to remove initial velocity and torque spike
% front-view motion
disp('Calculate the power consumed by each joint from the simulation of')
for i = 1 : numJoints
    % Remove element before the first time step
    timeIndex = find(ParamRobotOut.tout  < timeScale);
    ParamRobotOut.simout(i).q = ParamRobotOut.simout(i).q.delsample('Index',timeIndex);
    ParamRobotOut.simout(i).t = ParamRobotOut.simout(i).t.delsample('Index',timeIndex);
    ParamRobotOut.simout(i).w = ParamRobotOut.simout(i).w.delsample('Index',timeIndex);
    % Calculate power 
    ParamRobotOut.simout(i).p = ParamRobotOut.simout(i).t;
    ParamRobotOut.simout(i).p.Data = ParamRobotOut.simout(i).t.Data .* ParamRobotOut.simout(i).w.Data;
end

disp('Plot the measurements of the simulation of the front-view motion')
% Plot the measurements of the simulation of the front-view motion
plotMeasurements(ParamRobotOut, numJoints, positionLimits, velocityLimits, waypoints, choiceTrajectory, plane, timeScale);

% Calculate the motor ratings of the front-view motion
calculateRatings(ParamRobotOut, numJoints, plane, timeScale, ["ratingsFront" + modelRobot  + ".mat"]);

% Generate the envelope of the top-view
disp('Generate the envelope of top-view')
[pointsCoordinatesTop, pointsOrientationTop] = envelopeTopGen(robot, positionLimits, endEffectorName, numJoints, numRandomPoints, outerParams, innerParams);

% Generate the boundary of the top-view
disp('Generate the boundary of the top-view')
plane = "XY";
height = mean([outerParams(2), innerParams(2)]); % Height for top view
delta =  max([0.3, abs(outerParams(2) - innerParams(2))]); % thickness of slice
shrinkFactor = 1; % Boundary function shrink factor
numRequiredPoints = 200; % Number of points for boundary
[pointsCoordinatesTop, pointsOrientationTop] = boundaryPathGen(pointsCoordinatesTop, pointsOrientationTop, plane, height, delta, shrinkFactor, numRequiredPoints);

% Generate the waypoints for the top-view motion
disp('Generate the waypoints for top-view motion')
waypoints = waypointsGen(robot, endEffectorName, numJoints, pointsCoordinatesTop, pointsOrientationTop);
waypoints(4:end,:) = 0; % Make joint other than 1-3 as zero
waypoints(:,1) = []; % Remove the initial solution 

% Simulate the top-view motion
disp('Simulate the top-view motion')
timeScale = simTime*2 / length(waypoints); 
SimT = length(waypoints) * timeScale  - 2*timeScale;

simIn = setModelParameter(simIn,"StopTime",string(SimT)); % Set stop time for simulation
simIn = setVariable(simIn,"waypoints",waypoints);
simIn = setVariable(simIn,'timeScale',timeScale);
simIn = setVariable(simIn,'choiceTrajectory',choiceTrajectory);
simIn = setVariable(simIn,'ParametricRobot.Payloads.Density',12000);

CADRobotOut = sim(simIn);

% Calculate the power consumed by each joint from the simulation of the
% PrePreProcess data to remove initial velocity and torque spike
% top-view motion

for i = 1 : numJoints
    % Remove element before the first time step
    timeIndex = find(CADRobotOut.tout  < timeScale);
    CADRobotOut.simout(i).q = CADRobotOut.simout(i).q.delsample('Index',timeIndex);
    CADRobotOut.simout(i).t = CADRobotOut.simout(i).t.delsample('Index',timeIndex);
    CADRobotOut.simout(i).w = CADRobotOut.simout(i).w.delsample('Index',timeIndex);
    % Calculate power 
    CADRobotOut.simout(i).p = CADRobotOut.simout(i).t;
    CADRobotOut.simout(i).p.Data = CADRobotOut.simout(i).t.Data .* CADRobotOut.simout(i).w.Data;
end



% Plot the measurements of the simulation of the top-view motion
plotMeasurements(CADRobotOut, numJoints, positionLimits, velocityLimits, waypoints, choiceTrajectory, plane, timeScale);

% Calculate the motor ratings of the top-view motion
calculateRatings(CADRobotOut, numJoints, plane, timeScale, "ratingsTop" + modelRobot  + ".mat");