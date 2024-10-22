function [aviao, mortes, estab ] = main_estab_dinamica(aviao, const, mortes, estab)
    %Função main de estabilidade dinâmica, mata se os modos dinâmicos não
    %estiverem dentro dos intervalos minimos de qualidade level 3 estabelecidos pela MIL-F-8785C ...

    [aviao] = estab_condicao_de_trimagem(aviao, const);     %atualiza alfa trim considerando motor
    [estab] = estab_Derivadas_de_estabilidade_long (aviao, const, estab);
    [estab] = estab_Derivadas_de_estabilidade_laterod(aviao, const, estab);
    [aviao] = estab_Analise_dinamica_longitudinal (aviao, const, estab);
    [aviao] = estab_Analise_dinamica_laterodirecional(aviao, const, estab);

%     Zeta_curtoperiodo = aviao.Zeta_curtoperiodo;
%     Zeta_fugoide = aviao.Zeta_fugoide;
%     Wn_curtoperiodo = aviao.Wn_curtoperiodo;
%     Wn_fugoide = aviao.Wn_fugoide;
%     Zeta_dutchroll = aviao.Zeta_dutchroll;
%     Wn_dutchroll = aviao.Wn_dutchroll;
%     T_espiral = aviao.T_espiral;
%     T_roll = aviao.T_roll;

    if aviao.Zeta_curtoperiodo < 0.2 || aviao.Zeta_curtoperiodo > 2
        mortes.curto_periodo = 1;
        aviao.morte = 1;
    end
    if aviao.Zeta_fugoide <= 0
        mortes.fugoide = 1;
        aviao.morte = 1;
    end
    if aviao.Zeta_dutchroll < 0.02 || aviao.Wn_dutchroll < 0.5
        mortes.dutch_roll = 1;
        aviao.morte = 1;
    end
    if aviao.T_espiral <= 0 && aviao.T_espiral > -7.2
        mortes.espiral = 1;
        aviao.morte = 1;
    end
    if aviao.T_roll > 3
        mortes.roll = 1;
        aviao.morte = 1;
    end
end