close all; clear;
load('matlab')

x = reshape(geom_painel.C1X(geom_painel.surf_idx==1),33,12)';
y = reshape(geom_painel.C1Y(geom_painel.surf_idx==1),33,12)';

% surf(x,y,-D);
surf(fliplr(x),fliplr(-y),fliplr(abs(D)));
axis equal
% hold on
figure()
D_H=run.rho*w_ind_h.*DELTA_V_STRGH.*dy;
surf(x,y,abs(D_H));

% surf(fliplr(x),fliplr(-y),fliplr(-D_H));
axis equal

