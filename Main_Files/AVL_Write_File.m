function[AVL_file]=AVL_Write_File(X)
%% Create and Write an AVL File with the flow conditions
% and geometric parameters of the wing-winglet configuration.

%% Flow Conditions & Bounds of Design Variables
M=0.6;
X_lower= [0.6 10 0.6 0.4 0 -6.0 -0.5]; % Lower Bound
X_Upper= [3 90 1.5 1.0 45 -0.5 6.0];   % Upper Bounds
%% Parameters for Wing using the given Wing configuration
Wing_Surface='WING';
Wing_twist_angle=0.0;
Wing_Span=30.0; % Wing Span

% Root Coordinates
Wing.Root.Chord= 6.0;
Wing.Root.Xle= 0.0;
Wing.Root.Yle= 0.0;
Wing.Root.Zle= 0.0;

% Tip Coordinates
Wing.Tip.Chord= 1.5;
Wing.Tip.Xle= 5.0;
Wing.Tip.Yle= 15.0;
Wing.Tip.Zle= 1.0;

%% Parameters for Winglet
% Define the parameters in terms of Initial values X
Winglet_Surface='WINGLET';
Winglet_twist_angle=0.0;
Winglet_Length=X(1)*(X_Upper(1)-X_lower(1))+X_lower(1);
Winglet_Cant=X(2)*(X_Upper(2)-X_lower(2))+X_lower(2);
Winglet_Root_Chord= X(3)*(X_Upper(3)-X_lower(3))+X_lower(3);
Winglet_Taper=X(4)*(X_Upper(4)-X_lower(4))+X_lower(4);
Winglet_LE_Sweep=X(5)*(X_Upper(5)-X_lower(5))+X_lower(5); % in degrees
Winglet_Root_Twist=X(6)*(X_Upper(6)-X_lower(6))+X_lower(6); % Toe out angle
Winglet_Tip_Twist=X(7)*(X_Upper(7)-X_lower(7))+X_lower(7);  

% Root Coordinates
Winglet.Root.Chord= Winglet_Root_Chord; %0.75*Wing.Tip.Chord;
Winglet.Root.Xle= Wing.Tip.Yle*sind(Winglet_Root_Twist)+(Wing.Tip.Xle + (Wing.Tip.Chord-Winglet.Root.Chord))*cosd(Winglet_Root_Twist);
Winglet.Root.Yle= Wing.Tip.Yle*cosd(Winglet_Root_Twist)-(Wing.Tip.Xle + (Wing.Tip.Chord-Winglet.Root.Chord))*sind(Winglet_Root_Twist);
Winglet.Root.Zle= Wing.Tip.Zle;

% Tip Coordinates
Winglet.Tip.Chord= Winglet_Taper*Winglet.Root.Chord;
Winglet_Height= Winglet_Length*cosd(Winglet_Cant);
Winglet_Span = Winglet_Length*sind(Winglet_Cant);
Winglet.Tip.Xle = (Wing.Tip.Xle + (Wing.Tip.Chord-Winglet.Root.Chord) + Winglet_Length*sind(Winglet_LE_Sweep))*cosd(Winglet_Tip_Twist)-...
    (Winglet.Root.Yle + Winglet_Span)*sind(Winglet_Tip_Twist);
Winglet.Tip.Yle= (Wing.Tip.Xle + (Wing.Tip.Chord-Winglet.Root.Chord) +  Winglet_Length*sind(Winglet_LE_Sweep))*sind(Winglet_Tip_Twist)+...
    (Winglet.Root.Yle + Winglet_Span)*cosd(Winglet_Tip_Twist);
Winglet.Tip.Zle= Winglet.Root.Zle + Winglet_Height;

%% Calculating Reference values
Wing.Area=(Wing_Span)*((Wing.Root.Chord+Wing.Tip.Chord))/2;  % Wing_Span = 30;
Winglet.Area=2*Winglet_Span*((Winglet.Root.Chord+Winglet.Tip.Chord))/2; % Multiplied by 2 to convert Winglet Semi-Span to Winglet Span
Sref= Winglet.Area+Wing.Area;
Bref= Wing_Span+(2*Winglet_Span);
Cref= (2/3)*(Wing.Root.Chord-Wing.Tip.Chord*(Wing.Root.Chord*Wing.Tip.Chord)/(Wing.Root.Chord+Wing.Tip.Chord)); % MAC of the wing
% Cref=Sref/Bref; % As per AVL documentation

