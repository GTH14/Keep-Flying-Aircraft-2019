%% Constantes (só pra não precisar carregar todo o vetor const)
d_rodinha = 0.085; %alterar

%% Carregar parâmetros necessários

%b_total = aviao.b;                                                          %[m] envergadura total da asa
b = aviao.m_b;                                                              %[m] vetor de semi-envergaduras
b1 = b(1,1);
b2 = b(1,2);
b3 = b(1,3);
b_1 = b1/2;
b_2 = b2/2;
b_3 = b3/2;
c = aviao.c_sec;                                                            %[m] vetor de cordas
c_root = c_sec(1,1); 
c_int1 = c_sec(1,2); 
c_int2 = c_sec(1,3); 
c_tip = c_sec(1,4);
i_w = aviao.i_w;                                                            %[º] incidência da aeronave
h_BA = aviao.h_BA;
dist_BA_int1_root_i = (1/4)*c_root + b_1*tand(l1) - (c_int1/4);
dist_BA_int2_int1_i = (1/4)*c_int1 + b_2*tand(l2) - (c_int2/4);
dist_BA_tip_int2_i = (1/4)*c_int2 + b_3*tand(l3) - (c_tip/4);
h_BF_int1 = aviao.h_BF; 
h_BF_int2 = aviao.h_BF; 
h_BF_root = aviao.h_BF; 
h_BF_tip = aviao.h_BF; 

l_BA = aviao.l_BA;                                                          %[º] vetor de enflechamento no BA
h_asa_quarto = aviao.h_quarto;
ball_z = aviao.ball_z;
l1 = aviao.l1;                                                              % enflechamento no 1/4 de corda da seção 1
l2 = aviao.l2;                                                              % enflechamento no 1/4 de corda da seção 2
l3 = aviao.l3;                                                              % enflechamento no 1/4 de corda da seção 3

%EH
b_h=aviao.b_h;
i_h=aviao.i_h;
c_root_h=aviao.c_root_h;
d_BF_BA_x=aviao.d_BF_BA_x;
d_BF_BA_z=aviao.d_BF_BA_z;
d_BA_x = c_root * cosd(i_w) + d_BF_BA_x ;
d_BA_z = - c_root * sind(i_w) + d_BF_BA_z ;

%EV
d_BA_HT_BF_VT_x = 0.025;
cr_ev = aviao.cr_ev;
ang_tailboom = atand( ( d_BF_BA_z - (3/4)*c_root*sind(i_w) - (1/4)*c_root_h*sind(i_h))/(d_BF_BA_x + (3/4)*c_root*cosd(i_w) + (1/4)*c_root_h*cosd(i_h)) );
rot_v = ang_tailboom ;
d_BA_x_v = d_BA_x - d_BA_HT_BF_VT_x - cr_ev * cosd(rot_v) ;
d_BA_z_v = d_BA_z - d_BA_HT_BF_VT_x * tand(rot_v) - cr_ev * sind(rot_v);
b_v = aviao.b_v; 


%FUS
b_fus = aviao.b_fus; 
h_fus = aviao.h_fus; 
c_fus = aviao.c_fus; 

%Perfis
perfil = aviao.perfil;                                                      %[-] vetor de perfis
perfil_w = perfil (1,X); %não sei exatamente qual componente do vetor é
perfil_h = perfil (1,X); %não sei exatamente qual componente do vetor é
perfil_v = perfil (1,X); %não sei exatamente qual componente do vetor é

% tw = aviao.tw;
% t_w1 = aviao.t_w1;
% t_w2 = aviao.t_w2;
% t_w3 = aviao.t_w3;
% xCG = aviao.xCG;
% zCG = aviao.zCG;
% fb1 = aviao.fb1;
% fb2 = aviao.fb2;
% AR = aviao.AR;
% t1 = aviao.t1;
% t2 = aviao.t2;
% c_tip = aviao.c_tip;
% h_c_4 = aviao.h_c_4;
% t_h = aviao.t_h;
% perfil_h = aviao.perfil_h;
% i_h = aviao.i_h;
% c_tip_h = aviao.c_tip_h;
% d_bf_ba_x = aviao.d_bf_ba_x;
% d_bf_ba_z = aviao.d_bf_ba_z;
% ME = aviao.ME;
% b_v = aviao.b_v;


