tic
%% Inicialização do Struct
Struct_aviao
Struct_constantes
Struct_mortes
Struct_estab
%load('perfil_structure_vteste')
load('perfil_structure.mat');
%% Parametros de Chute

%Asa
% aviao.b = b;                    %[m] Envergadura da asa
% aviao.fb = fb;           %[m] Vetor com frações de envergadura
% aviao.AR = AR;                   %[-] Razão de aspecto
% aviao.i_w = i_w;                  %[º] Incidência na raiz
% aviao.t = t;         %[-] Vetor de taper em cada seção
% aviao.l = l;         %[] Vetor enflechamento
% aviao.tw = tw;        %[°] Vetor de twist
% aviao.d = d;         %[] Vetor de diedro em cada seção
% aviao.perfil = perfil; %[-] Vetor de perfis em cada seção
% aviao.h_BA = h_BA;                 %[m] Altura do BA da asa
% 
% %Cauda
% aviao.d_BF_BA_x = d_BF_BA_x;            %[m] Distância do BF da asa ao BA da cauda em x
% aviao.d_BF_BA_z = d_BF_BA_z;            %[m] Distância do BF da asa ao BA da cauda em z
% aviao.c_root_EH = c_root_EH;            %[m] Corda na raiz da EH
% aviao.t_EH = t_EH;            %[-] Vetor de taper em cada seção da EH
% aviao.b_EH = b_EH;                 %[m] Envergadura da EH
% aviao.fb_EH = fb_EH;
% aviao.i_EH = i_EH;                 %[°] Incidência da EH
% aviao.f_prof = f_prof;               %[-] Fração de corda atuável da EH
% aviao.perfil_EH = perfil_EH;            %[-] Perfil da EH
% 
% aviao.f_x_cg = f_x_cg;               %[-] Posição do CG em x/c_root

%Asa
aviao.b = 2;                    %[m] Envergadura da asa
aviao.fb = [0.7 0.8 0.6];           %[m] Vetor com frações de envergadura
aviao.AR = 5;                   %[-] Razão de aspecto
aviao.i_w = 2.5;                  %[º] Incidência na raiz
aviao.t = [0.95 0.87 0.74 0.6];         %[-] Vetor de taper em cada seção
aviao.l = [1 5 10 25];         %[] Vetor enflechamento
aviao.tw = [0 3 2 3];        %[°] Vetor de twist
aviao.d = [0 5 5 10];         %[] Vetor de diedro em cada seção
aviao.perfil = [6 6 6 6 6]; %[-] Vetor de perfis em cada seção
aviao.h_BA = 0.175;                 %[m] Altura do BA da asa

%Cauda
aviao.d_BF_BA_x = 0.8;            %[m] Distância do BF da asa ao BA da cauda em x
aviao.d_BF_BA_z = 0.15;            %[m] Distância do BF da asa ao BA da cauda em z
aviao.c_root_EH = 0.4;            %[m] Corda na raiz da EH
aviao.t_EH = [0.8 0.8];            %[-] Vetor de taper em cada seção da EH
aviao.b_EH =0.3;                 %[m] Envergadura da EH
aviao.fb_EH = 0.6;
aviao.i_EH = 0;                 %[°] Incidência da EH
aviao.f_prof = 0.25;               %[-] Fração de corda atuável da EH
aviao.perfil_EH = 6;            %[-] Perfil da EH

aviao.f_x_cg = 0.35;               %[-] Posição do CG em x/c_root

save('aviao')

%% GEOMETRIA
[aviao, mortes] = main_geometria(aviao, mortes, perfil_structure);
% plota_aviao(aviao , perfil_structure);
aviao.morte = 0;
%% AERODINAMICA
if aviao.morte == 0
    [aviao, mortes] = main_aerodinamica(aviao, mortes, const, perfil_structure);
    %% ESTABILIDADE ESTÁTICA
    if aviao.morte == 0
        [aviao, mortes] = main_estab_estatica(aviao, mortes);
        aviao.morte = 0;
        aviao.CL_alfa_EV = 0;
        %% ESTRUTURAS
%         if aviao.morte == 0
%             [aviao] = main_estruturas(aviao, mortes, perfil_structure, const);
        aviao.pv = 2;
        aviao.xmotor = 0.14;
