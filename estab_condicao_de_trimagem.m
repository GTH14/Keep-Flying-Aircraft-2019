function [aviao] = estab_condicao_de_trimagem (aviao, const)
    %clear;clc;close all
    %Esse script tem como objetivo calcular a condição de voo no qual o avião
    %está trimado. Partiremos das três equações longitudinais, ou seja, em X, Z
    %e momento em torno do eixo Y. (Eixo do corpo)
    %As equações são: obs: a = alfa
    %(1) X: L*sin(a) + T - D*cos(a) - mg*sin(a) = 0
    %(2) Z: mg*cos(a) - L*cos(a) - D*sin(a) = 0
    %(3) M: M0 + M_alfa*a + M_delta*delta + Mmotor = 0

    %carregando dados necessários

    rho = const.rho;   %mudar pro valor de constantes
    g = const.g;       %idem
    m = aviao.MTOW;
    S = aviao.S;
    AR = aviao.AR;
    mac = aviao.MAC;
    Cm0 = aviao.CM_0;   %apenas efeitos aerodinâmicos, desconsiderando motor
    Cm_alfa = aviao.CM_alfa;
    CL0 = aviao.CL_0;
    CL_alfa = aviao.CL_alfa;
    CD0 = aviao.CD_parasita;
    e = aviao.oswald;

    %dados para teste
