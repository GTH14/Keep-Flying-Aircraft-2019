function [NL_CL, NL_CM, aviao] = AERO_CLMAX_2(run, geom, geom_malha, geom_painel, infl_ALCOR, infl_solo, coef_zero,coef_alpha, coef_zero_g, coef_alpha_g, aviao, perfil_structure)
CL_alpha_1 = coef_alpha_g(1).CL - coef_zero_g(1).CL; CL_alpha_2 = coef_alpha_g(2).CL - coef_zero_g(2).CL;
CM = zeros(2,45);CL = zeros(2,45);alpha_v = zeros(1,45); i=1; grad =1; alpha_v(1) = (-coef_zero(end).CL)/(coef_alpha(end).CL - coef_zero(end).CL);
[CL(:,1),CM(:,1)] = AERO_ALCOR_MAIN_2(alpha_v(1), run, geom, geom_malha, geom_painel, infl_ALCOR,coef_zero_g, perfil_structure,aviao);
while (grad>0 && i<45)
    i = i+1; alpha_v(i) = alpha_v(i-1)+ 1;
    [CL(:,i),CM(:,i)] = AERO_ALCOR_MAIN_2(alpha_v(i), run, geom, geom_malha, geom_painel, infl_ALCOR,coef_zero_g, perfil_structure, aviao);
    grad = CL(1,i) - CL(1,i-1);
end
alpha_v(alpha_v==0)=[];
CL(CL==0)=[]; CL = reshape(CL,2,[]);
CM(CM==0)=[]; CM = reshape(CM,2,[]);

CL_1 = CL(1,:); CL_2 = CL(2,:);
CM_1 = CM(1,:); CM_2 = CM(2,:);
alfa_estol_2 = find(diff(CL_2)<0,1,'first');
alfa_estol_1 = find(diff(CL_1)<0,1,'first');
if (not(isempty(alfa_estol_1)) && not(isempty(alfa_estol_2)))
    aviao.alfa_estol = alpha_v(min([alfa_estol_1,alfa_estol_2]))-2;
elseif (not(isempty(alfa_estol_1)))
    aviao.alfa_estol = alpha_v(alfa_estol_1)-2;
elseif (not(isempty(alfa_estol_2)))
    aviao.alfa_estol = alpha_v(alfa_estol_2)-2;
end
%% w_ind 1->2
ca_2_X = (geom_painel.C1X(geom_painel.surf_idx==2) + geom_painel.C2X(geom_painel.surf_idx==2))/2;
ca_2_Y = (geom_painel.C1Y(geom_painel.surf_idx==2) + geom_painel.C2Y(geom_painel.surf_idx==2))/2;
ca_2_Z = (geom_painel.C1Z(geom_painel.surf_idx==2) + geom_painel.C2Z(geom_painel.surf_idx==2))/2;

num_ca = length(ca_2_X); num_total=length(geom_painel.CPX(geom_painel.surf_idx==1));

CPX=repmat(ca_2_X,1,num_total);
CPY=repmat(ca_2_Y,1,num_total);
CPZ=repmat(ca_2_Z,1,num_total);

