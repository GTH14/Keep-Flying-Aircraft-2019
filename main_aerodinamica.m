function [ aviao, mortes ] = main_aerodinamica( aviao,mortes,const,perfil_structure)
%% Inicializa as variáveis da asa
geom.AR = aviao.AR;
geom.b = aviao.b;
% geom.i_wl=aviao.i_w;
geom.i_wl = 3;
geom.fb = aviao.fb;
geom.t = aviao.t;
geom.l = aviao.l; 
geom.died = aviao.d;
geom.twist = aviao.tw;
geom.offset_X = 0;
geom.offset_Z = aviao.h_BA;
geom.corda_raiz = aviao.c(1);
% geom.perfis = aviao.perfil;
geom.perfis = [ 6 6 6 6 6];
geom.dens = 500;
%geom.i_w_rel = aviao.i_w2;
geom.d_BA_BA_X = 0;%aviao.d_BA_x; %A princípio é zero
geom.d_BA_BA_Z = aviao.h_BA;
geom.S = aviao.S/2; %Simetria 
geom.MAC = aviao.MAC;
geom.inv_perfil = false;
% geom.fim_def = aviao.fb_e;
% geom.fd = aviao.fc_e;
% geom.offset_x = [0,aviao.offset];

%% Inicializa as variáveis da cauda
geom_h.AR = (aviao.b_EH^2)/aviao.S_EH; 
geom_h.b = aviao.b_EH;
geom_h.i_wl=aviao.i_EH;
geom_h.fb = aviao.fb_EH;
geom_h.t = aviao.t_EH;
zero_sec = zeros(1,length(geom_h.t)); 
geom_h.l = zero_sec; 
geom_h.died = zero_sec; % A princípio é tudo zero
geom_h.twist = zero_sec;
geom_h.corda_raiz = aviao.c_root_EH;
geom_h.perfis = [aviao.perfil_EH,aviao.perfil_EH,aviao.perfil_EH];
geom_h.perfis = [6 6 6 ];
geom_h.dens = 300;
geom_h.S = aviao.S_EH/2; 
geom_h.MAC = aviao.MAC_EH;
geom_h.offset_X = aviao.c(1)*cosd(aviao.i_w)+aviao.d_BF_BA_x;
geom_h.offset_Z = -geom.offset_Z*sind(aviao.i_w)+aviao.d_BF_BA_z;
geom_h.inv_perfil = true;
geom_h.f_prof = aviao.f_prof; 


