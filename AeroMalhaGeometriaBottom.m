function [ geom_malha] = AeroMalhaGeometriaBottom( geom, perfil_structure )
% Malha feita para n seções 
%% número de painéis
panels_b = round(sqrt(geom.dens*geom.AR)/2);
panels_c = round(sqrt(geom.dens/geom.AR));

%% Parâmetros geométricos iniciais
b = geom.b;
i_w = geom.i_wl;
twist = geom.twist;
acum_twist = [0,cumsum(twist)];
fb = geom.fb;
t = geom.t;
%num_sec = length(t);
l = geom.l;
diedro = geom.died;
num_sec = length(diedro);
offset_X = geom.offset_X;
offset_Z = geom.offset_Z;
corda_raiz = geom.corda_raiz;
n_perfis = geom.perfis;
inv_perfil = geom.inv_perfil;
%% Parâmetros geométricos derivados dos iniciais
corda_inter_sec = [corda_raiz , corda_raiz*cumprod(t)]; % vetor com as cordas entre as seções ( [corda_raiz,corda_raiz*t1,corda_raiz*t1*t2 ...] )
% corda_inter_sec é [c_root,c_int1,c_int2,...,c_tip] 
aux1_b_sec = [1,cumprod(fb)]; % [1,fb1,fb1*fb2,fb1*fb2*fb3 ...]
aux2_b_sec = [1-fb,1]; % [1-fb1,1-fb2,1-fb3 ...,1] 
b_sec = b*aux1_b_sec.*aux2_b_sec; % Envergadura em cada seção


acum_b = [0,cumsum(b_sec)];
panels_b_sec = ceil(b_sec/b*panels_b); % número de painéins na direção da envergadura em cada seção
panels_b_sec(1) = panels_b - sum(panels_b_sec(2:end)); % Correção para a soma ser panels_b

%% Verificar se ta igual. A princípio usa o enflechamento
offsetX_inter_sec = [0,cumsum(b_sec.*tand(l)/2 - diff(corda_inter_sec)/4)]; % offset no começo de cada seção
%offsetX_inter_sec = geom.offset_x;
%os offsets se acumulam, por isso o cumsum. entre uma seção e outra sua
%formula é: b_sec.*tand(l)/2 + diff(corda_inter_sec)/4)
% acum_panels = [0,cumsum(panels_b_sec)];
%dz_diedro = [0,cumsum(b_sec/2.*tand(diedro))]; % z inicial da seção devido ao diedro

teta=0:pi/panels_c:pi;
x =0.5-0.5*cos(teta); % distribuição cossenoidal na direção da corda 


%% Construção da base de meia asa com origem no zero
x2 = x(:);
comp_x = length(x);
%z = zeros(1,comp_x);
%z2 = z(:);
% Xb=NaN(panels_c+1,panels_b+1+2*(num_sec-1)); % Matrizes com as coordenadas dos pontos da malha  
% Yb=Xb;                              
% Zb=Xb; % devido ao diedro
z_inicial = 0; %Z do começo de cada seção devido ao diedro das seções anteriores 
y_inicial = 0;
z_tw_inicial = 0;
%Z1_p=X1; % devido ao perfil
%load('aero_dados_perfil_v4.mat')
%dados para arrasto parasita
% Svetor = b_sec/2.*(corda_inter_sec(1:end-1)+corda_inter_sec(2:end))/2;
t_max0 = zeros(1,num_sec+1);
t_loc0 = zeros(1,num_sec+1);
middle = NaN(comp_x,1);
for i = 1:num_sec
    
