function AERO_POST_GEOM (geom_painel,geom_malha)
figure()
hold on
for i=1:length(geom_malha)
    surf(geom_malha(i).X,geom_malha(i).Y,geom_malha(i).Z,'Facecolor','interp','Facealpha',.6,'Edgealpha',.5);
end

for i=1:length(geom_painel.C1X)
    plot3([geom_painel.C1X(i),geom_painel.C2X(i),geom_painel.C3X(i),geom_painel.C4X(i),geom_painel.C1X(i)],[geom_painel.C1Y(i),geom_painel.C2Y(i),geom_painel.C3Y(i),geom_painel.C4Y(i),geom_painel.C1Y(i)],[geom_painel.C1Z(i),geom_painel.C2Z(i),geom_painel.C3Z(i),geom_painel.C4Z(i),geom_painel.C1Z(i)],'r');
end

plot3(geom_painel.CPX,geom_painel.CPY,geom_painel.CPZ,'.r','Markersize',12)

rho=.2;
quiver3(geom_painel.CPX,geom_painel.CPY,geom_painel.CPZ,geom_painel.NX,geom_painel.NY,geom_painel.NZ,rho)
hold off
axis equal
view(3)
grid;
drawnow
