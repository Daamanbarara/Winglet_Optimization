function [J]= Objective_function(Cd_i,Mr)
%% Reference values for the Planar Wing
Cd_i0 = 0.0113802; % Induced Drag of the Planar Wing
Mr_0 =2.514505306680092e+06; % Bending Moment of the Planar Wing

%% Objective function
% Change the value of k accordingly - 
% k=0- Winglet optimized for the minimum bending moment
% k=0.5- WInglet optimized for equal weightage to the minimum induced drag
% and bending moment
% k=1- Winglet optimized for the minimum induced drag
k=1;
J= k*(Cd_i/Cd_i0)+(1-k)*(Mr/Mr_0); 
end
