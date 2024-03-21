% Set the reference model for the CAD robot subsystem for actuator
% rating model
% reference ABBIRB120Robot

% Copyright 2023 - 2024 The MathWorks, Inc.


disp("Configuring the actuator rating model with Parametric robot...")

batteryBlock=find_system('ActuatorRatingModel','Name', ...
    'Robot Arm');
set(getSimulinkBlockHandle(batteryBlock),'ReferencedSubsystem', ...
    'ABBIRB120Robot');