%     acum_inicio = acum_panels(i);
%     acum_fim = acum_panels(i+1);
    acum_b_inicial = acum_b(i);
    acum_b_final = acum_b(i+1);
    corda_inicial = corda_inter_sec(i);
    corda_final = corda_inter_sec(i+1);
    offsetX_inicial = offsetX_inter_sec(i);
    offsetX_final = offsetX_inter_sec(i+1);
    
    
    num_panels = panels_b_sec(i); %número de painéis da seção
    % Eixo x
    Mx = repmat(x2,1,num_panels+1); 
    a =  repmat(linspace(0,1,num_panels+1),comp_x,1); % Matriz auxiliar para vetorização
    vix = corda_inicial*Mx + offsetX_inicial; % pontos iniciais em x
    vfx = corda_final*Mx + offsetX_final;     % pontos finais em x
    X1 = vix + (vfx-vix).*a; % (vfx2-vix2).*a2 varia linearmente cada x do inicio até o fim no eixo y
    
    %(:,acum_inicio+1+i-1:acum_fim+1+i-1) o i-1 é para não ocupar as opções com NaN
    % o +1 e -1 se cancelam
    %Vetor auxiliar para twist
    offsetX_Twist = repmat(X1(1,:)+(X1(end,:)-X1(1,:))/4,comp_x,1);
    
    % Eixo y
    Y1_atual = (acum_b_inicial/2 + (acum_b_final-acum_b_inicial)/2.*a)/cosd(diedro(i));
%     Y1_atual = [Y1_atual_ant,Y1_atual_ant];
    % /cosd(diedro(i)) porque o diedro é uma composição: estica o eixo y e
    % rotaciona em x para que a envergadura em y se mantenha
    %Eixo z será achado após calculada o Z_p devido aos perfis pela rotação
    %de [Y1 Z1_p] em torno de x
    % Tem q somar ou subtrair dz_diedro no final, que é a posição em z onde
    % começa a seção
        
    %Cordas
    cma = (X1(end,:) - X1(1,:)); %cordas seção
    Mc = repmat(cma,panels_c+1,1); % Matriz com as cordas em cada ponto 
%     X1 = [X1 ,X1];
    
    %linha média do perfil
    
    pontos_inicial=perfil_structure(n_perfis(i)).pontos; % Acha os pontos do perfil inicial
    pontos_final=perfil_structure(n_perfis(i+1)).pontos; % Acha os pontos do perfil final
    if inv_perfil
        
        pontos_inicial(:,2) = -pontos_inicial(:,2);
        pontos_final(:,2) = -pontos_final(:,2);
        
    end
%     [ perfil_center_inicial ] = AchaCentroPerfil( pontos_inicial,x ); % Acha linha média
%     [perfil_top_inicial] = AchaPerfilTop(pontos_inicial,x);
    [perfil_bottom_inicial] = AchaPerfilBottom(pontos_inicial,x);
%     [ perfil_center_final ] = AchaCentroPerfil( pontos_final,x );   % Acha linha média
    [perfil_bottom_final] = AchaPerfilBottom(pontos_final,x);
    %Parasita
    t_max0(i) = perfil_structure(n_perfis(i)).maxt_x;
    t_loc0(i) = perfil_structure(n_perfis(i)).t_c;
    %Faz a interpolação entre os perfis do inicio e fim
%     Z1_p_atual = PerfilSecao( perfil_center_inicial,perfil_center_final,Mc);
%     Z1_p_atual_top = PerfilSecao(perfil_top_inicial, perfil_top_final,Mc);
    Z1_p_atual_bottom = PerfilSecao(perfil_bottom_inicial, perfil_bottom_final,Mc);
    Z1_p_atual = Z1_p_atual_bottom;
    % tp(i) = toc;
    % Rotação pelo diedro
    
    [ Y1_0,Z1_p_atual ] = Rotaciona_X(Y1_atual-Y1_atual(1,1),Z1_p_atual,diedro(i) );%Y1_atual-acum_b_inicial/2 para mudar o eixo de rotação
    %a seção gira em torno dela mesma e não em torno da origem
    
    % Colocando os pontos nas matrizes da meia asa
    Y1 = Y1_0+y_inicial; % volta para a base original
    Z1 = Z1_p_atual+z_inicial; %- dz_diedro(i); %dz_diedro(i) é o ponto em z onde começa a seção
    z_inicial = min(Z1(:,end)); %min(Z1(:,end)) é o z do ba da ponta da seção anterior
    y_inicial = Y1(1,end);
    
    % twist
    ang_i = acum_twist(i);
    ang_f = acum_twist(i+1);
    Mi = ang_i + (ang_f-ang_i).*a;
