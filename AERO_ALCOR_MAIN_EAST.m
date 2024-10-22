function [CL,CARGAS_PACK] = AERO_ALCOR_MAIN_EAST(alpha_var, run, geom, geom_malha, geom_painel, infl_ALCOR,coef_zero_g, perfil_structure, aviao)
alpha_var;
% load('Reta');
% aviao.perfil(:) = 10;
% geom.S = geom.S/2;

% CL_store = []; alpha_store = [];
% alpha_list = -5:.5:20;
% for i=1:length(alpha_list)
% alpha_var = alpha_list(i);
run.alpha = alpha_var;
infl = AERO_RHS(run,geom_painel,infl_ALCOR);
coef_alpha_0 = AERO_SECOMP (run,geom(1),geom_malha,geom_painel,infl);
alcor(1).delta_alpha = zeros(size([coef_alpha_0(1).Cl]));
alcor(2).delta_alpha = zeros(size([coef_alpha_0(2).Cl]));
d_alpha = 0;
CPY = coef_zero_g(1).c_y;

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
Re = 400e3*ones(size(Re));

% delta_Cl_1 = 0.3* max(perfil_structure(aviao.perfil(1)).obj_cl.Values);
% delta_Cl_2 = 0.3* max(perfil_structure(aviao.perfil(2)).obj_cl.Values);
% delta_Cl_3 = 0.3* max(perfil_structure(aviao.perfil(3)).obj_cl.Values);
% delta_Cl_4 = 0.3* max(perfil_structure(aviao.perfil(4)).obj_cl.Values);
delta_Cl_1 = 0;
delta_Cl_2 = 0;
delta_Cl_3 = 0;
delta_Cl_4 = 0;

% delta_alpha_1 = delta_Cl_1 / mean(perfil_structure(aviao.perfil(1)).obj_cl_alpha(Re(is_sec_1_temp)));
% delta_alpha_2 = delta_Cl_2 / mean(perfil_structure(aviao.perfil(2)).obj_cl_alpha(Re(is_sec_2_temp)));
% delta_alpha_3 = delta_Cl_3 / mean(perfil_structure(aviao.perfil(3)).obj_cl_alpha(Re(is_sec_3_temp)));
% delta_alpha_4 = delta_Cl_4 / mean(perfil_structure(aviao.perfil(4)).obj_cl_alpha(Re(is_sec_3_temp)));

Cl0 = transpose([perfil_structure(aviao.perfil(1)).Cl_0(Re(is_sec_1_temp)).*is_sec_1_2 + perfil_structure(aviao.perfil(2)).Cl_0(Re(is_sec_1_temp)).*is_sec_1_1, ...
    perfil_structure(aviao.perfil(2)).Cl_0(Re(is_sec_2_temp)).*is_sec_2_2 + perfil_structure(aviao.perfil(3)).Cl_0(Re(is_sec_2_temp)).*is_sec_2_1,...
    perfil_structure(aviao.perfil(3)).Cl_0(Re(is_sec_3_temp)).*is_sec_3_2 + perfil_structure(aviao.perfil(4)).Cl_0(Re(is_sec_3_temp)).*is_sec_3_1]);
% Cl0 = transpose([perfil_structure(aviao.perfil(1)).obj_cl0(Re(is_sec_1_temp)).*is_sec_1_2 + perfil_structure(aviao.perfil(2)).obj_cl0(Re(is_sec_1_temp)).*is_sec_1_1, ...
%     perfil_structure(aviao.perfil(2)).obj_cl0(Re(is_sec_2_temp)).*is_sec_2_2 + perfil_structure(aviao.perfil(3)).obj_cl0(Re(is_sec_2_temp)).*is_sec_2_1,...
%     perfil_structure(aviao.perfil(3)).obj_cl0(Re(is_sec_3_temp)).*is_sec_3_2 + perfil_structure(aviao.perfil(4)).obj_cl0(Re(is_sec_3_temp)).*is_sec_3_1]);
% 
Cl_alpha = transpose([perfil_structure(aviao.perfil(1)).Cl_alpha(Re(is_sec_1_temp)).*is_sec_1_2 + perfil_structure(aviao.perfil(2)).Cl_alpha(Re(is_sec_1_temp)).*is_sec_1_1, ...
    perfil_structure(aviao.perfil(2)).Cl_alpha(Re(is_sec_2_temp)).*is_sec_2_2 + perfil_structure(aviao.perfil(3)).Cl_alpha(Re(is_sec_2_temp)).*is_sec_2_1,...
    perfil_structure(aviao.perfil(3)).Cl_alpha(Re(is_sec_3_temp)).*is_sec_3_2 + perfil_structure(aviao.perfil(4)).Cl_alpha(Re(is_sec_3_temp)).*is_sec_3_1]);
