%% Winglet Design Optimization using MATLAB's fmincon and AVL
% Author:D Barara

% Script for performing numerical optimization of the winglet design by
% accounting the aerodynamic performance as well as its structural performance
% based on the output from AVL.
%% Main Run File

% In order to find the optimum winglet design vary all
% the seven winglet design parameters:
% Design Variables
% X0(1) - Winglet length l_w - Winglet_length
% X0(2) - Cant Angle Phi - Winglet_Cant
% X0(3) - Winglet Root Chord C_wr - Winglet.Root.Chord
% X0(4) - Winglet Taper Ratio lambda_w - Winglet_Taper
% X0(5) - Winglet LE Sweep Lambda_w - Winglet_LE_Sweep
% X0(6) - Twist at root epsilon_wr - Winglet_Root_Twist
% X0(7) - Twist at tip epsilon_wt - Winglet_Tip_Twist

clc
clear all

% Initial values
X0=[0.5 0.5 0.5 0.5 0.5 0.5 0.5]; % Initial values of normalized DVs

% Bounds
LB= [0 0 0 0 0 0 0]; % Lower Bound of normalized DV
UB= [1 1 1 1 1 1 1]; % Upper Bound of normalized DV

% Options for the optimization
options.Display         = 'iter-detailed';
options.Algorithm       = 'sqp';
options.FunValCheck     = 'off';
options.DiffMinChange   = 1e-2;         % Minimum change while gradient searching
options.DiffMaxChange   = 5e-2;         % Maximum change while gradient searching
options.TolFun          = 1e-6;         % Maximum difference between two subsequent objective value
options.TolX            = 1e-6;         % Maximum difference between two subsequent design vectors
options.MaxIter         = 30;           % Maximum iterations
options.PlotFcns        = {@optimplotfval,@optimplotx,@optimplotfirstorderopt,@optimplotconstrviolation, @optimplotstepsize, @optimplotfunccount};

tic;
[X_opt,FVAL,EXITFLAG,OUTPUT] = fmincon(@(X)Optim_Run(X),X0,[],[],[],[],LB,UB,@(X)Constfun(X),options);
run_time = toc;
save ('variables');

[final] = Optim_Run(X_opt); % Optimized Design Variables

%% Dimensionalizing the values

X_lower= [0.6 10 0.6 0.4 0 -6.0 -0.5]; % Actual values of the Lower bounds
X_Upper= [3 90 1.5 1.0 45 -0.5 6.0];   % Actual values of the Upper bounds

X0_norm=[X0(1)*(X_Upper(1)-X_lower(1))+X_lower(1)
X0(2)*(X_Upper(2)-X_lower(2))+X_lower(2)
X0(3)*(X_Upper(3)-X_lower(3))+X_lower(3)
X0(4)*(X_Upper(4)-X_lower(4))+X_lower(4)
X0(5)*(X_Upper(5)-X_lower(5))+X_lower(5)
X0(6)*(X_Upper(6)-X_lower(6))+X_lower(6) 
X0(7)*(X_Upper(7)-X_lower(7))+X_lower(7)];

X_opt_norm=[X_opt(1)*(X_Upper(1)-X_lower(1))+X_lower(1)
X_opt(2)*(X_Upper(2)-X_lower(2))+X_lower(2)
X_opt(3)*(X_Upper(3)-X_lower(3))+X_lower(3)
X_opt(4)*(X_Upper(4)-X_lower(4))+X_lower(4)
X_opt(5)*(X_Upper(5)-X_lower(5))+X_lower(5)
X_opt(6)*(X_Upper(6)-X_lower(6))+X_lower(6) 
X_opt(7)*(X_Upper(7)-X_lower(7))+X_lower(7)];