%% Pontos Críticos (Para auxiliar o entendimento dos pontos críticos, verifique o arquivo xxx.pdf)

% ASA
X_pc = [];
Y_pc = [];
Z_pc = [];

%pc_ba_root
x_ba_root=0;
y_ba_root=0;
z_ba_root=h_BA;

X_pc = [X_pc x_ba_root];
Y_pc = [Y_pc y_ba_root];
Z_pc = [Z_pc z_ba_root];

%pc_ba_12
x_ba_12=dist_BA_int1_root;
y_ba_12=b1/2;
z_ba_12=h_BF_int1+c_int1*sind(i_w);

X_pc = [X_pc x_ba_12];
Y_pc = [Y_pc y_ba_12];
Z_pc = [Z_pc z_ba_12];

%pc_ba_23
x_ba_23=dist_BA_int2_int1+dist_BA_int1_root;
y_ba_23=(b1+b2)/2;
z_ba_23 = h_BF_int2+c_int2*sind(i_w);

X_pc = [X_pc x_ba_23];
Y_pc = [Y_pc y_ba_23];
Z_pc = [Z_pc z_ba_23];

%pc_ba_tip
x_ba_tip=dist_BA_tip_root;
y_ba_tip=(b1+b2+b3)/2;
z_ba_tip= h_BF_tip+c_tip*sind(i_w);

X_pc = [X_pc x_ba_tip];
Y_pc = [Y_pc y_ba_tip];
Z_pc = [Z_pc z_ba_tip];

%pc_bf_root
x_bf_root=c_root*cosd(i_w);
y_bf_root=0;
z_bf_root=h_BF_root;

X_pc = [X_pc x_bf_root];
Y_pc = [Y_pc y_bf_root];
Z_pc = [Z_pc z_bf_root];

%pc_bf_12
x_bf_12=dist_BA_int1_root+c_int1*cosd(i_w);
y_bf_12=b1/2;
z_bf_12=h_BF_int1;

X_pc = [X_pc x_bf_12];
Y_pc = [Y_pc y_bf_12];
Z_pc = [Z_pc z_bf_12];

%pc_bf_23
x_bf_23=dist_BA_int2_int1+dist_BA_int1_root+c_int2*cosd(i_w);
y_bf_23=(b1+b2)/2;
z_bf_23=h_BF_int2;

X_pc = [X_pc x_bf_23];
Y_pc = [Y_pc y_bf_23];
Z_pc = [Z_pc z_bf_23];

%pc_bf_tip
x_bf_tip=dist_BA_tip_root+c_tip*cosd(i_w);
y_bf_tip=(b1+b2+b3)/2;
z_bf_tip=h_BF_tip;

X_pc = [X_pc x_bf_tip];
Y_pc = [Y_pc y_bf_tip];
Z_pc = [Z_pc z_bf_tip];

% Empenagem horizontal
% eh_ba_root
x_eh_ba_root=d_BA_x;
y_eh_ba_root=0;
z_eh_ba_root=d_BA_z + h_root;                                              

X_pc = [X_pc x_eh_ba_root];
Y_pc = [Y_pc y_eh_ba_root];
Z_pc = [Z_pc z_eh_ba_root];

% eh_ba_tip
x_eh_ba_tip=d_BA_x;
y_eh_ba_tip=(b_h)/2;
z_eh_ba_tip=d_BA_z + h_root;                                               

X_pc = [X_pc x_eh_ba_tip];
Y_pc = [Y_pc y_eh_ba_tip];
Z_pc = [Z_pc z_eh_ba_tip];

% eh_bf_root
x_eh_bf_root=d_BA_x+c_root_h*cosd(i_h);
y_eh_bf_root=0;
z_eh_bf_root=d_BA_z-c_root_h*sind(i_h) + h_root;                               

X_pc = [X_pc x_eh_bf_root];
Y_pc = [Y_pc y_eh_bf_root];
Z_pc = [Z_pc z_eh_bf_root];

% eh_bf_tip
x_eh_bf_tip=d_BA_x+c_root_h*cosd(i_h);
y_eh_bf_tip=(b_h)/2;
z_eh_bf_tip=d_BA_z-c_root_h*sind(i_h) + h_root;                               

