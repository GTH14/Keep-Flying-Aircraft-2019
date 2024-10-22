function [aviao] = estab_Analise_dinamica_laterodirecional(aviao, const, estab)
% Este programa utiliza o método proposto em COOK que através de um sistema
% escrito na forma de espaço de estados obtém as funções de transferência
% das variáveis que caracterizam o modo laterodirecional: (obs: e = equilíbrio)
% v - Variação da velocidade de equi. Ve paralela ao eixo y do eixo do vento;
% p - velocidade de rolagem do avião;
% r - velocidade de guinada do avião;
% phi - variação do bank angle do avião;
% Beta - variação do ângulo de derrapagem (sideslip) de equilíbrio (beta_e = 0);
% qsi - é a deflexão do aileron
% zeta - é a deflexão do leme
%Os coeficientes das matrizes estão na forma concisa (explicada no Cook na
%sessão 4.4.2) e resumidas no apêndice 2.

% Um sistema descrito no formato de espaços de estados é descrito da
% seguinte maneira: x'(t) = Ax(t) + Bu(t) e y(t) = Cx(t) + Du(t)
%Sendo x(t) as variáveis de estado; x'(t) suas derivadas; y(t) a saída do
%sistema; e u(t) a entrada do sistema.
%Em nosso caso x(t) = [v p r phi] x'(t) = [v' p' r' phi']
%u(t) = [qsi zeta] e y(t) = x(t)
% As matrizes A, B, C e D estão detalhadas no capítulo 5 do COOK

%mãos a obra

%primeiramente, vamos definir os coeficientes;

%Derivadas_de_estab_laterodir; %Esse script calcula todas as derivadas de
%estabilidade
g = const.g;
m = aviao.MTOW;
V = aviao.V_cruz;
%Coeficientes na forma concisa:     obs:formulas com ok já foram revisadas 
yv = estab.Yv/m;
yp = (estab.Yp + m*estab.We)/m;
yr = (estab.Yr - m*estab.Ue)/m;
theta = estab.theta;
yphi = g*cos(theta);
% yqsi = g*sin(theta);
Iz = estab.Iz;
Ix = estab.Ix;
Ixz = estab.Ixz;
aux = Ix*Iz - Ixz^2;
lv = (Iz*estab.Lv + Ixz*estab.Nv)/aux;
lp = (Iz*estab.Lp + Ixz*estab.Np)/aux;
lr = (Iz*estab.Lr + Ixz*estab.Nr)/aux;
lphi = 0;
% lqsi = 0;
nv = (Ix*estab.Nv + Ixz*estab.Lv)/aux;
np = (Ix*estab.Np + Ixz*estab.Lp)/aux;
nr = (Ix*estab.Nr + Ixz*estab.Lr)/aux;
nphi = 0;
% nqsi = 0;
%Derivadas de controle
ya = estab.Ya/m;
la = (Iz*estab.La + Ixz*estab.Na)/aux;
na = (Ix*estab.Na + Ixz*estab.La)/aux;
yl = estab.Yl/m;
ll = (Iz*estab.Ll + Ixz*estab.Nl)/aux;
nl = (Ix*estab.Nl + Ixz*estab.Ll)/aux;

%Definição da matriz A

A = [yv yp yr yphi;
     lv lp lr lphi;
     nv np nr nphi;
     0  1  0  0  ];
%Definição da matriz B
B = [ya yl;
     la ll;
     na nl;
     0  0 ];
% A matriz C, quando queremos apenas avaliar v p r e phi é a matriz
% identidade, uma vez que y(t) = x(t). Porém, iremos aumentar a matriz C,
% pois também vamos analisar o ângulo de derrapagem beta. Fazendo beta =
% v/V0.
  
C = [1  0   0 0;
     0  1   0 0;
     0  0   1 0;
     0  0   0 1;
    1/V 0   0 0];
   
%Definição da matriz D
D = zeros(5,2);

%Definição do denominador da função de transferência que é comum a todas as
%variaveis

[~,den] = ss2tf(A,B,C,D,1);   %[num_aileron,den] = ss2tf(A,B,C,D,1);
% [num_leme,den2] = ss2tf(A,B,C,D,2);
% s = roots(den); %é esperado duas raízes complexas conjugadas e duas reais