%% Writing AVL File
filename = '.\AVL_File';
[status,result] =dos(strcat('del ',filename,'.avl'));
fid = fopen(strcat(filename,'.avl'), 'w');
% Header Data
fprintf(fid, 'Winglet \n');
fprintf(fid, '# \n');
fprintf(fid, '# \n');
fprintf(fid, '# \n');
fprintf(fid, '%0.2f \n', M);
fprintf(fid, '0 0 0.0 \n');
fprintf(fid, '%6.4f %6.4f %6.4f \n',Sref, Cref, Bref);
fprintf(fid, '0.0   0.0   0.0 \n');
fprintf(fid, '0.00 \n');
fprintf(fid, '# \n');
fprintf(fid, '\n');
fprintf(fid, '\n');
fprintf(fid, '#-------------------------------------------------- \n');
% Writing in data for Wing Surface
fprintf(fid, 'SURFACE \n');
fprintf(fid, '%s \n', Wing_Surface);
fprintf(fid, '# Horseshoe Vortex Distribution \n');
fprintf(fid, '!Nchordwise  Cspace  Nspanwise  Sspace \n');
fprintf(fid, '10            1.0     20         1.0 \n');
fprintf(fid, '# \n');
fprintf(fid, 'COMPONENT \n');
fprintf(fid, '1 \n');
fprintf(fid, '# \n');
fprintf(fid, '# Reflect image wing about y=0 plane \n');
fprintf(fid, 'YDUPLICATE  \n');
fprintf(fid, '0.0 \n');
fprintf(fid, '# \n');
fprintf(fid, '# Twist angle for wole surface \n');
fprintf(fid, 'ANGLE \n');
fprintf(fid, '%6.2f \n', Wing_twist_angle);
fprintf(fid, 'SECTION \n');
fprintf(fid, '#Root chord \n');
fprintf(fid, '!	Xle    Yle    Zle     Chord   Ainc  Nspanwise  Sspace\n');
fprintf(fid, '%6.3f    %6.3f   %6.3f     %6.3f   0.    0         0\n',Wing.Root.Xle,Wing.Root.Yle,Wing.Root.Zle,Wing.Root.Chord);
fprintf(fid, 'SECTION \n');
fprintf(fid, '#Tip \n');
fprintf(fid, '!	Xle    Yle    Zle     Chord   Ainc  Nspanwise  Sspace\n');
fprintf(fid, '%6.3f    %6.3f   %6.3f     %6.3f  0.    0         0\n',Wing.Tip.Xle,Wing.Tip.Yle,Wing.Tip.Zle,Wing.Tip.Chord);
fprintf(fid, '\n');
fprintf(fid, '\n');
fprintf(fid, '#-------------------------------------------------- \n');
% Writing in data for Winglet
fprintf(fid, 'SURFACE \n');
fprintf(fid, '%s \n', Winglet_Surface);
fprintf(fid, '# Horseshoe Vortex Distribution \n');
fprintf(fid, '!Nchordwise  Cspace  Nspanwise  Sspace \n');
fprintf(fid, '10            1.0     20         1.0 \n');
fprintf(fid, '# \n');
fprintf(fid, 'COMPONENT \n');
fprintf(fid, '1 \n');
fprintf(fid, '# \n');
fprintf(fid, '# Reflect image wing about y=0 plane \n');
fprintf(fid, 'YDUPLICATE  \n');
fprintf(fid, '0.0 \n');
fprintf(fid, '# \n');
fprintf(fid, '# Twist angle for wole surface \n');
fprintf(fid, 'ANGLE \n');
fprintf(fid, '%6.2f \n', Winglet_twist_angle);
fprintf(fid, 'SECTION \n');
fprintf(fid, '#Root chord \n');
fprintf(fid, '!	Xle    Yle    Zle     Chord   Ainc  Nspanwise  Sspace\n');
fprintf(fid, '%6.3f    %6.3f   %6.3f     %6.3f   0.    0         0\n',Winglet.Root.Xle,Winglet.Root.Yle,Winglet.Root.Zle,Winglet.Root.Chord);
fprintf(fid, 'SECTION \n');
fprintf(fid, '#Tip \n');
fprintf(fid, '!	Xle    Yle    Zle     Chord   Ainc  Nspanwise  Sspace\n');
fprintf(fid, '%6.3f    %6.3f   %6.3f     %6.3f   0.    0         0\n',Winglet.Tip.Xle,Winglet.Tip.Yle,Winglet.Tip.Zle,Winglet.Tip.Chord);
fprintf(fid, '\n');
fprintf(fid, '\n');
fprintf(fid, '#-------------------------------------------------- \n');
fclose (fid);

% Save the Design Parameters
save('Design_Parameters');

AVL_file=strcat(filename);
