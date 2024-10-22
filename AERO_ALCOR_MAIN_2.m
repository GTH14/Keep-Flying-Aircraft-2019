function [CL,CM] = AERO_ALCOR_MAIN_2(alpha_var, run, geom, geom_malha, geom_painel, infl_ALCOR,coef_zero_g, perfil_structure, aviao)
run.alpha = alpha_var;
infl = AERO_RHS(run,geom_painel,infl_ALCOR);
coef_alpha_0 = AERO_SECOMP (run,geom(1),geom_malha,geom_painel,infl);
alcor(1).delta_alpha = zeros(size([coef_alpha_0(1).Cl]));
alcor(2).delta_alpha = zeros(size([coef_alpha_0(2).Cl]));
CPY = coef_zero_g.c_y;
% aviao.m_b = [.4 .6 .4]; %TEMP
% aviao.perfil = [8 7 6 5]; %TEMP
% gap_c = [.6 .7 .8 .9 1];
% delta
b = cumsum(aviao.m_b);
is_sec_1_temp = CPY < b(1); 
is_sec_1_1 = (cumsum(is_sec_1_temp(is_sec_1_temp)))/(sum(is_sec_1_temp)+1);
is_sec_1_2 = fliplr((cumsum(is_sec_1_temp(is_sec_1_temp)))/(sum(is_sec_1_temp)+1));
is_sec_2_temp = (b(1) < CPY) & (CPY < b(2)); 
is_sec_2_1 = (cumsum(is_sec_2_temp(is_sec_2_temp)))/(sum(is_sec_2_temp)+1);
is_sec_2_2 = fliplr((cumsum(is_sec_2_temp(is_sec_2_temp)))/(sum(is_sec_2_temp)+1));
is_sec_3_temp = CPY > b(2); 
is_sec_3_1 = (cumsum(is_sec_3_temp(is_sec_3_temp)))/(sum(is_sec_3_temp)+1);
is_sec_3_2 = fliplr((cumsum(is_sec_3_temp(is_sec_3_temp)))/(sum(is_sec_3_temp)+1));

Re = 1.18*10*geom_malha(1).chord/18.6e-6;
Re(Re>600e3) = 600e3; % pouca mudança de coeficientes depois de Re 600e3, evita ruins de interp
Re(Re<250e3) = 250e3; % temp., tá dando ruim de interp. rever perfil structure

delta_Cl_1 = 0.3* max(perfil_structure(aviao.perfil(1)).obj_cl.Values);
delta_Cl_2 = 0.3* max(perfil_structure(aviao.perfil(2)).obj_cl.Values);
delta_Cl_3 = 0.3* max(perfil_structure(aviao.perfil(3)).obj_cl.Values);
delta_Cl_4 = 0.3* max(perfil_structure(aviao.perfil(4)).obj_cl.Values);

delta_alpha_1 = delta_Cl_1 / mean(perfil_structure(aviao.perfil(1)).obj_cl_alpha(Re(is_sec_1_temp)));
delta_alpha_2 = delta_Cl_2 / mean(perfil_structure(aviao.perfil(2)).obj_cl_alpha(Re(is_sec_2_temp)));
delta_alpha_3 = delta_Cl_3 / mean(perfil_structure(aviao.perfil(3)).obj_cl_alpha(Re(is_sec_3_temp)));
delta_alpha_4 = delta_Cl_4 / mean(perfil_structure(aviao.perfil(4)).obj_cl_alpha(Re(is_sec_3_temp)));

Cl0 = transpose([perfil_structure(aviao.perfil(1)).obj_cl0(Re(is_sec_1_temp)).*is_sec_1_2 + perfil_structure(aviao.perfil(2)).obj_cl0(Re(is_sec_1_temp)).*is_sec_1_1, ...
    perfil_structure(aviao.perfil(2)).obj_cl0(Re(is_sec_2_temp)).*is_sec_2_2 + perfil_structure(aviao.perfil(3)).obj_cl0(Re(is_sec_2_temp)).*is_sec_2_1,...
    perfil_structure(aviao.perfil(3)).obj_cl0(Re(is_sec_3_temp)).*is_sec_3_2 + perfil_structure(aviao.perfil(4)).obj_cl0(Re(is_sec_3_temp)).*is_sec_3_1]);

