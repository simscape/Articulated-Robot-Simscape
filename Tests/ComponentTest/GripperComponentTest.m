classdef GripperComponentTest < matlab.unittest.TestCase
    % The test locks down the "Two Finger Gripper" block behavior. The test 
    % sets up a test harness model with the Two Finger Gripper block 
    % connected to a World Frame block and a PS Ramp block acting as 
    % actuation input. The test verifies that the harness model set with 
    % default values of block parameters simulates without any errors or
    % warnings. The test also verifies that the harness model set with
    % custom values of block parameters simulates without any errors or warnings.
	
	% Copyright 2023 - 2024 The MathWorks, Inc.

    properties
        % Model and Block under test
        modelname = 'testModelTemplate';
        blockname = 'Gripper';
        
        % Source block
        sourceBlock = 'GripperLib/Two Finger Gripper';
        blockpath;
    end

    methods(TestClassSetup)

        function openModelWithTeardown(test)
            % Open model and add teardown.
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
            add_line(test.modelname, 'Finger actuator motion/RConn1', [test.blockname, '/LConn2']);
        end

    end

    methods(Test)

        function TestSimulationWithDefaultValues(test)
            % Test that the custom block simulates without any error or
            % warning for the default values.
            set_param(test.modelname,'SimMechanicsOpenEditorOnUpdate','off');
            test.verifyWarningFree(@()sim(test.modelname),...
                ['The model with block- ''', test.blockname, ''' should simulate without any errors and/or warnings.']);

        end

        function TestSimulationWithCustomValues(test)
            % Test that the custom block simulates without any error or
            % warning for the custom valid values.

            % Set custom parameters
            set_param(test.blockpath, 'lFinger', '0.5');
            set_param(test.blockpath, 'wFinger', '0.5');
            set_param(test.blockpath, 'sFingerMax', '0.5');
            set_param(test.blockpath, 'ptcldDensity', '6');
            set_param(test.modelname,'SimMechanicsOpenEditorOnUpdate','off');

            % Verify model simulates without warning
            test.verifyWarningFree(@()sim(test.modelname),...
                ['The model with block- ''', test.blockname, ''' should simulate without any errors and/or warnings.']);

        end

    end
    
end