function [aviao, mortes]= estab_acha_ev(aviao, mortes)
    S = aviao.S;
    alfa_trim = aviao.alfa_trim;
    b = aviao.b;
    l = aviao.vetor_lv;
    zmax = aviao.vetor_zmax;
    vetor_tam = length(l);
    i = vetor_tam;
    Sv = 0;
    A = 0;
    %se achar um leme que torne o avião estável, morte vira 0
    morte_Cl_beta = 1;
    morte_Cn_beta = 1;
    while ((morte_Cl_beta == 1 || morte_Cn_beta == 1) && i > 1)
        lv = l(i);
        zv = aviao.d_BF_BA_z*lv/aviao.d_BF_BA_x;
        cv = 0.1;
        z_ba = zmax(i) + 0.6*cv/4;  %z_ba é altura máxima disponível para a ev, no ba
        z_bf = z_ba - 0.6*cv;   %z_bf é altura máxima disponível para a ev, no ba
%         l_ba = l(i) - cv/4;
        while((morte_Cl_beta == 1 || morte_Cn_beta == 1) && cv < 4*(l(vetor_tam - 1) - l(i))/3)
            bv = 0.1;
%             l_aux = l_ba + (z_ba - bv)/0.6; %l aproximado onde zmax = bv
%             aux = l_aux - l_ba;
            aux = (z_ba - bv)/0.6;
            while((morte_Cl_beta == 1 || morte_Cn_beta == 1) && aux >= 0.05)
                if bv <= z_bf
                    Sv = bv*cv;
                else
                    Sv = bv*aux + (bv + z_bf)*(cv - aux)/2;
                end
                Sv = Sv - aviao.inc_tb*cv^2/2;
                A = bv^2/Sv;
                CLav = 1.5872*log(A) + 1.461;
%                 Para contribuições da ev para Cl_beta e Cn_beta foi usado o Roskam
                n = 0.724 + 3.06*(Sv/aviao.S)/(1 + cosd(sum(aviao.l))) + 0.009*aviao.AR; % equação 7.5
%                 Cálculo da contribuição da empenagem vertical para Cl_beta e Cn_beta
%                 Ângulo de ataque foi considerado como sendo o de equilíbrio
                Cybv = -CLav*n*Sv/S; % equação 7.4
                Cl_beta_v = Cybv*(zv - lv*alfa_trim/57.3)/b; %equação 7.14
                Cn_beta_v = -Cybv*(lv + zv*alfa_trim/57.3)/b; %equação 7.17
                Cl_beta = aviao.Cl_beta + Cl_beta_v;
                if Cl_beta >= -0.08 && Cl_beta <= -0.01
                    morte_Cl_beta = 0;
                end
                if Cn_beta_v >= 0.07 && Cn_beta_v <= 0.2
                    morte_Cn_beta = 0;
                end
                if morte_Cn_beta == 1 || morte_Cl_beta == 1
                    Cl_beta = Cl_beta - Cl_beta_v;
                    morte_Cn_beta = 1;
                    morte_Cl_beta = 1;
                    bv = bv + 0.01;
                end
                aux = (z_ba - bv)/0.6;
            end
            cv = cv + 0.01;
        end
        i = i - 1;
    end
    
    if morte_Cl_beta == 0 && morte_Cn_beta == 0
        aviao.bv = bv;
        aviao.cv_root = cv;
        aviao.cv_ponta = aux;
        aviao.lv = l(i);
        aviao.S_EV = Sv;
        aviao.AR_EV = A;
        aviao.Cn_beta = Cn_beta_v; %Outras contribuições foram desprezadas por não 
            %     haver fuselagem e segundo Roskam, a contribuição da asa é
            %     negligenciavel para ângulos de ataque pequenos
        aviao.Cl_beta = Cl_beta;
        aviao.v_ev = Sv*lv/(S*b);
    elseif ~(morte_Cl_beta == 1 && morte_Cn_beta == 1) %Avião é morto por somente um dos coeficientes
        aviao.bv = bv;
        aviao.cv_root = cv;
        aviao.lv = l(i);
        aviao.Cn_beta = Cn_beta_v; %Outras contribuições foram desprezadas por não 
            %     haver fuselagem e segundo Roskam, a contribuição da asa é
            %     negligenciavel para ângulos de ataque pequenos
        aviao.Cl_beta = Cl_beta;
        aviao.v_ev = Sv*lv/(S*b);
        mortes.Cl_Beta = morte_Cl_beta;
        mortes.Cn_Beta = morte_Cn_beta;
        aviao.morte = 1;
    else %Avião é morto pelos dois coeficientes
        mortes.Cl_Beta = morte_Cl_beta;
        mortes.Cn_Beta = morte_Cn_beta;
        aviao.morte = 1;
    end
end