X_pc = [X_pc x_eh_bf_tip];
Y_pc = [Y_pc y_eh_bf_tip];
Z_pc = [Z_pc z_eh_bf_tip];


%----------EV------------
%ba root
x_ev_ba_root=d_BA_x_v;
y_ev_ba_root=0;
z_ev_ba_root=d_BA_z_v+h_BA ;

X_pc = [X_pc x_ev_ba_root];
Y_pc = [Y_pc y_ev_ba_root];
Z_pc = [Z_pc z_ev_ba_root];

%ba tip
x_ev_ba_tip=d_BA_x_v -b_v*sind(rot_v);                                     
y_ev_ba_tip=0;
z_ev_ba_tip=d_BA_z_v+b_v*cosd(rot_v)+h_BA;

X_pc = [X_pc x_ev_ba_tip];
Y_pc = [Y_pc y_ev_ba_tip];
Z_pc = [Z_pc z_ev_ba_tip];

%bf root
x_ev_bf_root=d_BA_x_v+cr_ev*cosd(rot_v);
y_ev_bf_root=0;
z_ev_bf_root=d_BA_z_v+cr_ev*sind(rot_v)+h_BA;                              

X_pc = [X_pc x_ev_bf_root];
Y_pc = [Y_pc y_ev_bf_root];
Z_pc = [Z_pc z_ev_bf_root];

%bf tip
x_ev_bf_tip=d_BA_x_v -b_v*sind(rot_v)+cr_ev*cosd(rot_v);                     
y_ev_bf_tip=0;
z_ev_bf_tip=d_BA_z_v+b_v*cosd(rot_v)+cr_ev*sind(rot_v)+h_BA;

X_pc = [X_pc x_ev_bf_tip];
Y_pc = [Y_pc y_ev_bf_tip];
Z_pc = [Z_pc z_ev_bf_tip];

%-------------FUS--------------------
%ba_up
x_fus_ba_up=xCG -(c_fus)/2;
y_fus_ba_up=(b_fus)/2;
z_fus_ba_up=h_BA+h_fus;

X_pc = [X_pc x_fus_ba_up];
Y_pc = [Y_pc y_fus_ba_up];
Z_pc = [Z_pc z_fus_ba_up];

%bf_up
x_fus_bf_up=xCG +(c_fus)/2;
y_fus_bf_up=(b_fus)/2;
z_fus_bf_up=h_BA+h_fus;

X_pc = [X_pc x_fus_bf_up];
Y_pc = [Y_pc y_fus_bf_up];
Z_pc = [Z_pc z_fus_bf_up];

%ba_down
x_fus_ba_down=xCG -(c_fus)/2;
y_fus_ba_down=(b_fus)/2;
z_fus_ba_down=h_BA;

X_pc = [X_pc x_fus_ba_down];
Y_pc = [Y_pc y_fus_ba_down];
Z_pc = [Z_pc z_fus_ba_down];

%bf_down
x_fus_bf_down=xCG +(c_fus)/2;
y_fus_bf_down=(b_fus)/2;
z_fus_bf_down=h_BA;

X_pc = [X_pc x_fus_bf_down];
Y_pc = [Y_pc y_fus_bf_down];
Z_pc = [Z_pc z_fus_bf_down];
%% Espelhamento dos pontos críticos
X_pc2=X_pc;
Y_pc2=Y_pc*(-1);
Z_pc2=Z_pc;
X_pc=[X_pc X_pc2];
Y_pc=[Y_pc Y_pc2];
Z_pc=[Z_pc Z_pc2];

%% Roda

[xrod,zrod,yrod] = cylinder(0.5*[d_rodinha;d_rodinha]);
yrod = yrod/100;
zrod = zrod + 0.5*d_rodinha;
yrod = yrod + y_tp/2;
xrod = xrod + xCG + d_cg_tp;

