function [] = plota_aviao( aviao , ps , const , num_fig )
% plota_aviao( aviao , perfil_structure , const , 1 )
%% CARREGANDO VALORES %%
% ================================ AVIÃO ================================ %
b_total = aviao.b;                                                          %[m] envergadura total da asa
b = aviao.m_b;                                                              %[m] vetor de semi-envergaduras
c = aviao.c_sec;                                                            %[m] vetor de cordas
l_BA = aviao.l_BA;                                                          %[º] vetor de enflechamento no BA
perfil = aviao.perfil;                                                      %[-] vetor de perfis
i_w1 = aviao.i_w1;                                                          %[º] incidência da aeronave
i_w2 = aviao.i_w2;
tw = aviao.tw;
h_asa1_BA = aviao.h_asa1_BA;
h_asa2_BA = aviao.h_asa2_BA;
xCG = aviao.xCG;
zCG = aviao.zCG;
x_motor = aviao.x_motor;
h_motor = aviao.h_motor;
% ================================ CONST ================================ %
D_tp = const.D_tp;
D_bq = const.D_bq;
dtp = const.dtp;
db = const.db;
% ======================== CÁLCULOS GEOMÉTRICOS ========================= %
offset_BA_x = offsetBA_x(b,l_BA);                                           %[m] vetor offset do BA em x
cum_b = cumsum([0 b]);                                                      %[m] vetor com a posição em y das transições de seção
fb = 2*b / b_total;                                                         %[-] vetor com a fração de envergadura de cada seção

%% INICIALIZANDO FIG %%
figure(num_fig)
axis equal
hold on
axis tight
grid on
view(3)

%% CHÃO %%
X_chao = [-1/2 -1/2 3/2; 3/2 3/2 -1/2];
Y_chao = [-3/2 3/2 3/2; 3/2 -3/2 -3/2];
Z_chao = [0 0 0; 0 0 0];
surf(X_chao,Y_chao,Z_chao,'EdgeColor','none','FaceColor',[0.3 0.3 0.3])

%% MALHA %%
twist = [0 tw];
% ========================= NÚMERO DE ELEMENTOS ========================= %
num_paineis_X = 20;                                                         % número de painéis em X
num_paineis_Y = 10;                                                         % número de painéis em Y
paineis_Y = round(fb*num_paineis_Y);                                        % painéis em Y em cada seção
cum_paineis_Y = [1 cumsum(paineis_Y)];
num_paineis_Y = sum(paineis_Y);
num_paineis_total = num_paineis_Y * num_paineis_X;
% ============================ INICIALIZAÇÃO ============================ %
X = zeros(num_paineis_X,num_paineis_Y);
Z_sup = X;
Z_inf = X;
% ============================ DISTRIBUIÇÃO X =========================== %
theta = linspace(0,pi,num_paineis_X);
x = 0.5 * (1 - cos(theta));                                                 % distribuição cossenoidal ao longo da corda
% ================================ MALHA ================================ %
Y = repmat(linspace(0,cum_b(end),num_paineis_Y),num_paineis_X,1);
for secao = 1:length(paineis_Y)
    num_paineis = length(cum_paineis_Y(secao):cum_paineis_Y(secao+1));
%     X(:,cum_paineis_Y(secao):cum_paineis_Y(secao+1)) = linspaceVet(x'*c(secao)+offset_BA_x(secao),x'*c(secao+1)+offset_BA_x(secao+1),num_paineis);
    x0 = x*c(secao)+offset_BA_x(secao);
    x1 = x*c(secao+1)+offset_BA_x(secao+1);
    
    z0_sup = c(secao)*interp1(ps(perfil(secao)).pontos_sup(:,1),ps(perfil(secao)).pontos_sup(:,2),x,'linear','extrap');
    z0_inf = c(secao)*interp1(ps(perfil(secao)).pontos_inf(:,1),ps(perfil(secao)).pontos_inf(:,2),x,'linear','extrap');
    z1_sup = c(secao+1)*interp1(ps(perfil(secao+1)).pontos_sup(:,1),ps(perfil(secao+1)).pontos_sup(:,2),x,'linear','extrap');
    z1_inf = c(secao+1)*interp1(ps(perfil(secao+1)).pontos_inf(:,1),ps(perfil(secao+1)).pontos_inf(:,2),x,'linear','extrap');
    % ========================== APLICA TWIST =========================== %
    centro_twist0 = [x0(1) + c(secao)/4 , c(secao)*polyval(ps(perfil(secao)).cf,1/4)];
    centro_twist1 = [x1(1) + c(secao+1)/4 , c(secao+1)*polyval(ps(perfil(secao+1)).cf,1/4)];
    [x0,z0_sup,z0_inf] = aplicaTwist( x0 , z0_sup , z0_inf , twist(secao) , centro_twist0 );
    [x1,z1_sup,z1_inf] = aplicaTwist( x1 , z1_sup , z1_inf , twist(secao+1) , centro_twist1 );
    X(:,cum_paineis_Y(secao):cum_paineis_Y(secao+1)) = linspaceVet(x0',x1',num_paineis);

    Z_sup(:,cum_paineis_Y(secao):cum_paineis_Y(secao+1)) = linspaceVet(z0_sup',z1_sup',num_paineis);
    Z_inf(:,cum_paineis_Y(secao):cum_paineis_Y(secao+1)) = linspaceVet(z0_inf',z1_inf',num_paineis);
