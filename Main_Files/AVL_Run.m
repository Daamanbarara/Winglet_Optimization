function[Cd_i,Mr]=AVL_Run(filename,Cl)
%% Script for executing AVL, Calculating Bending Moment, 
% and Reading Induced Drag from the file

load('Design_Parameters'); % Loading the Design Parameters
%% Input Variables based on the Flow conditons defined for the case
M=0.6;  % Mach
Density=0.59; % Density in kg/m3 at 7000 m
T=242.7; % Temeperature in Kelvin at 7000 m
V=sqrt(1.4*287.06*T)*M; % Velocity 
Gravity=9.81;
Mass=(0.5*Density*V^2*Sref*Cl)/Gravity; % Using F=m*g
dyp= 0.5*Density*V^2; %Dynamic Pressure

%% Directory Preparation
% Purge Directory of interfering files
[status,result] =dos(strcat('del ',filename,'.ft'));
[status,result] =dos(strcat('del ',filename,'.fs'));
[status,result] =dos(strcat('del ',filename,'.run'));
%% Create run file
% Open the file with write permission
fid = fopen(strcat(filename,'.run'), 'w');

% Load the AVL definition of the aircraft
fprintf(fid, 'LOAD %s\n', strcat(filename,'.avl'));

% Change this parameter to set which run cases to apply 
fprintf(fid, '%i\n',   0); 

% Disable Graphics
fprintf(fid, 'PLOP\ng\n\n'); 

% Open the OPER menu
fprintf(fid, '%s\n',   'OPER');   

fprintf(fid, '%s\n',   'M');    
fprintf(fid, 'MN %6.4f\n', M);

% Drop out of OPER menu
fprintf(fid, '%s\n',   '');

% Define the run case
fprintf(fid, 'c1 \n',  'c1');    
fprintf(fid, 'c %6.4f\n',Cl);
fprintf(fid, 'd %6.4f\n',Density);
fprintf(fid, 'g %6.4f\n',Gravity);
fprintf(fid, 'm %6.4f\n',Mass);
fprintf(fid, '\n');

% Run the Case
fprintf(fid, '%s\n',   'x'); 

% Save the ft data
fprintf(fid, '%s\n',   'ft'); 
fprintf(fid, '%s%s\n',filename,'.ft');   

% Save the fs data
fprintf(fid, '%s\n',   'fs'); 
fprintf(fid, '%s%s\n',filename,'.fs');

% Drop out of OPER menu
fprintf(fid, '%s\n',   '');

% Switch to MODE menu
fprintf(fid, '%s\n',   'MODE');
fprintf(fid, '%s\n',   'n');

% Exit MODE Menu
fprintf(fid, '\n');     
% Quit Program
fprintf(fid, 'Quit\n'); 

% Close File
fclose(fid);

%% Execute Run
% Run AVL using 
[status,result] = dos(strcat('.\avl.exe < ',filename,'.run'));

%% Open the Strip forces .fs file for computing wing root bending moment
% Open the file with read permission
fid_fs = fopen(strcat(filename,'.fs'), 'r');
Data_wing_0= textscan(fid_fs,'%f %f %f %f %f %f %f %f %f %f %f %f %f',20,'headerLines',20);
Data_winglet_0= textscan(fid_fs,'%f %f %f %f %f %f %f %f %f %f %f %f %f',20,'headerLines',51);
fclose(fid_fs);

Data_full_0= cat(2, Data_wing_0{:,:}, Data_winglet_0{:,:});
Data_full_0= [Data_full_0(1:20,1:13);Data_full_0(1:20,14:26)];
y_0=Data_full_0(:,2);
c_0=Data_full_0(:,3);
cl_0=Data_full_0(:,8);
for i=1:length(y_0)
    q_0(i)=c_0(i)*cl_0(i)*dyp;
    S_0(i)=trapz(y_0(1:i),q_0(1:i)',1); 
end

Mr=trapz(y_0,S_0); % Bending Moment

%% Open the Total forces .ft file
% Open the file with read permission
fid_ft = fopen(strcat(filename,'.ft'), 'r');
Total_Force_Data= textscan(fid_ft,'%s %s %s %s %s %s %s %s',25,'headerLines',25);
fclose(fid_ft);

Cd_i=str2num(Total_Force_Data{1, 6}{1, 1}); % Reading the Induced Drag

end
