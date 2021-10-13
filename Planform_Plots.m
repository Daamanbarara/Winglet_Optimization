clc
clear all
load('Design_Parameters.mat');

%% Wing
% Coordinates for Leading Edge
% Root
Wing.LE.Root.Xle=Wing.Root.Xle;
Wing.LE.Root.Yle=Wing.Root.Yle;
Wing.LE.Root.Zle=Wing.Root.Zle;

% Tip Coordinates
Wing.LE.Tip.Xle=Wing.Tip.Xle;
Wing.LE.Tip.Yle=Wing.Tip.Yle;
Wing.LE.Tip.Zle=Wing.Tip.Zle;

% Coordinates for Trailing Edge
% Root
Wing.TE.Root.Xle=Wing.LE.Root.Xle+Wing.Root.Chord;
Wing.TE.Root.Yle=Wing.LE.Root.Yle;
Wing.TE.Root.Zle=Wing.LE.Root.Zle;

% Tip
Wing.TE.Tip.Xle=Wing.Tip.Xle+Wing.Tip.Chord;
Wing.TE.Tip.Yle=Wing.Tip.Yle;
Wing.TE.Tip.Zle=Wing.Tip.Zle;

%% Winglet
% Coordinates for Leading Edge
% Root
Winglet.LE.Root.Xle=Winglet.Root.Xle;
Winglet.LE.Root.Yle=Winglet.Root.Yle;
Winglet.LE.Root.Zle=Winglet.Root.Zle;

% Tip Coordinates
Winglet.LE.Tip.Xle=Winglet.Tip.Xle;
Winglet.LE.Tip.Yle=Winglet.Tip.Yle;
Winglet.LE.Tip.Zle=Winglet.Tip.Zle;

% Coordinates for Trailing Edge
% Root
Winglet.TE.Root.Xle=Winglet.LE.Root.Xle+Winglet.Root.Chord;
Winglet.TE.Root.Yle=Winglet.LE.Root.Yle;
Winglet.TE.Root.Zle=Winglet.LE.Root.Zle;

% Tip
Winglet.TE.Tip.Xle=Winglet.Tip.Xle+Winglet.Tip.Chord;
Winglet.TE.Tip.Yle=Winglet.Tip.Yle;
Winglet.TE.Tip.Zle=Winglet.Tip.Zle;

%% Plot
% X=[Wing.LE.Root.Xle Wing.LE.Tip.Xle Wing.TE.Tip.Xle Wing.TE.Root.Xle Wing.LE.Root.Xle];
% Y=[Wing.LE.Root.Yle Wing.LE.Tip.Yle Wing.TE.Tip.Yle Wing.TE.Root.Yle Wing.LE.Root.Yle];
% Z=[Wing.LE.Root.Zle Wing.LE.Tip.Zle Wing.TE.Tip.Zle Wing.TE.Root.Zle Wing.LE.Root.Zle];
X=[Wing.LE.Root.Xle Wing.LE.Tip.Xle Winglet.LE.Root.Xle Winglet.LE.Tip.Xle Winglet.TE.Tip.Xle...
   Winglet.TE.Root.Xle Winglet.LE.Root.Xle Winglet.TE.Root.Xle Wing.TE.Tip.Xle Wing.TE.Root.Xle Wing.LE.Root.Xle];
Y=[Wing.LE.Root.Yle Wing.LE.Tip.Yle Winglet.LE.Root.Yle Winglet.LE.Tip.Yle Winglet.TE.Tip.Yle...
   Winglet.TE.Root.Yle Winglet.LE.Root.Yle Winglet.TE.Root.Yle Wing.TE.Tip.Yle Wing.TE.Root.Yle Wing.LE.Root.Yle];
Z=[Wing.LE.Root.Zle Wing.LE.Tip.Zle Winglet.LE.Root.Zle Winglet.LE.Tip.Zle Winglet.TE.Tip.Zle...
   Winglet.TE.Root.Zle Winglet.LE.Root.Zle Winglet.TE.Root.Zle Wing.TE.Tip.Zle Wing.TE.Root.Zle Wing.LE.Root.Zle];
figure(1)
plot3(X,Y,Z,'b','LineWidth',2)
zlim([-5 5]);
xlim([-5 10]);
ylim([0 20]);
% grid on
xlabel('x[m]')
ylabel('y[m]')
zlabel('z[m]')

figure(2)
plot(Y,X,'b','LineWidth',2)
xlabel('y[m]')
ylabel('x[m]')
set(gca, 'YDir','reverse')
xlim([0 20]);
ylim([-2 8]);
figure(3)
plot(X,Z,'b','LineWidth',2)
ylim([-2 6]);
xlim([0 8]);
xlabel('x[m]')
ylabel('z[m]')
figure(4)
plot(Y,Z,'b','LineWidth',2)
ylim([-2 6]);
xlim([0 20]);
xlabel('y[m]')
ylabel('z[m]')
% xlim([-5 10]);
% surf(Wing.LE.Root.Xle,Wing.LE.Root.Yle,Wing.LE.Root.Zle,...
%     Wing.LE.Tip.Xle,Wing.LE.Tip.Yle,Wing.LE.Tip.Zle,...
%     Wing.TE.Tip.Xle,Wing.LE.Tip.Yle,Wing.LE.Tip.Zle,...
%     Wing.TE.Root.Xle,Wing.TE.Root.Yle,Wing.TE.Root.Zle);