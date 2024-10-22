function [ aviao ] = AeroMainGenetico( aviao,const,perfil_structure)
%% Inicializa as variáveis da asa
geom.AR = aviao.AR;
geom.b = aviao.b;
geom.i_wl=aviao.i_w;
geom.fb = aviao.fb;
geom.t = aviao.t;
zero_sec = zeros(1,length(geom.t)); 
geom.l = aviao.l_Q; 
geom.died = zero_sec; % A princípio é tudo zero
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
% geom.fim_def = aviao.fb_e;
% geom.fd = aviao.fc_e;
% geom.offset_x = [0,aviao.offset];

%% Inicializa as variáveis da cauda
geom_h.AR = 4;
geom_h.b = aviao.b_h;
geom_h.i_wl=aviao.i_h;
geom_h.fb = [];
geom_h.t = aviao.t_h;
zero_sec = zeros(1,length(geom_h.t)); 
geom_h.l = zero_sec; 
geom_h.died = zero_sec; % A princípio é tudo zero
geom_h.twist = zero_sec;
% geom_h.offset_X = 0;
% geom_h.offset_Z = aviao.h_asa1_BA;
geom_h.corda_raiz = aviao.c_sec_h(1);
geom_h.perfis = aviao.perfil_h;
geom_h.dens = 300;
geom_h.S = 1/2; %Simetria %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
geom_h.MAC = aviao.MAC_h;
geom_h.offset_X = geom.d_BA_BA_X;
geom_h.offset_Z = geom.offset_Z+geom.d_BA_BA_Z;
geom_h.inv_perfil = true;

%% Inicializa as variáveis da fuselagem
geom.c_fus = aviao.cfus;
geom.b_fus = aviao.bfus;
geom.h_fus = aviao.hfus;

%% Inicia o vetor run
%lembrar de colocar o vetor const
%run.Q = const.vel;
run.beta = 0;
run.xCG = 0;
run.rho = const.rho;
run.zCG =  .1;
% run.zCG =  const.zCG; %%%%%%%%%%%%%%%
run.sym = true;
run.mu = const.visc;
run.Q = 10;


%% Monta malha do avião
% Monta asa
[ geom_malha(1),geom ] = AeroMalhaGenetico( geom,perfil_structure );
% Monta a empenagem horizontal
[ geom_malha(2),geom_h ] = AeroMalhaGenetico( geom_h,perfil_structure );
% PlotaMalha(  geom_malha )

% PlotaMalha(  geom_malha );


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


%% Calcula os coeficientes com alpha alterado sem efeito solo
%condições
run.alpha = 1;
run.ground = false;
%matriz de influencia
inf_alpha_alter = AERO_RHS(run,geom_painel,inf_alpha);

%% Acha o xcg do avião
fun = @(x) AeroAchaxCP(x,run,aviao.ME,geom,geom_malha,geom_painel,inf_alpha_alter,inf_alpha0);
xCG = fzero(fun,geom.corda_raiz);
run.xCG = xCG;
aviao.x_cg = xCG; 

%% Coeficientes com o xCG correto
run.alpha = 0;
coef_alpha0 = AERO_SECOMP_Genetico (run,geom,geom_malha,geom_painel,inf_alpha0);
run.alpha = 1;
coef_alpha_alter = AERO_SECOMP_Genetico (run,geom,geom_malha,geom_painel,inf_alpha_alter);

%testaME = -100*(coef_alpha_alter(end).CM-coef_alpha0(end).CM)/(coef_alpha_alter(end).CL-coef_alpha0(end).CL)

%% Arrasto parasita
geom.Svetor = [geom.S,geom_h.S];
geom.MACvetor = [geom.MAC,geom_h.MAC];
[CD_parasita,CD_parasita_vetor] = AERO_PARASITA_genetico(run, geom);
%cdp = CD_parasita/length(coef_alpha0(1).Cd)/2;
cdp = CD_parasita_vetor(1)/length(coef_alpha0(1).Cd)/2; %cd parasita ao longo da semi-envergadura
[CD_parasita_fus] = AERO_PARASITA_genetico_fuselagem(run, geom);
CD_parasita = CD_parasita+CD_parasita_fus;

