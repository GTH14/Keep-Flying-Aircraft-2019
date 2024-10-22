function [alpha_stall, CL_max,CARGAS_PACK] = AERO_CLMAX_EAST(run, geom, geom_malha, geom_painel, inf_alpha0, coef_zero, coef_alpha, aviao, perfil_structure)
CL_alpha_tail = (coef_alpha(2).CL - coef_zero(2).CL)/coef_alpha(2).alpha;
fun = @(alpha_var) -AERO_ALCOR_MAIN_EAST(alpha_var, run, geom, geom_malha, geom_painel, inf_alpha0, coef_zero, perfil_structure, aviao) + CL_alpha_tail*alpha_var;
options = optimset('TolX',1e-1);
alpha_stall = fminbnd(fun,0,15,options);
[CL , CARGAS_PACK] = AERO_ALCOR_MAIN_EAST(alpha_stall, run, geom, geom_malha, geom_painel, inf_alpha0, coef_zero, perfil_structure, aviao);
CL_max = .95* CL - CL_alpha_tail*alpha_stall;

end