% Cl_alpha = transpose([perfil_structure(aviao.perfil(1)).obj_cl_alpha(Re(is_sec_1_temp)).*is_sec_1_2 + perfil_structure(aviao.perfil(2)).obj_cl_alpha(Re(is_sec_1_temp)).*is_sec_1_1, ...
%     perfil_structure(aviao.perfil(2)).obj_cl_alpha(Re(is_sec_2_temp)).*is_sec_2_2 + perfil_structure(aviao.perfil(3)).obj_cl_alpha(Re(is_sec_2_temp)).*is_sec_2_1,...
%     perfil_structure(aviao.perfil(3)).obj_cl_alpha(Re(is_sec_3_temp)).*is_sec_3_2 + perfil_structure(aviao.perfil(4)).obj_cl_alpha(Re(is_sec_3_temp)).*is_sec_3_1]);

alpha_eff_1 = transpose((coef_alpha_0(1).Cl - Cl0)./Cl_alpha); % + [delta_alpha_1*is_sec_1_1 + delta_alpha_2*is_sec_1_2, delta_alpha_2*is_sec_2_1 + delta_alpha_3*is_sec_2_2, delta_alpha_3*is_sec_3_1 + delta_alpha_4*is_sec_3_2];

Cl_v_1 = transpose([(perfil_structure(aviao.perfil(1)).CL_INTERP(alpha_eff_1(is_sec_1_temp),Re(is_sec_1_temp))-delta_Cl_1).*is_sec_1_2 + (perfil_structure(aviao.perfil(2)).CL_INTERP(alpha_eff_1(is_sec_1_temp),Re(is_sec_1_temp))-delta_Cl_2).*is_sec_1_1, ...
    (perfil_structure(aviao.perfil(2)).CL_INTERP(alpha_eff_1(is_sec_2_temp),Re(is_sec_2_temp))-delta_Cl_2).*is_sec_2_2 + (perfil_structure(aviao.perfil(3)).CL_INTERP(alpha_eff_1(is_sec_2_temp),Re(is_sec_2_temp))-delta_Cl_3).*is_sec_2_1,...
    (perfil_structure(aviao.perfil(3)).CL_INTERP(alpha_eff_1(is_sec_3_temp),Re(is_sec_3_temp))-delta_Cl_3).*is_sec_3_2 + (perfil_structure(aviao.perfil(4)).CL_INTERP(alpha_eff_1(is_sec_3_temp),Re(is_sec_3_temp))-delta_Cl_4).*is_sec_3_1]);
% Cl_v_1 = transpose([(perfil_structure(aviao.perfil(1)).obj_cl(alpha_eff_1(is_sec_1_temp),Re(is_sec_1_temp))-delta_Cl_1).*is_sec_1_2 + (perfil_structure(aviao.perfil(2)).obj_cl(alpha_eff_1(is_sec_1_temp),Re(is_sec_1_temp))-delta_Cl_2).*is_sec_1_1, ...
%     (perfil_structure(aviao.perfil(2)).obj_cl(alpha_eff_1(is_sec_2_temp),Re(is_sec_2_temp))-delta_Cl_2).*is_sec_2_2 + (perfil_structure(aviao.perfil(3)).obj_cl(alpha_eff_1(is_sec_2_temp),Re(is_sec_2_temp))-delta_Cl_3).*is_sec_2_1,...
%     (perfil_structure(aviao.perfil(3)).obj_cl(alpha_eff_1(is_sec_3_temp),Re(is_sec_3_temp))-delta_Cl_3).*is_sec_3_2 + (perfil_structure(aviao.perfil(4)).obj_cl(alpha_eff_1(is_sec_3_temp),Re(is_sec_3_temp))-delta_Cl_4).*is_sec_3_1]);

