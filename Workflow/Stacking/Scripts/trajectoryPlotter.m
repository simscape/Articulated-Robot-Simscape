rateObj = rateControl(10);
%% Plot trajectory in figure 

% Copyright 2023 The MathWorks, Inc.
for i = 1 : size(waypoints,2)
    show(robot,waypoints(:,i));
    drawnow
    waitfor(rateObj);
end