%% Calcula os coeficientes com alpha 0 e com efeito solo
%condições
run.alpha = 0;
run.ground = true;
%matriz de influencia
[inf_alpha_solo]=AERO_INF_VORING_V02 (run,geom_painel);
inf_alpha0_solo = AERO_RHS(run,geom_painel,inf_alpha_solo);
[inf_alpha_solo_temp]=AERO_INF_VORING_V02D (run,geom_painel);
inf_alpha0_solo.B_H = inf_alpha_solo_temp.B;
coef_alpha0_solo = AERO_SECOMP_Genetico (run,geom,geom_malha,geom_painel,inf_alpha0_solo);



%% Calcula os coeficientes com alpha alterado com efeito solo
%condições
run.alpha = 1;
run.ground = true;
geom_malha_solo = geom_malha;
[ geom_malha_solo(1).X,geom_malha_solo(1).Z] =  Rotaciona_Y( geom_malha(1).X,geom_malha(1).Z,run.alpha); %% DEVE ROTACIONAR EM RELAÇÃO AO TP IMAGINÁRIO (NÃO ORIGEM)
[ geom_malha_solo(2).X,geom_malha_solo(2).Z] =  Rotaciona_Y( geom_malha(2).X,geom_malha(2).Z,run.alpha);

run.alpha = 0; %Alpha foi alterado na malha
geom_painel_solo = AERO_PAINEL (geom_malha_solo);
[inf_alpha_alter_solo]=AERO_INF_VORING_V02 (run,geom_painel_solo);
[inf_alpha_alter_solo_temp]=AERO_INF_VORING_V02D (run,geom_painel_solo);
inf_alpha_alter_solo.B_H = inf_alpha_alter_solo_temp.B;
inf_alpha_alter_solo = AERO_RHS(run,geom_painel_solo,inf_alpha_alter_solo);
coef_alpha_alter_solo = AERO_SECOMP_Genetico (run,geom,geom_malha_solo,geom_painel_solo,inf_alpha_alter_solo);
% PlotaMalha(  geom_malha_solo );

%% Calcula os coeficientes com deflexão sem efeito solo
geom.def = 5; % 5 graus é o suficiente para tirar as derivadas
geom.inicio_def = 0; % A princípio é 0
%decomentar linhas a baixo
% geom.fim_def = aviao.fb_e; % Como começa a deflexão começa na raíz o fim é o próprio fb_e
% geom.fd = aviao.fc_e;

%Deflexão da cauda
geom_malha_def = geom_malha;
Xaux = geom_malha_def(2).X-geom_h.offset_X;
Zaux = geom_malha_def(2).Z-geom_h.offset_Z;
[ Xaux,Zaux ] = Rotaciona_Y( Xaux,Zaux,-geom.def );
geom_malha_def(2).X = Xaux+geom_h.offset_X;
geom_malha_def(2).Z = Zaux+geom_h.offset_Z;

%painéis com deflexão
geom_painel_def = AERO_PAINEL (geom_malha_def);

%condições
run.alpha = 0;
run.ground = false;
%matriz de influencia
[inf_def]=AERO_INF_VORING_V02 (run,geom_painel_def);
[inf_def_temp]=AERO_INF_VORING_V02D (run,geom_painel_def);
inf_def.B_H = inf_def_temp.B;
inf_def= AERO_RHS(run,geom_painel_def,inf_def);
coef_def = AERO_SECOMP_Genetico (run,geom,geom_malha_def,geom_painel_def,inf_def);


%% Calcula os coeficientes com deflexão com efeito solo
%condições
run.alpha = 0;
run.ground = true;
%matriz de influencia
[inf_def_solo]=AERO_INF_VORING_V02 (run,geom_painel_def);
[inf_def_solo_temp]=AERO_INF_VORING_V02D (run,geom_painel_def);
inf_def_solo.B_H = inf_def_solo_temp.B;
inf_def_solo= AERO_RHS(run,geom_painel_def,inf_def_solo);
coef_def_solo = AERO_SECOMP_Genetico (run,geom,geom_malha_def,geom_painel_def,inf_def_solo);

