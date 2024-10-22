% função que calcula a posição do motor mais próxima do bordo de ataque da
% raiz
function [d_motor,x_motor,h_motor]=geometria_motor_v2(c,h_asa1_BA,pf,perfil,s_b,l_BA)
% Fator de segurança de distância entre motor e BA
k=0.03;
% Corda na linha de ação do eixo do motor 
y=[0,s_b(1)];
x=[0,s_b(1)*tand(l_BA(1))];
dP1P2_y=.055;
x1=interp1(y,x,dP1P2_y);

y=[0,s_b(1)];
x=[c(1),c(2)];
c1=interp1(y,x,.055);

c_motor_sup=c1*pf(perfil(1)).pontos_sup;
c_motor_inf=c1*pf(perfil(1)).pontos_inf;
len_sup=length(c_motor_sup(:,1));
len_inf=length(c_motor_inf(:,1));

%Extradorso
x2=c_motor_sup(1:len_sup,1);
z2=c_motor_sup(1:len_sup,2);
c_u=interp1(x2,z2,c1/4);

%Intradorso
x3=c_motor_inf(1:len_inf,1);
z3=c_motor_inf(1:len_inf,2);
c_l=interp1(x3,z3,c1/4);

x2=x2+x1;
x3=x3+x1;

p_corda=[x1,0];
BA_lim=[x1,c_l;x1,c_u];
h_motor=h_asa1_BA+c_l;

%plot(x2,z2,x3,z3,BA_lim(:,1),BA_lim(:,2));
%axis equal
%% Pos inicial do motor'
%auxiliares
dP1P2_z=.08;
dP1P2_x=.08;
% Posições
% Linha de ação do eixo do Motor
P1_ini=[-0.5,h_motor-h_asa1_BA];
% Linha de ação do furo do Escapamento
P2_ini=P1_ini+[dP1P2_x,-dP1P2_z];

%plot(x2,z2,x3,z3,BA_lim(:,1),BA_lim(:,2),[P1_ini(1,1),P2_ini(1,1)],[P1_ini(1,2),P2_ini(1,2)]);
%axis equal

%% Verifica posição relativa
P1_ini(1,1)=BA_lim(1,1)-k-dP1P2_x;
P2_ini(1,1)=BA_lim(1,1)-k;
% Ponto 1 dentro
if P1_ini(1,2)>BA_lim(1,2) && P1_ini(1,2)<BA_lim(2,2)
    P1_ini(1,1)=BA_lim(1,1)-k-dP1P2_x;
    P2_ini(1,1)=BA_lim(1,1)-k;
    if P1_ini(1,2)<k
        P1_ini(1,1)=BA_lim(1,1)-k;
        P2_ini(1,1)=BA_lim(1,1)-k+dP1P2_x;
    end
end
% Ponto 1 fora (embaixo)
if P1_ini(1,2)<=BA_lim(1,2)
    P1_ini(1,1)=BA_lim(1,1)-k;
    P2_ini(1,1)=BA_lim(1,1)-k+dP1P2_x;
end
% Ponto 2 fora (em cima)
if P2_ini(1,2)>BA_lim(2,2)
    P1_ini(1,1)=BA_lim(1,1)-k;
    P2_ini(1,1)=BA_lim(1,1)-k+dP1P2_x;
end

%plot(x2,z2,x3,z3,BA_lim(:,1),BA_lim(:,2),[P1_ini(1,1),P2_ini(1,1)],[P1_ini(1,2),P2_ini(1,2)]);
%axis equal
%% Atribui d_motor
d_motor=abs(-.21+P2_ini(1,1));
x_motor=-.21+P2_ini(1,1);