%% Inicia o vetor run
%lembrar de colocar o vetor const
% run.Q = const.vel;
run.beta = 0;
% run.xCG = aviao.xCG;
run.xCG = 0.1;
run.rho = const.rho;
% run.zCG =  aviao.z_cg(1);
run.zCG = 0;
% run.zCG =  const.zCG; %%%%%%%%%%%%%%%
run.sym = true;
run.mu = const.visc;
run.Q = 10;
% [aviao,mortes] = Reynolds(run,geom,perfil_structure,aviao,mortes);
if aviao.morte == 0
        %% Monta malha do avião
    % Monta asa
    [ geom_malha(1), geom ] = AeroMalhaGenetico( geom, perfil_structure );
    % Monta a empenagem horizontal
    [ geom_malha(2), geom_h ] = AeroMalhaGenetico( geom_h, perfil_structure );
    % surf(geom_malha(2).X, geom_malha(2).Y, geom_malha(2).Z, 'FaceColor', 'b');
    % hold on;
    % PlotaMalha(  geom_malha )
    aviao.m_b = geom_malha(1).b_sec/2;
    run.alpha = 0;
    run.sym = true;
    %% Calcula os coeficientes com alpha 0 e sem efeito solo
    %painéis
    geom_painel = AERO_PAINEL (geom_malha);
    %condições
    run.alpha = 0;
    run.ground = false;
    %matriz de influencia
    [inf_alpha]=AERO_INF_VORING_V02 (run,geom_painel);
    % [inf_alpha_temp]=AERO_INF_VORING_V02D (run,geom_painel);
    % inf_alpha.B_H = inf_alpha_temp.B;
    inf_alpha0 = AERO_RHS(run,geom_painel,inf_alpha);
    run.alpha = 0;
    coef_alpha0 = AERO_SECOMP_Genetico (run,geom,geom_malha,geom_painel,inf_alpha0);
    %% Calcula os coeficientes com alpha alterado sem efeito solo
    %condições
    run.alpha = 1;
    run.ground = false;
    %matriz de influencia
    inf_alpha_alter = AERO_RHS(run,geom_painel,inf_alpha);
    run.alpha = 1;
    coef_alpha_alter = AERO_SECOMP_Genetico (run,geom,geom_malha,geom_painel,inf_alpha_alter);


    %% Arrasto parasita
    % geom.Svetor = [geom.S,geom_h.S];
    % geom.MACvetor = [geom.MAC,geom_h.MAC];
    % [CD_parasita,CD_parasita_vetor] = AERO_PARASITA_genetico(run, geom);
    % %cdp = CD_parasita/length(coef_alpha0(1).Cd)/2;
    % cdp = CD_parasita_vetor(1)/length(coef_alpha0(1).Cd)/2; %cd parasita ao longo da semi-envergadura
    % [CD_parasita_fus] = AERO_PARASITA_genetico_fuselagem(run, geom);
    % CD_parasita = CD_parasita+CD_parasita_fus;
    [CD_parasita] = Arrasto_parasita(perfil_structure,run,geom,geom_h);
    %% Calcula os coeficientes com alpha 0 e com efeito solo
    %condições
    run.alpha = 0;
    run.ground = true;
    %matriz de influencia
    [inf_alpha_solo]=AERO_INF_VORING_V02 (run,geom_painel);
    inf_alpha0_solo = AERO_RHS(run,geom_painel,inf_alpha_solo);
    % [inf_alpha_solo_temp]=AERO_INF_VORING_V02D (run,geom_painel);
    % inf_alpha0_solo.B_H = inf_alpha_solo_temp.B;
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
    % [inf_alpha_alter_solo_temp]=AERO_INF_VORING_V02D (run,geom_painel_solo);
    % inf_alpha_alter_solo.B_H = inf_alpha_alter_solo_temp.B;
    inf_alpha_alter_solo = AERO_RHS(run,geom_painel_solo,inf_alpha_alter_solo);
    coef_alpha_alter_solo = AERO_SECOMP_Genetico (run,geom,geom_malha_solo,geom_painel_solo,inf_alpha_alter_solo);
    % PlotaMalha(  geom_malha_solo );

    %% Calcula os coeficientes com deflexão sem efeito solo
    geom_h.def = 5; % 5 graus é o suficiente para tirar as derivadas

    geom_malha_def = geom_malha;
    [geom_malha_def(2), geom_h] = AeroMalhaGenetico(geom_h, perfil_structure);
    % surf(geom_malha_def(2).X, geom_malha_def(2).Y, geom_malha_def(2).Z, 'FaceColor', 'r');
    % PlotaMalha(geom_malha_def);
    % % descomentar linhas a baixo

    %Deflexão da cauda
    % painéis com deflexão
    geom_painel_def = AERO_PAINEL (geom_malha_def);

    %condições
    run.alpha = 0;
    run.ground = false;
    %matriz de influencia
    [inf_def]=AERO_INF_VORING_V02 (run,geom_painel_def);
    % [inf_def_temp]=AERO_INF_VORING_V02D (run,geom_painel_def);
    % inf_def.B_H = inf_def_temp.B;
    inf_def= AERO_RHS(run,geom_painel_def,inf_def);
    coef_def = AERO_SECOMP_Genetico (run,geom,geom_malha_def,geom_painel_def,inf_def);


    %% Calcula os coeficientes com deflexão com efeito solo
    %condições
    run.alpha = 0;
    run.ground = true;
    %matriz de influencia
    [inf_def_solo]=AERO_INF_VORING_V02 (run,geom_painel_def);
    % [inf_def_solo_temp]=AERO_INF_VORING_V02D (run,geom_painel_def);
    % inf_def_solo.B_H = inf_def_solo_temp.B;
    inf_def_solo= AERO_RHS(run,geom_painel_def,inf_def_solo);
    coef_def_solo = AERO_SECOMP_Genetico (run,geom,geom_malha_def,geom_painel_def,inf_def_solo);

    %% CLMAX
    [alpha_stall, CL_max, CARGAS_PACK] = AERO_CLMAX_EAST(run, geom, geom_malha, geom_painel, inf_alpha0, coef_alpha0, coef_alpha_alter, aviao, perfil_structure);
    % [NL_CL, NL_CM, aviao] = AERO_CLMAX(run, geom, geom_malha, geom_painel, inf_alpha0,coef_alpha0, coef_alpha_alter,coef_alpha0_solo, coef_alpha_alter_solo, aviao, perfil_structure);

    %% Coeficientes, Derivadas, xCG e ACs

    aviao.CM_0=coef_alpha0(end).CM;            %[-] CM do avião para alfa=0
    aviao.CM_alfa=(coef_alpha_alter(end).CM-aviao.CM_0);            %[1/º] CM_alfa do avião em relação ao CG
    aviao.CL_0=coef_alpha0(end).CL;            %[-] CL do avião para alfa=0
    % aviao.CL_zero_w=coef_alpha0(1).CL;          %[-] CL da asa 1(inferior) para alfa=0
    % aviao.CL_zero_2=coef_alpha0(2).CL;          %[-] CL da asa 2(superior) para alfa=0
    aviao.CL_alfa=(coef_alpha_alter(end).CL-aviao.CL_0) ;            %[1/rad] CL_alfa do avião
    aviao.CD_parasita = CD_parasita;      %[-] CD parasita do avião
    aviao.CD_0=coef_alpha0(end).CD+CD_parasita;            %[-] CD total (induzido+parasita) do avião para alfa=0
    aviao.CD_alfa=(coef_alpha_alter(end).CD-coef_alpha0(end).CD) ;         %[1/º] CD_alfa do avião 
    aviao.CD_alfa_solo=(coef_alpha_alter_solo(end).CD-coef_alpha0_solo(end).CD) ;         %[1/rad] CD_alfa do avião 
    % aviao.alfa_estol=max(NL_CL.GridVectors{1,1})*57.3 + 10;         %[º] Alfa de estol em voo
    aviao.CD_0_solo=coef_alpha0_solo(end).CD+CD_parasita;            %[-] CD total(induzido+parasita) do avião para alfa=0 em solo
    aviao.oswald=aviao.CL_0^2/(pi*geom.AR*(coef_alpha0(end).CD));             %[-] Oswald Efficency Number em voo
    aviao.CL_def= (coef_def(end).CL-coef_alpha0(end).CL)/5;      %[1/º] Derivada do cl c/ relação a deflexão do elevon
    % aviao.CL_max=max(NL_CL.Values);             %[-] Cl_máx da aeronave em voo
    aviao.CM_def=(coef_def(end).CM-coef_alpha0(end).CM)/5;              %[1/º] Derivada do cm c/ relação a deflexão do elevon
    aviao.CD_def=(coef_def(end).CD-coef_alpha0(end).CD)/5;    %[1/º] Derivada do cD c/ relação a deflexão do profundor
    aviao.CL_0_solo=coef_alpha0_solo(end).CL;            %[-] CL do avião em solo para alfa=0
    aviao.CL_alfa_solo=(coef_alpha_alter_solo(end).CL-aviao.CL_0_solo);       %[1/º] CL_alfa do avião em solo
    % aviao.CD_alfa_solo=(coef_alpha_alter_solo(end).CD-aviao.CD_solo)/deg2rad(1); 
    aviao.CL_def_solo=(coef_def_solo(end).CL-coef_alpha0_solo(end).CL);         %[1/º] Derivada do cl c/ relação a deflexão do elevon em solo
    aviao.CD_def_solo=(coef_def_solo(end).CD-coef_alpha0_solo(end).CD);  
    aviao.CM_0_solo=coef_alpha0_solo(end).CM;            %[-] CM do avião em solo para alfa=0
    aviao.CM_alfa_solo=(coef_alpha_alter_solo(end).CM-aviao.CM_0_solo);       %[1/º] CM_alfa do avião em solo
    aviao.CM_def_solo=(coef_def_solo(end).CM-aviao.CM_0_solo);         %[1/º] Derivada do cm c/ relação a deflexão do elevon em solo
    % aviao.alfa_estol_solo=0;    %[º] Alfa de estol em solo
    % % aviao.def_elev=12;           %[º] Deflexão negativa máxima do elevon
