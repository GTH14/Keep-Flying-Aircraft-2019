function [aviao] = main_desempenho(aviao, const)
%Plotar ou não o gráfico, mudar para valor diferente de 0 para plotar
plota = 1;

%Valores que eu estou colocando manualmente
g = 9.8;
vdef = 1; 
tam_pista = 60;
xp = 55;  %Distãncia da pista em que se atua o profundor
vento = 0;

%Salvando as variáveis de acordo com o aviao e const
% load('escolhido_retardado')
PV = aviao.PV;
CD_0_solo = aviao.CD_0_solo;
CD_def_solo = aviao.CD_def_solo;
CM_alfa_solo = aviao.CM_alfa_solo;
CL_0_solo = aviao.CL_0_solo;
CL_def_solo = -aviao.CL_def_solo;
CL_alfa_solo = aviao.CL_alfa_solo;
CM_0_solo = aviao.CM_0_solo;
CM_def_solo = -aviao.CM_def_solo;
MAC = aviao.MAC;
alfa_estol_solo = aviao.alfa_estol_solo/(57.2958);
def_max = -aviao.def_max/(57.2958);
S = aviao.S;
p = const.rho;
u = const.mi;
x_cg = aviao.xCG;
db = const.D_bq;
z_cg = aviao.zCG;
z_motor = aviao.z_motor;
dtp = const.D_tp;
x_motor = aviao.x_motor;
delta_x_carga = aviao.x_comp;
delta_z_carga = aviao.z_comp;

%Condições Iniciais
dt = 0.001;
massa_minima = 10;
massa_maxima = 25;
% aang = 0;

