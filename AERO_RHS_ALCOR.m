function infl = AERO_RHS_ALCOR(run,geom_painel, infl, alcor)
NX = geom_painel.NX; NY = geom_painel.NY; NZ = geom_painel.NZ;
for i = 1:2
    alpha_cor_1 = alcor(i).delta_alpha;
    NX_temp = geom_painel.NX(geom_painel.surf_idx==i); NZ_temp = geom_painel.NZ(geom_painel.surf_idx==i);
    v_ind_x = infl.v_ind_x; v_ind_y = infl.v_ind_y; v_ind_z = infl.v_ind_z;
    
    alpha_cor_1 = repmat(alpha_cor_1, 1,length(NX_temp)/length(alpha_cor_1)); alpha_cor_1 = deg2rad(alpha_cor_1(:));
    [teta,r] = cart2pol(NX_temp,NZ_temp);
    teta_2 = teta - alpha_cor_1;
    [NX_temp,NZ_temp] = pol2cart(teta_2,r);
    NX(geom_painel.surf_idx==i) = NX_temp; NZ(geom_painel.surf_idx==i) = NZ_temp; 
end
a_ind_x=v_ind_x.*NX;
a_ind_y=v_ind_y.*NY;
a_ind_z=v_ind_z.*NZ;

a_inf = a_ind_x + a_ind_y + a_ind_z;
infl.A = a_inf;

RHS_X=-run.Q*cosd(run.alpha)*cosd(run.beta)*NX;
RHS_Y=-run.Q*cosd(run.alpha)*sind(run.beta)*NY;
RHS_Z=-run.Q*sind(run.alpha)*NZ;
RHS=RHS_X+RHS_Y+RHS_Z;

gamma = a_inf\RHS;
% infl = inf;
infl.gamma = gamma;

end
