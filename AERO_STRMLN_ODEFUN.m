function [dy] = AERO_STRMLN_ODEFUN (t,p0,run,geom_painel,infl)
disp(t)
p0 = reshape(p0,3,[]);
CPX = repmat(p0(1,:),length(geom_painel.C1X),1);
CPY = repmat(p0(2,:),length(geom_painel.C1X),1);
CPZ = repmat(p0(3,:),length(geom_painel.C1X),1);

CPX_w = repmat(p0(1,:),sum(geom_painel.is_TE),1);
CPY_w = repmat(p0(2,:),sum(geom_painel.is_TE),1);
CPZ_w = repmat(p0(3,:),sum(geom_painel.is_TE),1);

C1X = repmat(geom_painel.C1X,1,length(p0));
C2X = repmat(geom_painel.C2X,1,length(p0));
C3X = repmat(geom_painel.C3X,1,length(p0));
C4X = repmat(geom_painel.C4X,1,length(p0));
C1Y = repmat(geom_painel.C1Y,1,length(p0));
C2Y = repmat(geom_painel.C2Y,1,length(p0));
C3Y = repmat(geom_painel.C3Y,1,length(p0));
C4Y = repmat(geom_painel.C4Y,1,length(p0));
C1Z = repmat(geom_painel.C1Z,1,length(p0));
C2Z = repmat(geom_painel.C2Z,1,length(p0));
C3Z = repmat(geom_painel.C3Z,1,length(p0));
C4Z = repmat(geom_painel.C4Z,1,length(p0));
is_TE = logical(repmat(geom_painel.is_TE,1,length(p0)));
FAR_DIST = zeros(size(CPZ_w))+200;

[u1,v1,w1]=aero_vortex_line(CPX,CPY,CPZ,C1X,C1Y,C1Z,C2X,C2Y,C2Z);
[u2,v2,w2]=aero_vortex_line(CPX,CPY,CPZ,C2X,C2Y,C2Z,C3X,C3Y,C3Z);
[u3,v3,w3]=aero_vortex_line(CPX,CPY,CPZ,C3X,C3Y,C3Z,C4X,C4Y,C4Z);
[u4,v4,w4]=aero_vortex_line(CPX,CPY,CPZ,C4X,C4Y,C4Z,C1X,C1Y,C1Z);

u_surf = infl.gamma'*(u1 + u2 + u3 + u4); v_surf = infl.gamma'*(v1 + v2 + v3 + v4); w_surf = infl.gamma'*(w1 + w2 + w3 + w4);

[u1_w,v1_w,w1_w]=aero_vortex_line(CPX_w(:),CPY_w(:),CPZ_w(:),C4X(is_TE),C4Y(is_TE),C4Z(is_TE),C3X(is_TE),C3Y(is_TE),C3Z(is_TE));
[u2_w,v2_w,w2_w]=aero_vortex_line(CPX_w(:),CPY_w(:),CPZ_w(:),C3X(is_TE),C3Y(is_TE),C3Z(is_TE),FAR_DIST(:),C3Y(is_TE),C3Z(is_TE));
[u3_w,v3_w,w3_w]=aero_vortex_line(CPX_w(:),CPY_w(:),CPZ_w(:),FAR_DIST(:),C3Y(is_TE),C3Z(is_TE),FAR_DIST(:),C4Y(is_TE),C4Z(is_TE));
[u4_w,v4_w,w4_w]=aero_vortex_line(CPX_w(:),CPY_w(:),CPZ_w(:),FAR_DIST(:),C4Y(is_TE),C4Z(is_TE),C4X(is_TE),C4Y(is_TE),C4Z(is_TE));

u_wake = transpose(infl.gamma(logical(geom_painel.is_TE)))*reshape(u1_w + u2_w + u3_w + u4_w,[],length(p0));
v_wake = transpose(infl.gamma(logical(geom_painel.is_TE)))*reshape(v1_w + v2_w + v3_w + v4_w,[],length(p0));
w_wake = transpose(infl.gamma(logical(geom_painel.is_TE)))*reshape(w1_w + w2_w + w3_w + w4_w,[],length(p0));

dy = [run.Q*cosd(run.alpha)+u_surf+u_wake; v_surf+v_wake; run.Q*sind(run.alpha)+w_surf+w_wake]; dy=dy(:);
end