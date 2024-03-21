function [ParametricRobotSensitivity] = parametricRobotSensitivityTornadoPlot(data)
% PARAMETRICROBOTSENSITIVITYTORNADOPLOT This function plots the 
% sensitivities as a tornado plot with the sensitivity table obtained from 
% sdo.analyze as an input.
%

% Copyright 2023 - 2024 The MathWorks, Inc.

if istable(data)
    
    ParametricRobotSensitivity = figure('Name', data.Properties.Description);
    for ii = 1:length(data.Properties.VariableNames)
        subplot(length(data.Properties.VariableNames),1,ii);
        barh(data.(data.Properties.VariableNames{ii}),'BaseValue',0);
        xlim([-1 1]);
        yticklabels(data.ParameterName);
        title(data.Properties.VariableNames{ii});
    end
    sgtitle(data.Properties.Description);

elseif isstruct(data)

    analysisData =fieldnames(data);
    ParametricRobotSensitivity = zeros(length(analysisData));
    for jj = 1: length(analysisData)

        ParametricRobotSensitivity(jj) = figure('Name', data.(analysisData{jj}).Properties.Description);
        for ii = 1:length(data.(analysisData{jj}).Properties.VariableNames)
            subplot(length(data.(analysisData{jj}).Properties.VariableNames),1,ii);
            barh(data.(analysisData{jj}).(data.(analysisData{jj}).Properties.VariableNames{ii}),'BaseValue',0);
            xlim([-1 1]);
            yticklabels(data.(analysisData{jj}).ParameterName);
            title(data.(analysisData{jj}).Properties.VariableNames{ii});
        end
        sgtitle(data.(analysisData{jj}).Properties.Description);
    end
end
