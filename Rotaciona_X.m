function [ Y_f,Z_f ] = Rotaciona_X( Y,Z,d )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
Y_f = Y*cosd(d)+Z*sind(d);
Z_f = -Y*sind(d)+Z*cosd(d);

end

