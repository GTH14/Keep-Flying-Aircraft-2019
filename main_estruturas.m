function [aviao, mortes] = main_estruturas(aviao, mortes, perfil_structure, const)
%% DESCRIÇÃO %%
%Função que tem como objetivos: Calcular uma longarina de tubo de carbono
%partir da distribuição de esforços na aeronave; Obtenção da distância longitudinal do
%motor para garantir a posição do CG; Calculo do PV da aeronave; Calculo
%dos momentos de inercia


%% RETIRANDO DADOS DO AVIAO %%

perfil_asa = aviao.perfil;
perfil_V= 5;
b=2*aviao.b_sec;
c=aviao.c;
d = cumsum(aviao.d);
%hf=aviao.h_fus;
%bf=aviao.b_fus;
%cf=aviao.c_fus;
%cl_alfa2d=perfil_structure(perfil_asa).Clalfa;
%alfa_zero=perfil_structure(perfil_asa).alfa_zero;
%cm2d=perfil_structure(perfil_asa).Cm;
%CL_alfa=aviao.CL_alfa;
%CL_zero=aviao.CL_zero;
%CL_max=aviao.CL_max;
%S=aviao.S;
%c_raiz_VT = aviao.c_v; %%% considerando leme retangular
%c_ponta_VT = aviao.c_v;
%m_motor=tracao_structure(aviao.motor).massa;
area_perfilasa= zeros (numel(perfil_asa,1));
% area_perfilEH= zeros (numel(perfil_H),1);
for j = 1: numel(perfil_asa)
    area_perfilasa(j)=perfil_structure(perfil_asa(j)).area_unit;
end
area_perfilEH= zeros (2,1);
area_perfilEH(1)= perfil_structure(aviao.perfil_EH).area_unit;
area_perfilEH(2)= perfil_structure(aviao.perfil_EH).area_unit;
area_perfilEV=perfil_structure(perfil_V).area_unit;
h_asa=aviao.h_BA; 
l = cumsum(aviao.l);
l_BA= cumsum(aviao.l_BA);
d_BA_motor= aviao.d_BA_motor;
%% CORPO DA FUNÇÃO %%
%% Obtendo distribuição do cl
CARGAS_PACK = aviao.CARGAS_PACK;
q=CARGAS_PACK.l;
x=CARGAS_PACK.CVX;
db=CARGAS_PACK.CVY(1,:);
s = size(db);
%% Calculando momento fletor e torsor
Mfle= zeros(s(2),1);
Mtor= zeros (s(2),1);
j = 1;
Mfle(j)= trapz(db(j:s(2)), sum (q(:,(j:s(2)))))*sum(db(j:s(2)).*sum (q(:,(j:s(2)))))/sum(sum (q(:,(j:s(2)))));
for j = 2:(s(2) - 1)
    Mfle(j)= trapz(db(j:s(2)), sum (q(:,(j:s(2)))))*sum((db(j:s(2)) - db(j-1).*sum (q(:,(j:s(2))))))/sum(sum (q(:,(j:s(2)))));
    Mtor(j)= - sum(sum(q(:,(j:s(2))).*(c(1)/4 - x(:,(j:s(2))))));
end
%% Calculando massa e centros da longarina
[m_long,x_long,y_long,z_long,r_long] = estruturas_longarina(Mfle,Mtor, const,b,l,d,c,q,h_asa);
%% Peso vazio e posicao do motor
[pv,xmotor,Ix,Iz,Iy,Ixz,zcg,z_motor] = ETT_PV_INERCIA(aviao, perfil_structure, perfil_asa, area_perfilEV,area_perfilEH,c,b/2,l_BA,l,area_perfilasa,m_long,x_long,y_long,z_long,r_long, const);

%% MORTE %%
if -xmotor<0.1 && -xmotor> d_BA_motor
    aviao.morte=1;
    mortes.xmotor = 1;
end
%% Salvando dados em aviao %%
aviao.pv = pv;
aviao.xmotor = xmotor;
aviao.ix= Ix;
aviao.iy = Iy;
aviao.iz = Iz;
aviao.ixz= Ixz;
aviao.ixy = 0;
aviao.iyz=0;
aviao.zCG = zcg;
aviao.zmotor = z_motor;
end