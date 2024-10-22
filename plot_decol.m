function  plot_decol( salva, t_rolagem, t_decolagem )
t = salva(:,1);
x = salva(:,2);
vx = salva(:,3);
L = salva(:,8);
D = salva(:,9);
N_tp = salva(:,4);
N_beq = salva(:,5);
R = salva(:,6);
de = salva(:,7);
T = salva(:,10);
W = salva(:,12);
z = salva(:,13);
vz = salva(:,14);
theta = salva(:,16);
vtheta = salva(:,17);
atheta = salva(:,18);
gama = salva(:,20);
alfa = salva(:,21);
v = salva(:,22);
L_z = salva(:,23);
D_z = salva(:,24);
L_x = salva(:,25);
D_x = salva(:,26);



figure;
plot(t,L_z,'k',t,D_z,'b',t,N_tp,'c',t,N_beq,'g',t,W,'r','LineWidth',2);
legend('Sustentação','Arrasto','Normal trem de pouso','Normal bequilha','Peso');
xlabel('Tempo [s]');
ylabel('Força vertical [N]');
%      line([t_rolagem t_rolagem],[-50 200],'LineWidth',0.5,'LineStyle','--')
%      line([t_decolagem t_decolagem],[-50 200,],'LineWidth',0.5,'LineStyle','-')
ax = gca;
ax.XTick = unique(unique(sort([0:1:12 t_rolagem t_decolagem])));
%ax.XTickLabel = {'0','1','2','3','4','5','6','7','8','t_R','t_{LO}'};
%ax.XTickLabelRotation = 45;
title('Forças verticais x tempo');
% xlim([0 t_decolagem])
grid;

figure;
plot(t,L_x,'k',t,D_x,'b',t,T,'m',t,R,'c','LineWidth',2);
legend('Sustentação','Arrasto','Tração', 'Atrito');
xlabel('Tempo [s]');
ylabel('Força horizontal [N]');
%      line([t_rolagem t_rolagem],[-10 50],'LineWidth',0.5,'LineStyle','--')
%      line([t_decolagem t_decolagem],[-10 50],'LineWidth',0.5,'LineStyle','-')
ax = gca;
ax.XTick = unique(sort([0:1:12 t_rolagem t_decolagem]));
%ax.XTickLabel = {'0','1','2','3','4','5','6','7','8','t_R','t_{LO}'};
title('Forças horizontais x tempo');
% xlim([0 t_decolagem])
grid;

figure;
plot(t,x,'b',t,-z,'m',t,theta,'c',t,gama,'g',t,alfa,'r',t,de,'LineWidth',2);
legend('x','z', 'teta','gama','alfa','Deflexão');
xlabel('Tempo [s]');
ylabel('Posição');
%      line([t_rolagem t_rolagem],[-5 50],'LineWidth',0.5,'LineStyle','--')
%      line([t_decolagem t_decolagem],[-5 50],'LineWidth',0.5,'LineStyle','-')
ax = gca;
ax.XTick = unique(sort([0:1:12 t_rolagem t_decolagem]));
%ax.XTickLabel = {'0','1','2','3','4','5','6','7','8','t_R','t_{LO}'};
title('Deslocamentos x tempo');
% xlim([0 t_decolagem])
grid;

figure;
plot(t,vx,'b',t,-vz,'m',t,vtheta,'c',t,v,'r','LineWidth',2);
legend('Vx','Vz', 'Vteta','V');
xlabel('Tempo [s]');
%     ylabel('Velocidades');
%      line([t_rolagem t_rolagem],[-5 20],'LineWidth',0.5,'LineStyle','--')
%      line([t_decolagem t_decolagem],[-5 20],'LineWidth',0.5,'LineStyle','-')
ax = gca;
ax.XTick = unique(sort([0:1:12 t_rolagem t_decolagem]));
%ax.XTickLabel = {'0','1','2','3','4','5','6','7','8','t_R','t_{LO}'};
title('Velocidades x tempo');
% xlim([0 t_decolagem])
grid;



end