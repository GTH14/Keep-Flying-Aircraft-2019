function inf_out = AERO_RHS(run,geom_painel,inf)
RHS_X=-run.Q*cosd(run.alpha)*cosd(run.beta)*geom_painel.NX;
RHS_Y=-run.Q*cosd(run.alpha)*sind(run.beta)*geom_painel.NY;
RHS_Z=-run.Q*sind(run.alpha)*geom_painel.NZ;
RHS=RHS_X+RHS_Y+RHS_Z;

gamma = inf.A\RHS;
inf_out = inf;
inf_out.gamma = gamma;
end