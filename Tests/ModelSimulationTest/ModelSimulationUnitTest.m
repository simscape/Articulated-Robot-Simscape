classdef ModelSimulationUnitTest < matlab.unittest.TestCase
    % This MATLAB unit test is used to run the Simulink models for the
    % project. The test verifies that models simulate without any errors or 
    % warnings. 

    % Copyright 2023 - 2024 The MathWorks, Inc.

    methods (Test)

        function RobotStackingModel(testCase)
            % Test for the StackingRobotModel example model

            % Load system and add teardown
            modelname = "StackingRobotModel";
            load_system(modelname)
            testCase.addTeardown(@()close_system(modelname, 0));
            set_param(modelname,'SimMechanicsOpenEditorOnUpdate','off');

            % Simulate model
            sim(modelname);
        end

        function sm_abbIrb120_1_RawImportModel(testCase)
            % Test for the sm_abbIrb120_1_RawImport model

            % Load system and add teardown
            modelname = "sm_abbIrb120_1_RawImport";
            load_system(modelname)
            testCase.addTeardown(@()close_system(modelname, 0));
            set_param(modelname,'SimMechanicsOpenEditorOnUpdate','off');

            % Simulate model
            sim(modelname);
        end

        function ParametricRobotModel(testCase)
            % Test for the ParametricRobotModel example model

            % Load system and add teardown
            modelname = "ParametricRobotModel";
            load_system(modelname)
            testCase.addTeardown(@()close_system(modelname, 0));
            set_param(modelname,'SimMechanicsOpenEditorOnUpdate','off');

            % Simulate model
            sim(modelname);
        end

        function ParametricRobotWithGripperPayloadsModel(testCase)
            % Test for the ParametricRobotWithGripperPayloads example model

            % Load system and add teardown
            modelname = "ParametricRobotWithGripperPayloads";
            load_system(modelname)
            testCase.addTeardown(@()close_system(modelname, 0));
            set_param(modelname,'SimMechanicsOpenEditorOnUpdate','off');

            % Simulate model
            sim(modelname);
        end

        function ParametricRobotWithMassModel(testCase)
             % Test for the ParametricRobotWithMass example model

            % Load system and add teardown
            modelname = "ParametricRobotWithMass";
            load_system(modelname)
            testCase.addTeardown(@()close_system(modelname, 0));
            set_param(modelname,'SimMechanicsOpenEditorOnUpdate','off');

            % Simulate model
            sim(modelname);
        end

        function ActuatorRatingModel(testCase)
            % Test for the ParametricRobotStacking example model

            % Load system and add teardown
            modelname = "ActuatorRatingModel";
            load_system(modelname)
            testCase.addTeardown(@()close_system(modelname, 0));
            set_param(modelname,'SimMechanicsOpenEditorOnUpdate','off');

            % Simulate model
            sim(modelname);
        end

        function StackingModel(testCase)
            % Test for the ParametricRobotStacking example model

            % Load system and add teardown
            modelname = "StackingModel";
            load_system(modelname)
            testCase.addTeardown(@()close_system(modelname, 0));
            set_param(modelname,'SimMechanicsOpenEditorOnUpdate','off');

            % Simulate model
            sim(modelname);
        end

        function TorqueControlConfigModel(testCase)
            % Test for the TorqueControlConfig example model

            % Load system and add teardown
            modelname = "TorqueControlConfig";
            load_system(modelname)
            testCase.addTeardown(@()close_system(modelname, 0));
            set_param(modelname,'SimMechanicsOpenEditorOnUpdate','off');
     
            % Get simulation input object
            simIn = Simulink.SimulationInput(modelname);
            
            % Simulate model
            sim(simIn);
        end

    end

end