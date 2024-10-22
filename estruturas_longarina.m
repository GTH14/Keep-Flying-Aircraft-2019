function [m_long,x_long,y_long,z_long,r_long] = estruturas_longarina(Mfle,Mtor,const,b,l,d,c,q,h_asa)
%% DESCRIÇÃO %%
%Há aqui o cálculo da posição da longarina na aeronave e sua
%massa

%% Constantes necessárias

Ri = 0.5*9*(2.54/800);
esp = 0.25/1000;
n_cam= [];

%% Dimensionando numero de camadas
for j= 2:4
    R = Ri + j*esp;
    Tnmax = max(Mfle)*R*4/(pi*(R^4-Ri^4)) + sum(sum(q))*sind(d(1))/(pi*(R^2- Ri^2));                                        % Tensão transversal
    Tcmax = max(Mtor)*2*R/(pi*(R^4- Ri^4)) + 4*sum(sum(q))*cosd(d(1))*(R^2 + R*Ri + Ri^2)/(3*pi*(R^2- Ri^2)*(R^2 + Ri^2));    % Tensão de cisalhamento para tubos
    %% Utilizando critério de falha tsai - wu
    F1 = 1/450e6 - 1/400e6;
    %F2 = 1/XT - 1/XC;
    %F12= - sqrt(1/(Xt*Xc*XT*XC))/2;
    F11 = 1/(450e6*400e6);
    %F22 = 1/(XT*XC);
    F6 = 0;
    F66 = 1/(60e6*60e6);
    C1 = F1*Tnmax + F6*Tcmax;
    C2 = F11*Tnmax^2 + F66*Tcmax^2;
    R = sqrt(C1^2 +4*C2);
    FOS = (-C1 + R)/(2*C2);
    if FOS > 1.8
        n_cam=[n_cam j] ;
    end
end
%% Calculando massa total e centro de massa da longarina
R = Ri + esp*n_cam(1);
Massa_secao = zeros(numel(b),1);
x_secao = zeros (numel(b),1);
z_secao = zeros(numel(b),1);
for i= 1:numel(b)
    Massa_secao(i)= pi*(R^2-Ri^2)*const.dens_carbono*b(i)/(cosd(d(i)*cosd(l(i))));
    x_secao(i)= c(1)/4 + b(i)*tand(l(i))/4 + sum(b(1:i-1).*tand(l(1:i-1))/2);
    z_secao(i) = h_asa + b(i)*tand(d(i))/4 + sum(b(1:i-1).*tand(d(1:i-1))/2);
end
  
m_long = sum(Massa_secao);
x_long = sum(x_secao.*Massa_secao)/m_long;
y_long = 0;
z_long = sum(z_secao.*Massa_secao)/m_long;
r_long = R;




        

