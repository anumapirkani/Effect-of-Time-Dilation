%% Script developed by Anum Pirkani
% For details, contact: anum.apirkani@gmail.com

clc;
clear; 
close all;

%% Initial Variables
   SpeedLight         = 299792458;
   SpeedMovingTarget1 = 0.8 * SpeedLight;    
   SpeedMovingTarget2 = 0.99 * SpeedLight;   
   LorentzFactor1     = 1 / sqrt(1 - (SpeedMovingTarget1^2 / SpeedLight^2));
   LorentzFactor2     = 1 / sqrt(1 - (SpeedMovingTarget2^2 / SpeedLight^2));

   VelocityRatioValues = linspace(0, 1, 600);
   LorentzFactorValues = 1 ./ sqrt(1 - VelocityRatioValues.^2);

   fig = figure('Name', 'Time Dilation', 'NumberTitle', 'off',...
                'Position', [50, 50, 1500, 600], 'Color', [0.1, 0.1, 0.1]);

   videoFile           = VideoWriter('TimeDilation.mp4', 'MPEG-4');
   videoFile.FrameRate = 30;
   open(videoFile);

%% Lorentz Factor vs Velocity
   subplot(131);
   hold on;
   FirstPlot = plot(NaN, NaN,'m','LineWidth',5);
   xlabel('Velocity Ratio (v/c)','FontSize',12,'FontWeight','bold','Color','white');
   ylabel('Time Dilation (γ)','FontSize',12,'FontWeight','bold','Color','white');
   grid on;
   grid minor;
   xlim([0 1]);
   ylim([0.9 7]);
   set(gca,'Color',[0.2 0.2 0.2],'XColor','white','YColor','white');

%% Time Progress
   subplot(132);
   hold on;
   StationaryPlot = plot(0, 0, 'b', 'LineWidth', 5);
   MovingPlot1    = plot(0, 0, 'r', 'LineWidth', 5);
   MovingPlot2    = plot(0, 0, 'g', 'LineWidth', 5); 
   xlabel('Stationary Time (s)', 'FontSize', 12, 'FontWeight', 'bold', 'Color', 'white');
   ylabel('Elapsed Time (s)', 'FontSize', 12, 'FontWeight', 'bold', 'Color', 'white');
   legend({'Stationary Time', 'Moving: 0.8*c', 'Moving: 0.99*c'}, 'TextColor', 'k', 'Location', 'northwest');
   grid on;
   grid minor;
   xlim([0 60]);
   ylim([0 60]);
   set(gca,'Color',[0.2 0.2 0.2],'XColor','white','YColor','white');

%% Clocks
   subplot(133);
   hold on;
   axis equal;
   xlim([-2 2]);
   ylim([-1.5 2]);
   set(gca,'XColor','none','YColor','none');

   ThetaClock = linspace(0, 2*pi, 100);
   xCircle    = cos(ThetaClock);
   yCircle    = sin(ThetaClock);

   % Stationary Clock
     fill(0+0.4*xCircle, 1.2+0.4*yCircle, 'b', 'LineWidth', 3);
     h1 = line([0, 0], [1.2, 1.2 + 0.3], 'Color', 'k', 'LineWidth', 4);
     text(0, 1.8, 'Stationary Clock', 'HorizontalAlignment', 'center', 'FontSize', 12, 'FontWeight', 'bold', 'Color', 'k');
     TextStationary = text(0, 0.6, '0.00 s', 'HorizontalAlignment', 'center', 'FontSize', 14, 'FontWeight', 'bold', 'Color', 'k');

   % Moving Clock: 0.8*c
     fill(-0.8+0.4*xCircle, -0.6+0.4*yCircle, 'r', 'LineWidth', 3);
     h2 = line([-0.8, -0.8], [-0.6, -0.6 + 0.3], 'Color', 'k', 'LineWidth', 4);
     text(-0.8, 0.05, 'Moving: 0.8*c', 'HorizontalAlignment', 'center', 'FontSize', 12, 'FontWeight', 'bold', 'Color', 'k');
     TextMoving1 = text(-0.8, -1.2, '0.00 s', 'HorizontalAlignment', 'center', 'FontSize', 14, 'FontWeight', 'bold', 'Color', 'k');

   % Moving Clock: 0.99*c
     fill(0.8+0.4*xCircle, -0.6+0.4*yCircle, 'g', 'LineWidth', 3);
     h3 = line([0.8, 0.8], [-0.6, -0.6 + 0.3], 'Color', 'k', 'LineWidth', 4);
     text(0.8, 0.05, 'Moving: 0.99*c', 'HorizontalAlignment', 'center', 'FontSize', 12, 'FontWeight', 'bold', 'Color', 'k');
     TextMoving2 = text(0.8, -1.2, '0.00 s', 'HorizontalAlignment', 'center', 'FontSize', 14, 'FontWeight', 'bold', 'Color', 'k');

%% Animation
   InitialTime          = 0;
   MaximumTime          = 60;
   dt                   = 0.1;
   StationaryTimeValues = 0;
   MovingTimeValues1    = 0;
   MovingTimeValues2    = 0;
   i = 1;

   tic;
   while InitialTime < MaximumTime
         InitialTime = i * dt;
         if toc < InitialTime
            continue; 
         end
    
         TimeMoving1 = InitialTime / LorentzFactor1;
         TimeMoving2 = InitialTime / LorentzFactor2;

         set(h1, 'XData', [0, 0 + 0.3*cos(-InitialTime * pi/30 + pi/2)], ...
                 'YData', [1.2, 1.2 + 0.3*sin(-InitialTime * pi/30 + pi/2)]);
         set(TextStationary, 'String', sprintf('%.2fs', InitialTime));

         set(h2, 'XData', [-0.8, -0.8 + 0.3*cos(-TimeMoving1 * pi/30 + pi/2)], ...
                 'YData', [-0.6, -0.6 + 0.3*sin(-TimeMoving1 * pi/30 + pi/2)]);
         set(TextMoving1, 'String', sprintf('%.2fs', TimeMoving1));

         set(h3, 'XData', [0.8, 0.8 + 0.3*cos(-TimeMoving2 * pi/30 + pi/2)], ...
                 'YData', [-0.6, -0.6 + 0.3*sin(-TimeMoving2 * pi/30 + pi/2)]);
         set(TextMoving2, 'String', sprintf('%.2fs', TimeMoving2));

         StationaryTimeValues = [StationaryTimeValues, InitialTime]; %#ok<*AGROW>
         MovingTimeValues1    = [MovingTimeValues1, TimeMoving1];
         MovingTimeValues2    = [MovingTimeValues2, TimeMoving2];
         set(StationaryPlot, 'XData', StationaryTimeValues, 'YData', StationaryTimeValues);
         set(MovingPlot1, 'XData', StationaryTimeValues, 'YData', MovingTimeValues1);
         set(MovingPlot2, 'XData', StationaryTimeValues, 'YData', MovingTimeValues2);
   
         if i > length(VelocityRatioValues)
            break;
         end
         set(FirstPlot, 'XData', VelocityRatioValues(1:i), 'YData', LorentzFactorValues(1:i)); 
    
         drawnow;
         
         frame = getframe(fig);
         writeVideo(videoFile, frame);
    
         i = i + 1;
   end
   
 close(videoFile);
