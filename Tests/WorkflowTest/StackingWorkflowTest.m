classdef StackingWorkflowTest < InitializeTestForWorkflows & matlab.unittest.TestCase
    % The test class runs the scripts and functions associated with
    % Stacking Workflow and verify there are no warnings or errors when
    % files are executed.
    
    % Copyright 2023 - 2024 The MathWorks, Inc.

    methods (Test)

        function TestStackingWorkflowMLX(test)
            %The test runs the |.mlx| file and makes sure that there are
            %no errors or warning thrown.
            test.verifyWarningFree(@()runStackingWorkflow, '''StackingWorkflow'' |.mlx|  should execute without any warnings or errors.');
        end

    end

end

function runStackingWorkflow()
% Function runs the |.mlx| script.
StackingWorkflow;
end