function [aviao,mortes] = main_estab_estatica(aviao,mortes)
    %verifica intervalo de coeficientes e mata avioes
    %verificar nomes de variaveis e unidade de ângulos
    AR = aviao.AR;
    mac = aviao.MAC;
    AR_eh = aviao.b_EH^2/aviao.S_EH;
    S = aviao.S;
    b = aviao.b;
    CM0 = aviao.CM_0;
    CM_alfa = aviao.CM_alfa;
    CM_def = aviao.CM_def; %verificar comportamento de CM_def quando cauda possui sustentação negativa
    ME = CM_alfa/aviao.CL_alfa;
    aviao.ME = ME;
    alfa_trim = -CM0/CM_alfa;
    aviao.alfa_trim = alfa_trim;
    alfa_estol = aviao.alfa_estol;
    de_max = aviao.def_max;
    sweep_w = aviao.l_meia;
    twist_w = sum(aviao.tw);
    diedro_w = sum(aviao.d);
    taper_w = prod(aviao.t);

    de_trim_pos = (CM0 - 3*CM_alfa)/CM_def; % ângulo de ataque mínimo = -3º
    de_trim_neg = (CM0 + 0.9*alfa_estol*CM_alfa)/CM_def; % ângulo de ataque máximo = 0.9alfa_estol
    lh = aviao.c(1)*(cosd(alfa_trim) + cosd(aviao.i_w(1))) + 0.25*aviao.c_root_EH*(cosd(alfa_trim) + cosd(aviao.i_EH(1))) - aviao.xCG + aviao.d_BF_BA_x ;
    aviao.l_EH = lh;
    aviao.v_eh = aviao.S_EH*lh/(S*mac);
    
%     Equação 7.9 foi usada para contribuição da asa e EH para o Cl_beta
%     As correções por compressibilidade devido à enflechamento, diedro e 
%     fuselagem podem ser consideradas 1, pelas figuras 7.12, 7.13 e 7.16.
%     Padrão adotado para nomes dos coeficientes retirados das figuras
%     Coef_7_(numero da figura), então o coeficiente retirado da figura 11
%     será Coef_11.

    CL = aviao.CL_0 + aviao.CL_alfa*alfa_trim;
    Cl_beta_w = CL*(estab_Coef_7_11(sweep_w, AR, taper_w) + estab_Coef_7_14(AR, taper_w)) + diedro_w*estab_Coef_7_15(AR, sweep_w, taper_w) + twist_w*tan(sweep_w)*estab_Coef_7_17(AR, taper_w);
    CL = aviao.CL_0_EH + aviao.CL_alfa_EH*(alfa_trim + aviao.i_EH);
    Cl_beta_h = CL*estab_Coef_7_14(AR_eh, prod(aviao.t_EH))*aviao.v_eh*mac/b; %não há twist, diedro e enflechamento
    aviao.Cl_beta = Cl_beta_w + Cl_beta_h;
    [aviao,mortes] = estab_acha_ev(aviao, mortes);
    
    if ME < 0.07 || ME > 0.15
        aviao.morte = 1;
        mortes.ME = 1;
    end
    if alfa_trim < -3 || alfa_trim > alfa_estol - 5
        aviao.morte = 1;
        mortes.alfa_trim = 1;
    end
    if de_trim_pos > de_max || de_trim_neg < -de_max
        aviao.morte = 1;
        mortes.def_trim_prof = 1;
    end
end