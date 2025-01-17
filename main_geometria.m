function [aviao, mortes ] = main_geometria(aviao, mortes, perfil_structure)

%% FUNCAO DE GEOMETRIA %%

perfil_raiz = aviao.perfil(1);
thick = perfil_structure(perfil_raiz).espessura;
b = aviao.b;                        %[m] Envergadura da asa
fb = aviao.fb;                      %[m] Vetor com fra��es de envergadura
fb_EH = aviao.fb_EH;
AR = aviao.AR;                      %[-] Raz�o de aspecto
i_w = aviao.i_w;                    %[�] Incid�ncia na raiz
t = aviao.t;                        %[-] Vetor de taper em cada se��o
l = aviao.l;                        %[�] Vetor enflechamento
tw = aviao.tw;                      %[�] Vetor de twist
d = aviao.d;                        %[�] Vetor de diedro em cada se��o
% perfil = aviao.perfil;              %[-] Vetor de perfis em cada se��o
h_BA = aviao.h_BA;                  %[m] Altura do BA da asa
na = length(t);                    %[-] N�mero de se��es asa

%Cauda
d_BF_BA_x = aviao.d_BF_BA_x;        %[m] Dist�ncia do BF da asa ao BA da cauda em x
d_BF_BA_z = aviao.d_BF_BA_z;        %[m] Dist�ncia do BF da asa ao BA da cauda em z
c_root_EH = aviao.c_root_EH;        %[m] Corda na raiz da EH
t_EH = aviao.t_EH;                  %[-] Vetor de taper em cada se��o da EH
b_EH = aviao.b_EH;                  %[m] Envergadura da EH
i_EH = aviao.i_EH;                  %[�] Incid�ncia da EH
% f_prof = aviao.f_prof;              %[-] Fra��o de corda atu�vel da EH
% perfil_EH = aviao.perfil_EH;        %[-] Perfil da EH
ne = length(t_EH);                   %[-] N�mero de se��es EH

%Compartimento de carga/CG
% d_carga = const.d_carga;            %[kg/m^3] Densidade da carga
% m_carga = const.m_carga;            %[kg] Massa fixa de carga
% y_max_comp = const.y_max_comp;      %[m] Tamanho m�ximo em Y do compartimento de carga

%Cone
H = 0.75;                           %[m] Altura do cone
R = 1.25;                           %[m] Raio do cone

%Flags
flag_x_complexo = 0;

%% 1.Parametros para outras areas
%Area da asa
S = (b^2)/AR;

% % %Envergadura
% % aux1_b_sec = [1,cumprod(fb)];       % [1,fb1,fb1*fb2,fb1*fb2*fb3 ...] o cumprod � a fun��o de produto cumulativo
% % aux2_b_sec = [1-fb,1];              % [1-fb1,1-fb2,1-fb3 ...,1] 
% % b_sec = b*aux1_b_sec.*aux2_b_sec;   % Envergadura em cada se��o
% % b_sec = b_sec/2;

%semi-envergaduras  das se��es da asa
vetor_b = zeros(1, na);
x = b/2;
for i = 1:(na - 1)
    vetor_b(i) = x*fb(i);
    x = x - vetor_b(i);
end
vetor_b(na) = x;
b_sec = vetor_b;

%semi-envergaduras  das se��es da eh
vetor_b = zeros(1, ne);
x = b_EH/2;
for i = 1:(ne - 1)
    vetor_b(i) = x*fb_EH(i);
    x = x - vetor_b(i);
end
vetor_b(ne) = x;
b_sec_eh = vetor_b;

%Cordas, enflechamento, diedro, incid�ncia da ASA
ant = 1;
aux = 0;

for i = 1:na
    aux = aux + ant*b_sec(i)*(1  + t(i));
    ant = ant*t(i);
end

c = zeros(1, na+1);
iw = zeros(1, na+1);
lw = zeros(1, na);
dw = zeros(1, na);

c(1) = S/aux;
iw(1) = i_w;
lw(1) = l(1);
dw(1) = d(1);

for i = 2:na
    c(i) = c(i-1)*t(i-1);
    iw(i) = iw(i-1) + tw(i-1);
    lw(i) = lw(i-1) + l(i);
    dw(i) = dw(i-1) + d(i);
end

c(na+1) = c(na)*t(na);
iw(na+1) = iw(na) + tw(na);
xCG = aviao.f_x_cg*c(1);              %[-] Posi��o do CG em x/c(1)

%Cordas da EH
ceh = zeros(1,ne+1);
i = 1;
ceh(i) = c_root_EH;
for i = 2:ne+1
    ceh(i) = ceh(i-1)*t_EH(i-1);
end

%MAC
c1 = c(1:end-1);
c2 = c(2:end);
int = (2/3)*c1.*(1 + t + t.^2).*((c1 + c2).*b_sec)./(1 + t);
mac = sum(int)/S;