if any(alpha_eff_1<0)
    is_neg = alpha_eff_1<0;
    Cl_v_1(is_neg) = Cl0(is_neg) + Cl_alpha(is_neg) .* alpha_eff_1(is_neg)';
end
Cl_v_1(isnan(Cl_v_1)) = 0.5;

resd = max(abs(coef_alpha_0(1).Cl-Cl_v_1));
coef_alpha = coef_alpha_0; iter = 1;
while (resd>1e-3 && iter<300)
    alpha_eff_1 = transpose((coef_alpha(1).Cl - Cl0)./Cl_alpha -  alcor(1).delta_alpha);
    
    Cl_v_1 = transpose([perfil_structure(aviao.perfil(1)).CL_INTERP(alpha_eff_1(is_sec_1_temp),Re(is_sec_1_temp)).*is_sec_1_2 + perfil_structure(aviao.perfil(2)).CL_INTERP(alpha_eff_1(is_sec_1_temp),Re(is_sec_1_temp)).*is_sec_1_1, ...
        perfil_structure(aviao.perfil(2)).CL_INTERP(alpha_eff_1(is_sec_2_temp),Re(is_sec_2_temp)).*is_sec_2_2 + perfil_structure(aviao.perfil(3)).CL_INTERP(alpha_eff_1(is_sec_2_temp),Re(is_sec_2_temp)).*is_sec_2_1,...
        perfil_structure(aviao.perfil(3)).CL_INTERP(alpha_eff_1(is_sec_3_temp),Re(is_sec_3_temp)).*is_sec_3_2 + perfil_structure(aviao.perfil(4)).CL_INTERP(alpha_eff_1(is_sec_3_temp),Re(is_sec_3_temp)).*is_sec_3_1]);
%     Cl_v_1 = transpose([(perfil_structure(aviao.perfil(1)).obj_cl(alpha_eff_1(is_sec_1_temp),Re(is_sec_1_temp))-delta_Cl_1).*is_sec_1_2 + (perfil_structure(aviao.perfil(2)).obj_cl(alpha_eff_1(is_sec_1_temp),Re(is_sec_1_temp))-delta_Cl_2).*is_sec_1_1, ...
%         (perfil_structure(aviao.perfil(2)).obj_cl(alpha_eff_1(is_sec_2_temp),Re(is_sec_2_temp))-delta_Cl_2).*is_sec_2_2 + (perfil_structure(aviao.perfil(3)).obj_cl(alpha_eff_1(is_sec_2_temp),Re(is_sec_2_temp))-delta_Cl_3).*is_sec_2_1,...
%         (perfil_structure(aviao.perfil(3)).obj_cl(alpha_eff_1(is_sec_3_temp),Re(is_sec_3_temp))-delta_Cl_3).*is_sec_3_2 + (perfil_structure(aviao.perfil(4)).obj_cl(alpha_eff_1(is_sec_3_temp),Re(is_sec_3_temp))-delta_Cl_4).*is_sec_3_1]);

    if any(alpha_eff_1<0)
        is_neg = alpha_eff_1<0;
        Cl_v_1(is_neg) = Cl0(is_neg) + Cl_alpha(is_neg) .* alpha_eff_1(is_neg)';
    end
    Cl_v_1(isnan(Cl_v_1)) = 0.5;
    alcor(1).delta_alpha = alcor(1).delta_alpha + (Cl_v_1-coef_alpha(1).Cl)./Cl_alpha;
%     alcor(1).delta_alpha = (Cl_v_1-coef_alpha(1).Cl)./Cl_alpha;

    infl_ALCOR = AERO_RHS_ALCOR(run,geom_painel, infl_ALCOR, alcor); 
    coef_alpha = AERO_SECOMP (run,geom(1),geom_malha,geom_painel,infl_ALCOR);
    resd = max(abs(coef_alpha(1).Cl-Cl_v_1));
    iter = iter+1;
end
if iter == 900
    CL = 0
else
    CL = coef_alpha(end).CL;
    CARGAS_PACK.l = coef_alpha(1).l;
    CARGAS_PACK.CVX = coef_alpha(1).CVX;
    CARGAS_PACK.CVY = coef_alpha(1).CVY;
    CARGAS_PACK.Cl = coef_alpha(1).Cl;
    
end

% iter
% end
% plot(alpha_list,CL_store)
% grid
% alpha_var
% coef_alpha(end)