%% Articulated Robot Design with Simscape
% 
% This project contains custom libraries, models and code to help 
% you design articulated robots. You can learn to perform a parameter sensitivity 
% analysis, determine the work envelope and actuator rating, and perform a 
% stacking operation.
%

% Copyright 2023 - 2024 The MathWorks, Inc.

%% Articulated Robot For Stacking Operation
%
% Articulated robots are an integral part of various industries, 
% ranging from manufacturing and assembly to healthcare and research. The 
% development of articulated robots involves the design, control, and 
% implementation of mechanical systems capable of performing precise tasks.
% Mechanical designers often use Computer-Aided Design (CAD) models to 
% evaluate a design. To meet all the functional requirements, the CAD 
% design process is generally iterative and can be time consuming. You can 
% accelerate the development process by starting with a system-level analysis 
% to evaluate your options. This project shows how to create a system-level
% simplified parametric robot model using Simscape Multibody(TM).
%
% * To open the articulated robot model for stacking application, click
% <matlab:open_system('StackingRobotModel.slx') Stacking Robot Model>. 
% * You can define your own custom trajectory and analyze the stacking operation.
% 
% <<RobotStackingAnimation.gif>>
%
% * To run the model for pre-defined stacking scenarios, in the Input Trajectory 
% Preload block, set *Scenario* to |Stacking 1| or |Stacking 2|. Set *Scenario* 
% to |Custom Trajectory| and run the model  to see the robot trace a path 
% as per your choice. 
% * To generate any trajectory, click on *Create custom 
% trajectory using app* on the canvas. 
% * Define waypoints and gripper open or 
% close signal and click *Generate Trajectory* button in the Custom Trajectory 
% Generator app. 
% * You can compare measured joint angles with target values 
% using the scope block Joint Angles on model canvas. You can view measured
% joint torques in the scope block Joint Torques.
% * The stacking robot model uses pre-defined robot arm trajectory for solved inverse 
% kinematics and inverse dynamics. To learn how to solve inverse kinematics 
% and inverse dynamics for a stacking operation using a Simscape model, see 
% <matlab:open('StackingWorkflow.mlx') Perform a Stacking Operation with 
% an Articulated Robot>.
%
% To design your own articulated robot, you can leverage the existing 
% custom library blocks or create your new custom blocks. To learn more on 
% how to do that, go to the next section and follow the 6-step process. You 
% will also learn how to determine which robot arm link length has the highest 
% influence on its reach and how manufacturing tolerances may impact the same.
%
%% Design Your Own Articulated Robot
% 
% This section contains information to help you learn how to build and 
% parameterize components, assemble them to build an articulated 
% robot, and verify a final design for a stacking application. Follow these 
% steps to design an articulated robot.
%
% 1. *Design Components:* The project contains custom library blocks such 
% as <matlab:web('Link.html','-new') Link>, <matlab:web('LLink.html','-new') L-Link>, 
% <matlab:web('RotatingBaseWithBracket.html','-new') Rotating Base With Bracket>, 
% <matlab:web('TwoFingerGripper.html','-new') Two Finger Gripper>. The custom 
% library blocks serve as early-stage or system-level mechanical design tools for 
% quick prototyping and development of a simplified parametric articulated 
% robot. The custom library blocks use the foundation of Simscape Multibody. 
% You can parameterize custom library blocks to suit your application.
%
% 2. *Assemble Robot from Components:* Assemble the parameterized blocks to 
% build integrated robot models with end effectors. You can also represent the
% payloads and operating environment using Simscape Multibody. To setup a 
% model with parameterized library blocks, see 
% <matlab:web('RobotModelSetupHelp.html','-new') Articulated Robot Model Setup
% with Simscape Multibody>.
%
% 3. *Determine Operating Work Envelope of Designed Robot:* After you 
% create the robot model, you can determine the work envelope. 
% To determine the work envelope of the robot for a given 
% architecture, see
% <matlab:open('DetermineEnvelopeWorkflow.mlx') Determine the Work Envelope for an
% Articulated Robot>.
%
% 4. *Study Impact of Design Parameters on Work Envelope:* You can predict 
% how the system performance depends on key design parameters. To study the 
% impact of key mechanical design parameters on the robot work 
% envelope, see
% <matlab:open('ParameterSensitivityAnalysisWorkflow.mlx') Perform
% a Parameter Sensitivity Analysis for the Robot Work Envelope>.
%
% 5. *Size Joint Actuation Components:* For a known work envelope 
% and payload weight, you can size the electrical actuation components. To 
% learn more about sizing electrical actuation components, see 
% <matlab:open('ActuatorRatingWorkflow.mlx') Evaluate the Actuator Rating for
% an Articulated Robot>.
%
% 6. *Perform Stacking Operation:* You can use a robot model with sized 
% actuators to perform a task. To learn more about using such an 
% articulated robot to perform a stacking operation, see
% <matlab:open('StackingWorkflow.mlx') Perform a Stacking Operation with an 
% Articulated Robot>.
% 
%% Workflows  
%
% * <matlab:open('DetermineEnvelopeWorkflow.mlx') Determine the Work Envelope for an
% Articulated Robot> (Step # 3 above)
% * <matlab:open('ParameterSensitivityAnalysisWorkflow.mlx') Perform a
% Parameter Sensitivity Analysis for the Robot Work Envelope> (Step # 4 above)
% * <matlab:open('ActuatorRatingWorkflow.mlx') Evaluate the Actuator Rating for
% an Articulated Robot> (Step # 5 above)
% * <matlab:open('StackingWorkflow.mlx') Perform a Stacking Operation with 
% an Articulated Robot> (Step # 6 above)
%
%% Model
%
% * <matlab:open_system('StackingRobotModel.slx') Stacking Robot Model>
%