%MAC EH
ceh1 =  ceh(1:end-1);
ceh2 = ceh(2:end);
S_EH = sum((ceh1 + ceh2).*b_sec_eh);
int = (2/3)*ceh1.*(1 + t_EH + t_EH.^2)*S_EH/(1 + t_EH);
mac_EH = sum(int)/S_EH;

%% 2.Vetores de coordenadas 

nf = na+ne+2;                       %[-] N�mero de pontos de colis�o frontal (BAs)
nt = nf;                            %[-] N�mero de pontos de colis�o traseira (BFs)

pf = zeros(nf,3);                   %[-] Vetor com coord dos pontos frontais
pt = zeros(nt,3);                   %[-] Vetor com coord dos pontos traseiros

%% 3.Calculo dos pontos relevantes 

%Calculo dos pontos frontais-----------------------------------------------

%BA Asa -------------------------------------------------------------------
pf(1,:) = [0 0 h_BA]; %primeiro ponto � o da raiz do BA da asa
i = 2;
x = 0;
y = 0;
z = h_BA;

while i <= na+1
    x = x + c(i-1)/4*cosd(iw(i-1)) + tand(lw(i-1))*b_sec(i-1) - c(i)/4*cosd(iw(i)); %pura geometria, ver folha
    y = y + b_sec(i-1);
    z = z - c(i-1)/4*sind(iw(i-1)) + tand(dw(i-1))*b_sec(i-1) + c(i)/4*sind(iw(i));
    pf(i,:) = [x y z];
    i = i+1;
end

%BA EH --------------------------------------------------------------------
pf(na+2,:) = [(c(1)*cosd(i_w)+d_BF_BA_x) 0 (h_BA-c(1)*sind(i_w)+d_BF_BA_z)]; %BA raiz da EH
i = i+1;
x = (c(1)*cosd(i_w)+d_BF_BA_x);
y = 0;
z = (h_BA-c(1)*sind(i_w)+d_BF_BA_z);
ch = c_root_EH;
ieh = i_EH;
while i <= nf
    x = x + ch/4*cosd(ieh) - ch/4*t_EH(i-na-2)*cosd(ieh); %pura geometria, ver folha
    y = y + b_sec_eh(i - na -2);
    z = z - ch/4*sind(ieh) + ch/4*t_EH(i-na-2)*sind(ieh);
    pf(i,:) = [x y z];
    ch = ch*t(i - na - 2); %atualiza o ponto inicial para o calculo do proximo
    i = i+1;
end

%Calculo dos pontos traseiros----------------------------------------------
%Agora, como ja temos todos pontos frontais, basta somar as projecoes da corda de cada secao

%Asa-----------------------------------------------------------------------
i = 1;
while i <= na + 1 %ta na asa
    pt(i,:) = pf(i,:) + [(c(i)*cosd(iw(i))) 0 (-c(i)*sind(iw(i)))];
    i = i + 1;
end

%EH------------------------------------------------------------------------
ch = c_root_EH;
ieh = i_EH;
while i <= nt %ta na EH (i nao reiniciou)
    pt(i,:) = pf(i,:) + [(ch*cosd(ieh)) 0 (-ch*sind(ieh))];
    if i < (nt)
        ch = ch*t_EH(i-na-1); %atualiza para a proxima iteracao, retira indices da asa
    end
    i = i + 1;
end

%% 4.Calculo das distancias frontais

%Calculo todas distancias dos pontos frontais ate bater no cone, o aviao todo ir� para frente com a menor delas (limite)
dx = zeros(1, nf);
i = 1;
while i<nf+1
    xa = pf(i,1); %coord x do ponto i frontal
    xc = -((((H - pf(i,3))/H)^2)*R^2 -(pf(i,2))^2)^0.5; %coord x do cone
    dx(i) = xa - xc;
    i = i+1;
end
z_flag = 0;
morte = 0;
for i = 1:(na + 1)
    if (pf(i, 3) <= 0) || (pt(i,3) <= 0)
        z_flag = 1;
        morte = 1;
    end
end
%% 5.Deslocamento do aviao (alinhamento frontal)
pf(:,1) = pf(:,1) - (min(dx(1:nf)));
pt(:,1) = pt(:,1) - (min(dx(1:nf))); 
%a frente ficou alinhada no limite, agora resta ver se algum ponto traseiro esta saindo do cone

%% 6.Verificar colis�o traseira
%note que o xc traseiro � a mesma equacao (inverte o sinal, apenas), mas agora usaremos os pontos traseiros como referencia
%se algum ponto do aviao tiver um x maior que seu respectivo xc, ele nao coube
i = 1;
while i <= nt && morte == 0
    xa = pt(i,1); %coord x do ponto i traseiro
    xc = ((((H - pf(i,3))/H)^2)*R^2 - (pf(i,2))^2)^0.5; %coord x do cone
    if xa>xc
        morte = 1;
    end
    if ~isreal(xc)
        flag_x_complexo = 1;
        morte = 1;
    end
    i = i+1;
end