C1X=repmat(geom_painel.C1X(geom_painel.surf_idx==1)',num_ca,1);
C2X=repmat(geom_painel.C2X(geom_painel.surf_idx==1)',num_ca,1);
C3X=repmat(geom_painel.C3X(geom_painel.surf_idx==1)',num_ca,1);
C4X=repmat(geom_painel.C4X(geom_painel.surf_idx==1)',num_ca,1);
C1Y=repmat(geom_painel.C1Y(geom_painel.surf_idx==1)',num_ca,1);
C2Y=repmat(geom_painel.C2Y(geom_painel.surf_idx==1)',num_ca,1);
C3Y=repmat(geom_painel.C3Y(geom_painel.surf_idx==1)',num_ca,1);
C4Y=repmat(geom_painel.C4Y(geom_painel.surf_idx==1)',num_ca,1);
C1Z=repmat(geom_painel.C1Z(geom_painel.surf_idx==1)',num_ca,1);
C2Z=repmat(geom_painel.C2Z(geom_painel.surf_idx==1)',num_ca,1);
C3Z=repmat(geom_painel.C3Z(geom_painel.surf_idx==1)',num_ca,1);
C4Z=repmat(geom_painel.C4Z(geom_painel.surf_idx==1)',num_ca,1);

[u1,v1,w1]=aero_vortex_line(CPX,CPY,CPZ,C1X,C1Y,C1Z,C2X,C2Y,C2Z);
[u2,v2,w2]=aero_vortex_line(CPX,CPY,CPZ,C2X,C2Y,C2Z,C3X,C3Y,C3Z);
[u3,v3,w3]=aero_vortex_line(CPX,CPY,CPZ,C3X,C3Y,C3Z,C4X,C4Y,C4Z);
[u4,v4,w4]=aero_vortex_line(CPX,CPY,CPZ,C4X,C4Y,C4Z,C1X,C1Y,C1Z);

u_ind_i = u1 + u2 + u3 + u4; v_ind_i = v1 + v2 + v3 + v4; w_ind_i = w1 + w2 + w3 + w4;
u_ind_w_i = u2 + u4; v_ind_w_i = v2 + v4; w_ind_w_i = w2 + w4;

[u1,v1,w1]=aero_vortex_line(CPX,-CPY,CPZ,C1X,C1Y,C1Z,C2X,C2Y,C2Z);
[u2,v2,w2]=aero_vortex_line(CPX,-CPY,CPZ,C2X,C2Y,C2Z,C3X,C3Y,C3Z);
[u3,v3,w3]=aero_vortex_line(CPX,-CPY,CPZ,C3X,C3Y,C3Z,C4X,C4Y,C4Z);
[u4,v4,w4]=aero_vortex_line(CPX,-CPY,CPZ,C4X,C4Y,C4Z,C1X,C1Y,C1Z);

u_ind_i = u_ind_i + u1 + u2 + u3 + u4; u_ind_j = u_ind_i;
v_ind_i = v_ind_i - v1 - v2 - v3 - v4; v_ind_j = v_ind_i;
w_ind_i = w_ind_i + w1 + w2 + w3 + w4; w_ind_j = w_ind_i;

[u1,v1,w1]=aero_vortex_line(CPX,CPY,-CPZ,C1X,C1Y,C1Z,C2X,C2Y,C2Z);
[u2,v2,w2]=aero_vortex_line(CPX,CPY,-CPZ,C2X,C2Y,C2Z,C3X,C3Y,C3Z);
[u3,v3,w3]=aero_vortex_line(CPX,CPY,-CPZ,C3X,C3Y,C3Z,C4X,C4Y,C4Z);
[u4,v4,w4]=aero_vortex_line(CPX,CPY,-CPZ,C4X,C4Y,C4Z,C1X,C1Y,C1Z);

u_ind_i = u_ind_i + u1 + u2 + u3 + u4;
v_ind_i = v_ind_i + v1 + v2 + v3 + v4;
w_ind_i = w_ind_i - w1 - w2 - w3 - w4;

[u1,v1,w1]=aero_vortex_line(CPX,-CPY,-CPZ,C1X,C1Y,C1Z,C2X,C2Y,C2Z);
[u2,v2,w2]=aero_vortex_line(CPX,-CPY,-CPZ,C2X,C2Y,C2Z,C3X,C3Y,C3Z);
[u3,v3,w3]=aero_vortex_line(CPX,-CPY,-CPZ,C3X,C3Y,C3Z,C4X,C4Y,C4Z);
[u4,v4,w4]=aero_vortex_line(CPX,-CPY,-CPZ,C4X,C4Y,C4Z,C1X,C1Y,C1Z);

u_ind_i = u_ind_i + u1 + u2 + u3 + u4;
v_ind_i = v_ind_i - v1 - v2 - v3 - v4;
w_ind_i = w_ind_i - w1 - w2 - w3 - w4;

C1X=repmat(geom_painel.C1X(geom_painel.surf_idx==2)',num_ca,1);
C2X=repmat(geom_painel.C2X(geom_painel.surf_idx==2)',num_ca,1);
C3X=repmat(geom_painel.C3X(geom_painel.surf_idx==2)',num_ca,1);
C4X=repmat(geom_painel.C4X(geom_painel.surf_idx==2)',num_ca,1);
C1Y=repmat(geom_painel.C1Y(geom_painel.surf_idx==2)',num_ca,1);
C2Y=repmat(geom_painel.C2Y(geom_painel.surf_idx==2)',num_ca,1);
C3Y=repmat(geom_painel.C3Y(geom_painel.surf_idx==2)',num_ca,1);
C4Y=repmat(geom_painel.C4Y(geom_painel.surf_idx==2)',num_ca,1);
C1Z=repmat(geom_painel.C1Z(geom_painel.surf_idx==2)',num_ca,1);
C2Z=repmat(geom_painel.C2Z(geom_painel.surf_idx==2)',num_ca,1);
C3Z=repmat(geom_painel.C3Z(geom_painel.surf_idx==2)',num_ca,1);
C4Z=repmat(geom_painel.C4Z(geom_painel.surf_idx==2)',num_ca,1);

[u1,v1,w1]=aero_vortex_line(CPX,CPY,-CPZ,C1X,C1Y,C1Z,C2X,C2Y,C2Z);
[u2,v2,w2]=aero_vortex_line(CPX,CPY,-CPZ,C2X,C2Y,C2Z,C3X,C3Y,C3Z);
[u3,v3,w3]=aero_vortex_line(CPX,CPY,-CPZ,C3X,C3Y,C3Z,C4X,C4Y,C4Z);
[u4,v4,w4]=aero_vortex_line(CPX,CPY,-CPZ,C4X,C4Y,C4Z,C1X,C1Y,C1Z);

u_ind_i = u_ind_i + u1 + u2 + u3 + u4;
v_ind_i = v_ind_i + v1 + v2 + v3 + v4;
w_ind_i = w_ind_i - w1 - w2 - w3 - w4;

[u1,v1,w1]=aero_vortex_line(CPX,-CPY,-CPZ,C1X,C1Y,C1Z,C2X,C2Y,C2Z);
[u2,v2,w2]=aero_vortex_line(CPX,-CPY,-CPZ,C2X,C2Y,C2Z,C3X,C3Y,C3Z);
[u3,v3,w3]=aero_vortex_line(CPX,-CPY,-CPZ,C3X,C3Y,C3Z,C4X,C4Y,C4Z);
[u4,v4,w4]=aero_vortex_line(CPX,-CPY,-CPZ,C4X,C4Y,C4Z,C1X,C1Y,C1Z);

u_ind_i = u_ind_i + u1 + u2 + u3 + u4;
v_ind_i = v_ind_i - v1 - v2 - v3 - v4;
w_ind_i = w_ind_i - w1 - w2 - w3 - w4;

U_ind_G = u_ind_i * infl_solo.gamma(geom_painel.surf_idx==1);
V_ind_G = v_ind_i * infl_solo.gamma(geom_painel.surf_idx==1);
W_ind_G = w_ind_i * infl_solo.gamma(geom_painel.surf_idx==1);

U_ind = u_ind_j * infl_ALCOR.gamma(geom_painel.surf_idx==1);
V_ind = v_ind_j * infl_ALCOR.gamma(geom_painel.surf_idx==1);
W_ind = w_ind_j * infl_ALCOR.gamma(geom_painel.surf_idx==1);

alpha_ind_2_G = sum(atand(W_ind_G./(U_ind_G+run.Q)).*infl_solo.gamma(geom_painel.surf_idx==2)/sum(infl_solo.gamma(geom_painel.surf_idx==2)));
alpha_ind_2 = sum(atand(W_ind./(U_ind+run.Q)).*infl_ALCOR.gamma(geom_painel.surf_idx==2)/sum(infl_ALCOR.gamma(geom_painel.surf_idx==2)));
alpha_intrf_2 = alpha_ind_2_G - alpha_ind_2;
%% w_ind 2->1
% ca_2_X = transpose(geom_malha(1).X(1,:) + (geom_malha(1).X(end,:) - geom_malha(1).X(1,:))/2); ca_2_X(isnan(diff(ca_2_X)))=[];
% ca_2_Y = transpose(geom_malha(1).Y(1,:) + (geom_malha(1).Y(end,:) - geom_malha(1).Y(1,:))/2); ca_2_Y(isnan(diff(ca_2_Y)))=[];
% ca_2_Z = transpose(geom_malha(1).Z(1,:) + (geom_malha(1).Z(end,:) - geom_malha(1).Z(1,:))/2); ca_2_Z(isnan(diff(ca_2_Z)))=[];
ca_2_X = (geom_painel.C1X(geom_painel.surf_idx==1) + geom_painel.C2X(geom_painel.surf_idx==1))/2;
ca_2_Y = (geom_painel.C1Y(geom_painel.surf_idx==1) + geom_painel.C2Y(geom_painel.surf_idx==1))/2;
ca_2_Z = (geom_painel.C1Z(geom_painel.surf_idx==1) + geom_painel.C2Z(geom_painel.surf_idx==1))/2;
num_ca = length(ca_2_X); num_total=length(geom_painel.CPX(geom_painel.surf_idx==2));

CPX=repmat(ca_2_X,1,num_total);
CPY=repmat(ca_2_Y,1,num_total);
CPZ=repmat(ca_2_Z,1,num_total);

C1X=repmat(geom_painel.C1X(geom_painel.surf_idx==2)',num_ca,1);
C2X=repmat(geom_painel.C2X(geom_painel.surf_idx==2)',num_ca,1);
C3X=repmat(geom_painel.C3X(geom_painel.surf_idx==2)',num_ca,1);
C4X=repmat(geom_painel.C4X(geom_painel.surf_idx==2)',num_ca,1);
C1Y=repmat(geom_painel.C1Y(geom_painel.surf_idx==2)',num_ca,1);
C2Y=repmat(geom_painel.C2Y(geom_painel.surf_idx==2)',num_ca,1);
C3Y=repmat(geom_painel.C3Y(geom_painel.surf_idx==2)',num_ca,1);
C4Y=repmat(geom_painel.C4Y(geom_painel.surf_idx==2)',num_ca,1);
C1Z=repmat(geom_painel.C1Z(geom_painel.surf_idx==2)',num_ca,1);
C2Z=repmat(geom_painel.C2Z(geom_painel.surf_idx==2)',num_ca,1);
C3Z=repmat(geom_painel.C3Z(geom_painel.surf_idx==2)',num_ca,1);
C4Z=repmat(geom_painel.C4Z(geom_painel.surf_idx==2)',num_ca,1);

[u1,v1,w1]=aero_vortex_line(CPX,CPY,CPZ,C1X,C1Y,C1Z,C2X,C2Y,C2Z);
[u2,v2,w2]=aero_vortex_line(CPX,CPY,CPZ,C2X,C2Y,C2Z,C3X,C3Y,C3Z);
[u3,v3,w3]=aero_vortex_line(CPX,CPY,CPZ,C3X,C3Y,C3Z,C4X,C4Y,C4Z);
[u4,v4,w4]=aero_vortex_line(CPX,CPY,CPZ,C4X,C4Y,C4Z,C1X,C1Y,C1Z);

u_ind_i = u1 + u2 + u3 + u4; v_ind_i = v1 + v2 + v3 + v4; w_ind_i = w1 + w2 + w3 + w4;
u_ind_w_i = u2 + u4; v_ind_w_i = v2 + v4; w_ind_w_i = w2 + w4;

[u1,v1,w1]=aero_vortex_line(CPX,-CPY,CPZ,C1X,C1Y,C1Z,C2X,C2Y,C2Z);
[u2,v2,w2]=aero_vortex_line(CPX,-CPY,CPZ,C2X,C2Y,C2Z,C3X,C3Y,C3Z);
[u3,v3,w3]=aero_vortex_line(CPX,-CPY,CPZ,C3X,C3Y,C3Z,C4X,C4Y,C4Z);
[u4,v4,w4]=aero_vortex_line(CPX,-CPY,CPZ,C4X,C4Y,C4Z,C1X,C1Y,C1Z);

u_ind_i = u_ind_i + u1 + u2 + u3 + u4; u_ind_j = u_ind_i;
v_ind_i = v_ind_i - v1 - v2 - v3 - v4; v_ind_j = v_ind_i;
w_ind_i = w_ind_i + w1 + w2 + w3 + w4; w_ind_j = w_ind_i;

[u1,v1,w1]=aero_vortex_line(CPX,CPY,-CPZ,C1X,C1Y,C1Z,C2X,C2Y,C2Z);
[u2,v2,w2]=aero_vortex_line(CPX,CPY,-CPZ,C2X,C2Y,C2Z,C3X,C3Y,C3Z);
[u3,v3,w3]=aero_vortex_line(CPX,CPY,-CPZ,C3X,C3Y,C3Z,C4X,C4Y,C4Z);
[u4,v4,w4]=aero_vortex_line(CPX,CPY,-CPZ,C4X,C4Y,C4Z,C1X,C1Y,C1Z);

u_ind_i = u_ind_i + u1 + u2 + u3 + u4;
v_ind_i = v_ind_i + v1 + v2 + v3 + v4;
w_ind_i = w_ind_i - w1 - w2 - w3 - w4;

[u1,v1,w1]=aero_vortex_line(CPX,-CPY,-CPZ,C1X,C1Y,C1Z,C2X,C2Y,C2Z);
[u2,v2,w2]=aero_vortex_line(CPX,-CPY,-CPZ,C2X,C2Y,C2Z,C3X,C3Y,C3Z);
[u3,v3,w3]=aero_vortex_line(CPX,-CPY,-CPZ,C3X,C3Y,C3Z,C4X,C4Y,C4Z);
[u4,v4,w4]=aero_vortex_line(CPX,-CPY,-CPZ,C4X,C4Y,C4Z,C1X,C1Y,C1Z);

u_ind_i = u_ind_i + u1 + u2 + u3 + u4;
v_ind_i = v_ind_i - v1 - v2 - v3 - v4;
w_ind_i = w_ind_i - w1 - w2 - w3 - w4;

C1X=repmat(geom_painel.C1X(geom_painel.surf_idx==1)',num_ca,1);
C2X=repmat(geom_painel.C2X(geom_painel.surf_idx==1)',num_ca,1);
C3X=repmat(geom_painel.C3X(geom_painel.surf_idx==1)',num_ca,1);
C4X=repmat(geom_painel.C4X(geom_painel.surf_idx==1)',num_ca,1);
C1Y=repmat(geom_painel.C1Y(geom_painel.surf_idx==1)',num_ca,1);
C2Y=repmat(geom_painel.C2Y(geom_painel.surf_idx==1)',num_ca,1);
C3Y=repmat(geom_painel.C3Y(geom_painel.surf_idx==1)',num_ca,1);
C4Y=repmat(geom_painel.C4Y(geom_painel.surf_idx==1)',num_ca,1);
C1Z=repmat(geom_painel.C1Z(geom_painel.surf_idx==1)',num_ca,1);
C2Z=repmat(geom_painel.C2Z(geom_painel.surf_idx==1)',num_ca,1);
C3Z=repmat(geom_painel.C3Z(geom_painel.surf_idx==1)',num_ca,1);
C4Z=repmat(geom_painel.C4Z(geom_painel.surf_idx==1)',num_ca,1);

[u1,v1,w1]=aero_vortex_line(CPX,CPY,-CPZ,C1X,C1Y,C1Z,C2X,C2Y,C2Z);
[u2,v2,w2]=aero_vortex_line(CPX,CPY,-CPZ,C2X,C2Y,C2Z,C3X,C3Y,C3Z);
[u3,v3,w3]=aero_vortex_line(CPX,CPY,-CPZ,C3X,C3Y,C3Z,C4X,C4Y,C4Z);
[u4,v4,w4]=aero_vortex_line(CPX,CPY,-CPZ,C4X,C4Y,C4Z,C1X,C1Y,C1Z);

u_ind_i = u_ind_i + u1 + u2 + u3 + u4;
v_ind_i = v_ind_i + v1 + v2 + v3 + v4;
w_ind_i = w_ind_i - w1 - w2 - w3 - w4;

[u1,v1,w1]=aero_vortex_line(CPX,-CPY,-CPZ,C1X,C1Y,C1Z,C2X,C2Y,C2Z);
[u2,v2,w2]=aero_vortex_line(CPX,-CPY,-CPZ,C2X,C2Y,C2Z,C3X,C3Y,C3Z);
[u3,v3,w3]=aero_vortex_line(CPX,-CPY,-CPZ,C3X,C3Y,C3Z,C4X,C4Y,C4Z);
[u4,v4,w4]=aero_vortex_line(CPX,-CPY,-CPZ,C4X,C4Y,C4Z,C1X,C1Y,C1Z);

u_ind_i = u_ind_i + u1 + u2 + u3 + u4;
v_ind_i = v_ind_i - v1 - v2 - v3 - v4;
w_ind_i = w_ind_i - w1 - w2 - w3 - w4;

U_ind_G = u_ind_i * infl_solo.gamma(geom_painel.surf_idx==2);
% V_ind_G = v_ind_i * infl_solo.gamma(geom_painel.surf_idx==2);
W_ind_G = w_ind_i * infl_solo.gamma(geom_painel.surf_idx==2);

U_ind = u_ind_j * infl_ALCOR.gamma(geom_painel.surf_idx==2);
% V_ind = v_ind_j * infl_ALCOR.gamma(geom_painel.surf_idx==2);
W_ind = w_ind_j * infl_ALCOR.gamma(geom_painel.surf_idx==2);

% alpha_ind_1 = atand(mean(W_ind)/(mean(U_ind)+run.Q));
alpha_ind_1_G = sum(atand(W_ind_G./(U_ind_G+run.Q)).*infl_solo.gamma(geom_painel.surf_idx==1)/sum(infl_solo.gamma(geom_painel.surf_idx==1)));
alpha_ind_1 = sum(atand(W_ind./(U_ind+run.Q)).*infl_ALCOR.gamma(geom_painel.surf_idx==1)/sum(infl_solo.gamma(geom_painel.surf_idx==1)));
alpha_intrf_1 = alpha_ind_1_G - alpha_ind_1;
%%
alpha_v(alpha_v==0)=[];
CL(CL==0)=[]; CL = reshape(CL,2,[]);
CM(CM==0)=[]; CM = reshape(CM,2,[]);

CL_1 = CL(1,:); CL_2 = CL(2,:);
CM_1 = CM(1,:); CM_2 = CM(2,:);
alfa_estol_2 = find(diff(CL_2)<0,1,'first');
alfa_estol_1 = find(diff(CL_1)<0,1,'first');
if (not(isempty(alfa_estol_1)) && not(isempty(alfa_estol_2)))
    aviao.alfa_estol = alpha_v(min([alfa_estol_1,alfa_estol_2]))-2;
elseif (not(isempty(alfa_estol_1)))
    aviao.alfa_estol = alpha_v(alfa_estol_1)-2;
elseif (not(isempty(alfa_estol_2)))
    aviao.alfa_estol = alpha_v(alfa_estol_2)-2;
end
%% Correção Solo
CL0g_1 = coef_zero_g(1).CL; CL0g_2 = coef_zero_g(2).CL;
CM0g_1 = coef_zero_g(1).CM; CM0g_2 = coef_zero_g(2).CM;
CM_alpha_1 = coef_alpha_g(1).CM - coef_zero_g(1).CM; CM_alpha_2 = coef_alpha_g(2).CM - coef_zero_g(2).CM;

% Linear divide
is_lin_1 = diff(CL_1)./diff(alpha_v); is_lin_1 = (is_lin_1/is_lin_1(1))>.95; is_lin_1(2) = true;
CL_lin_1 = CL_1(is_lin_1);
CM_lin_1 = CM_1(is_lin_1);
alpha_lin_1_L = (CL_lin_1-CL0g_1)/CL_alpha_1;
alpha_lin_1_M = (CM_lin_1-CM0g_1)/CM_alpha_1;

is_lin_2 = diff(CL_2)./diff(alpha_v); is_lin_2 = (is_lin_2/is_lin_2(1))>.95; is_lin_2(2) = true;
CL_lin_2 = CL_2(is_lin_2);
CM_lin_2 = CM_2(is_lin_2);
alpha_lin_2_L = (CL_lin_2-CL0g_2)/CL_alpha_2;
alpha_lin_2_M = (CM_lin_2-CM0g_2)/CM_alpha_2;

CL_nl_1 = CL_1(not(is_lin_1));
CM_nl_1 = CM_1(not(is_lin_1));
alpha_n1_1_L = alpha_v(not(is_lin_1)); 

if length(alpha_n1_1_L)<2
    delta_alpha_nl_1_L=1e-3;
else
delta_alpha_nl_1_L = alpha_n1_1_L(2) - alpha_n1_1_L(1);
end

alpha_n1_1_M = alpha_v(not(is_lin_1)); 
if length(alpha_n1_1_M)<2
    delta_alpha_nl_1_M=1e-3;
else
delta_alpha_nl_1_M = alpha_n1_1_M(2) - alpha_n1_1_M(1);
end

alpha_n1_1_L = (alpha_n1_1_L-alpha_n1_1_L(1)+delta_alpha_nl_1_L)*( max(abs(alpha_lin_1_L) - min(abs(alpha_lin_1_L) )))/(max(alpha_v(is_lin_1))-min(alpha_v(is_lin_1))) + max(alpha_lin_1_L);
alpha_n1_1_M = (alpha_n1_1_M-alpha_n1_1_M(1)+delta_alpha_nl_1_M)*( max(abs(alpha_lin_1_M) - min(abs(alpha_lin_1_M) )))/(max(alpha_v(is_lin_1))-min(alpha_v(is_lin_1))) + max(alpha_lin_1_M);

alpha_1_corr_L = [ alpha_lin_1_L, alpha_n1_1_L]; [alpha_1_corr_L, L_1_idx] = sort(alpha_1_corr_L); alpha_1_corr_L = alpha_1_corr_L + alpha_intrf_1;
alpha_1_corr_M = [ alpha_lin_1_M, alpha_n1_1_M]; [alpha_1_corr_M, M_1_idx] = sort(alpha_1_corr_M);
CL_1_corr = [ CL_lin_1, CL_nl_1]; CL_1_corr = CL_1_corr(L_1_idx);
CM_1_corr = [ CM_lin_1, CM_nl_1]; CM_1_corr = CM_1_corr(M_1_idx);

CL_nl_2 = CL_2(not(is_lin_2));
CM_nl_2 = CM_2(not(is_lin_2));
alpha_n1_2_L = alpha_v(not(is_lin_2)); 
if length(alpha_n1_2_L)<2
    delta_alpha_nl_2_L=1e-3;
else
delta_alpha_nl_2_L = alpha_n1_2_L(2) - alpha_n1_2_L(1);
end
alpha_n1_2_M = alpha_v(not(is_lin_2)); 
if length(alpha_n1_2_M)<2
    delta_alpha_nl_2_M=1e-3;
else
delta_alpha_nl_2_M = alpha_n1_2_M(2) - alpha_n1_2_M(1);
end
alpha_n1_2_L = (alpha_n1_2_L-min(alpha_n1_2_L)+delta_alpha_nl_2_L)*( max(abs(alpha_lin_2_L) - min(abs(alpha_lin_2_L) )))/(max(alpha_v(is_lin_2))-min(alpha_v(is_lin_2))) + max(alpha_lin_2_L);
alpha_n1_2_M = (alpha_n1_2_M-min(alpha_n1_2_M)+delta_alpha_nl_2_M)*( max(abs(alpha_lin_2_M) - min(abs(alpha_lin_2_M) )))/(max(alpha_v(is_lin_2))-min(alpha_v(is_lin_2))) + max(alpha_lin_2_M);

alpha_2_corr_L = [ alpha_lin_2_L, alpha_n1_2_L]; [alpha_2_corr_L, L_2_idx] = sort(alpha_2_corr_L); alpha_2_corr_L = alpha_2_corr_L + alpha_intrf_2;
alpha_2_corr_M = [ alpha_lin_2_M, alpha_n1_2_M]; [alpha_2_corr_M, M_2_idx] = sort(alpha_2_corr_M);

CL_2_corr = [ CL_lin_2, CL_nl_2]; CL_2_corr = CL_2_corr(L_2_idx); 
CM_2_corr = [ CM_lin_2, CM_nl_2]; CM_2_corr = CM_2_corr(M_2_idx);

CL = CL_1_corr + interp1(alpha_2_corr_L,CL_2_corr,alpha_1_corr_L,'linear','extrap');
alpha_L = alpha_1_corr_L;
CM = CM_1_corr + interp1(alpha_2_corr_M,CM_2_corr,alpha_1_corr_M,'linear','extrap');
alpha_M = alpha_1_corr_M;
[alpha_M, ord_idx] = sort(alpha_M); CM = CM(ord_idx);
NL_CL = griddedInterpolant(deg2rad(alpha_L),CL,'linear','nearest');
NL_CM = griddedInterpolant(deg2rad(alpha_M),CM,'linear','nearest');