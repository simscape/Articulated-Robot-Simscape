% Test runner for Articulated Robot Design With Simscape project
% The test runner sricpt for this project is used to create a test suite 
% that consists of test scripts in the 'Tests' folder. The runner runs 
% this test suite and generates output.

% Copyright 2023 - 2024 The MathWorks, Inc.

relStr = matlabRelease().Release;
disp("This is MATLAB " + relStr + ".");

topFolder = currentProject().RootFolder; 

%% Create test suite
% Test suite for unit test
suite = matlab.unittest.TestSuite.fromFolder(fullfile(topFolder,"Tests"), 'IncludingSubfolders', true);
suite = selectIf(suite, 'Superclass', 'matlab.unittest.TestCase');

%% Create test runner
runner = matlab.unittest.TestRunner.withTextOutput(...
    'OutputDetail',matlab.unittest.Verbosity.Detailed);

%% Set up JUnit style test results
runner.addPlugin(matlab.unittest.plugins.XMLPlugin.producingJUnitFormat(...
    fullfile(topFolder, "Tests", "Robotics_TestResults_"+relStr+".xml")));

%% MATLAB Code Coverage Report
coverageReportFolder = fullfile(topFolder, "coverage-RoboticsCodeCoverage" + relStr);
if ~isfolder(coverageReportFolder)
    mkdir(coverageReportFolder)
end

coverageReport = matlab.unittest.plugins.codecoverage.CoverageReport( ...
    coverageReportFolder, MainFile = "RoboticsCoverageReport" + relStr + ".html" );

% Code Coverage Plugin
fileList = [fullfile(topFolder, "Component/Controller", "createWaypoints.m")...
    fullfile(topFolder, "Scripts", "ParametricGripperPayloadsParameters.m")...
    fullfile(topFolder, "Scripts", "ParametricRobotParameters.m")...
    fullfile(topFolder, "Scripts", "TrajectoryCreation.m")...
    fullfile(topFolder, "Scripts", "customTrajectory.m")...
    fullfile(topFolder, "Scripts", "ksTrajectoryCreation.m")...
    fullfile(topFolder, "Scripts", "pointCloudDataBrick.m")...
    fullfile(topFolder, "Scripts", "pointCloudFinger.m")...
    fullfile(topFolder, "Scripts", "waypointLocation.m")...
    fullfile(topFolder, "Workflow/ActuatorRating/Scripts", "envelopeTopGen.m")...
    fullfile(topFolder, "Workflow/ActuatorRating/Scripts", "jointDataBusCreator.m")...
    fullfile(topFolder, "Workflow/ActuatorRating/Scripts", "volumeSphereGen.m")...
    fullfile(topFolder, "Workflow/ActuatorRating/Scripts", "waypointsGen.m")...
    fullfile(topFolder, "Workflow/ActuatorRating/Scripts", "envelopeFrontGen.m")...
    fullfile(topFolder, "Workflow/ActuatorRating/Scripts", "envelopeGenerator.m")...
    fullfile(topFolder, "Workflow/ActuatorRating", "DetermineEnvelopeWorkflow.mlx")...
    fullfile(topFolder, "Workflow/ParameterSensitivityAnalysis", "ParameterSensitivityAnalysisSetup.mlx")...
    fullfile(topFolder, "Workflow/ParameterSensitivityAnalysis", "ParameterSensitivityAnalysisWorkflow.mlx")...
    fullfile(topFolder, "Workflow/ParameterSensitivityAnalysis", "parametricRobotSensitivityReachObjective.m")...
    fullfile(topFolder, "Workflow/ParameterSensitivityAnalysis", "parametricRobotSensitivityTornadoPlot.m")...
    fullfile(topFolder, "Workflow/Stacking", "StackingWorkflow.mlx")...
    fullfile(topFolder, "Workflow/Stacking/Scripts", "ParametricRobotLoader.m") ...
    fullfile(topFolder, "Workflow/Stacking/Scripts", "LoadParametricStacking.m")];
codeCoveragePlugin = matlab.unittest.plugins.CodeCoveragePlugin.forFile(fileList, Producing = coverageReport );
addPlugin(runner, codeCoveragePlugin);

%% Run tests
results = run(runner, suite);
out = assertSuccess(results);
disp(out); 