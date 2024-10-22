function [ ] = PlotaMalha(  geom_malha )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
figure(3)
for i = 1:length(geom_malha)
    surf(geom_malha(i).X,geom_malha(i).Y,geom_malha(i).Z)
    axis equal
    hold on
    % surf(geom_malha(2).X,geom_malha(2).Y,geom_malha(2).Z)
    % hold on
    % surf(geom_malha(3).X,geom_malha(3).Y,geom_malha(3).Z)
end

