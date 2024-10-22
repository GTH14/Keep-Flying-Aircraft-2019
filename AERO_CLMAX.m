function [NL_CL, NL_CM, aviao] = AERO_CLMAX(run, geom, geom_malha, geom_painel, infl_ALCOR, coef_zero,coef_alpha, coef_zero_g, coef_alpha_g, aviao, perfil_structure)
%% REAL SHIT
CL_alpha_1 = coef_alpha_g(1).CL - coef_zero_g(1).CL; CL_alpha_2 = coef_alpha_g(2).CL - coef_zero_g(2).CL;
CM = zeros(2,45);CL = zeros(2,45);alpha_v = zeros(1,45); i=1; grad =1; alpha_v(1) = (-coef_zero(end).CL)/(coef_alpha(end).CL - coef_zero(end).CL);
[CL(:,1),CM(:,1)] = AERO_ALCOR_MAIN_2(alpha_v(1), run, geom, geom_malha, geom_painel, infl_ALCOR,coef_zero_g, perfil_structure,aviao);
while (grad>0 && i<45)
    i = i+1; alpha_v(i) = alpha_v(i-1)+ 1; alpha_v(i)
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

%% Correção Solo
CL0g_1 = coef_zero_g(1).CL; CL0g_2 = coef_zero_g(2).CL;
CM0g_1 = coef_zero_g(1).CM; CM0g_2 = coef_zero_g(2).CM;
CM_alpha_1 = coef_alpha_g(1).CM - coef_zero_g(1).CM; CM_alpha_2 = coef_alpha_g(2).CM - coef_zero_g(2).CM;

% Linear divide
is_lin_1 = diff(CL_1)./diff(alpha_v); is_lin_1 = (is_lin_1/is_lin_1(1))>.95; is_lin_1(2) = true;
is_lin_1((find(diff(cumsum(is_lin_1,2))==0,1,'first')+1):end)=false;
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

alpha_1_corr_L = [ alpha_lin_1_L, alpha_n1_1_L]; [alpha_1_corr_L, L_1_idx] = sort(alpha_1_corr_L);
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

alpha_2_corr_L = [ alpha_lin_2_L, alpha_n1_2_L]; [alpha_2_corr_L, L_2_idx] = sort(alpha_2_corr_L);
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

% figure(1)
% plot(alpha_1_corr_L,CL_1_corr,'.-')
% hold on;
% plot(alpha_2_corr_L,CL_2_corr,'.-')
% plot(alpha_L,CL,'.-')
% hold off;
% grid on;
% 
% figure(2)
% plot(alpha_1_corr_M,CM_1_corr,'.')
% hold on;
% plot(alpha_2_corr_M,CM_2_corr,'.')
% plot(alpha_L,CM,'.-')
% hold off;
% grid on;