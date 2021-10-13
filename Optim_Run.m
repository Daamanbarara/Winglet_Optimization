function[J]=Optim_Run(X)
Cd_i0 = 0.0113802; % Induced Drag of the Planar Wing without winglet
Mr_0 =2.514505306680092e+06; % Bending Moment of the Planar Wing without winglet

% Executing the scripts in order
[AVL_file] = AVL_Write_File(X);
[g,Cl]= Constfun(X);
[Cd_i,Mr]  = AVL_Run(AVL_file,Cl);
[J]= Objective_function(Cd_i,Mr);

end