%% CLMAX
[alpha_stall, CL_max] = AERO_CLMAX_EAST(run, geom, geom_malha, geom_painel, inf_alpha0, coef_alpha0, coef_alpha_alter, aviao, perfil_structure);

%% Coeficientes, Derivadas, xCG e ACs

aviao.CM_zero=coef_alpha0(end).CM;            %[-] CM do avião para alfa=0
aviao.CM_alfa=(coef_alpha_alter(end).CM-aviao.CM_zero)/deg2rad(1);            %[1/rad] CM_alfa do avião em relação ao CG
aviao.CL_zero=coef_alpha0(end).CL;            %[-] CL do avião para alfa=0
aviao.CL_zero_w=coef_alpha0(1).CL;          %[-] CL da asa 1(inferior) para alfa=0
% aviao.CL_zero_2=coef_alpha0(2).CL;          %[-] CL da asa 2(superior) para alfa=0
aviao.CL_alfa=(coef_alpha_alter(end).CL-aviao.CL_zero)/deg2rad(1);            %[1/rad] CL_alfa do avião
aviao.CL_alfa_w=(coef_alpha_alter(1).CL - coef_alpha0(1).CL)/deg2rad(1);          %[1/rad] CL_alfa da asa 1(inferior)
aviao.CLeh_alfa=(coef_alpha_alter(2).CL - coef_alpha0(2).CL)/deg2rad(1);          %[1/rad] CL_alfa da asa 2(superior)
aviao.CD_parasita = CD_parasita;      %[-] CD parasita do avião
aviao.CD_zero=coef_alpha0(end).CD+CD_parasita;            %[-] CD total (induzido+parasita) do avião para alfa=0
aviao.CD_zero_w=coef_alpha0(1).CD+CD_parasita/2;          %[-] CD da asa 1(inferior) para alfa=0
% aviao.CD_zero_2=coef_alpha0(2).CD+CD_parasita/2;          %[-] CD da asa 2(superior) para alfa=0
aviao.CD_alfa=(coef_alpha_alter(end).CD-coef_alpha0(end).CD)/deg2rad(1);            %[1/rad] CD_alfa do avião
aviao.CD_alfa_w=(coef_alpha_alter(1).CD-coef_alpha0(1).CD)/deg2rad(1);          %[1/rad] CD_alfa da asa 1(inferior)
aviao.CDeh_alfa=(coef_alpha_alter(2).CD-coef_alpha0(2).CD)/deg2rad(1);          %[1/rad] CD_alfa da asa 2(superior)
% aviao.alfa_estol=max(NL_CL.GridVectors{1,1})*57.3 + 10;         %[º] Alfa de estol em voo
aviao.CD_solo=coef_alpha0(end).CD+CD_parasita;            %[-] CD total(induzido+parasita) do avião para alfa=0 em solo
aviao.oswald=aviao.CL_zero^2/(pi*geom.AR*(coef_alpha0(end).CD));             %[-] Oswald Efficency Number em voo
aviao.CL_de= (coef_def(end).CL-coef_alpha0(end).CL)/deg2rad(geom.def);      %[1/rad] Derivada do cl c/ relação a deflexão do elevon
% aviao.CL_max=max(NL_CL.Values);             %[-] Cl_máx da aeronave em voo
aviao.CM_de=(coef_def(end).CM-coef_alpha0(end).CM)/deg2rad(geom.def);              %[1/rad] Derivada do cm c/ relação a deflexão do elevon
% aviao.CD_de=(coef_def(end).CD-coef_alpha0(end).CD)/deg2rad(geom.def);    %[1/rad] Derivada do cD c/ relação a deflexão do profundor
aviao.CL_solo=coef_alpha0_solo(end).CL;            %[-] CL do avião em solo para alfa=0
aviao.CL_alfa_solo=(coef_alpha_alter_solo(end).CL-aviao.CL_solo)/deg2rad(1);       %[1/rad] CL_alfa do avião em solo
% aviao.CD_alfa_solo=(coef_alpha_alter_solo(end).CD-aviao.CD_solo)/deg2rad(1); 
aviao.CL_de_solo=(coef_def_solo(end).CL-coef_alpha0_solo(end).CL)/deg2rad(geom.def);         %[1/rad] Derivada do cl c/ relação a deflexão do elevon em solo
% aviao.CD_de_solo=(coef_def_solo(end).CD-coef_alpha0_solo(end).CD)/deg2rad(geom.def);  
aviao.CM_solo=coef_alpha0_solo(end).CM;            %[-] CM do avião em solo para alfa=0
aviao.CM_alfa_solo=(coef_alpha_alter_solo(end).CM-aviao.CM_solo)/deg2rad(1);       %[1/rad] CM_alfa do avião em solo
aviao.CM_de_solo=(coef_def_solo(end).CM-aviao.CM_solo)/deg2rad(geom.def);         %[1/rad] Derivada do cm c/ relação a deflexão do elevon em solo
% aviao.alfa_estol_solo=0;    %[º] Alfa de estol em solo
aviao.def_elev=12;           %[º] Deflexão negativa máxima do elevon
% aviao.SM=-100*aviao.CM_alfa/aviao.CL_alfa;                 %[%] Porcentagem de margem estática
aviao.CL_max = CL_max;
aviao.alfa_estol = alpha_stall;
% aviao.nl_CL=NL_CL;
% aviao.nl_CM=NL_CM;