%         aviao.ix= Ix;
%         aviao.iy = Iy;
%         aviao.iz = Iz;
%         aviao.ixz= Ixz;
%         aviao.ixy = 0;
%         aviao.iyz=0;
        aviao.zCG = aviao.h_BA;
        aviao.zmotor = aviao.h_BA;
            %% DESEMPENHO
            %% ESTABILIDADE DINÂMICA
            if aviao.morte == 0
                [aviao] = main_desempenho(aviao, const);
                [aviao, mortes] = main_estab_dinamica(aviao, const, mortes, estab);
            end
%         end
    end
end
%% Outputs p/ o Modefrontier
% Motivo da Morte

% Geometria
m_geometria = mortes.geometria;

%Aerodinâmica
m_Reynolds = mortes.Reynolds;
m_estol_ponta = mortes.estol_ponta;

%Estabilidade estática
m_ME = mortes.ME;
m_alfa_trim = mortes.alfa_trim;
m_def_trim_prof = mortes.def_trim_prof;
m_Cl_beta = mortes.Cl_Beta;
m_Cn_beta = mortes.Cn_Beta;
%Desempenho

%Estruturas
m_xmotor = mortes.xmotor;

%Estabilidade dinâmica
%Inicialmente não vai matar
% % Vetor avião

%% Geometria

a_MAC = aviao.MAC;                  %[m] Corda Média Aerodinâmica
a_S = aviao.S;                    %[m^2] Área da asa
a_c = aviao.c;      %[m] Vetor das cordas de cada seção
a_S_EH = aviao.S_EH;

%% Aerodinamica

% a_CL_0 = aviao.CL_0;                 %[-] CL para alfa = 0
% a_CL_0_solo = aviao.CL_0_solo;            %[-] CL para alfa = 0 em solo
% a_CL_alfa = aviao.CL_alfa;              %[1/rad] CL_alfa
% aviao.CL_alfa_solo;         %[1/rad] CL_alfa em solo
% aviao.CL_def;               %[1/rad] Derivada do CL c/ relação a deflexão do profundor
% aviao.CL_def_solo;          %[1/rad] Derivada do CL c/ relação a deflexão do profundor em solo
% aviao.CM_0;                 %[-] CM para alfa = 0
% aviao.CM_0_solo;            %[-] CM para alfa = 0 em solo
% aviao.CM_alfa;              %[1/rad] CM_alfa em relação ao CG
% aviao.CM_alfa_solo;         %[1/rad] CM_alfa em solo
% aviao.CM_def;               %[1/rad] Derivada do CM c/ relação a deflexão do profundor
% aviao.CM_def_solo;          %[1/rad] Derivada do CM c/ relação a deflexão do profundor em solo
% aviao.CD_0;                 %[-] CD para alfa = 0
% aviao.CD_0_solo;            %[-] CD para alfa = 0 em solo
% aviao.CD_alfa;              %[1/rad] CD_alfa
% aviao.CD_alfa_solo;         %[1/rad] CD_alfa em solo
% aviao.CD_def;               %[1/rad] Derivada do CD c/ relação a deflexão do profundor
% aviao.CD_def_solo;          %[1/rad] Derivada do CD c/ relação a deflexão do profundor em solo
a_alfa_estol = aviao.alfa_estol;           %[º] Alfa de estol em voo
a_CL_max = aviao.CL_max;
% aviao.alfa_estol_solo;      %[º] Alfa de estol em solo
% aviao.def_max;              %[º] Deflexão máxima do profundor

%% Estabilidade
a_alfa_trim = aviao.alfa_trim;
a_bv = aviao.bv;
a_cv_root = aviao.cv_root;
a_S_EV = aviao.S_EV;
a_lv = aviao.lv;                   
a_Cl_beta = aviao.Cl_beta;              %[1/º] Derivada de momento / eixo X
a_Cn_beta = aviao.Cn_beta;              %[1/º] Derivada de momento / eixo Z
% a_v_ev = aviao.v_ev;                 %[-] "Volume" da EV
% a_v_eh = aviao.v_eh;                 %[-] "Volume" da EH

%% Desempenho

a_MTOW = aviao.MTOW;               %[kg] Massa total levantada

%% Estruturas

a_z_motor = aviao.z_motor;
a_x_motor = aviao.x_motor;               % Posição X do motor

a_PV = aviao.PV;                   %[kg] Peso vazio
a_CP = aviao.CP;                   %[kg] Carga paga
a_ee = a_CP/a_PV;
pCP = 12.5*a_CP;
pEE = 5*a_ee;
aviao.pontuacao = pCP + pEE;
a_pontuacao = aviao.Pontuacao;            %[kg] Pontuação
a_tempo               = toc;
save('aviao')