%% 7.Verificacao do compartimento de carga
ymax = 0.70;
% xmin = 0.10;
ymin = 0.10;
zmin = 0.05;
dy = 0.05;
dz = 0.01;
P = 0;
dens = 0.7*7870;
y = ymin;
while (y<= ymax) && P<18
    y = y + dy;
    chord = c(1)/4*((t(1)-1)*(y/2)/(vetor_b(1)) + 1); %corda nesse y
    xBA = c(1)/4*cosd(iw(1)) + tand(l(1))*(y/2) - chord/4*cosd(iw(1)+tw(1)*(y/(2*vetor_b(1)))); %posicao x do BA nesse y
    xlim1 = xBA + chord/4 - 0.025 - xCG; %distancia limite de x at� a longarina, descontando 1 polegada
    dist_norm = (xBA - xCG)/chord; %distancia normalizada do BA ao CG nesse y
    i = 1;
    while thick(i,1)<dist_norm
        i = i+1;
    end
    zlim = thick(i,2)*chord*0.8; %limite de z, � a espessura da origem do comp de carga com folga de 20%
% %     while hsjsjd(i,1)>dist_norm
% %         i = i+1;
% %     end
% %     zsup = jajajah(i,2)
% %     i = i+10
% %     while hsjsjd(i,1)<dist_norm
% %         i = i+1;
% %     end
% %     zinf = jdjjdhs(i,2)
% %     zlim = (zsup-zinf)*0.8 %limite de z, � a espessura da origem do comp de carga com folga de 20%
    z = zmin;
    while (z<zlim && P<18)
        z = z + dz;
        i = i-1;
        while thick(i,2)*chord*0.81>zlim %i nao reiniciou ainda, parte da origem e vai at� o BA
            i = i-1;
        end
        xlim2 = xCG - (thick(i,1)*chord + xBA);
        x = min(xlim1,xlim2)*2;
        P = dens*x*y*z;
    end
end
zBA = c(1)/4*sind(iw(1)) + tand(dw(1))*(y/2) + chord/4*sind(iw(1)+tw(1)*(y/(2*vetor_b(1)))); %posicao z do BA nesse y
z_comp = zBA + (xCG+y/2)*sind(i_w) + perfil_structure(perfil_raiz).pontos_inf(i,2)*c(1)*cosd(i_w) + thick(i,2)*0.4*c(1)*cosd(i_w);
comp = [x y z z_comp];
%% 8.Empenagem vertical
origem_tbx = pt(1,1) - c(1)/2*cosd(iw(1));
origem_tbz = pt(1,3) + c(1)/2*sind(iw(1));
origem = [origem_tbx,origem_tbz];
fim = [pf(na+2,1),pf(na+2,3)];
inc_tb = (fim(2)-origem(2))/(fim(1)-origem(1));
folga = 0.1; %muito perto da asa
n= 20; %numero de iteracoes
dx = (fim(1)-origem(1) - folga)/n;  %variacao do braco
pos_evx = ((origem(1) + folga):dx:fim(1));
pos_evy = ((origem(2) + folga*inc_tb):(dx*inc_tb):fim(2));
bracos_ev = pos_evx - xCG;
altura_ev = H.*(1 - ((pos_evx.^2 + pos_evy.^2).^(0.5))./R);

%bonus pro Eric: enflechamento na meia corda
x1 = c(1)/2*cosd(iw(1));
x2 = pf(na+1,1) + c(na+1)/2*cosd(iw(na+1));
y1 = 0;
y2 = pf(na+1,2);
enf_meio = atand((x2-x1)/(y2-y1));

%bonus pro Marcos: enflechamento do BA
i = 1;
enf_BA = zeros(1,na);
while i<(na)
    enf_BA(i) = atand((pf(i+1,1)-pf(i,1))/(pf(i+1,2)-pf(i,2)));
    i = i + 1;
end

%% 9.Motor
xc = -((((H - pf(1,3))/H)^2) * R^2 -(pf(1,2))^2)^0.5;
d_BA_motor = pf(1,1) - xc;

origem_cone = [0 0 H] - pf(1);

%% 10.Salvar vetor aviao
aviao.x_comp = comp(1);
aviao.y_comp = comp(2);             %Verificar
aviao.z_comp = comp(3);
aviao.S = S;
aviao.S_EH = S_EH;
aviao.c = c;
aviao.c_EH = ceh;
aviao.MAC = mac;
aviao.MAC_EH = mac_EH;
aviao.inc_tb = inc_tb;
aviao.vetor_lv = bracos_ev;
aviao.vetor_zmax = altura_ev;
aviao.l_meia = enf_meio;
aviao.l_BA = enf_BA;
aviao.comp = comp;
aviao.d_BA_motor = d_BA_motor;
aviao.flag_geom = flag_x_complexo;
aviao.flag_z = z_flag;
aviao.b_sec = b_sec;
aviao.b_sec_EH = b_sec_eh;
aviao.xCG = xCG;
aviao.origem_cone = origem_cone;
aviao.morte = morte || flag_x_complexo || z_flag;
mortes.geometria = morte || flag_x_complexo || z_flag;
end
