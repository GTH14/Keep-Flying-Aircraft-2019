function [ CD, CD_H ] = AeroMainHOUGH( aviao,const,dens)
%% Inicializa as variáveis
geom.AR = aviao.AR;
geom.b = aviao.b;
geom.i_wl=aviao.i_w1;
geom.fb = aviao.fb;
geom.t = aviao.t;
zero_sec = zeros(1,length(geom.t)); 
geom.l = aviao.l_Q; 
geom.died = zero_sec; % A princípio é tudo zero
geom.twist = aviao.tw;
geom.offset_X = 0;
geom.offset_Z = aviao.h_asa1_BA;
geom.corda_raiz = aviao.c_sec(1);
geom.perfis = aviao.perfil;
geom.dens = dens;
geom.i_w_rel = aviao.i_w2;
geom.d_BA_BA_X = 0; %A princípio é zero
geom.d_BA_BA_Z = aviao.d_BA_Z;
geom.S = aviao.S/2; %Simetria 
geom.MAC = aviao.MAC;
geom.corda_raiz = aviao.c_sec(1);
geom.fim_def = aviao.fb_e;
geom.fd = aviao.fc_e;
geom.offset_x = [0,aviao.offset];

%% Inicia o vetor run
%lembrar de colocar o vetor const
%run.Q = const.vel;
run.beta = 0;
run.xCG = aviao.xCG;
run.rho = const.rho;
run.zCG =  aviao.zCG;
run.sym = true;
run.mu = const.visc;
run.Q = 10;

% run.beta = 0;
% run.xCG = 0;
% run.rho = 1.1170;
% run.zCG = 0.1;


%% Monta malha do avião

% Monta asa de baixo
[ geom_malha(1),geom ] = AeroMalhaGenetico( geom );

% Monta asa de cima 
geom_malha(2) = geom_malha(1);
i_w_rel = geom.i_w_rel;
[ X_wu,Z_wu ] = Rotaciona_Y( geom_malha(2).X,geom_malha(2).Z,i_w_rel );
geom_malha(2).X = X_wu + geom.d_BA_BA_X;
geom_malha(2).Z = Z_wu + geom.d_BA_BA_Z;
% Fecha o espaço entre as asas
[ geom_malha ] = FechaBox( geom_malha );


%% Calcula os coeficientes com alpha 0 e sem efeito solo
%painéis
geom_painel = AERO_PAINEL (geom_malha);
%condições
run.alpha = 0;
run.ground = false;
%matriz de influencia
[inf_alpha]=AERO_INF_VORING_V02 (run,geom_painel);
[inf_alpha_temp]=AERO_INF_VORING_V02D (run,geom_painel);
inf_alpha.B_H = inf_alpha_temp.B;
inf_alpha0 = AERO_RHS(run,geom_painel,inf_alpha);
coef_alpha_H = AERO_SECOMP_Genetico (run,geom,geom_malha,geom_painel,inf_alpha0);
CD_H = coef_alpha_H(end).CD;
inf_alpha0.B_H = inf_alpha.B;
coef_alpha = AERO_SECOMP_Genetico (run,geom,geom_malha,geom_painel,inf_alpha0);
CD = coef_alpha(end).CD;

