function waypLoc = waypointLocation(wayPoints,eePositions)
% Function gives the index of waypoints in trajectory

% Copyright 2023 - 2024 The MathWorks, Inc.

eepositionStart=1; % Start row of end effector positions
waypLoc = zeros(1,length(wayPoints));
waypLoc(1,1) = 1; % First waypoint location 

for i=2:length(wayPoints)
    tol = abs(eePositions - wayPoints(i,:)'); 
    tol(:,1:eepositionStart) = tol(:,1:eepositionStart)+10;
    findLoc = find(ismember((tol<0.01)',[1,1,1],'rows')); % Find points which are close to the waypoints
    if all(diff(findLoc)==1)
        findLoc;
    else
        consecWayp = diff([0,diff(findLoc')==1,0]); % find the consecutive points near waypoints
        % Take the first group of consecutive points for solution
        startLoc = findLoc(consecWayp>0);
        endLoc  = findLoc(consecWayp<0);
        findLoc = [startLoc(1):endLoc(1)];
    end
    RowSum = sum(tol(:,findLoc),1); 
    [MinRowSum,RowNr] = min(RowSum); 
    waypLoc(1,i) =findLoc(RowNr);
    eepositionStart = findLoc(RowNr); % set the new location for tolerance check
end
end