Cl_alpha = transpose([perfil_structure(aviao.perfil(1)).obj_cl_alpha(Re(is_sec_1_temp)).*is_sec_1_2 + perfil_structure(aviao.perfil(2)).obj_cl_alpha(Re(is_sec_1_temp)).*is_sec_1_1, ...
    perfil_structure(aviao.perfil(2)).obj_cl_alpha(Re(is_sec_2_temp)).*is_sec_2_2 + perfil_structure(aviao.perfil(3)).obj_cl_alpha(Re(is_sec_2_temp)).*is_sec_2_1,...
    perfil_structure(aviao.perfil(3)).obj_cl_alpha(Re(is_sec_3_temp)).*is_sec_3_2 + perfil_structure(aviao.perfil(4)).obj_cl_alpha(Re(is_sec_3_temp)).*is_sec_3_1]);

alpha_eff_1 = transpose((coef_alpha_0(1).Cl - Cl0)./Cl_alpha) + [delta_alpha_1*is_sec_1_1 + delta_alpha_2*is_sec_1_2, delta_alpha_2*is_sec_2_1 + delta_alpha_3*is_sec_2_2, delta_alpha_3*is_sec_3_1 + delta_alpha_4*is_sec_3_2];
% alpha_eff_1 = transpose((coef_alpha_0(1).Cl - Cl0)./Cl_alpha);
Cl_v_1 = transpose([(perfil_structure(aviao.perfil(1)).obj_cl(alpha_eff_1(is_sec_1_temp),Re(is_sec_1_temp))-delta_Cl_1).*is_sec_1_2 + (perfil_structure(aviao.perfil(2)).obj_cl(alpha_eff_1(is_sec_1_temp),Re(is_sec_1_temp))-delta_Cl_2).*is_sec_1_1, ...
    (perfil_structure(aviao.perfil(2)).obj_cl(alpha_eff_1(is_sec_2_temp),Re(is_sec_2_temp))-delta_Cl_2).*is_sec_2_2 + (perfil_structure(aviao.perfil(3)).obj_cl(alpha_eff_1(is_sec_2_temp),Re(is_sec_2_temp))-delta_Cl_3).*is_sec_2_1,...
    (perfil_structure(aviao.perfil(3)).obj_cl(alpha_eff_1(is_sec_3_temp),Re(is_sec_3_temp))-delta_Cl_3).*is_sec_3_2 + (perfil_structure(aviao.perfil(4)).obj_cl(alpha_eff_1(is_sec_3_temp),Re(is_sec_3_temp))-delta_Cl_4).*is_sec_3_1]);

% alpha_eff_2 = transpose((coef_alpha_0(2).Cl - Cl0)./Cl_alpha);
alpha_eff_2 = transpose((coef_alpha_0(2).Cl - Cl0)./Cl_alpha) + [delta_alpha_1*is_sec_1_1 + delta_alpha_2*is_sec_1_2, delta_alpha_2*is_sec_2_1 + delta_alpha_3*is_sec_2_2, delta_alpha_3*is_sec_3_1 + delta_alpha_4*is_sec_3_2];

% Cl_v_2 = transpose([perfil_structure(aviao.perfil(1)).obj_cl(alpha_eff_2(is_sec_1_temp),Re(is_sec_1_temp)).*is_sec_1_2 + perfil_structure(aviao.perfil(2)).obj_cl(alpha_eff_2(is_sec_1_temp),Re(is_sec_1_temp)).*is_sec_1_1, ...
%     perfil_structure(aviao.perfil(2)).obj_cl(alpha_eff_2(is_sec_2_temp),Re(is_sec_2_temp)).*is_sec_2_2 + perfil_structure(aviao.perfil(3)).obj_cl(alpha_eff_2(is_sec_2_temp),Re(is_sec_2_temp)).*is_sec_2_1,...
%     perfil_structure(aviao.perfil(3)).obj_cl(alpha_eff_2(is_sec_3_temp),Re(is_sec_3_temp)).*is_sec_3_2 + perfil_structure(aviao.perfil(4)).obj_cl(alpha_eff_2(is_sec_3_temp),Re(is_sec_3_temp)).*is_sec_3_1]);