%% Plotes
% Pontos críticos
% figure
gcf()
hold on
h=scatter3(X_pc,Y_pc,Z_pc,'filled');
h.MarkerFaceColor = [1 0.5 0.2];
axis([-0.5, 2.5, -1.50, 1.50, -1.50, 1.50]);
% Linhas entre pontos críticos
%--------BA----------%
%root_12
X_ba_root_12=[x_ba_root,x_ba_12];
Y_ba_root_12=[y_ba_root,y_ba_12];
Z_ba_root_12=[z_ba_root,z_ba_12];
line(X_ba_root_12,Y_ba_root_12,Z_ba_root_12,'Color',[0 0 0]);
%12_23
X_ba_12_23=[x_ba_12,x_ba_23];
Y_ba_12_23=[y_ba_12,y_ba_23];
Z_ba_12_23=[z_ba_12,z_ba_23];
line(X_ba_12_23,Y_ba_12_23,Z_ba_12_23,'Color',[0 0 0]);
%23_tip
X_ba_23_tip=[x_ba_23,x_ba_tip];
Y_ba_23_tip=[y_ba_23,y_ba_tip];
Z_ba_23_tip=[z_ba_23,z_ba_tip];
line(X_ba_23_tip,Y_ba_23_tip,Z_ba_23_tip,'Color',[0 0 0]);
%--------BF----------%
%root_12
X_bf_root_12=[x_bf_root,x_bf_12];
Y_bf_root_12=[y_bf_root,y_bf_12];
Z_bf_root_12=[z_bf_root,z_bf_12];
line(X_bf_root_12,Y_bf_root_12,Z_bf_root_12,'Color',[0 0 0]);
%12_23
X_bf_12_23=[x_bf_12,x_bf_23];
Y_bf_12_23=[y_bf_12,y_bf_23];
Z_bf_12_23=[z_bf_12,z_bf_23];
line(X_bf_12_23,Y_bf_12_23,Z_bf_12_23,'Color',[0 0 0]);
%23_tip
X_bf_23_tip=[x_bf_23,x_bf_tip];
Y_bf_23_tip=[y_bf_23,y_bf_tip];
Z_bf_23_tip=[z_bf_23,z_bf_tip];
line(X_bf_23_tip,Y_bf_23_tip,Z_bf_23_tip,'Color',[0 0 0]);

%ESPELHADO
%--------BA----------%
%root_12
X_ba_root_12=[x_ba_root,x_ba_12];
Y_ba_root_12=[-y_ba_root,-y_ba_12];
Z_ba_root_12=[z_ba_root,z_ba_12];
line(X_ba_root_12,Y_ba_root_12,Z_ba_root_12,'Color',[0 0 0]);
%12_23
X_ba_12_23=[x_ba_12,x_ba_23];
Y_ba_12_23=[-y_ba_12,-y_ba_23];
Z_ba_12_23=[z_ba_12,z_ba_23];
line(X_ba_12_23,Y_ba_12_23,Z_ba_12_23,'Color',[0 0 0]);
%23_tip
X_ba_23_tip=[x_ba_23,x_ba_tip];
Y_ba_23_tip=[-y_ba_23,-y_ba_tip];
Z_ba_23_tip=[z_ba_23,z_ba_tip];
line(X_ba_23_tip,Y_ba_23_tip,Z_ba_23_tip,'Color',[0 0 0]);
%--------BF----------%
%root_12
X_bf_root_12=[x_bf_root,x_bf_12];
Y_bf_root_12=[-y_bf_root,-y_bf_12];
Z_bf_root_12=[z_bf_root,z_bf_12];
line(X_bf_root_12,Y_bf_root_12,Z_bf_root_12,'Color',[0 0 0]);
%12_23
X_bf_12_23=[x_bf_12,x_bf_23];
Y_bf_12_23=[-y_bf_12,-y_bf_23];
Z_bf_12_23=[z_bf_12,z_bf_23];
line(X_bf_12_23,Y_bf_12_23,Z_bf_12_23,'Color',[0 0 0]);
%23_tip
X_bf_23_tip=[x_bf_23,x_bf_tip];
Y_bf_23_tip=[-y_bf_23,-y_bf_tip];
Z_bf_23_tip=[z_bf_23,z_bf_tip];
line(X_bf_23_tip,Y_bf_23_tip,Z_bf_23_tip,'Color',[0 0 0]);
%------------EH----------------
%--------BA----------%
%root_tip
X_eh_ba_root_tip=[x_eh_ba_root,x_eh_ba_tip];
Y_eh_ba_root_tip=[y_eh_ba_root,y_eh_ba_tip];
Z_eh_ba_root_tip=[z_eh_ba_root,z_eh_ba_tip];
line(X_eh_ba_root_tip,Y_eh_ba_root_tip,Z_eh_ba_root_tip,'Color',[0 0 0]);
%root_tip espelho
X_eh_ba_root_tip=[x_eh_ba_root,x_eh_ba_tip];
Y_eh_ba_root_tip=[-y_eh_ba_root,-y_eh_ba_tip];
Z_eh_ba_root_tip=[z_eh_ba_root,z_eh_ba_tip];
line(X_eh_ba_root_tip,Y_eh_ba_root_tip,Z_eh_ba_root_tip,'Color',[0 0 0]);
%---------BF------------%
%root_tip
X_eh_bf_root_tip=[x_eh_bf_root,x_eh_bf_tip];
Y_eh_bf_root_tip=[y_eh_bf_root,y_eh_bf_tip];
Z_eh_bf_root_tip=[z_eh_bf_root,z_eh_bf_tip];
line(X_eh_bf_root_tip,Y_eh_bf_root_tip,Z_eh_bf_root_tip,'Color',[0 0 0]);
%root_tip espelho
X_eh_bf_root_tip=[x_eh_bf_root,x_eh_bf_tip];
Y_eh_bf_root_tip=[-y_eh_bf_root,-y_eh_bf_tip];
Z_eh_bf_root_tip=[z_eh_bf_root,z_eh_bf_tip];
line(X_eh_bf_root_tip,Y_eh_bf_root_tip,Z_eh_bf_root_tip,'Color',[0 0 0]);

