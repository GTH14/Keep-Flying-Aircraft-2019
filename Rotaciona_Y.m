function [ X_f,Z_f ] = Rotaciona_Y( X,Z,alpha )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
X_f = X*cosd(alpha)+Z*sind(alpha);
Z_f = -X*sind(alpha)+Z*cosd(alpha);

end

