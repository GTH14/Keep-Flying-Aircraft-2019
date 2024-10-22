function [] = plota_aviao_v3(aviao,perfil_structure)
%% Inicializa as variáveis da asa
geom.AR = aviao.AR;
geom.b = aviao.b;
geom.i_wl=aviao.i_w;
geom.fb = aviao.fb;
geom.t = aviao.t;
geom.l = aviao.l; 
geom.died = aviao.d;
geom.twist = aviao.tw;
geom.offset_X = 0;
geom.offset_Z = aviao.h_BA;
geom.corda_raiz = aviao.c(1);
geom.perfis = aviao.perfil;
geom.dens = 300;
%geom.i_w_rel = aviao.i_w2;
geom.d_BA_BA_X = 0;%aviao.d_BA_x; %A princípio é zero
geom.d_BA_BA_Z = aviao.h_BA;
geom.S = aviao.S/2; %Simetria 
geom.MAC = aviao.MAC;
geom.inv_perfil = false;
% geom.fim_def = aviao.fb_e;
% geom.fd = aviao.fc_e;
% geom.offset_x = [0,aviao.offset];

%% Inicializa as variáveis da cauda
geom_h.AR = (aviao.b_EH^2)/aviao.S_EH; 
geom_h.b = aviao.b_EH;
geom_h.i_wl=aviao.i_EH;
geom_h.fb = aviao.fb_EH;
geom_h.t = aviao.t_EH;
zero_sec = zeros(1,length(geom_h.t)); 
geom_h.l = zero_sec; 
geom_h.died = zero_sec; % A princípio é tudo zero
geom_h.twist = zero_sec;
geom_h.corda_raiz = aviao.c_root_EH;
geom_h.perfis = [aviao.perfil_EH,aviao.perfil_EH,aviao.perfil_EH];
geom_h.dens = 300;
geom_h.S = aviao.S_EH/2; 
geom_h.MAC = aviao.MAC_EH;
geom_h.offset_X = aviao.c(1)*cosd(aviao.i_w)+aviao.d_BF_BA_x;
geom_h.offset_Z = -geom.offset_Z*sind(aviao.i_w)+aviao.d_BF_BA_z;
geom_h.inv_perfil = true;
geom_h.f_prof = aviao.f_prof; 

    %% Monta malha do avião
% Monta asa
[ geom_malhatop(1)] = AeroMalhaGeometriaTop( geom, perfil_structure );
[ geom_malhabottom(1)] = AeroMalhaGeometriaBottom( geom, perfil_structure );
% Monta a empenagem horizontal
[ geom_malhatop(2)] = AeroMalhaGeometriaTop( geom_h, perfil_structure );
[ geom_malhabottom(2)] = AeroMalhaGeometriaBottom( geom_h, perfil_structure );
% Monta a empenagem vertcal

    %% Forma o cone
[Cone] = formaCone(0.75,1.25,60,aviao.origem_cone(1));

    %% Forma compartimento de cargas
geom_comp.pos0 = [aviao.xCG, 0, aviao.comp(4)];
geom_comp.tam = aviao.comp(1:3);
geom_comp.angle = aviao.i_w;
[comp] = forma_comp(geom_comp);
 
    %% Plota aviao
figure(num_fig)
axis equal
hold on
axis tight
grid on
view(3)
surf(geom_malhatop(1).X,geom_malhatop(1).Y, geom_malhatop(1).Z,'EdgeColor','none','FaceColor', [0.3 0 0],'FaceAlpha',0.3);
surf(geom_malhatop(2).X,geom_malhatop(2).Y, geom_malhatop(2).Z,'EdgeColor','none','FaceColor', [0 0.3 0]);
surf(geom_malhabottom(1).X,geom_malhabottom(1).Y, geom_malhabottom(1).Z,'EdgeColor','none','FaceColor', [0.3 0 0],'FaceAlpha',0.3);
surf(geom_malhabottom(2).X,geom_malhabottom(2).Y, geom_malhabottom(2).Z,'EdgeColor','none','FaceColor', [0 0.3 0]);
surf(Cone.X,Cone.Y,Cone.Z,'FaceAlpha',0.3,'FaceColor', [0 0 0.3]);
surf(comp.X, comp.Y, comp.Z, 'EdgeColor','none','FaceColor', [0.6 0 0])