%------------EV---------%
%tip
X_ev_tip=[x_ev_ba_tip,x_ev_bf_tip];
Y_ev_tip=[y_ev_ba_tip,y_ev_bf_tip];
Z_ev_tip=[z_ev_ba_tip,z_ev_bf_tip];
line(X_ev_tip,Y_ev_tip,Z_ev_tip,'Color',[0 0 0]);
%root
X_ev_root=[x_ev_ba_root,x_ev_bf_root];
Y_ev_root=[y_ev_ba_root,y_ev_bf_root];
Z_ev_root=[z_ev_ba_root,z_ev_bf_root];
line(X_ev_root,Y_ev_root,Z_ev_root,'Color',[0 0 0]);
%ba
X_ev_ba=[x_ev_ba_root,x_ev_ba_tip];
Y_ev_ba=[y_ev_ba_root,y_ev_ba_tip];
Z_ev_ba=[z_ev_ba_root,z_ev_ba_tip];
line(X_ev_ba,Y_ev_ba,Z_ev_ba,'Color',[0 0 0]);
%bf
X_ev_bf=[x_ev_bf_root,x_ev_bf_tip];
Y_ev_bf=[y_ev_bf_root,y_ev_bf_tip];
Z_ev_bf=[z_ev_bf_root,z_ev_bf_tip];
line(X_ev_bf,Y_ev_bf,Z_ev_bf,'Color',[0 0 0]);


%hold off; %--------------------------------------------------------------------
% Plotes dos perfis nas seções
pontos=perfil_structure(aviao.perfil_w).pontos;
x_perfil_w=pontos(:,1);
z_perfil_w=pontos(:,2);
[teta,r]=cart2pol(x_perfil_w,z_perfil_w);
teta2=teta-i_w*pi/180;
[x_perfil_w,z_perfil_w]=pol2cart(teta2,r);

%Perfil na raiz
[teta,r]=cart2pol(x_perfil_w,z_perfil_w);
r=r*c_root;
[x_perfil_w_r,z_perfil_w_r]=pol2cart(teta2,r);
x_perfil_w_root=x_perfil_w_r;
y_perfil_w_root=x_perfil_w_r*0;
z_perfil_w_root=z_perfil_w_r + h_BA;
plot3(x_perfil_w_root,y_perfil_w_root,z_perfil_w_root,'Color',[0 0 0]);

%Perfil na 12
[teta,r]=cart2pol(x_perfil_w,z_perfil_w);
r=r*c_int1;
[x_perfil_w_1,z_perfil_w_1]=pol2cart(teta2,r);
x_perfil_w_12=x_perfil_w_1+x_ba_12;
y_perfil_w_12=x_perfil_w_1*0+y_ba_12;
z_perfil_w_12=z_perfil_w_1+z_ba_12;
plot3(x_perfil_w_12,y_perfil_w_12,z_perfil_w_12,'Color',[0 0 0]);

