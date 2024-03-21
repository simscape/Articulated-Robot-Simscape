function plotMeasurements(data, numJoints, positionLimits, velocityLimits, waypoints, choiceTrajectory, plane, timeScale)
% PLOTMEASUREMENTS Plot the measurements from simulation of an articulated
% robot's envelope trajectory
%   PLOTMEASUREMENTS(DATA, NUMJOINTS, POSITIONLIMITS, VELOCITYLIMITS,
%   WAYPOINTS, CHOICETRAJECTORY, PLANE, TIMESCALE) plots the joint angles,
%   torques, velocities and power from the simulation data DATA. Specify 
%   CHOICETRAJECTORY and PLANE as a string scalar or character vector.
%   Specify POSITIONLIMITS and VELOCITYLIMITS as a [NUMJOINTS, 2] array and 
%   a [1, NUMJOINTS] vector, respectively. Specify WAYPOINTS as a
%   [NUMJOINTS, NUMPOINTS] array.

% Copyright 2023 The MathWorks, Inc.
    
    % Plot measurements of joint angle positions
    figure;
    
    for i = 1 : numJoints
        jointQ(i) = subplot(2, 3, i);
        hold on
    
        % Plot target angle markers
        plot((1 : length(waypoints)) .* timeScale, rad2deg(waypoints(i, :)), 'LineStyle', 'None', 'Marker', 'o', 'MarkerSize', 8, 'MarkerFaceColor', 'blue');
    
        % Plot actual path
        plot(data.simout(i).q.Time, rad2deg(squeeze(data.simout(i).q.Data)), 'LineStyle', '-', 'Color', 'black', 'LineWidth', 1.5);
    
        % Plot joint angle limits
        xMax = length(waypoints) * timeScale;
        yMin = rad2deg(positionLimits(i, 1));
        yMax = rad2deg(positionLimits(i, 2));
        plot([0, xMax], [yMin, yMin], 'LineStyle', '--', 'Color', 'magenta', 'LineWidth', 0.5);
        plot([0, xMax], [yMax, yMax], 'LineStyle', '--', 'Color', 'magenta', 'LineWidth', 0.5);
    
        title(['Joint ' num2str(i)]);
        xlabel('Simulation Time (s)');
        ylabel('Angle (deg)');
        xlim([0, xMax])
    
        hold off
    end
    str = ['Joint Angle Positions in ' convertStringsToChars(plane) ' plane'];
    sgtitle(str);
    linkaxes(jointQ,'y');
    fL = legend('Target Angle Markers', 'Actual Path', 'Joint Angle Limits');
    fL.Location = 'best';

    % Plot measurements of joint torques
    figure;
    
    for i = 1 : numJoints
        jointTq(i) = subplot(2, 3, i);
    
        % Plot torque
        plot(data.simout(i).t.Time, squeeze(data.simout(i).t.Data), 'LineStyle', '-', 'Color', 'black', 'LineWidth', 1.5);
    
        title(['Joint ' num2str(i)]);
        xlabel('Simulation Time (s)');
        ylabel('Torque (Nm)');
        xlim([0, (length(waypoints) * timeScale)])
    end
    
    str = ['Joint Torques in ' convertStringsToChars(plane) ' plane'];
    sgtitle(str);
    linkaxes(jointTq,'y');

    % Plot measurements of joint velocities
    figure;
    
    for i = 1 : numJoints
        jointVel(i) = subplot(2, 3, i);
        hold on
    
        % Plot velocities
        plot(data.simout(i).w.Time, rad2deg(squeeze(data.simout(i).w.Data)), 'LineStyle', '-', 'Color', 'black', 'LineWidth', 1.5);
    
        % Plot joint velocities limits
        xMax = length(waypoints) * timeScale;
        yMin = rad2deg(-1 * velocityLimits(i));
        yMax = rad2deg(velocityLimits(i));
        plot([0, xMax], [yMin, yMin], 'LineStyle', '--', 'Color', 'magenta', 'LineWidth', 0.5);
        plot([0, xMax], [yMax, yMax], 'LineStyle', '--', 'Color', 'magenta', 'LineWidth', 0.5);
    
        title(['Joint ' num2str(i)]);
        xlabel('Simulation Time (s)');
        ylabel('Velocity (deg/s)');
        xlim([0, xMax])
    
        hold off
    end
    str = ['Joint Velocities in ' convertStringsToChars(plane) ' plane'];
    sgtitle(str);
    linkaxes(jointVel,'y');
    fL = legend('Actual Velocity', 'Joint Velocity Limits');
    fL.Location = 'north';

    % Plot measurements of joint power consumed
    figure;
    
    for i = 1 : numJoints
        jointPw(i) = subplot(2, 3, i);
    
        % Plot torque
        plot(data.simout(i).p.Time, abs(squeeze(data.simout(i).p.Data)), 'LineStyle', '-', 'Color', 'black', 'LineWidth', 1.5);
    
        title(['Joint ' num2str(i)]);
        xlabel('Simulation Time (s)');
        ylabel('Power (W)');
        xlim([0, (length(waypoints) * timeScale)])
    end
    linkaxes(jointPw,'y');    
    str = ['Joint Power Consumed in ' convertStringsToChars(plane) ' plane'];
    sgtitle(str);
end