end
% ============================== SIMETRIA =============================== %
X = [fliplr(X) X(:,2:end)];
Y = [-fliplr(Y) Y(:,2:end)];
Z_sup = [fliplr(Z_sup) Z_sup(:,2:end)];
Z_inf = [fliplr(Z_inf) Z_inf(:,2:end)];

% ============================= INCIDÊNCIA ============================== %
for i = 1:length(Y(1,:))
    [x,z_sup,z_inf] = aplicaTwist(X(:,i)',Z_sup(:,i)',Z_inf(:,i)',i_w1,[0,0]);
    X(:,i) = x';
    Z_sup(:,i) = z_sup';
    Z_inf(:,i) = z_inf';
end
% ============================= SEGUNDA ASA ============================= %
X1 = X;
Y1 = Y;
Z_sup1 = Z_sup;
Z_inf1 = Z_inf;

X2 = X;
Y2 = Y;
Z_sup2 = Z_sup;
Z_inf2 = Z_inf;
    % =========================== INCIDÊNCIA ============================ %
    for i = 1:length(Y(1,:))
    [x,z_sup,z_inf] = aplicaTwist(X2(:,i)',Z_sup2(:,i)',Z_inf2(:,i)',i_w2,[0,0]);
    X2(:,i) = x';
    Z_sup2(:,i) = z_sup';
    Z_inf2(:,i) = z_inf';
    end
% ============================= TRANSLAÇÕES ============================= %
Z_sup1 = Z_sup1 + h_asa1_BA;
Z_inf1 = Z_inf1 + h_asa1_BA;
Z_sup2 = Z_sup2 + h_asa2_BA;
Z_inf2 = Z_inf2 + h_asa2_BA;

% ================================ PLOT ================================= %
surf(X1,Y1,Z_sup1,'FaceAlpha',0.3,'LineStyle',':')
surf(X1,Y1,Z_inf1,'FaceAlpha',0.3)
surf(X2,Y2,Z_sup2)
surf(X2,Y2,Z_inf2)

%% RODAS %%
if aviao.y_tp ~= 0
    xTP = xCG + dtp;
    yTP = aviao.y_tp;
    zTP = D_tp/2;
    
    xBQ = xCG - db;
    yBQ = 0;
    zBQ = D_bq/2;
    
    circle(xTP,yTP,zTP,D_tp/2,'k');
    circle(xTP,-yTP,zTP,D_tp/2,'k');
    circle(xBQ,yBQ,zBQ,D_bq/2,'k');
    
end

%% FUSELGAEM %%
if aviao.b_fus ~= 0
    b_fus = aviao.b_fus;
    c_fus = aviao.c_fus;
    h_fus = aviao.h_fus;
    CG = aviao.Fuselagem.CG;
    
    X_fus = [CG(1)-c_fus/2,CG(1)+c_fus/2,CG(1)+c_fus/2,CG(1)-c_fus/2,CG(1)-c_fus/2;CG(1)-c_fus/2,CG(1)+c_fus/2,CG(1)+c_fus/2,CG(1)-c_fus/2,CG(1)-c_fus/2];
    Y_fus = [-b_fus/2,-b_fus/2,-b_fus/2,-b_fus/2,-b_fus/2;b_fus/2,b_fus/2,b_fus/2,b_fus/2,b_fus/2];
    Z_fus = [CG(3)+h_fus/2,CG(3)+h_fus/2,CG(3)-h_fus/2,CG(3)-h_fus/2,CG(3)+h_fus/2;CG(3)+h_fus/2,CG(3)+h_fus/2,CG(3)-h_fus/2,CG(3)-h_fus/2,CG(3)+h_fus/2];
%     Z_fus = Z_fus + h_asa1_BA;
    
    X_fus = reshape(X_fus,1,[]);
    Z_fus = reshape(Z_fus,1,[]);
    [ X_fus , Z_fus ] = aplicaRot( X_fus , Z_fus , i_w1 , [CG(1),CG(3)] );
    X_fus = reshape(X_fus,2,[]);
    Z_fus = reshape(Z_fus,2,[]);
    
    Z_fus = Z_fus + h_asa1_BA;
    
    surf(X_fus,Y_fus,Z_fus,'FaceColor','g')  
    plot3(CG(1),CG(2),CG(3)+h_asa1_BA,'*')
end

%% LONGARINA %%
existe_longarina = true;
try aviao.Longarina.cg_c;
catch ME
    if (strcmp(ME.identifier,'MATLAB:nonExistentField'))
        existe_longarina = false;
    end
end

if existe_longarina
    Longarina = aviao.Longarina;
    secoes = length(Longarina.d)-1;
    D = zeros(1,secoes);
    for i = 1:secoes
        D(i) = min([Longarina.d(i) Longarina.d(i+1)]);
    end
    num_elementos = 100;
    X_long = zeros(num_elementos,secoes+1);
    Y_long = repmat([0 aviao.s_b],num_elementos,1);
    Z_long = X_long;
    for i = 1:secoes
        x0c = Longarina.cg_c(1,i);
        z0c = Longarina.cg_c(3,i);       
        x1c = Longarina.cg_c(1,i+1);
        z1c = Longarina.cg_c(3,i+1); 
        theta = linspace(0,2*pi,num_elementos)';
        x0 = cos(theta)*D(i)/2 + x0c;
        x1 = cos(theta)*D(i)/2 + x1c;
        z0 = sin(theta)*D(i)/2 + z0c;
        z1 = sin(theta)*D(i)/2 + z1c;
        
        X_long(:,[i,i+1]) = [x0,x1];
        Z_long(:,[i,i+1]) = [z0,z1];
    end
    Z_long = Z_long + h_asa1_BA;

    X_long = reshape(X_long,1,[]);
    Z_long = reshape(Z_long,1,[]);
    [ X_long , Z_long ] = aplicaRot( X_long , Z_long , i_w1 , [0,0] );
    X_long = reshape(X_long,num_elementos,[]);
    Z_long = reshape(Z_long,num_elementos,[]);  
    
    % ============================ SIMETRIA ============================= %
    X_long = [fliplr(X_long) X_long(:,2:end)];
    Y_long = [-fliplr(Y_long) Y_long(:,2:end)];
    Z_long = [fliplr(Z_long) Z_long(:,2:end)];
    
    surf(X_long,Y_long,Z_long)
end

%% MOTOR %%
plot3(x_motor,0,h_motor,'*')

%% zCG %%
plot3(xCG,0,zCG,'*')

%% SOMA DIMENSIONAL %%
% 'SOMA DIMENSIONAL'
% sum_dim = (max([X1(:);X2(:)]) - x_motor) + 2 * max(Y1(:))

end

%% Função aplicaTwist() %%
% ============================== DESCRIÇÃO ============================== %
% Essa função recebe dois vetores referentes às coordenadas X e Z do perfil
% e aplica um twist.
function [ x_twist , z_sup_twist , z_inf_twist ] = aplicaTwist( x , z_sup , z_inf , twist , centro_twist )
x = x - centro_twist(1);
z_sup = z_sup - centro_twist(2);
z_inf = z_inf - centro_twist(2);

R = [cosd(-twist) -sind(-twist); sind(-twist) cosd(-twist)];
v_sup = [x;z_sup];
v_inf = [x;z_inf];

v_sup_twist = R*v_sup;
v_inf_twist = R*v_inf;

x_twist = v_sup_twist(1,:);
z_sup_twist = v_sup_twist(2,:);
z_inf_twist = interp1(v_inf_twist(1,:),v_inf_twist(2,:),x_twist,'linear','extrap');

x_twist = x_twist + centro_twist(1);
z_sup_twist = z_sup_twist + centro_twist(2);
z_inf_twist = z_inf_twist + centro_twist(2);

end

%% Função linspaceVet() %%
function y = linspaceVet(d1,d2,n)
n1 = n-1;
N = repmat(0:n1,length(d1),1);
y = d1 + N.*(d2-d1)./n1;
end

%% Função offsetBA_x() %%
function [ offset ] = offsetBA_x(Sb,l_BA)

offset = Sb .* tand(l_BA);
if length(offset) > 1
    for k = 2:1:length(offset)
        offset(k) = sum(offset(k-1:k));
    end
end
offset = [ 0 offset ];
end

function [xunit,yunit,zunit] = circle(x,y,z,r,fontinhas)
th = 0:pi/50:2*pi;
xunit = r * cos(th) + x;
yunit = 0 * sin(th) + y;
zunit = r * sin(th) + z;

plot3(xunit,yunit,zunit,fontinhas,'LineWidth',1)
end

%% Função aplicaRot() %%
% ============================== DESCRIÇÃO ============================== %
% Essa função recebe dois vetores referentes às coordenadas X e Z do perfil
% e aplica um twist.
function [ x_twist , z_sup_twist ] = aplicaRot( x , z_sup , twist , centro_twist )
x = x - centro_twist(1);
z_sup = z_sup - centro_twist(2);

R = [cosd(-twist) -sind(-twist); sind(-twist) cosd(-twist)];
v_sup = [x;z_sup];

v_sup_twist = R*v_sup;

x_twist = v_sup_twist(1,:);
z_sup_twist = v_sup_twist(2,:);

x_twist = x_twist + centro_twist(1);
z_sup_twist = z_sup_twist + centro_twist(2);

end