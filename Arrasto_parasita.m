function [CD_parasita] = Arrasto_parasita(perfil,run,geom,geom_h)

%Cálculo Reynolds e Cf

rho = run.rho;
Velocidade = run.Q;
MAC = geom.MAC;
MAC_eh = geom_h.MAC;
mu = run.mu;

Re_asa = rho*Velocidade*MAC/mu; 
Re_eh = rho*Velocidade*MAC_eh/mu; 

%Cf_turb=0.455/log10(Re)^2.58;
Cf_asa_turb = 0.455*(log10(Re_asa))^-2.58;
Cf_eh_turb = 0.455*(log10(Re_eh))^-2.58;



%Cálculo Form Factor (FF)

%M = Velocidade/340;
%Pa1 = aviao.perfil(1,1);
%Pa2 = aviao.perfil(1,2);
%Pa3 = aviao.perfil(1,3);
%Pa4 = aviao.perfil(1,4);
%Pa5 = aviao.perfil(1,5);
P_asa = geom.perfis(1,1);
P_eh = geom_h.perfis(1,1);
%[t_asa, pos] = max([perfil(Pa1).t_c,perfil(Pa2).t_c,perfil(Pa3).t_c,perfil(Pa4).t_c,perfil(Pa5).t_c]);
maxtc_asa = perfil(P_asa).t_c;
maxtc_eh = perfil(P_eh).t_c;
%loc_th_asa = perfil(aviao.perfil(1,pos)).maxt_x*MAC;
x_maxtc_asa = perfil(P_asa).maxt_x;
x_maxtc_eh = perfil(P_eh).maxt_x;

FF_asa = (1+(0.6/x_maxtc_asa)*maxtc_asa+100*maxtc_asa^4); 
FF_eh = (1+(0.6/x_maxtc_eh)*maxtc_eh+100*maxtc_eh^4);      



%Cálculo CD_parasita

S_asa = geom.S;
S_eh = geom_h.S;
S_wet_asa = 2*S_asa;
S_wet_eh = 2*S_eh;

%CD_0_vetor = Cf*FF*S_wet/S;
CD_asa_parasita = Cf_asa_turb*FF_asa*S_wet_asa/S_asa;
CD_eh_parasita = Cf_eh_turb*FF_eh*S_wet_eh/S_eh;

CD_parasita = CD_asa_parasita+CD_eh_parasita;
end