Cl_v_2 = transpose([(perfil_structure(aviao.perfil(1)).obj_cl(alpha_eff_2(is_sec_1_temp),Re(is_sec_1_temp))-delta_Cl_1).*is_sec_1_2 + (perfil_structure(aviao.perfil(2)).obj_cl(alpha_eff_2(is_sec_1_temp),Re(is_sec_1_temp))-delta_Cl_2).*is_sec_1_1, ...
    (perfil_structure(aviao.perfil(2)).obj_cl(alpha_eff_2(is_sec_2_temp),Re(is_sec_2_temp))-delta_Cl_2).*is_sec_2_2 + (perfil_structure(aviao.perfil(3)).obj_cl(alpha_eff_2(is_sec_2_temp),Re(is_sec_2_temp))-delta_Cl_3).*is_sec_2_1,...
    (perfil_structure(aviao.perfil(3)).obj_cl(alpha_eff_2(is_sec_3_temp),Re(is_sec_3_temp))-delta_Cl_3).*is_sec_3_2 + (perfil_structure(aviao.perfil(4)).obj_cl(alpha_eff_2(is_sec_3_temp),Re(is_sec_3_temp))-delta_Cl_4).*is_sec_3_1]);

resd = max([abs(coef_alpha_0(1).Cl-Cl_v_1);abs(coef_alpha_0(2).Cl-Cl_v_2)]);

coef_alpha = coef_alpha_0; iter = 1;
while (resd>1e-3 && iter<900)
% alpha_eff_2 = transpose((coef_alpha(2).Cl - Cl0)./Cl_alpha - alcor(2).delta_alpha); alpha_eff_2(alpha_eff_2>25) = 25;
% alpha_eff_2 = transpose((coef_alpha_0(2).Cl - Cl0)./Cl_alpha); alpha_eff_2(alpha_eff_2>25) = 25;
alpha_eff_2 = transpose((coef_alpha_0(2).Cl - Cl0)./Cl_alpha) + [delta_alpha_1*is_sec_1_1 + delta_alpha_2*is_sec_1_2, delta_alpha_2*is_sec_2_1 + delta_alpha_3*is_sec_2_2, delta_alpha_3*is_sec_3_1 + delta_alpha_4*is_sec_3_2];

% alpha_eff_1 = transpose((coef_alpha_0(1).Cl - Cl0)./Cl_alpha) + [delta_alpha_1*is_sec_1_1 + delta_alpha_2*is_sec_1_2, delta_alpha_2*is_sec_2_1 + delta_alpha_3*is_sec_2_2, delta_alpha_3*is_sec_3_1 + delta_alpha_4*is_sec_3_2];
% alpha_eff_1 = transpose((coef_alpha_0(1).Cl - Cl0)./Cl_alpha); alpha_eff_1(alpha_eff_1>25) = 25;
alpha_eff_1 = transpose((coef_alpha_0(1).Cl - Cl0)./Cl_alpha) + [delta_alpha_1*is_sec_1_1 + delta_alpha_2*is_sec_1_2, delta_alpha_2*is_sec_2_1 + delta_alpha_3*is_sec_2_2, delta_alpha_3*is_sec_3_1 + delta_alpha_4*is_sec_3_2];

