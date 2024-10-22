function [inf_out]=AERO_INF_VORING_V02 (run,geom_painel)

num_total=length(geom_painel.CPX);

%% Artifício para Vetorização

CPX=repmat(geom_painel.CPX,1,num_total);
CPY=repmat(geom_painel.CPY,1,num_total);
CPZ=repmat(geom_painel.CPZ,1,num_total);
NX=repmat(geom_painel.NX,1,num_total);
NY=repmat(geom_painel.NY,1,num_total);
NZ=repmat(geom_painel.NZ,1,num_total);

C1X=repmat(geom_painel.C1X',num_total,1);
C2X=repmat(geom_painel.C2X',num_total,1);
C3X=repmat(geom_painel.C3X',num_total,1);
C4X=repmat(geom_painel.C4X',num_total,1);
C1Y=repmat(geom_painel.C1Y',num_total,1);
C2Y=repmat(geom_painel.C2Y',num_total,1);
C3Y=repmat(geom_painel.C3Y',num_total,1);
C4Y=repmat(geom_painel.C4Y',num_total,1);
C1Z=repmat(geom_painel.C1Z',num_total,1);
C2Z=repmat(geom_painel.C2Z',num_total,1);
C3Z=repmat(geom_painel.C3Z',num_total,1);
C4Z=repmat(geom_painel.C4Z',num_total,1);

is_TE=logical(repmat(geom_painel.is_TE',num_total,1));
FAR_DIST=500*ones(sum(is_TE(:)),1);
[idx_TE_x,idx_TE_y]=ind2sub(size(is_TE),find(is_TE));
%% Velocidades Induzidas

[u1,v1,w1]=aero_vortex_line(CPX,CPY,CPZ,C1X,C1Y,C1Z,C2X,C2Y,C2Z);
[u2,v2,w2]=aero_vortex_line(CPX,CPY,CPZ,C2X,C2Y,C2Z,C3X,C3Y,C3Z);
[u3,v3,w3]=aero_vortex_line(CPX,CPY,CPZ,C3X,C3Y,C3Z,C4X,C4Y,C4Z);
[u4,v4,w4]=aero_vortex_line(CPX,CPY,CPZ,C4X,C4Y,C4Z,C1X,C1Y,C1Z);

u_ind_i = u1 + u2 + u3 + u4; v_ind_i = v1 + v2 + v3 + v4; w_ind_i = w1 + w2 + w3 + w4;
u_ind_w_i = u2 + u4; v_ind_w_i = v2 + v4; w_ind_w_i = w2 + w4;

[u1,v1,w1]=aero_vortex_line(CPX(is_TE),CPY(is_TE),CPZ(is_TE),C4X(is_TE),C4Y(is_TE),C4Z(is_TE),C3X(is_TE),C3Y(is_TE),C3Z(is_TE));
[u2,v2,w2]=aero_vortex_line(CPX(is_TE),CPY(is_TE),CPZ(is_TE),C3X(is_TE),C3Y(is_TE),C3Z(is_TE),FAR_DIST,C3Y(is_TE),C3Z(is_TE));
[u3,v3,w3]=aero_vortex_line(CPX(is_TE),CPY(is_TE),CPZ(is_TE),FAR_DIST,C3Y(is_TE),C3Z(is_TE),FAR_DIST,C4Y(is_TE),C4Z(is_TE));
[u4,v4,w4]=aero_vortex_line(CPX(is_TE),CPY(is_TE),CPZ(is_TE),FAR_DIST,C4Y(is_TE),C4Z(is_TE),C4X(is_TE),C4Y(is_TE),C4Z(is_TE));

u_ind_i_fwake = u1 + u2 + u3 + u4; v_ind_i_fwake = v1 + v2 + v3 + v4; w_ind_i_fwake = w1 + w2 + w3 + w4;
u_ind_w_i_fwake = u2 + u4; v_ind_w_i_fwake = v2 + v4; w_ind_w_i_fwake = w2 + w4;

if run.sym
    [u1,v1,w1]=aero_vortex_line(CPX,-CPY,CPZ,C1X,C1Y,C1Z,C2X,C2Y,C2Z);
    [u2,v2,w2]=aero_vortex_line(CPX,-CPY,CPZ,C2X,C2Y,C2Z,C3X,C3Y,C3Z);
    [u3,v3,w3]=aero_vortex_line(CPX,-CPY,CPZ,C3X,C3Y,C3Z,C4X,C4Y,C4Z);
    [u4,v4,w4]=aero_vortex_line(CPX,-CPY,CPZ,C4X,C4Y,C4Z,C1X,C1Y,C1Z);
    
    u_ind_i = u_ind_i + u1 + u2 + u3 + u4; 
    v_ind_i = v_ind_i - v1 - v2 - v3 - v4; 
    w_ind_i = w_ind_i + w1 + w2 + w3 + w4;
    
    u_ind_w_i = u_ind_w_i + u2 + u4; 
    v_ind_w_i = v_ind_w_i - v2 - v4; 
    w_ind_w_i = w_ind_w_i + w2 + w4;
    
    [u1,v1,w1]=aero_vortex_line(CPX(is_TE),-CPY(is_TE),CPZ(is_TE),C4X(is_TE),C4Y(is_TE),C4Z(is_TE),C3X(is_TE),C3Y(is_TE),C3Z(is_TE));
    [u2,v2,w2]=aero_vortex_line(CPX(is_TE),-CPY(is_TE),CPZ(is_TE),C3X(is_TE),C3Y(is_TE),C3Z(is_TE),FAR_DIST,C3Y(is_TE),C3Z(is_TE));
    [u3,v3,w3]=aero_vortex_line(CPX(is_TE),-CPY(is_TE),CPZ(is_TE),FAR_DIST,C3Y(is_TE),C3Z(is_TE),FAR_DIST,C4Y(is_TE),C4Z(is_TE));
    [u4,v4,w4]=aero_vortex_line(CPX(is_TE),-CPY(is_TE),CPZ(is_TE),FAR_DIST,C4Y(is_TE),C4Z(is_TE),C4X(is_TE),C4Y(is_TE),C4Z(is_TE));
    
    u_ind_i_fwake = u_ind_i_fwake + u1 + u2 + u3 + u4; 
    v_ind_i_fwake = v_ind_i_fwake - v1 - v2 - v3 - v4; 
    w_ind_i_fwake = w_ind_i_fwake + w1 + w2 + w3 + w4;
    
    u_ind_w_i_fwake = u_ind_w_i_fwake + u2 + u4; 
    v_ind_w_i_fwake = v_ind_w_i_fwake - v2 - v4; 
    w_ind_w_i_fwake = w_ind_w_i_fwake + w2 + w4;
end

if run.ground
    [u1,v1,w1]=aero_vortex_line(CPX,CPY,-CPZ,C1X,C1Y,C1Z,C2X,C2Y,C2Z);
    [u2,v2,w2]=aero_vortex_line(CPX,CPY,-CPZ,C2X,C2Y,C2Z,C3X,C3Y,C3Z);
    [u3,v3,w3]=aero_vortex_line(CPX,CPY,-CPZ,C3X,C3Y,C3Z,C4X,C4Y,C4Z);
    [u4,v4,w4]=aero_vortex_line(CPX,CPY,-CPZ,C4X,C4Y,C4Z,C1X,C1Y,C1Z);
    
    u_ind_i = u_ind_i + u1 + u2 + u3 + u4; 
    v_ind_i = v_ind_i + v1 + v2 + v3 + v4; 
    w_ind_i = w_ind_i - w1 - w2 - w3 - w4;
    
    u_ind_w_i = u_ind_w_i + u2 + u4; 
    v_ind_w_i = v_ind_w_i + v2 + v4; 
    w_ind_w_i = w_ind_w_i - w2 - w4;
    
    [u1,v1,w1]=aero_vortex_line(CPX(is_TE),CPY(is_TE),-CPZ(is_TE),C4X(is_TE),C4Y(is_TE),C4Z(is_TE),C3X(is_TE),C3Y(is_TE),C3Z(is_TE));
    [u2,v2,w2]=aero_vortex_line(CPX(is_TE),CPY(is_TE),-CPZ(is_TE),C3X(is_TE),C3Y(is_TE),C3Z(is_TE),FAR_DIST,C3Y(is_TE),C3Z(is_TE));
    [u3,v3,w3]=aero_vortex_line(CPX(is_TE),CPY(is_TE),-CPZ(is_TE),FAR_DIST,C3Y(is_TE),C3Z(is_TE),FAR_DIST,C4Y(is_TE),C4Z(is_TE));
    [u4,v4,w4]=aero_vortex_line(CPX(is_TE),CPY(is_TE),-CPZ(is_TE),FAR_DIST,C4Y(is_TE),C4Z(is_TE),C4X(is_TE),C4Y(is_TE),C4Z(is_TE));
    
    u_ind_i_fwake = u_ind_i_fwake + u1 + u2 + u3 + u4; 
    v_ind_i_fwake = v_ind_i_fwake + v1 + v2 + v3 + v4; 
    w_ind_i_fwake = w_ind_i_fwake - w1 - w2 - w3 - w4;
    
    u_ind_w_i_fwake = u_ind_w_i_fwake + u2 + u4; 
    v_ind_w_i_fwake = v_ind_w_i_fwake + v2 + v4; 
    w_ind_w_i_fwake = w_ind_w_i_fwake - w2 - w4;
end

if (run.sym && run.ground)
    [u1,v1,w1]=aero_vortex_line(CPX,-CPY,-CPZ,C1X,C1Y,C1Z,C2X,C2Y,C2Z);
    [u2,v2,w2]=aero_vortex_line(CPX,-CPY,-CPZ,C2X,C2Y,C2Z,C3X,C3Y,C3Z);
    [u3,v3,w3]=aero_vortex_line(CPX,-CPY,-CPZ,C3X,C3Y,C3Z,C4X,C4Y,C4Z);
    [u4,v4,w4]=aero_vortex_line(CPX,-CPY,-CPZ,C4X,C4Y,C4Z,C1X,C1Y,C1Z);
    
    u_ind_i = u_ind_i + u1 + u2 + u3 + u4; 
    v_ind_i = v_ind_i - v1 - v2 - v3 - v4; 
    w_ind_i = w_ind_i - w1 - w2 - w3 - w4;
    
    u_ind_w_i = u_ind_w_i + u2 + u4; 
    v_ind_w_i = v_ind_w_i - v2 - v4; 
    w_ind_w_i = w_ind_w_i - w2 - w4;
    
    [u1,v1,w1]=aero_vortex_line(CPX(is_TE),-CPY(is_TE),-CPZ(is_TE),C4X(is_TE),C4Y(is_TE),C4Z(is_TE),C3X(is_TE),C3Y(is_TE),C3Z(is_TE));
    [u2,v2,w2]=aero_vortex_line(CPX(is_TE),-CPY(is_TE),-CPZ(is_TE),C3X(is_TE),C3Y(is_TE),C3Z(is_TE),FAR_DIST,C3Y(is_TE),C3Z(is_TE));
    [u3,v3,w3]=aero_vortex_line(CPX(is_TE),-CPY(is_TE),-CPZ(is_TE),FAR_DIST,C3Y(is_TE),C3Z(is_TE),FAR_DIST,C4Y(is_TE),C4Z(is_TE));
    [u4,v4,w4]=aero_vortex_line(CPX(is_TE),-CPY(is_TE),-CPZ(is_TE),FAR_DIST,C4Y(is_TE),C4Z(is_TE),C4X(is_TE),C4Y(is_TE),C4Z(is_TE));
    
    u_ind_i_fwake = u_ind_i_fwake + u1 + u2 + u3 + u4; 
    v_ind_i_fwake = v_ind_i_fwake - v1 - v2 - v3 - v4; 
    w_ind_i_fwake = w_ind_i_fwake - w1 - w2 - w3 - w4;
    
    u_ind_w_i_fwake = u_ind_w_i_fwake + u2 + u4; 
    v_ind_w_i_fwake = v_ind_w_i_fwake - v2 - v4; 
    w_ind_w_i_fwake = w_ind_w_i_fwake - w2 - w4;
end

%%
v_ind_x=(u_ind_i+sparse(idx_TE_x,idx_TE_y,u_ind_i_fwake));
v_ind_y=(v_ind_i+sparse(idx_TE_x,idx_TE_y,v_ind_i_fwake));
v_ind_z=(w_ind_i+sparse(idx_TE_x,idx_TE_y,w_ind_i_fwake));

a_inf = v_ind_x.*NX + v_ind_y.*NY + v_ind_z.*NZ;

v_ind_x_w=(u_ind_w_i+sparse(idx_TE_x,idx_TE_y,u_ind_w_i_fwake));
v_ind_y_w=(v_ind_w_i+sparse(idx_TE_x,idx_TE_y,v_ind_w_i_fwake));
v_ind_z_w=(w_ind_w_i+sparse(idx_TE_x,idx_TE_y,w_ind_w_i_fwake));

b_inf = v_ind_x_w.*NX + v_ind_y_w.*NY + v_ind_z_w.*NZ;

inf_out.A = a_inf;
inf_out.B = b_inf;
inf_out.B_H = [];
inf_out.v_ind_x = v_ind_x;
inf_out.v_ind_y = v_ind_y;
inf_out.v_ind_z = v_ind_z;
