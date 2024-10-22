% load('aviao.mat')
Struct_aviao;
Struct_mortes;
Struct_constantes;
load('perfil_structure_KF19EAST_V04.mat');
aviao.AR = 5;
aviao.b = 3.65;
aviao.i_w = 9;
aviao.fb = [0.8 0.2];
aviao.t = [1 0.9 0.8];
aviao.l = [0 0 0] ; %Ver sentido certo
aviao.tw = [0 5 5];
aviao.h_BA = 0.9;
aviao.c(1) = 0.7;
aviao.perfil = [6 6 6 6];
% aviao.d_BA_x = 0 ; %A princípio é zero
% aviao.d_BA_z = 0.9;
aviao.S = 3; %Simetria 
aviao.MAC = 0.6;
aviao.d = [0 0 10];
% aviao.ME = 5;
aviao.f_x_cg = 0.25;%aviao.zCG;
aviao.z_cg = 0.382402528869991;%aviao.xCG ;
%% Inicializa as variáveis da cauda
aviao.b_EH =1.2;
aviao.i_EH = 0;
aviao.t_EH= 0.5;
aviao.c_root_EH = 0.3;
aviao.perfil_EH = [9 9];
aviao.S_EH = 0.5; 
aviao.MAC_EH = 0.3;
aviao.l_EH = 0;
aviao.d_BF_BA_x = 0.85;
aviao.d_BF_BA_z = 0.25;
aviao.f_prof = 0.5;

close all;
[aviao] = main_aerodinamica( aviao,mortes,const,perfil_structure );

