classdef ParameterSensitivityAnalysisWorkflowTest < InitializeTestForWorkflows & matlab.unittest.TestCase
    % The test class runs the scripts and functions associated with
    % Parameter Sensitivity Analysis Workflow and verify there are no 
    % warnings or errors when files are executed.
    
    % Copyright 2023 - 2024 The MathWorks, Inc.

    methods (Test)

        function TestRobotParameterSensitivityAnalysisSetupMLX(test)
            %The test runs the |.mlx| file and makes sure that there are
            %no errors or warning thrown.
            test.verifyWarningFree(@()runRobotParameterSensitivityAnalysisSetup,...
                '''EnvelopeAndRatingWorkflow'' |.mlx|  should execute without any warnings or errors.');
        end

        function TestRobotMechParameterSensitivityWithSimscapeMLX(test)
            %The test runs the |.mlx| file and makes sure that there are
            %no errors or warning thrown.
            test.verifyWarningFree(@()runRobotMechParameterSensitivityWithSimscape,...
                '''EnvelopeAndRatingWorkflow'' |.mlx|  should execute without any warnings or errors.');
        end

    end

end

function runRobotParameterSensitivityAnalysisSetup()
% Function runs the |.mlx| script.
testScript = true; %#ok<NASGU> % Required to run script for less number of parameter space.
ParameterSensitivityAnalysisSetup;
end

function runRobotMechParameterSensitivityWithSimscape
% Function runs the |.mlx| script.
testScript = true; %#ok<NASGU> % Required to run script for less number of parameter space.
ParameterSensitivityAnalysisWorkflowTest;
end