%Perfil na 12 espelhado
x_perfil_w_12=x_perfil_w_1+x_ba_12;
y_perfil_w_12=x_perfil_w_1*0-y_ba_12;
z_perfil_w_12=z_perfil_w_1+z_ba_12;
plot3(x_perfil_w_12,y_perfil_w_12,z_perfil_w_12,'Color',[0 0 0]);

%Perfil na 23
[teta,r]=cart2pol(x_perfil_w,z_perfil_w);
r=r*c_int2;
[x_perfil_w_2,z_perfil_w_2]=pol2cart(teta2,r);
x_perfil_w_23=x_perfil_w_2+x_ba_23;
y_perfil_w_23=x_perfil_w_2*0+y_ba_23;
z_perfil_w_23=z_perfil_w_2+z_ba_23;
plot3(x_perfil_w_23,y_perfil_w_23,z_perfil_w_23,'Color',[0 0 0]);

%Perfil na 23 espelhado
x_perfil_w_23=x_perfil_w_2+x_ba_23;
y_perfil_w_23=x_perfil_w_2*0-y_ba_23;
z_perfil_w_23=z_perfil_w_2+z_ba_23;
plot3(x_perfil_w_23,y_perfil_w_23,z_perfil_w_23,'Color',[0 0 0]);

%Perfil na tip
[teta,r]=cart2pol(x_perfil_w,z_perfil_w);
r=r*c_tip;
[x_perfil_w_t,z_perfil_w_t]=pol2cart(teta2,r);
x_perfil_w_tip=x_perfil_w_t+x_ba_tip;
y_perfil_w_tip=x_perfil_w_t*0+y_ba_tip;
z_perfil_w_tip=z_perfil_w_t+z_ba_tip;
plot3(x_perfil_w_tip,y_perfil_w_tip,z_perfil_w_tip,'Color',[0 0 0]);

%Perfil na tip espelhado
x_perfil_w_tip=x_perfil_w_t+x_ba_tip;
y_perfil_w_tip=x_perfil_w_t*0-y_ba_tip;
z_perfil_w_tip=z_perfil_w_t+z_ba_tip;
plot3(x_perfil_w_tip,y_perfil_w_tip,z_perfil_w_tip,'Color',[0 0 0]);

%---------EH------------
pontos_h=perfil_structure(aviao(pos.perfil_h)).pontos;
x_perfil_h=pontos_h(:,1);
z_perfil_h=pontos_h(:,2);
z_perfil_h=z_perfil_h * (-1);
[teta,r]=cart2pol(x_perfil_h,z_perfil_h);
r=r*c_root_h;
teta2=teta-i_h*pi/180;
[x_perfil_h,z_perfil_h]=pol2cart(teta2,r);

%root da eh
x_perfil_h_root=x_perfil_h+d_BA_x;
y_perfil_h_root=x_perfil_h*0;
z_perfil_h_root=z_perfil_h + d_BA_z + h_root;                              % [FONTAS]: adicionei '+ h_root'
plot3(x_perfil_h_root,y_perfil_h_root,z_perfil_h_root,'Color',[0 0 0]);

%tip da eh
x_perfil_h_tip=x_perfil_h+d_BA_x;
y_perfil_h_tip=x_perfil_h*0+(b_h/2);
z_perfil_h_tip=z_perfil_h+ d_BA_z + h_root;                                % [FONTAS]: adicionei '+ h_root'
plot3(x_perfil_h_tip,y_perfil_h_tip,z_perfil_h_tip,'Color',[0 0 0]);
%tip da eh espelhado
x_perfil_h_tip2=x_perfil_h+d_BA_x;
y_perfil_h_tip2=x_perfil_h*0-(b_h/2);
z_perfil_h_tip2=z_perfil_h + d_BA_z + h_root;                              % [FONTAS]: adicionei '+ h_root'
plot3(x_perfil_h_tip2,y_perfil_h_tip2,z_perfil_h_tip2,'Color',[0 0 0]);