%     aviao.SM=-100*aviao.CM_alfa/aviao.CL_alfa;                 %[%] Porcentagem de margem estática
    aviao.CL_max = CL_max;
    aviao.alfa_estol = alpha_stall;
    % aviao.alfa_trim_pure = -aviao.CM_0/aviao.CM_alfa;
    % aviao.nl_CL=NL_CL;
    % aviao.nl_CM=NL_CM;
    aviao.Cl_0 = coef_alpha0(end).Cl;
    aviao.CL_0_EH = coef_alpha0(2).CL;
    aviao.CL_alfa_EH = (coef_alpha_alter(2).CL - coef_alpha0(2).CL);
    aviao.Cl_alfa = (coef_alpha_alter(end).Cl - coef_alpha0(end).Cl);
    aviao.Cd_0 = coef_alpha0(end).Cd;
    aviao.def_max = 15;
%     aviao.c = geom.corda_raiz*aviao.taper;
%     aviao.b_sec = cumsum(geom_malha(1).b_sec);
    aviao.CARGAS_PACK =CARGAS_PACK;

    %% Mortes 

    Cl_0 = coef_alpha0(1).Cl;
    
     %Distribuição
     b_lim_max_cl = aviao.b/2*0.15; 
     [~,index_max_cl] = max(Cl_0);
     y_max_cl  = linspace(0, aviao.b/2, length(Cl_0));
     y_max_cl = y_max_cl(index_max_cl);
     mortes.estol_ponta = 0;
     if y_max_cl>=b_lim_max_cl
         mortes.tip_stall = 1;
     end
    %  
    %  % plot da distribuição
    %  figure(2)
    %  plot(aviao.y1,aviao.cl0_y1)


     %debug
    % aviao.geom_malha = geom_malha;
end

end