function AERO_POST_RESULT (run, geom_malha, geom_painel, infl, coef)
k=size(geom_malha.X,1)-1;
p0=[geom_painel.CPX(geom_painel.i_idx==k);geom_painel.CPY(geom_painel.i_idx==k);geom_painel.CPZ(geom_painel.i_idx==k)];
p0=transpose(reshape(p0,[],3)); p0=p0(:);

strmln_fun = @(t,y) AERO_STRMLN_ODEFUN (t,y,run,geom_painel,infl);
options = odeset('RelTol',1e-3, 'AbsTol', 1e-3);
[t,y] = ode23(strmln_fun,[0,.015],p0,options);
%%
figure()
y_r=reshape(y,[],3,length(p0)/3);
for st=2:length(p0)/3-1
plot3(squeeze(y_r(:,1,st)),squeeze(y_r(:,2,st)),squeeze(y_r(:,3,st)),'r')
hold on
end
%%
% is_dirty = isnan( diff(geom_malha.X,1,2) );
% X_clean = geom_malha.X; X_clean(is_dirty)=[]; X_clean = reshape(X_clean,size(geom_malha.X,1),[]);
% Y_clean = geom_malha.Y; Y_clean(is_dirty)=[]; Y_clean = reshape(Y_clean,size(geom_malha.X,1),[]);
% Z_clean = geom_malha.Z; Z_clean(is_dirty)=[]; Z_clean = reshape(Z_clean,size(geom_malha.X,1),[]);

% C = interp3(reshape(geom_painel.CPX,panels_c,panels_b),reshape(geom_painel.CPY,panels_c,panels_b),reshape(geom_painel.CPZ,panels_c,panels_b),coef.L+coef.D,X_clean,Y_clean,Z_clean,'linear','extrap');
% C = interp3(reshape(geom_painel.CPX,panels_b,panels_c)',reshape(geom_painel.CPY,panels_b,panels_c)',reshape(geom_painel.CPZ,panels_b,panels_c)',coef.L+coef.D,X_clean,Y_clean,Z_clean,'spline');

% CPX = reshape(geom_painel.CPX,panels_b,panels_c)';
% CPY = reshape(geom_painel.CPY,panels_b,panels_c)';
% CPZ = reshape(geom_painel.CPZ,panels_b,panels_c)';

% CPX=CPX(:);
% CPY=CPY(:);
% CPZ=CPZ(:);
% C=coef.L(:)+coef.D(:); C=abs(C)/max(abs(C));
% for i=1: length(CPX)
%     plot3(CPX(i),CPY(i),CPZ(i),'.','Color',[C(i) C(i) 1],'markersize',15)
%     hold on
% end

% C = scatteredInterpolant(CPX(:),CPY(:),CPZ(:),coef.L(:)+coef.D(:),'natural');
% surf(geom_malha.X,geom_malha.Y,geom_malha.Z,C(geom_malha.X,geom_malha.Y,geom_malha.Z),'facecolor','interp')
% hold on
% plot3(geom_painel.CPX,geom_painel.CPY,geom_painel.CPZ,coef.L(:)+coef.D(:),'.','markersize',20);
panels_b = sum(not(isnan(diff(geom_malha.X(1,:)))));
panels_c = size(geom_malha.X,1)-1;
CP = (coef.L+coef.D)./ transpose(reshape( geom_painel.dA,panels_b, panels_c))/(.5*run.rho*run.Q^2);
surf(reshape(geom_painel.CPX,panels_b,panels_c)',reshape(geom_painel.CPY,panels_b,panels_c)',reshape(geom_painel.CPZ,panels_b,panels_c)',CP,'facecolor','interp','Edgecolor','none')
mesh(geom_malha.X,geom_malha.Y,geom_malha.Z,'facecolor','none')
hold off
colorbar
axis equal
grid;