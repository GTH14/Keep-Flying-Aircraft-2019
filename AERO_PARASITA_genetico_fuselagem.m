function [CD_zero_fus] = AERO_PARASITA_genetico_fuselagem(run, geom)

% c_fus = geom.c_fus;
% b_fus = geom.b_fus;
% h_fus = geom.h_fus;
c_fus = 0;
b_fus = 0;
h_fus = 0;
S = geom.S;
fator_Q = 1;
Re=run.Q*c_fus/run.mu;     %fuselagem
Cf=0.455*(log10(Re)).^-2.58;
f=c_fus/b_fus;
FF=1+60*f^-3+f/400;
k_swet = 1;
Swet=k_swet*(2*c_fus*h_fus+2*b_fus*h_fus+c_fus*b_fus);
CD_zero_fus=fator_Q.*(Cf.*(FF.*Swet))/S;


end

