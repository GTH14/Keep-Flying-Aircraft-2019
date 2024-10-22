function [f] = AeroAchaxCP(x,run,SM_obj,geom,geom_malha,geom_painel,inf_alpha_alter,inf_alpha0)
%% Calcula os coeficientes com alpha 0

run.xCG = x;
run.alpha = 0;
coef_alpha0 = AERO_SECOMP_Genetico (run,geom,geom_malha,geom_painel,inf_alpha0);

%% Calcula os coeficientes com alpha alterado sem efeito solo

run.alpha = 1;
coef_alpha_alter = AERO_SECOMP_Genetico (run,geom,geom_malha,geom_painel,inf_alpha_alter);


CM0=coef_alpha0(end).CM;
CM_alt = coef_alpha_alter(end).CM;
CL0=coef_alpha0(end).CL;
CL_alt = coef_alpha_alter(end).CL;

CM_alfa = (CM_alt-CM0)/run.alpha;
CL_alfa = (CL_alt-CL0)/run.alpha;
SM_calc = -100*CM_alfa/CL_alfa; 

f = SM_calc-SM_obj;


end