%Calculo dos amortecimentos, frequências naturais e constante de tempo

[omega_n, zeta] = damp(tf(1,den));

    for i = 1:length(zeta)
       for j = (i+1):length(zeta)
           if(omega_n(i) == omega_n(j))
               Wn_dutchroll = omega_n(i);
               Zeta_dutchroll = zeta(i);
               tau_dutchroll = 1./(zeta(i).*omega_n(i));
               index_dr = [i,j];
           end
       end
    end
    
    for i = 1:length(zeta)
        for j = (i+1):length(zeta)
            if(i == index_dr(1) || i == index_dr(2))
            else
                if(omega_n(i) > omega_n(j))
                    Wn_roll = omega_n(i);
                    Zeta_roll = zeta(i);
                    T_roll = 1./(zeta(i).*omega_n(i));
                    
                    Wn_espiral = omega_n(j);
                    Zeta_espiral = zeta(j);
                    T_espiral = 1./(zeta(j).*omega_n(j));
                else
                    Wn_roll = omega_n(j);
                    Zeta_roll = zeta(j);
                    T_roll = 1./(zeta(j).*omega_n(j));
                    
                    Wn_espiral = omega_n(i);
                    Zeta_espiral = zeta(i);
                    T_espiral = 1./(zeta(i).*omega_n(i));
                end
            end
        end
    end

aviao.Zeta_dutchroll = Zeta_dutchroll;
aviao.Wn_dutchroll = Wn_dutchroll;
aviao.tau_dutchroll = tau_dutchroll;
aviao.Wn_espiral = Wn_espiral;
aviao.Zeta_espiral = Zeta_espiral;
aviao.T_espiral = T_espiral;
aviao.Wn_roll = Wn_roll;
aviao.Zeta_roll = Zeta_roll;
aviao.T_roll = T_roll;
end
%Analise no simulink
%primeiro, temos que definir todas as funções de tranferência.

% tempo = 0; %instante onde aparece o degrau
% t = 20;
% Q = 6/57.3;      %amplitude da deflexão do aileron
% Z = 5/57.3;      % "         "   "       "   leme
% K = 57.3;    %constante que passa de rad pra graus na saída dos blocos
% 
% 
% num1  = num_aileron(1,:);
% num2  = num_aileron(2,:);
% num3  = num_aileron(3,:);
% num4  = num_aileron(4,:);
% num5  = num_aileron(5,:);
% num6  = num_leme(1,:);
% num7  = num_leme(2,:);
% num8  = num_leme(3,:);
% num9  = num_leme(4,:);
% num10 = num_leme(5,:);

% 
% sim('simulacao_lat')
% 
% figure (1)
% plot (tout,v)
% grid on
% xlabel('tempo [s]')
% ylabel('velocidade v [m/s]')
% 
% figure(2)
% plot(tout,p)
% xlabel('tempo [s]')
% ylabel('rolagem p [°/s]')
% grid on
% 
% figure(3)
% plot(tout,r)
% grid on
% xlabel ('tempo [s]')
% ylabel ('guinada r [º/s]')
% 
% figure(4)
% plot(tout,phi)
% xlabel ('tempo [s]')
% ylabel ('bank angle \phi [º/s]')
% grid on
% 
% figure(5)
% plot(tout,beta)
% xlabel ('tempo [s]')
% ylabel ('ângulo de derrapagem \beta [º/s]')
% grid on
% 
% figure(6)
% plot(tout,v1)
% xlabel ('tempo [s]')
% ylabel ('velocidade v1 [m/s]')
% grid on
% 
% figure (7)
% plot (tout,p1)
% grid on
% xlabel('tempo [s]')
% ylabel('rolagem p1 [º/s]')
% 
% figure(8)
% plot(tout,r1)
% xlabel('tempo [s]')
% ylabel('guinada r1 [º/s]')
% grid on
% 
% figure(9)
% plot(tout,phi1)
% grid on
% xlabel ('tempo [s]')
% ylabel ('bank angle \phi 1 [º/s]')
% 
% figure(10)
% plot(tout,beta1)
% xlabel ('tempo [s]')
% ylabel ('ângulo de derrapagem \beta 1 [º/s]')
% grid on