Cl_v_1 = transpose([(perfil_structure(aviao.perfil(1)).obj_cl(alpha_eff_1(is_sec_1_temp),Re(is_sec_1_temp))-delta_Cl_1).*is_sec_1_2 + (perfil_structure(aviao.perfil(2)).obj_cl(alpha_eff_1(is_sec_1_temp),Re(is_sec_1_temp))-delta_Cl_2).*is_sec_1_1, ...
    (perfil_structure(aviao.perfil(2)).obj_cl(alpha_eff_1(is_sec_2_temp),Re(is_sec_2_temp))-delta_Cl_2).*is_sec_2_2 + (perfil_structure(aviao.perfil(3)).obj_cl(alpha_eff_1(is_sec_2_temp),Re(is_sec_2_temp))-delta_Cl_3).*is_sec_2_1,...
    (perfil_structure(aviao.perfil(3)).obj_cl(alpha_eff_1(is_sec_3_temp),Re(is_sec_3_temp))-delta_Cl_3).*is_sec_3_2 + (perfil_structure(aviao.perfil(4)).obj_cl(alpha_eff_1(is_sec_3_temp),Re(is_sec_3_temp))-delta_Cl_4).*is_sec_3_1]);

% Cl_v_2 = transpose([perfil_structure(aviao.perfil(1)).obj_cl(alpha_eff_2(is_sec_1_temp),Re(is_sec_1_temp)).*is_sec_1_2 + perfil_structure(aviao.perfil(2)).obj_cl(alpha_eff_2(is_sec_1_temp),Re(is_sec_1_temp)).*is_sec_1_1, ...
%     perfil_structure(aviao.perfil(2)).obj_cl(alpha_eff_2(is_sec_2_temp),Re(is_sec_2_temp)).*is_sec_2_2 + perfil_structure(aviao.perfil(3)).obj_cl(alpha_eff_2(is_sec_2_temp),Re(is_sec_2_temp)).*is_sec_2_1,...
%     perfil_structure(aviao.perfil(3)).obj_cl(alpha_eff_2(is_sec_3_temp),Re(is_sec_3_temp)).*is_sec_3_2 + perfil_structure(aviao.perfil(4)).obj_cl(alpha_eff_2(is_sec_3_temp),Re(is_sec_3_temp)).*is_sec_3_1]);

Cl_v_2 = transpose([(perfil_structure(aviao.perfil(1)).obj_cl(alpha_eff_2(is_sec_1_temp),Re(is_sec_1_temp))-delta_Cl_1).*is_sec_1_2 + (perfil_structure(aviao.perfil(2)).obj_cl(alpha_eff_2(is_sec_1_temp),Re(is_sec_1_temp))-delta_Cl_2).*is_sec_1_1, ...
    (perfil_structure(aviao.perfil(2)).obj_cl(alpha_eff_2(is_sec_2_temp),Re(is_sec_2_temp))-delta_Cl_2).*is_sec_2_2 + (perfil_structure(aviao.perfil(3)).obj_cl(alpha_eff_2(is_sec_2_temp),Re(is_sec_2_temp))-delta_Cl_3).*is_sec_2_1,...
    (perfil_structure(aviao.perfil(3)).obj_cl(alpha_eff_2(is_sec_3_temp),Re(is_sec_3_temp))-delta_Cl_3).*is_sec_3_2 + (perfil_structure(aviao.perfil(4)).obj_cl(alpha_eff_2(is_sec_3_temp),Re(is_sec_3_temp))-delta_Cl_4).*is_sec_3_1]);

alcor(1).delta_alpha = alcor(1).delta_alpha + (Cl_v_1-coef_alpha(1).Cl)./Cl_alpha;
alcor(2).delta_alpha = alcor(2).delta_alpha + (Cl_v_2-coef_alpha(2).Cl)./Cl_alpha;

infl_ALCOR = AERO_RHS_ALCOR(run,geom_painel, infl_ALCOR, alcor); 

coef_alpha = AERO_SECOMP (run,geom(1),geom_malha,geom_painel,infl_ALCOR);
resd = max([abs(coef_alpha(1).Cl-Cl_v_1);abs(coef_alpha(2).Cl-Cl_v_2)]);
iter = iter+1;
end
% iter
CL = [coef_alpha(1).CL; coef_alpha(2).CL];
CM = [coef_alpha(1).CM; coef_alpha(2).CM];
% CL_1 = coef_alpha(1).CL; 
% CL_2 = coef_alpha(2).CL;



