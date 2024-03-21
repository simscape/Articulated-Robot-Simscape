function h = plotCircle(x,y,r)
% Function to plot workspace reach

% Copyright 2023 The MathWorks, Inc.

hold on
th = 0:pi/50:2*pi;
xunit = r * cos(th) + x;
yunit = r * sin(th) + y;
h = plot(xunit, yunit);
hold off