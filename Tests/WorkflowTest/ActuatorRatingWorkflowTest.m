classdef ActuatorRatingWorkflowTest < InitializeTestForWorkflows & matlab.unittest.TestCase
    % The test class runs the scripts and functions associated with
    % Envolope and Rating Workflow and verify there are no warnings or
    % errors when files are executed.
    
    % Copyright 2023 - 2024 The MathWorks, Inc.

    methods (Test)

        function TestEnvelopeAndRatingWorkflowMLX(test)
            %The test runs the |.mlx| file and makes sure that there are
            %no errors or warning thrown.
            test.verifyWarningFree(@()runEnvelopeAndRatingWorkflow,...
                '''EnvelopeAndRatingWorkflow'' |.mlx|  should execute without any warnings or errors.');
        end

    end

end

function runEnvelopeAndRatingWorkflow()
% Function runs the |.mlx| script.
DetermineEnvelopeWorkflow;
end