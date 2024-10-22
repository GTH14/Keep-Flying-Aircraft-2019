function [CD_zero,CD_zero_vetor] = AERO_PARASITA_genetico(run, geom)
%Rever os fatores para empenagem conforme configuração

Re = run.rho*run.Q*[geom(:).MACvetor]/run.mu;
Cf=0.455*(log10(Re)).^-2.58;
FF = 1 + 0.6*[geom.t_max]./[geom.t_loc] + 100*[geom.t_max].^4;
S_wet = 2*[geom(:).Svetor];
CD_zero_vetor = Cf.*FF.*S_wet/geom.S;
CD_zero = sum(CD_zero_vetor);
%CD_zero = (run.sym+1) * CD_zero;
% maxtc_asa=perfil_structure(perfil_asa).t_c;
% maxtc_Ht=perfil_structure(perfil_Ht).t_c;
% maxtc_Vt=perfil_structure(perfil_Vt).t_c;
% 
% x_maxtc_asa=perfil_structure(perfil_asa).maxt_x;
% x_maxtc_Ht=perfil_structure(perfil_asa).maxt_x;
% x_maxtc_Vt=perfil_structure(perfil_asa).maxt_x;
% 
% FF(1)=1+0.6*maxtc_asa/x_maxtc_asa+100*(maxtc_asa)^4;
% FF(2)=1+0.6*maxtc_Ht/x_maxtc_Ht+100*(maxtc_Ht)^4;
% FF(3)=1+0.6*maxtc_Vt/x_maxtc_Vt+100*(maxtc_Vt)^4;

%Repensar o fator de de wetted area conforme a tendência geométrica
% k_swet=1.1;
% Swet(1)=k_swet*2*S;
% Swet(2)=k_swet*2*b_h*c_h;
% Swet(3)=k_swet*4*b_v*c_v;
% 
% cd0=fator_Q.*(Cf.*(FF.*Swet))/S;
% 
% %trem de pouso, considerando CD.S/areafrontal=0.25 => CD=0.25*area_frontal/S
% area_frontal_trem=0.3*0.03;
% 
% cd0(max(size(cd0))+1)=0.25*area_frontal_trem/S;
% 
% fator_cagada=.8;
% CD_zero=fator_cagada*sum(cd0);
end