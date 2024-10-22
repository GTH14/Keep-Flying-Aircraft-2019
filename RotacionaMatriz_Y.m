function [ X_f,Z_f ] = RotacionaMatriz_Y( X,Z,M_alpha )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
X_f = X.*cosd(M_alpha)+Z.*sind(M_alpha);
Z_f = -X.*sind(M_alpha)+Z.*cosd(M_alpha);

end

