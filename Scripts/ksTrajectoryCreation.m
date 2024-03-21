function trajectory = ksTrajectoryCreation(rawRobot, ks, eePositions)
%% Script to create trajectory by defining waypoints and using 
% KinematicsSolver objects

% Copyright 2023 - 2024 The MathWorks, Inc.

%%

% Initialization
trajectory=[];

% Add frame variable for end effector relative to world
base = [rawRobot '/World Frame/W'];

follower = [rawRobot '/ParametricRobotSubsystem/F'];
addFrameVariables(ks,'HandL','Translation',base,follower);
addFrameVariables(ks,'HandL','Rotation',base,follower);

targetIDsL = ["HandL.Translation.x";"HandL.Translation.y";"HandL.Translation.z";"HandL.Rotation.x";"HandL.Rotation.y";"HandL.Rotation.z"];
addTargetVariables(ks,targetIDsL);

outputIDsL = ["j1.Rz.q";"j2.Rz.q";"j3.Rz.q";"j4.Rz.q";"j5.Rz.q";"j6.Rz.q"];
addOutputVariables(ks,outputIDsL);
addInitialGuessVariables(ks,outputIDsL);
initialGuess = [0 0 0 0 0 0];
eul = [pi 0 pi/2];
waypoints_ks = zeros(6, size(eePositions, 2));

for i = 1 : size(eePositions, 2)
    trvec = eePositions(:, i)';
    tform = [trvec eul];

    QSol = ks.solve(tform,initialGuess);

    waypoints_ks(:, i) = QSol;

    initialGuess = QSol;
end

trajectory=[waypoints_ks;zeros(1,size(waypoints_ks,2))];
end