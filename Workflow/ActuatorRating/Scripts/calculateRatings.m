function calculateRatings(data, numJoints, motionType, timeScale, outFilename)
% CALCULATERATINGS Calculate the motor ratings required at each joint of
% the articulated robot, and store the result
%   CALCULATERATINGS(DATA, NUMJOINTS, MOTIONTYPE, TIMESCALE,
%   OUTFILENAME) calculates the required parameters for the motors at each
%   joint of an articulated robot, using the array of structures in 
%   DATA, which is the recording from the simulation. Specify
%   MOTIONTYPE and OUTFILENAME as a string scalar or 
%   character vector.

% Copyright 2023 - 2024 The MathWorks, Inc.

    % Control whether overall maximums are calculated and stored
    overallMaxEnable = 0;

    % Read existing values if file exists
    % if isfile(outFilename)
    %     currDataInFile = load(outFilename);
    % else
    %     currDataInFile = [];
    % end
    ActuatorRating = {};
    tableHeadings = {"JointNumber", "MotionType", "CalculationType", ...
        "TimeScale", "MaximumTorque", "MaximumVelocity", "MaximumPower"};
    ActuatorRating = tableHeadings;

    % Find maximum power consumed from simulation
    for i = 1 : numJoints
        [maxPower, maxPowerIdx] = max(abs(data.simout(i).p.Data));
        tableData = {i, motionType, "Simulation Maximum", timeScale, ...
            data.simout(i).t.Data(maxPowerIdx), ...
            rad2deg(data.simout(i).w.Data(maxPowerIdx)), maxPower};
        ActuatorRating = [ActuatorRating;tableData];
    end

    
    % Add details of overall maximums
    if overallMaxEnable == 1
        for i = 1 : numJoints
            tableData = [i, motionType, "Overall Maximum", timeScale, ...
            max(abs(data.simout(i).t.Data)), rad2deg(max(abs(data.simout(i).w.Data))), ...
            max(abs(data.simout(i).t.Data)) * max(abs(data.simout(i).w.Data))];
        end
    end

    % Write table to file
    proj = currentProject;
    projPath=proj.RootFolder;
    filePath = fullfile(projPath,'/Workflow/ActuatorRating/Data/',outFilename);
    save(filePath,'ActuatorRating');
end

