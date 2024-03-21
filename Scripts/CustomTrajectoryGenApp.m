classdef CustomTrajectoryGenApp < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        CustomTrajectoryGeneratorUIFigure  matlab.ui.Figure
        GridLayout                  matlab.ui.container.GridLayout
        InputPanel                  matlab.ui.container.Panel
        TrajectoryCreate            matlab.ui.container.GridLayout
        HelpButton                  matlab.ui.control.Button
        GenerateTrajectoryButton    matlab.ui.control.Button
        DeleteButton                matlab.ui.control.Button
        AddButton                   matlab.ui.control.Button
        CoordinateInput             matlab.ui.control.Table
        NumberofTrajectoryPointsEditField  matlab.ui.control.NumericEditField
        NumberofWaypointsEditField  matlab.ui.control.NumericEditField
        NumberofWaypointsEditFieldLabel  matlab.ui.control.Label
        NumberofTrajectoryPointsEditFieldLabel  matlab.ui.control.Label
        TrajectoryPlot              matlab.ui.container.Panel
        Workspace                   matlab.ui.control.UIAxes
    end

    % Properties that correspond to apps with auto-reflow
    properties (Access = private)
        onePanelWidth = 576;
    end

    
    properties (Access = private)
        CustomWaypoint % Data for Custom Waypoints
    end
    
    methods (Access = private)
        
        function plotWaypoints(app)
            X = app.CoordinateInput.Data(:,1);
            Y = app.CoordinateInput.Data(:,2);
            Z = app.CoordinateInput.Data(:,3);
            PlotView = get(app.Workspace, 'View');
            plot3(app.Workspace,X,Y,Z,'--or','LineWidth',2,'Color','b');
            view(app.Workspace,PlotView);
        end

        function plotSelection(app,Idx)
            X = app.CoordinateInput.Data(:,1);
            Y = app.CoordinateInput.Data(:,2);
            Z = app.CoordinateInput.Data(:,3);
            PlotView = get(app.Workspace, 'View');
            plot3(app.Workspace,X,Y,Z,'--or','LineWidth',2,'Color','b');
            hold(app.Workspace,'on');
            plot3(app.Workspace,X(Idx),Y(Idx),Z(Idx),'-o','Color','r');
            view(app.Workspace,PlotView);
            hold(app.Workspace,'off');
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            load("robotTrajectoryConfig.mat");
            app.CustomWaypoint = Stacking.wayPointsStackingCustom;
            app.NumberofWaypointsEditField.Value = size(Stacking.wayPointsStackingCustom,1)
            numWayp = app.NumberofWaypointsEditField.Value;
            app.CustomWaypoint =app.CustomWaypoint(1:numWayp,:);
            app.CoordinateInput.Data(:,1:3) =  app.CustomWaypoint;
            app.CoordinateInput.Data(:,4)=Stacking.waypointGripCustom(1:numWayp);
            plotWaypoints(app);
            view(app.Workspace,[42.5 50]);
            app.CoordinateInput.ColumnFormat = {'shortG','shortG','shortG','shortG'};

        end

        % Cell edit callback: CoordinateInput
        function CoordinateInputCellEdit(app, event)
            indices = event.Indices;
            newData = event.NewData;
            plotWaypoints(app);
        end

        % Cell selection callback: CoordinateInput
        function CoordinateInputCellSelection(app, event)
            indices = event.Indices;
            if ~ isempty(indices)
                plotSelection(app,indices(1));
            end
        end

        % Button pushed function: AddButton
        function AddButtonPushed(app, event)
            indices = app.CoordinateInput.Selection;
            wayP = app.CoordinateInput.Data;
            if isempty(indices)
                indices = size(wayP,1);
            end

            if indices(end,1) < size(wayP,1)
                tableDataBelow = wayP(indices(end,1)+1:end,:);
                wayP(indices(end,1)+1:size(wayP,1)+1,:) = 0;
                wayP(indices(end,1)+2:end,:) = tableDataBelow;
            else
                wayP(size(wayP,1)+1,:) = zeros(1,4);
            end
            app.CoordinateInput.Data =  wayP;
            plotWaypoints(app);
            app.NumberofWaypointsEditField.Value = size(app.CoordinateInput.Data,1);
        end

        % Button pushed function: DeleteButton
        function DeleteButtonPushed(app, event)
            indices = app.CoordinateInput.Selection;
            wayP = app.CoordinateInput.Data;
            if isempty(indices)
                indices = size(wayP,1);
            end
            if indices == 0
                wayP;
            else
                wayP(indices(:,1),:) = [];
            end
            app.CoordinateInput.Data =  wayP;
            plotWaypoints(app);
            app.NumberofWaypointsEditField.Value = size(app.CoordinateInput.Data,1);
        end

        % Button pushed function: GenerateTrajectoryButton
        function GenerateTrajectoryButtonPushed(app, event)
            d = uiprogressdlg(app.CustomTrajectoryGeneratorUIFigure,'Title','Computing trajectory',...
                'Indeterminate','on');
            drawnow;
            load("robotTrajectoryConfig.mat");
            customTrajectory(app.CoordinateInput.Data,app.NumberofTrajectoryPointsEditField.Value,Stacking)
            close(d)

        end

        % Value changed function: NumberofWaypointsEditField
        function NumberofWaypointsEditFieldValueChanged2(app, event)
            numWayp = app.NumberofWaypointsEditField.Value;
            if size(app.CoordinateInput.Data,1)> numWayp
                app.CoordinateInput.Data( numWayp+1:end,:) = [];
            else
               app.CoordinateInput.Data(end+1:numWayp,:) = 0;
            end

            plotWaypoints(app);
        end

        % Button pushed function: HelpButton
        function HelpButtonPushed(app, event)
            web('CustomTrajectoryHelp.html')
        end

        % Changes arrangement of the app based on UIFigure width
        function updateAppLayout(app, event)
            currentFigureWidth = app.CustomTrajectoryGeneratorUIFigure.Position(3);
            if(currentFigureWidth <= app.onePanelWidth)
                % Change to a 2x1 grid
                app.GridLayout.RowHeight = {498, 498};
                app.GridLayout.ColumnWidth = {'1x'};
                app.TrajectoryPlot.Layout.Row = 2;
                app.TrajectoryPlot.Layout.Column = 1;
            else
                % Change to a 1x2 grid
                app.GridLayout.RowHeight = {'1x'};
                app.GridLayout.ColumnWidth = {487, '1x'};
                app.TrajectoryPlot.Layout.Row = 1;
                app.TrajectoryPlot.Layout.Column = 2;
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create CustomTrajectoryGeneratorUIFigure and hide until all components are created
            app.CustomTrajectoryGeneratorUIFigure = uifigure('Visible', 'off');
            app.CustomTrajectoryGeneratorUIFigure.AutoResizeChildren = 'off';
            app.CustomTrajectoryGeneratorUIFigure.Position = [100 100 928 498];
            app.CustomTrajectoryGeneratorUIFigure.Name = 'Custom Trajectory Generator';
            app.CustomTrajectoryGeneratorUIFigure.SizeChangedFcn = createCallbackFcn(app, @updateAppLayout, true);

            % Create GridLayout
            app.GridLayout = uigridlayout(app.CustomTrajectoryGeneratorUIFigure);
            app.GridLayout.ColumnWidth = {487, '1x'};
            app.GridLayout.RowHeight = {'1x'};
            app.GridLayout.ColumnSpacing = 0;
            app.GridLayout.RowSpacing = 0;
            app.GridLayout.Padding = [0 0 0 0];
            app.GridLayout.Scrollable = 'on';

            % Create InputPanel
            app.InputPanel = uipanel(app.GridLayout);
            app.InputPanel.Layout.Row = 1;
            app.InputPanel.Layout.Column = 1;

            % Create TrajectoryCreate
            app.TrajectoryCreate = uigridlayout(app.InputPanel);
            app.TrajectoryCreate.ColumnWidth = {173, '1.33x', '0.5x'};
            app.TrajectoryCreate.RowHeight = {22, '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1.57x'};
            app.TrajectoryCreate.ColumnSpacing = 4.6;
            app.TrajectoryCreate.Padding = [4.6 10 4.6 10];

            % Create NumberofTrajectoryPointsEditFieldLabel
            app.NumberofTrajectoryPointsEditFieldLabel = uilabel(app.TrajectoryCreate);
            app.NumberofTrajectoryPointsEditFieldLabel.HorizontalAlignment = 'right';
            app.NumberofTrajectoryPointsEditFieldLabel.Layout.Row = 2;
            app.NumberofTrajectoryPointsEditFieldLabel.Layout.Column = 1;
            app.NumberofTrajectoryPointsEditFieldLabel.Text = 'Number of Trajectory Points';

            % Create NumberofWaypointsEditFieldLabel
            app.NumberofWaypointsEditFieldLabel = uilabel(app.TrajectoryCreate);
            app.NumberofWaypointsEditFieldLabel.HorizontalAlignment = 'right';
            app.NumberofWaypointsEditFieldLabel.Layout.Row = 1;
            app.NumberofWaypointsEditFieldLabel.Layout.Column = 1;
            app.NumberofWaypointsEditFieldLabel.Text = 'Number of Waypoints';

            % Create NumberofWaypointsEditField
            app.NumberofWaypointsEditField = uieditfield(app.TrajectoryCreate, 'numeric');
            app.NumberofWaypointsEditField.ValueChangedFcn = createCallbackFcn(app, @NumberofWaypointsEditFieldValueChanged2, true);
            app.NumberofWaypointsEditField.Tooltip = {'Number of waypoints for the trajectory.'};
            app.NumberofWaypointsEditField.Layout.Row = 1;
            app.NumberofWaypointsEditField.Layout.Column = 2;
            app.NumberofWaypointsEditField.Value = 13;

            % Create NumberofTrajectoryPointsEditField
            app.NumberofTrajectoryPointsEditField = uieditfield(app.TrajectoryCreate, 'numeric');
            app.NumberofTrajectoryPointsEditField.Tooltip = {'Number of points for trajectory creation.'};
            app.NumberofTrajectoryPointsEditField.Layout.Row = 2;
            app.NumberofTrajectoryPointsEditField.Layout.Column = 2;
            app.NumberofTrajectoryPointsEditField.Value = 300;

            % Create CoordinateInput
            app.CoordinateInput = uitable(app.TrajectoryCreate);
            app.CoordinateInput.ColumnName = {'X (m)'; 'Y (m)'; 'Z (m)'; 'Grip (1=Cl;-1=Op)'};
            app.CoordinateInput.RowName = {};
            app.CoordinateInput.ColumnEditable = true;
            app.CoordinateInput.CellEditCallback = createCallbackFcn(app, @CoordinateInputCellEdit, true);
            app.CoordinateInput.CellSelectionCallback = createCallbackFcn(app, @CoordinateInputCellSelection, true);
            app.CoordinateInput.Tooltip = {'Add or delete end effector X-Y-Z coordinates and gripper closed or open position.'};
            app.CoordinateInput.Layout.Row = [3 14];
            app.CoordinateInput.Layout.Column = [1 2];

            % Create AddButton
            app.AddButton = uibutton(app.TrajectoryCreate, 'push');
            app.AddButton.ButtonPushedFcn = createCallbackFcn(app, @AddButtonPushed, true);
            app.AddButton.Tooltip = {'Add new waypoint at the selected row in table.'};
            app.AddButton.Layout.Row = 7;
            app.AddButton.Layout.Column = 3;
            app.AddButton.Text = 'Add';

            % Create DeleteButton
            app.DeleteButton = uibutton(app.TrajectoryCreate, 'push');
            app.DeleteButton.ButtonPushedFcn = createCallbackFcn(app, @DeleteButtonPushed, true);
            app.DeleteButton.Tooltip = {'Delete the selected row from table.'};
            app.DeleteButton.Layout.Row = 8;
            app.DeleteButton.Layout.Column = 3;
            app.DeleteButton.Text = 'Delete';

            % Create GenerateTrajectoryButton
            app.GenerateTrajectoryButton = uibutton(app.TrajectoryCreate, 'push');
            app.GenerateTrajectoryButton.ButtonPushedFcn = createCallbackFcn(app, @GenerateTrajectoryButtonPushed, true);
            app.GenerateTrajectoryButton.Tooltip = {'Generate trajectory from the end effector position by Inverse Kinematics. '};
            app.GenerateTrajectoryButton.Layout.Row = 15;
            app.GenerateTrajectoryButton.Layout.Column = [1 2];
            app.GenerateTrajectoryButton.Text = 'Generate Trajectory';

            % Create HelpButton
            app.HelpButton = uibutton(app.TrajectoryCreate, 'push');
            app.HelpButton.ButtonPushedFcn = createCallbackFcn(app, @HelpButtonPushed, true);
            app.HelpButton.Tooltip = {'Help for the app.'};
            app.HelpButton.Layout.Row = 15;
            app.HelpButton.Layout.Column = 3;
            app.HelpButton.Text = 'Help';

            % Create TrajectoryPlot
            app.TrajectoryPlot = uipanel(app.GridLayout);
            app.TrajectoryPlot.Layout.Row = 1;
            app.TrajectoryPlot.Layout.Column = 2;

            % Create Workspace
            app.Workspace = uiaxes(app.TrajectoryPlot);
            title(app.Workspace, 'Workspace')
            xlabel(app.Workspace, 'X (m)')
            ylabel(app.Workspace, 'Y (m)')
            zlabel(app.Workspace, 'Z (m)')
            app.Workspace.Position = [21 37 416 418];

            % Show the figure after all components are created
            app.CustomTrajectoryGeneratorUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = CustomTrajectoryGenApp

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.CustomTrajectoryGeneratorUIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.CustomTrajectoryGeneratorUIFigure)
        end
    end
end