%     Mi = [Mi_ant,Mi_ant];
    %Ox_twist = offsetX_inicial_Twist+(offsetX_final_Twist-offsetX_inicial_Twist).*a;
    [X1,Zp2] = RotacionaMatriz_Y( X1-offsetX_Twist,Z1_p_atual,Mi);%Rotação devido à incidência
    X1 = X1+offsetX_Twist;
    Z1 = Z1+Zp2-Z1_p_atual;%influencia do twist no Z dos perfis
    Z1 = Z1+z_tw_inicial-Z1(1,1); %Correção de continuidade
    z_tw_inicial = Z1(1,end);     %Correção de continuidade
    % Construção da matriz geral
   
    if i==1
        Xb = X1;
        Yb = Y1;
        Zb = Z1;
%         Mi_w = Mi;
%         Ox_twist_w = Ox_twist;
%         Xb(:,acum_inicio+i:acum_fim+i) = X1;
%         Yb(:,acum_inicio+i:acum_fim+i) = Y1;
%         Zb(:,acum_inicio+i:acum_fim+i) = Z1;
        
    else
        
        Xb_ant = Xb;
        Yb_ant = Yb;
        Zb_ant = Zb;
%         Mi_w_ant = Mi_w;
%         Ox_twist_w_ant = Ox_twist_w;
        
        Xb = [Xb_ant middle X1];
        Yb = [Yb_ant middle Y1];
        Zb = [Zb_ant middle Z1];
%         Mi_w = [Mi_w_ant middle Mi]; % Matriz com a incidência de cada ponto
%         Ox_twist_w = [Ox_twist_w_ant middle Ox_twist];
%         c = 2*(i-1);
%         Xb(:,acum_inicio+c:acum_fim+c) = X1;
%         Yb(:,acum_inicio+c:acum_fim+c) = Y1;
%         Zb(:,acum_inicio+c:acum_fim+c) = Z1;
%         
%         Xb(:,acum_inicio+c-1) = middle;
%         Yb(:,acum_inicio+c-1) = middle;
%         Zb(:,acum_inicio+c-1) = middle;
    end
  
end
%calcula o vetor com as cordas 
% Xc_aux=Xb(:,2:end);
% X_aux=[fliplr(Xb) Xc_aux];
% cma_out = X_aux(end,:)-X_aux(1,:);
cma_out = Xb(end,:)-Xb(1,:);
chord = (cma_out(2:end)+cma_out(1:end-1))/2; %corda em cada painel
chord(isnan(chord)) = []; % Tira os NaN 
if i_w~=0||sum(abs(twist))==0
    
    [Xb,Zb] = Rotaciona_Y( Xb,Zb,i_w);%Rotação devido à incidência

end 
% len = length(Xb(1,:));
% pos_isnan = [];
% for i = 1:len
%     if isnan(Xb(1,i))
%         pos_isnan = [pos_isnan,i+1];
%     end
% end
% Xb(:,pos_isnan) = [];
% Yb(:,pos_isnan) = [];
% Zb(:,pos_isnan) = [];

len = length(Xb(1,:));
pos_isnan = [];
for i = 1:len
    if isnan(Xb(1,i))
        pos_isnan = [pos_isnan,i+1];
    end
end
Xb(:,pos_isnan) = Xb(:,pos_isnan-2);
Yb(:,pos_isnan) = Yb(:,pos_isnan-2);
Zb(:,pos_isnan) = Zb(:,pos_isnan-2);

% % Fazendo os dois lados da asa
% Xc=Xb(:,2:end);
% Yc=Yb(:,2:end);
% Zc=Zb(:,2:end);
% 
% X=[fliplr(Xb) Xc];
% Y=[fliplr(-Yb) Yc];
% Z=[fliplr(Zb) Zc];

Xb=Xb+offset_X;
Zb=Zb+offset_Z;

% Dados Arrasto parasita
t_max0(end) = perfil_structure(n_perfis(end)).maxt_x;
t_loc0(end) = perfil_structure(n_perfis(end)).t_c;
[geom.t_max,t_loc_ind] = max(t_max0);
geom.t_loc = t_loc0(t_loc_ind);


geom_malha = struct('X',Xb,'Y',Yb,'Z',Zb,'numelem',panels_b*panels_c,'cma_out',cma_out,'x',x2,'chord',chord);