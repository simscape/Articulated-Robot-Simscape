function jointDataBus = jointDataBus
% Set up the Simulink model parameters for jointDataBus

% Copyright 2023 The MathWorks, Inc.

jointDataBus = Simulink.Bus;
jointDataBus.Description = '';
jointDataBus.DataScope = 'Auto';
jointDataBus.HeaderFile = '';
jointDataBus.Alignment = -1;

jointDataNames = ['q', 't', 'w'];
for i = 1 : length(jointDataNames)
    jointDataBus.Elements(i) = Simulink.BusElement;
    jointDataBus.Elements(i).Name = jointDataNames(i);
    jointDataBus.Elements(i).Complexity = 'real';
    jointDataBus.Elements(i).Dimensions = 1;
    jointDataBus.Elements(i).DataType = 'double';
    jointDataBus.Elements(i).Min = [];
    jointDataBus.Elements(i).Max = [];
    jointDataBus.Elements(i).DimensionsMode = 'Fixed';
    jointDataBus.Elements(i).SamplingMode = 'Sample based';
    jointDataBus.Elements(i).SampleTime = -1;
    jointDataBus.Elements(i).DocUnits = '';
    jointDataBus.Elements(i).Description = '';
end
end