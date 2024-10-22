%% aviao teste - geometria
aviao.b = 3.64; %envergadura
aviao.AR = 5.8272; %aspect ratio
aviao.fb = [0.5, .5]; %frações de envergadura de cada seção
aviao.t = [0.97222, 0.8, 0.8357]; %tapers
aviao.h_c_4 = 0.2;  %altura da asa no 1/4 de corda da raiz em função do MAC
aviao.l_Q = [1.5794,-0.52635,0.78391] ; %enflechamento no 1/4 de corda de cada seção%aviao.i_w = 6; %incidência da asa
%aviao.c_tip = 0.45; %corda na ponta
%viao.d_bf_ba_x = 1.93; %distância entre o BF da asa e o BA da empenagem horizontal no eixo X
aviao.d_bf_ba_z = .5; %distância entre o BF da asa e o BA da empenagem horizontal no eixo Z
const.ball_n = 45; %número de bolinhas
aviao.ball_z = 5; %número de bolinhas em Z
aviao.c_tip_h = 0.2; %corda na ponta da EH
aviao.t_h = 0.66667; %taper da EH
aviao.b_h = 1.02; %envergadura da EH
aviao.perfil =  4*[1 1 1 1];
aviao.perfil_h = [1,1];
aviao.ME = 5;
aviao.c_tip = .3;

%const.d_bf_ev_ba_eh = 0;