% % SM parcial de cada asa
% 
% SM1 = -(coef_alpha_alter(1).CM-coef_alpha0(1).CM)/(coef_alpha_alter(1).CL-coef_alpha0(1).CL);
% SM2 = -(coef_alpha_alter(2).CM-coef_alpha0(2).CM)/(coef_alpha_alter(2).CL-coef_alpha0(2).CL);
% 
% aviao.xAC(1) = SM1*aviao.MAC+run.xCG ; %[m] Posição em x do Centro Aerodinâmico de cada asa
% aviao.xAC(2) = SM2*aviao.MAC+run.xCG ;
% %[m] Posição em z do Centro Aerodinâmico de cada asa em relação ao chão
% aviao.zAC=[aviao.h_asa1_BA,aviao.h_asa2_BA]-tand([geom.i_wl,geom.i_wl+geom.i_w_rel]).*aviao.xAC;

% alfa_estol_solo (CL_max=CL_solo+CL_alfa_solo*alfa_estol_solo)
% alfa_estol_solo = (aviao.CL_max - aviao.CL_solo)/aviao.CL_alfa_solo;        %[rad]
% [CL_max_solo,max_idx] = max(NL_CL.Values); alpha_grid = NL_CL.GridVectors{1,1};
% aviao.alfa_estol_solo = rad2deg(alpha_grid(max_idx));
% aviao.theta_crit_asa = theta_crit_asa;



%% Mortes 

Cl_0 = coef_alpha0(1).Cl;
 %Distribuição
 b_lim_max_cl = aviao.b/2*0.4; 
 [~,index_max_cl] = max(Cl_0);
 y_max_cl  = linspace(0, aviao.b/2, length(Cl_0));
 y_max_cl = y_max_cl(index_max_cl);
 mortes.estol_ponta = 0;
 if y_max_cl>=b_lim_max_cl
     mortes.estol_ponta = 1;
 end
%  
%  % plot da distribuição
%  figure(2)
%  plot(aviao.y1,aviao.cl0_y1)
 
 %Fuselagem
 
 alpha_estol_solo = 14;
 hf = 0.5;  %altura da fuselagem em relação ao chão
 h_min = geom.c_fus*sind(alpha_estol_solo);
 f_seg = 1.1;
 
 
 mortes.fuselagem = 0;
 if hf<f_seg*h_min
     mortes.fuselagem = 1;  
 end
 
 
 %debug
 disp( mortes.estol_ponta);
 disp( mortes.fuselagem);

aviao.geom_malha = geom_malha;
end

