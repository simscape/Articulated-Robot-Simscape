function table = tableActuatorRating(matFileFront,matFileTop)
% Generate table for joint actuator rating

% Copyright 2023 The MathWorks, Inc.

robotRating = load(matFileFront,'ActuatorRating');
ratingFront = robotRating.ActuatorRating;
robotRating = load(matFileTop,'ActuatorRating');
ratingTop = robotRating.ActuatorRating;
maxTorque = [];
maxVel = [];
maxPower = [];

for i = 2:4
    maxTorque(end+1) = max(abs(ratingFront{i,5}),abs(ratingTop{i,5}));
    maxVel(end+1) = max(abs(ratingFront{i,6}),abs(ratingTop{i,6}));
    maxPower(end+1) = max(abs(ratingFront{i,7}),abs(ratingTop{i,7}));
end    

table.Case     =  {'Joint','Max Torque (Nm)','Max Velocity (deg/s)','Max Power (W)'};
table.joint    =  ["Joint 1";"Joint 2";"Joint 3"];
table.torque   =  maxTorque';
table.vel   =  maxVel';
table.power    =  maxPower';
end