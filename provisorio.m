function [ aviao, mortes ] = AeroMainGenetico( aviao,mortes,const,perfil_structure)
%% Inicializa as variáveis da asa
geom.AR = aviao.AR;
geom.b = aviao.b;
geom.i_w=aviao.i_w;
geom.fb = aviao.fb;
geom.t = aviao.t;
zero_sec = zeros(1,length(geom.t)); 
geom.l = aviao.l_Q; 
geom.died = aviao.d; % A princípio é tudo zero
geom.twist = aviao.tw;
geom.offset_X = 0;
geom.offset_Z = aviao.h_BA;
geom.corda_raiz = aviao.c_sec(1);
geom.perfis = aviao.perfil;
geom.dens = 300;
%geom.i_w_rel = aviao.i_w2;
geom.d_BA_BA_X = aviao.d_BA_x; %A princípio é zero
geom.d_BA_BA_Z = aviao.d_BA_z;
geom.S = aviao.S/2; %Simetria 
geom.MAC = aviao.MAC;
geom.inv_perfil = false;
%% Inicializa as variáveis da cauda
geom_h.AR = (aviao.b_h^2)/aviao.S_h; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
geom_h.b = aviao.b_h;
geom_h.i_w=aviao.i_h;
geom_h.fb = [];
geom_h.t = aviao.t_h;
zero_sec = zeros(1,length(geom_h.t)); 
geom_h.l = aviao.l_Q_h*57.3; 
geom_h.died = zero_sec; % A princípio é tudo zero
geom_h.twist = zero_sec;
geom_h.corda_raiz = aviao.c_sec_h(1);
geom_h.perfis = aviao.perfil_h;
geom_h.dens = 200;
geom_h.S = aviao.S_h; %Simetria %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
geom_h.MAC = aviao.MAC_h;
geom_h.offset_X = geom.d_BA_BA_X;
geom_h.offset_Z = geom.offset_Z+geom.d_BA_BA_Z;
geom_h.inv_perfil = true;
%% Inicia o vetor run
%lembrar de colocar o vetor const
%run.Q = const.vel;
run.beta = 0;
run.xCG = aviao.x_cg;
run.rho = const.rho;
%run.zCG =  aviao.z_cg(1);
run.sym = true;
run.mu = const.visc;
run.Q = 10;
%% Monta malha do avião
% Monta asa
[ geom_malha(1), geom ] = AeroMalhaGenetico( geom, perfil_structure );
% Monta a empenagem horizontal
[ geom_malha(2), geom_h ] = AeroMalhaGenetico( geom_h, perfil_structure );
% PlotaMalha(  geom_malha )

%% Calcula os coeficientessem efeito solo
%% *** alfa 0 ***
%painéis
geom_painel = AERO_PAINEL (geom_malha);
%condições
run.alpha = 0;
run.ground = false;
%matriz de influencia
[inf_alfa]=AERO_INF_VORING_V02 (run,geom_painel);
% [inf_alpha_temp]=AERO_INF_VORING_V02D (run,geom_painel);
% inf_alpha.B_H = inf_alpha_temp.B;
inf_alfa_0 = AERO_RHS(run,geom_painel,inf_alfa);
coef_alfa_0 = AERO_SECOMP_Genetico (run,geom,geom_malha,geom_painel,inf_alfa_0);
%% *** alfa alterado ***
%condições
run.alpha = 1;
run.ground = false;
%matriz de influencia
inf_alfa_alter = AERO_RHS(run,geom_painel,inf_alfa);
%% Calcula os coeficientes sob efeito solo
%% *** alfa 0 *** solo
%condições
run.alpha = 0;
run.ground = true;
%matriz de influencia
[inf_alfa_solo]=AERO_INF_VORING_V02 (run,geom_painel);
inf_alfa_0_solo = AERO_RHS(run,geom_painel,inf_alfa_solo);
% [inf_alpha_solo_temp]=AERO_INF_VORING_V02D (run,geom_painel);
% inf_alpha0_solo.B_H = inf_alpha_solo_temp.B;
coef_alfa_0_solo = AERO_SECOMP_Genetico (run,geom,geom_malha,geom_painel,inf_alfa_0_solo);

%% *** alfa alterado *** solo
%condições
run.ground = true;
% Monta malha do avião em solo
geom_malha_solo = geom_malha;
[ geom_malha_solo(1).X,geom_malha_solo(1).Z] =  Rotaciona_Y( geom_malha(1).X,geom_malha(1).Z,run.alpha); %% DEVE ROTACIONAR EM RELAÇÃO AO TP IMAGINÁRIO (NÃO ORIGEM)
[ geom_malha_solo(2).X,geom_malha_solo(2).Z] =  Rotaciona_Y( geom_malha(2).X,geom_malha(2).Z,run.alpha);

run.alpha = 0; %Alpha foi alterado na malha
geom_painel_solo = AERO_PAINEL (geom_malha_solo);
[inf_alfa_alter_solo]=AERO_INF_VORING_V02 (run,geom_painel_solo);
% [inf_alpha_alter_solo_temp]=AERO_INF_VORING_V02D (run,geom_painel_solo);
% inf_alpha_alter_solo.B_H = inf_alpha_alter_solo_temp.B;
inf_alfa_alter_solo = AERO_RHS(run,geom_painel_solo,inf_alfa_alter_solo);
coef_alfa_alter_solo = AERO_SECOMP_Genetico (run,geom,geom_malha_solo,geom_painel_solo,inf_alfa_alter_solo);
% PlotaMalha(  geom_malha_solo );

