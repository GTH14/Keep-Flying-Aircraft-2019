function coef = AERO_SECOMP_Genetico (run,geom,geom_malha,geom_painel,infl)
%c_root = geom_malha(1).chord; 
xCG = run.xCG;% xCG = reshape(linspace(c_root(1)*.2,c_root(1)*.4,5),1,1,[]);
B = infl.B; C = infl.gamma; W=B*C;% B_H = infl.B_H; W_H=B_H*C;
numel_old = 0;
CL_t = 0; CD_t = CL_t; CM_t = CL_t; CD_T_t = CL_t;
len = 2;
len_d = length(geom.died);
for i=1:len
    
    panels_b = sum(not(isnan(diff(geom_malha(i).X(1,:))))); panels_c = length(geom_malha(i).X(:,1))-1;
    numel_ac = numel_old + panels_b*panels_c;
    
    V_STRGH=reshape(C(numel_old+1:numel_ac),panels_b,panels_c); V_STRGH=V_STRGH';
    DELTA_V_STRGH=[V_STRGH(1,:);diff(V_STRGH)];
    dy=diff(geom_malha(i).Y(1:panels_c,:),1,2); dy(isnan(dy))=[]; dy=reshape(dy,panels_c,panels_b);
%     if i==3
%         dy=diff(geom_malha(i).Z(1:panels_c,:),1,2); dy(isnan(dy))=[]; dy=reshape(abs(dy),panels_c,panels_b);
%     end
%% correção diedro, não mexer ainda
% panels_b_3=round(b_w*fb1*fb2/b_w*panels_b_w);   % número de paineis da direção da envergadura na seção 3
% panels_b_2=round(((b_w*fb1*(1-fb2))*panels_b_w)/b_w); % número de paineis da direção da envergadura na seção 2
% panels_b_1=panels_b_w-panels_b_2-panels_b_3; % número de paineis da direção da envergadura na seção 1
% d_eff_L=[cosd(l1)*cosd(diedro_1)*ones(panels_b_1,panels_c_w);cosd(l2)*cosd(diedro_2)*ones(panels_b_2,panels_c_w);cosd(l3)*cosd(diedro_3)*ones(panels_b_3,panels_c_w)]';
%   diedro_eff = cosd(d(i))*ones(panels_c,panels_b);

%% correção diedro
    coeff_died = [];
    if i == 1
        for j = 1:len_d
            coeff_died_aux = cosd(geom.died(j))*ones(geom.panels_c,geom.panels_b_sec(j));
            coeff_died = [coeff_died,coeff_died_aux];
        end
%         DELTA_V_STRGH = coeff_died.*DELTA_V_STRGH;


    end
    if i == 2
        coeff_died = 1;
    end

    L=DELTA_V_STRGH.*dy*run.rho*run.Q;
    l=DELTA_V_STRGH*run.rho*run.Q;
    CL=sum(sum(coeff_died.*DELTA_V_STRGH.*dy/(.5*run.Q*geom.S)));
%     
%     if i==1
%     CL=sum(sum(DELTA_V_STRGH(:,2:end).*dy(:,2:end)/(.5*run.Q*geom.S)));
%     end
    w_ind=reshape(W(numel_old+1:numel_ac),panels_b,panels_c); w_ind=w_ind';
%     w_ind_h=reshape(W_H(numel_old+1:numel_ac),panels_b,panels_c); w_ind_h=w_ind_h';
    D=abs(run.rho*w_ind.*DELTA_V_STRGH.*dy);
    d=abs(run.rho*w_ind.*DELTA_V_STRGH);
    CD=sum(sum(-w_ind.*DELTA_V_STRGH.*dy/(.5*run.Q^2*geom.S)));
    CD_T = sum(-run.rho/2*V_STRGH(end,:).*w_ind(end,:).*dy(end,:))/(.5*run.rho*run.Q^2*geom.S); %FAR FIELD
    
    CVX=(geom_painel.C1X(numel_old+1:numel_ac)+geom_painel.C2X(numel_old+1:numel_ac))/2; CVX=reshape(CVX,panels_b,panels_c); CVX=repmat(CVX',1,1,length(xCG))-repmat(xCG,size(CVX,2),size(CVX,1),1);
    CVY=(geom_painel.C1Y(numel_old+1:numel_ac)+geom_painel.C2Y(numel_old+1:numel_ac))/2; CVY=reshape(CVY,panels_b,panels_c); CVY=CVY';
    CVZ=(geom_painel.C1Z(numel_old+1:numel_ac)+geom_painel.C2Z(numel_old+1:numel_ac))/2; CVZ=reshape(CVZ,panels_b,panels_c); CVZ=CVZ'-run.zCG;
    
%     [teta,r] = cart2pol(CVX,CVZ);
%     teta_2 = teta - deg2rad(run.alpha);
%     [CVX,CVZ] = pol2cart(teta_2,r);
    
    CM_L=-squeeze(sum(sum((CVX.*repmat(L,1,1,length(xCG)))/(.5*run.rho*run.Q^2*geom.S*geom.MAC))));
    CM_D=sum(sum(CVZ.*D))/(.5*run.rho*run.Q^2*geom.S*geom.MAC);
    CM = CM_L+repmat(CM_D,length(xCG),1);
    
    
    CR_lift = sum(sum(L))/(.5*run.rho*run.Q^2*geom.S*geom.MAC);
    
    
    %     Cm_L=-sum((CVX.*l))./(.5*run.rho*run.Q^2*geom_malha(i).chord*geom.MAC);
    %     Cm_D=sum(CVZ.*d)./(.5*run.rho*run.Q^2*geom_malha(i).chord*geom.MAC);
    %     Cm = Cm_L'+Cm_D';
    
    Cl = transpose(sum( l )./(.5*run.rho*run.Q^2*geom_malha(i).chord));
    Cd = transpose(sum( d )./(.5*run.rho*run.Q^2*geom_malha(i).chord));

    
%     CL = (run.sym+1) * CL; CD = (run.sym+1) * CD; CM = (run.sym+1) * CM;
%     if run.sym
%         L = [fliplr(L),L]; D = [fliplr(D), D]; Cl = [flipud(Cl);Cl];
%     end
    numel_old = numel_ac;
%     coef(i) = struct('CL',CL,'CD',CD,'CM',CM,'L',L,'D',D,'Cl',Cl);
    coef(i) = struct('alpha',run.alpha,'CL',CL,'CD',CD,'CD_T',CD_T,'CM',CM,'L',L,'D',D,'Cl',Cl,'Cd',Cd,'c_y',CVY(1,:));
    %coef(i).c_y = CVY;
    CL_t = CL_t + CL;
    CD_t = CD_t + CD;
    CD_T_t = CD_T_t + CD_T;
    CM_t = CM_t + CM;

end
% coef(i+1) = struct('CL',CL_t,'CD',CD_t,'CM',CM_t,'L',[],'D',[],'Cl',[]);
coef(i+1) = struct('alpha',run.alpha,'CL',CL_t,'CD',CD_t,'CD_T',CD_T_t,'CM',CM_t,'L',[],'D',[],'Cl',[],'Cd',[],'c_y',[]);
coef(i+1).CR_lift = CR_lift;
end