%----------EV------------
pontos_v=perfil_structure(aviao.perfil_v).pontos;
x_perfil_v=pontos_v(:,1);
y_perfil_v=pontos_v(:,2);
z_perfil_v=y_perfil_v*0 +1;
[teta,r]=cart2pol(x_perfil_v,z_perfil_v);
r=r*cr_ev;
teta2=teta+rot_v*pi/180;
y_perfil_v=y_perfil_v*cr_ev;
[x_perfil_v,z_perfil_v]=pol2cart(teta2,r);


%% Plotes condicionais:
%----------plote da fus------------
%frente
x_fus = [x_fus_ba_up x_fus_ba_down x_fus_ba_up x_fus_ba_down]; % Generate data for x vertices
y_fus = [y_fus_ba_up -y_fus_ba_down -y_fus_ba_up y_fus_ba_down]; % Generate data for y vertices
z_fus = [z_fus_ba_up z_fus_ba_up z_fus_ba_down z_fus_ba_down]; % Solve for z vertices data
patch(x_fus, y_fus, z_fus, [1 0.5 0.2],'FaceAlpha',0.5);
%tras
x_fus = [x_fus_bf_up x_fus_bf_down x_fus_bf_up x_fus_bf_down]; % Generate data for x vertices
y_fus = [y_fus_ba_up -y_fus_ba_down -y_fus_ba_up y_fus_ba_down]; % Generate data for y vertices
z_fus = [z_fus_ba_up z_fus_ba_up z_fus_ba_down z_fus_ba_down]; % Solve for z vertices data
patch(x_fus, y_fus, z_fus, [1 0.5 0.2],'FaceAlpha',0.5);
%cima
x_fus = [x_fus_ba_up x_fus_ba_down x_fus_bf_up x_fus_bf_down]; % Generate data for x vertices
y_fus = [y_fus_ba_up -y_fus_ba_down -y_fus_ba_up y_fus_ba_down]; % Generate data for y vertices
z_fus = [z_fus_ba_up z_fus_ba_up z_fus_ba_up z_fus_ba_up]; % Solve for z vertices data
patch(x_fus, y_fus, z_fus, [1 0.5 0.2],'FaceAlpha',0.5);
%baixo
x_fus = [x_fus_ba_up x_fus_ba_down x_fus_bf_up x_fus_bf_down]; % Generate data for x vertices
y_fus = [y_fus_ba_up -y_fus_ba_down -y_fus_ba_up y_fus_ba_down]; % Generate data for y vertices
z_fus = [z_fus_ba_down z_fus_ba_down z_fus_ba_down z_fus_ba_down]; % Solve for z vertices data
patch(x_fus, y_fus, z_fus, [1 0.5 0.2],'FaceAlpha',0.5);
%direita
x_fus = [x_fus_ba_up x_fus_ba_up x_fus_bf_up x_fus_bf_down]; % Generate data for x vertices
y_fus = [y_fus_ba_up y_fus_ba_up y_fus_ba_up y_fus_ba_up]; % Generate data for y vertices
z_fus = [z_fus_ba_up z_fus_ba_down z_fus_ba_down z_fus_ba_up]; % Solve for z vertices data
patch(x_fus, y_fus, z_fus, [1 0.5 0.2],'FaceAlpha',0.5);
%esquerda
x_fus = [x_fus_ba_up x_fus_ba_up x_fus_bf_up x_fus_bf_down]; % Generate data for x vertices
y_fus = [-y_fus_ba_up -y_fus_ba_up -y_fus_ba_up -y_fus_ba_up]; % Generate data for y vertices
z_fus = [z_fus_ba_up z_fus_ba_down z_fus_ba_down z_fus_ba_up]; % Solve for z vertices data
patch(x_fus, y_fus, z_fus, [1 0.5 0.2],'FaceAlpha',0.5);

%% Demais Plotes
%-------Plote do CG-------------
scatter3(xCG,0,z_fus_ba_up-(h_fus)/2, 'filled','b');
%-------Plote do NP-------------
scatter3(xNP,0,z_fus_ba_up-(h_fus)/2, 'filled','r');
%-------Plote de Roda-----------
surf(xrod,yrod,zrod,'FaceColor','k')
surf(xrod,-yrod,zrod,'FaceColor','k')

%% Titulo do gráfico
title(strcat('Carga Paga:  ',num2str(aviao(pos.CP)),' kg'));

