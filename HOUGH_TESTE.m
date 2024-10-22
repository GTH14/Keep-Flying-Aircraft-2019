close all;
%% Inicialização do Struct
% Struct_aviao
Struct_constantes
Struct_mortes
load('perfil_structure_v1')
load('tracao_structure_2017.mat')
%load('aviao')
motivo_morte=zeros(1,13);
v_aviao=zeros(1,14);
%Testa_chutes; % Vetor parâmetros de chute para testes
%% Parâmetros de Chute
aviao.b=b;
aviao.AR=AR;
aviao.fb=fb;
aviao.t=t;
aviao.fh_asa=fh_asa;
aviao.tw=tw;
aviao.l_BF=l_BF;
aviao.fb_e=fb_e;
aviao.fc_e=fc_e;
aviao.perfil=perfil;
aviao.i_w1=i_w1;
aviao.offset_w2=offset_w2;
aviao.i_w2=i_w2;
aviao.f_xCG=f_xCG;
aviao.motor=motor;
%aviao.h_motor=h_motor;
%% GEOMETRIA - ok
[aviao,mortes]=geometria_MAIN(aviao,mortes,perfil_structure);
%% AERODINAMICA

dens_range = 400:50:600;
CD_vec = zeros(size(dens_range)); CD_H_vec = CD_vec;
for i = 1:length(dens_range)
    dens = dens_range(i);
    [ CD, CD_H ] = AeroMainHOUGH( aviao,const,dens);
    CD_vec(i) = CD;
    CD_H_vec(i) = CD_H;
end
%%
figure(1)
plot(dens_range, CD_vec);
hold on
plot(dens_range, CD_H_vec)
grid on