%Distância Geométricas
raiz = sqrt(dtp^2 + z_cg^2); % distancia da roda que ta no chao ao cg
ang = atan(z_cg/dtp); 
rt = sqrt((dtp+x_cg-x_motor)^2 + z_motor^2);
ang2 = atan(z_motor/(dtp+x_cg-x_motor));
while abs(massa_maxima - massa_minima) > 0.001
    m = (massa_minima + massa_maxima)/2;
    %Cálculo do momento de inercia
    Iyy_vazio_tp = aviao.iy + PV*(dtp^2 + z_cg^2);
    Iyy_carga_tp = ((m - PV)*(delta_z_carga^2 + delta_x_carga^2)/12 + (m - PV)*((dtp - delta_x_carga)^2 + (z_cg + delta_z_carga)^2)); 
    Iyy_total_tp = Iyy_vazio_tp + Iyy_carga_tp;
    W = m*g;
    x = 0;
    v = 0;
    t = 0;
    L =  0;
    NB = 100;
    def = 0;
    alfa = 0;
    omega = 0;
    velocidade = [];
    aceleracao = [];
    posicao = [];
    tracao = [];
    massa = [];
    normalB = [];
    normalTP = [];
    lift = [];
    arrasto = [];
    peso = [];
    atrito = [];
    tempo = [];
    momento = [];
    angulo = [];
    while x < xp  %Primeira parte da decolagem
        T = (-0.011365*(v + vento)^2 - 0.639420*(v + vento) + 34.695)*p;
        L = (p*S*CL_0_solo*(v+ vento)^2)/2;
        D = (p*S*CD_0_solo*(v+ vento)^2)/2;
        M = (p*S*CM_0_solo*MAC*(v + vento)^2)/2;
        if NB > 0
            NB = (T*z_motor - M  - D*z_cg - L*dtp + W*dtp)/(db + dtp);
        end
        if (W - NB - L) > 0
            NTP = W - NB - L;
        else
            NTP = 0;
        end
        Fat = min(T - D, (NTP + NB)*u);
        a = (T - D - Fat)/m;
        v = v + a*dt;
        x = x + v*dt;
        t = t + dt; 
        
        %Salvando os valores de cada vetor
        if plota ~= 0 
            massa = [massa m];
            tracao = [tracao T];
            normalTP = [normalTP NTP];
            normalB = [normalB NB];
            lift = [lift L];
            arrasto = [arrasto D];
            peso = [peso W];
            atrito = [atrito Fat];
            velocidade = [velocidade v];
            aceleracao=[aceleracao a];
            posicao=[posicao x];
            tempo = [tempo t];
            momento = [momento M];
            angulo = [angulo alfa*57.2958];
        end
    end
    while NB > 0.001
        if abs(def) <= abs(def_max)/2
             def = def - vdef*dt;
        end
        T = (-0.011365*(v + vento)^2 - 0.639420*(v + vento) + 34.695)*p;
        L = (p*S*(CL_0_solo + CL_def_solo*def)*(v+ vento)^2)/2;
        D = (p*S*(CD_0_solo + CD_def_solo*def)*(v+ vento)^2)/2;
        M = (p*S*(CM_0_solo + CM_def_solo*def)*MAC*(v + vento)^2)/2;
        if NB > 0
            NB = (T*z_motor - M - D*z_cg - L*dtp + W*dtp)/(db + dtp);
        end
        if (W - NB - L) > 0
             NTP = W - NB - L;
        end
        Fat = min(T - D, (NTP + NB)*u);
        a = (T - D - Fat)/m;
        v = v + a*dt;
        x = x + v*dt;
        t = t + dt;
        if plota ~= 0 
            massa = [massa m];
            tracao = [tracao T];
            normalTP = [normalTP NTP];
            normalB = [normalB NB];
            lift = [lift L];
            arrasto = [arrasto D];
            peso = [peso W];
            atrito = [atrito Fat];
            velocidade = [velocidade v];
            aceleracao=[aceleracao a];
            posicao=[posicao x];
            tempo = [tempo t];
            momento = [momento M];
            angulo = [angulo alfa*57.2958];
        end
    end
    while x < tam_pista
        if abs(def) <= abs(def_max)/2
            def = def - vdef*dt;
        end
        NB = 0;
        aang = (M+(L-W)*raiz*cos(ang+alfa)+D*raiz*sin(ang+alfa)-rt*sin(ang2+alfa)*T*cos(alfa)+rt*cos(ang+alfa)*T*sin(alfa)+m*raiz*(a*sin(ang+alfa))-raiz*cos(ang+alfa)*omega^2)/(Iyy_total_tp);
        omega = omega + aang*dt;
        alfa = alfa + omega*dt;
        if (W - L - T*sin(alfa)) > 0
            NTP = W - L - T*sin(alfa);
        else
            NTP = 0;
        end
        T = (-0.011365*(v + vento)^2 - 0.639420*(v + vento) + 34.695)*p;
        L = (p*S*(CL_0_solo + CL_def_solo*def + CL_alfa_solo*alfa)*(v+ vento)^2)/2;
        D = (p*S*(CD_0_solo + CD_def_solo*def)*(v+ vento)^2)/2;
        M = (p*S*(CM_0_solo + CM_def_solo*def + CM_alfa_solo*alfa)*MAC*(v + vento)^2)/2;
        Fat = min(T*cos(alfa) - D, (NTP)*u);
        a = (T*cos(alfa) - D - Fat)/m;
        v = v + a*dt;
        x = x + v*dt;
        t = t + dt;
        if plota ~= 0
            angulo = [angulo alfa*57.2958];
            massa = [massa m];
            tracao = [tracao T];
            normalTP = [normalTP NTP];
            normalB = [normalB NB];
            lift = [lift L];
            arrasto = [arrasto D];
            peso = [peso W];
            atrito = [atrito Fat];
            velocidade = [velocidade v];
            aceleracao=[aceleracao a];
            posicao=[posicao x];
            tempo = [tempo t];
            momento = [momento M];
        end
    end   
%     Problemas na decolagem
    problema = 0;
    if W > L
        problema = 1;
    end
    if alfa > alfa_estol_solo
        problema = 2;
    end
    if alfa < 0
        problema = 3;
    end
    if x > tam_pista + 1
        problema =4;
    end
    if problema == 0
        massa_minima= m;
    else
        massa_maxima = m;
    end
end
Mtow = m;
aviao.MTOW = Mtow;
if plota ~= 0
    subplot(3,1,1);
    plot(posicao, normalTP); 
    hold on
    plot(posicao, lift); 
    plot(posicao, peso);
    plot(posicao, normalB);
    plot(posicao, momento);
    legend('normaltTP', 'lift', 'peso', 'normalB', 'momento')
    hold off
    subplot(3,1,2)
    plot(tempo, arrasto)
    hold on
    plot(tempo, tracao)
    plot(tempo, atrito)
    legend('arrasto', 'tracao', 'atrito')
    hold off
    subplot(3,1,3)
    plot(tempo, angulo)
    legend('alfa')
end
    aviao.CP = aviao.MTOW - aviao.PV;
    aviao.ee = aviao.CP/aviao.PV;
    pCP = 12.5*aviao.CP;
    pEE = 5*aviao.ee;
    aviao.pontuacao = pCP + pEE;
end