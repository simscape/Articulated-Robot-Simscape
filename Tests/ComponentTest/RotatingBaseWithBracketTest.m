classdef RotatingBaseWithBracketTest < matlab.unittest.TestCase
    % The test locks down the "Rotating Base With Bracket" block behavior. 
    % The test sets up a test harness model with the Rotating Base With 
    % Bracket block connected to a World Frame block. The test verifies 
    % that the harness model set with default values of block 
    % parameters simulates without any errors or warnings. The test also 
    % verifies that the harness model set with custom values of block 
    % parameters simulates without any errors or warnings.
	
	% Copyright 2023 - 2024 The MathWorks, Inc.

    properties
        % Model and Block under test
        modelname = 'testModelTemplate';
        blockname = 'Rotating Base With Bracket';

        % Source block
        sourceBlock = 'LinkLib/Rotating Base With Bracket';
        blockpath;
    end

    properties (TestParameter)

        % Dropdown options for 'connConfig' parameter
        connConfig = {  'Single bracket',...
            'Double bracket with pin'   };

        % Dropdown options for 'inertiaType' parameter
        inertiaType = {'Calculate from Geometry', 'Custom'};
    end

    methods(TestClassSetup)

        function openModelWithTeardown(test)
            % open model and add teardown.
            open_system(test.modelname);
            test.addTeardown(@()close_system(test.modelname, 0));
        end

        function setupBlockForTesting(test)
            % Setup model for testing

            % Add block to the test model
            test.blockpath = [test.modelname, '/', test.blockname];
            add_block(test.sourceBlock, test.blockpath, 'Position', [-220,193,-35,302]);

            % Connect blocks
            add_line(test.modelname, 'World Frame/RConn1', [test.blockname, '/LConn1']);
            add_line(test.modelname, 'World Frame/RConn1', [test.blockname, '/RConn1']);
        end
        
    end

    methods(Test)

        function TestSimulationWithDefaultValues(test, connConfig, inertiaType)
            % Test that the custom block simulates without any error or
            % warning for the default values.

            % Set connection configuration and inertia type
            set_param(test.blockpath, 'connConfig', connConfig);
            set_param(test.blockpath, 'baseInertiaType', inertiaType, 'rotorInertiaType', inertiaType);

            test.verifyWarningFree(@()sim(test.modelname),...
                ['The model with block- ''', test.blockname, ''' should simulate without any errors and/or warnings.']);

        end

        function TestSimulationWithCustomValues(test)
            % Test that the custom block simulates without any error or
            % warning for the custom valid values.

            % Set custom parameters
            set_param(test.blockpath, 'baseRadius', '0.5');
            set_param(test.blockpath, 'baseTotalLength', '1.25');

            % Verify model simulates without warning
            test.verifyWarningFree(@()sim(test.modelname),...
                ['The model with block- ''', test.blockname, ''' should simulate without any errors and/or warnings.']);

        end

    end

end