%     rho = 1.1170;
%     g = 9.81;
%     grav = 9.81;
%     m = 20;
%     S = 2.7495;
%     mac = 0.6;
%     Cm0 = -6.6699E-4;
%     Cm_alfa = -0.249;
%     CL0 = 0.5907;
%     CL_alfa = 3.5459;
%     CD0 = 0.0495;
%     CD_alfa = 0.01;
%     AR = 5.4955;
%     e = 0.97;
%     braco_motor = 0.1;
   
    h_motor = aviao.zmotor;
    h_cg = aviao.zCG;
    % braco_motor = braco_motor - h_cg; %altura em relação ao Cg

    braco_motor = h_motor - h_cg; %altura em relação ao Cg


    %% Solucao do Mario
    % %inicialmente, n vamos considerar o momento do motor e iremos calcular
    % %iterativamente até convergir.
    % 
    % %Partindo da equação 3:
    % %alfa(1) = (-Cm0-Cm_delta*delta)/Cm_alfa;
    % alfa(1) = -Cm0/Cm_alfa;
    % %Utilizo na equação dois para achar a velocidade
    % CL = CL0 + CL_alfa*alfa(1); %+ CL_delta*delta;
    % CD = CD0 + CD_alfa*alfa(1);
    % V(1) = sqrt(m*g*cos(alfa(1))/(0.5*rho*S*(CL*cos(alfa(1) + CD*sin(alfa(1))))));
    % %Substituindo na eq 1, achamos a tração necessária
    % D = 0.5*rho*S*V(1)^2*CD;
    % L = 0.5*rho*S*V(1)^2*CL;
    % T(1) = D*cos(alfa(1)) + m*g*sin(alfa(1)) - L*sin(alfa(1));
    % 
    % Cmt = T(1)*braco_motor/(0.5*rho*S*V(1)^2*mac);
    % alfa(2) = (Cmt - Cm0)/Cm_alfa;
    % CL = CL0 + CL_alfa*alfa(2);
    % CD = CD0 + CD_alfa*alfa(2);
    % V(2) = sqrt(m*g*cos(alfa(2))/(0.5*rho*S*(CL*cos(alfa(2)) + CD*sin(alfa(2)))));
    % D = 0.5*rho*S*V(2)^2*CD;
    % L = 0.5*rho*S*V(2)^2*CL;
    % T(2) = D*cos(alfa(2)) + m*g*sin(alfa(2)) - L*sin(alfa(2));
    % 
    % %Agora, calculamos o novo alfa de modo a anular o momento causado pelo motor
    % %até convergir:
    % eps = 0.01;
    % i = 2;
    % while abs(T(i) - T(i-1)) >= eps && i <= 40
    %     Cmt = T(i)*braco_motor/(0.5*rho*S*V(i)^2*mac);
    %     alfa(i+1) = (Cmt - Cm0)/Cm_alfa;
    %     CL = CL0 + CL_alfa*alfa(i+1);
    %     CD = CD0 + CD_alfa*alfa(i+1);
    %     V(i+1) = sqrt(m*g*cos(alfa(i+1))/(0.5*rho*S*(CL*cos(alfa(i+1)) + CD*sin(alfa(i+1)))));
    %     D = 0.5*rho*S*V(i+1)^2*CD;
    %     L = 0.5*rho*S*V(i+1)^2*CL;
    %     T(i+1) = D*cos(alfa(i+1)) + m*g*sin(alfa(i+1)) - L*sin(alfa(i+1));
    %     
    %     i = i+1;
    % end
    % 
    % %Tmax = (a*V(i)^2 + b*V(i) + c)*rho
    % novo_cm0 = -Cm_alfa*alfa(i);
    % T_cruz = T(i);
    % alfa_trim_novo = alfa(i);
    % V_cruz = V(i);

    %% Verificar solucao
    % eq_X1 = L*sin(alfa(length(alfa))) + T_cruz - D*cos(alfa(length(alfa))) - m*g*sin(alfa(length(alfa)))
    % eq_Z1 = m*g*cos(alfa(length(alfa))) - L*cos(alfa(length(alfa))) - D*(alfa(length(alfa)))
    % eq_M1 = Cm0 + Cm_alfa*alfa(length(alfa)) + Cmt 

    %% Nova versao (Solucao do Erik)

    i = 1;
    err_alfa = 1;err_V = 1;err_Ctau = 1;
    alfa_n = zeros(1, 5000);
    V_n = zeros(1, 5000);
    Ctau = zeros(1, 5000);
    while err_alfa > 1e-5 || err_V > 1e-5 || err_Ctau > 1e-5
        alfa_n(i) = (-Cm0 - Ctau(i)*(-braco_motor/mac))/Cm_alfa;
        K2 = 1/(pi*AR*e);
        K3 = m*g/(0.5*rho*S);
        CL = CL0 + CL_alfa*alfa_n(i);
        CD = CD0 + K2*CL^2;

        V_n(i) = sqrt(K3*cos(alfa_n(i))/(CL*cos(alfa_n(i))+CD*sin(alfa_n(i))));
        K1 = m*g/(0.5*rho*S*V_n(i).^2);

        Ctau(i+1) = K1*sin(alfa_n(i)) - CL*sin(alfa_n(i)) + CD*cos(alfa_n(i));

        if i >= 2
            err_alfa = abs(alfa_n(i) - alfa_n(i-1));
            err_V = abs(V_n(i) - V_n(i-1));
            err_Ctau = abs(Ctau(i) - Ctau(i-1));
        end
        i = i + 1;
    end
    alfa_trim_c_motor = alfa_n(i-1);
    V_cruz = V_n(i-1);
    T_cruz = Ctau(i-1)*0.5*rho*S*V_cruz.^2;
    novo_cm0 = -Cm_alfa*alfa_trim_c_motor;
    aviao.alfa_trim_motor = alfa_trim_c_motor;
    aviao.V_cruz = V_cruz;
    aviao.T_cruz = T_cruz;
    aviao.CM_0_motor = novo_cm0;

    %% Verificar solucao
    % L = CL*0.5*rho*S*V_final.^2;
    % D = CD*0.5*rho*S*V_final.^2;
    % eq_X1 = L*sin(alfa_n(length(alfa_n))) + tau_final - D*cos(alfa_n(length(alfa_n))) - m*g*sin(alfa_n(length(alfa_n)))
    % eq_Z1 = m*g*cos(alfa_n(length(alfa_n))) - L*cos(alfa_n(length(alfa_n))) - D*sin(alfa_n(length(alfa_n)))
    % eq_M1 = Cm0 + Cm_alfa*alfa_n(length(alfa_n)) + Ctau(length(Ctau))*(-braco_motor/mac)

    %%
    % novo_cm0
    % T_cruz
    % alfa_trim_novo
    % V_cruz
    % 
    % novo_cm0_new
    % alfa_final
    % V_final
    % tau_final
end