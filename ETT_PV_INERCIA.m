function [x_sem,pv,xmotor,Ix,Iz,Iy,Ixz,zcg,z_motor] = ETT_PV_INERCIA(aviao, perfil_structure,perfil_asa, area_perfilEV,area_perfilEH,c,b,BAl,l,area_perfilasa,m_long,x_long,y_long,z_long,r_long, const)
%calculo do pv, da posição do motor e de momentos de inércia
xCG = aviao.xCG;
b_EV = aviao.bv;
c_EH_root = aviao.c_EH(1);
c_EH_1 = aviao.c_EH(2);
c_EH_2 = aviao.c_EH(3);
c_EV_root = aviao.cv_root;
c_EV_final = c_EV_root;
b_EH1 = aviao.b_sec_EH(1);
b_EH2 = aviao.b_sec_EH(2);
d_BF_BA_x = aviao.d_BF_BA_x;
d_BF_BA_z = aviao.d_BF_BA_z;
m_adesivos = 0.15;
h_EV = aviao.zv + aviao.h_BA;
h_asa = aviao.h_BA;
h_EH = h_asa + d_BF_BA_z;
m_motor = 0.8;
Ix = 0;
Iy = 0;
Iz = 0;
Ixz = 0;
Knerv = 0;
KBF = 0;
KBA = 0;
m_BF = 0;
m_BA = 0;
m_nerv = 0;
dd = 0;                                                                     %distância entre o bordo de ataque da c_raiz e do bordo de ataque do fim da seção atual
da = 0;                                                                     %distância entre o bordo de ataque da c_raiz e do bordo de ataque do fim da seção anterior
enverg_ant = 0;
x_BA_ant = 0;
%% ASA

for j = 1:1:length(c)-1                                                     %percorre a asa
  if j == 1
      x = 3;
  else
      x = 1;
  end
  t = 2*perfil_structure(perfil_asa(j)).maxt_x;
 
  l_BF = atand((b(j)*tand(BAl(j))+c(j+1) - c(j))/b(j));
  m_nervx = 0;
  Nn = ceil((b(j))/0.14);
  dd = dd + tand(BAl(j))*b(j)*cosd(l(j));
  for i = x:1:Nn                                                            %nervuras da sessao j
      Cn = c(j)-((c(j)-c(j+1))*(i-1)/Nn);                                   %corda da nervura n
      m_capstripen = (const.dens_balsa)*0.001*0.006*2.1*Cn;
      m_nervn = 0.7*(const.dens_balsa)*0.003*area_perfilasa(j)*Cn^2 + m_capstripen;
      m_nervx = m_nervx + 2*m_nervn;
      Hn = Cn*t;
      z_nervn = h_asa ;
      y_nervn = (b(j)/Nn) * (i-1) + enverg_ant ;
      x_nervn = ((dd-da)*(i-1)/Nn) + 0.4*Cn;
      Inx = m_nervn*(0.003^2+Hn^2)/12;
      Inz = m_nervn*((3/5)*(((0.4*Cn)^2 + 0.003^2)/12 + (0.2*Cn)^2)+(2/5)*(((0.6*Cn)^2 + 0.003^2)/12 + (0.3*Cn)^2));
      Iny = m_nervn*((3/5)*(((0.4*Cn)^2 + Hn^2)/12 + (0.2*Cn)^2)+(2/5)*(((0.6*Cn)^2 + Hn^2)/12 + (0.3*Cn)^2));
      Ix = Ix + 2*(Inx + m_nervn*(y_nervn^2 + z_nervn^2));
      Iy = Iy + 2*(Iny + m_nervn*(x_nervn^2 + z_nervn^2));
      Iz = Iz + 2*(Inz + m_nervn*(x_nervn^2 + y_nervn^2));
      Ixz = Ixz + 2*x_nervn*z_nervn*m_nervn;
  end
Knerv = Knerv + m_nervx*((((dd-da)/2) + da) + 0.4*((c(j)+c(j+1)/2)));       %soma parcial pra calcular o x_nervura
da = dd;
m_nerv = m_nerv + m_nervx;
m_BFn = 2*(const.dens_balsa)*0.001*0.04*b(j)/cosd(l_BF);                    %BF da sessao j
x_BF =(b(j)*cosd(l(j))*tand(l_BF)+c(j+1) - c(j))/2 + c(1);
y_BF = b(j)/2 + enverg_ant;
z_BF = h_asa;
Iz = Iz + (m_BFn*(x_BF^2+y_BF^2) + m_BFn*(0.04^2+(b(j)/cosd(l_BF))^2)/12);
Ix = Ix + (m_BFn*(z_BF^2+y_BF^2) + m_BFn*(0.002^2 + b(j)^2)/12);
Iy = Iy + (m_BFn*(z_BF^2+x_BF^2) + m_BFn*(0.04^2 + 0.002^2)/12);
KBF = KBF + 2*m_BFn*x_BF;
m_BF = m_BF + 2*m_BFn;
m_BAn = 2*(const.dens_balsa)*0.001*0.216*((c(j)+c(j+1))/2)*b(j)*cosd(l(j))/cosd(BAl(j)); %BA da sessao j
x_BA =(tand(BAl(j))*b(j)*cosd(l(j))/2)+x_BA_ant;
y_BA = b(j)/2 + enverg_ant;
z_BA = h_asa;
Iz = Iz + (m_BAn*(x_BA^2+y_BA^2) + m_BAn*((1/4)*(((c(j)+c(j+1))/2)*t)^2+(b(j)^2)/12));
Ix = Ix + (m_BAn*(z_BA^2+y_BA^2) + m_BAn*((1/4)*(((c(j)+c(j+1))/2)*t)^2+(b(j)^2)/12));
Iy = Iy + (m_BAn*(z_BA^2+x_BA^2) + m_BAn*((((c(j)+c(j+1))/2)*t)^2)/2);
KBA = KBA + 2*m_BAn*x_BA;
m_BA = m_BA + 2*m_BAn;
x_BA_ant = x_BA;
enverg_ant = b(j);
end
m_n0 = (const.dens_divinycell*6/1000 + 2*const.dens_carbono*0.5/1000)*(c(1)*0.8508*area_perfilasa(j));
x_n0 = -0.3;
y_n0 = 0;
z_n0 = h_asa + c(1)*t/2;
Ix = Ix + m_n0*(0.001^2+(c(1)*t)^2)/12 + m_n0*(y_n0^2 + z_n0^2);
Iy = Iy + m_n0*((3/5)*(((0.4*c(1))^2 + (t*c(1))^2)/12 + (0.2*c(1))^2)+(2/5)*(((0.6*c(1))^2 + (t*c(1))^2)/12 + (0.3*c(1))^2)) + m_n0*(x_n0^2 + z_n0^2);
Iz = Iz + m_n0*((3/5)*(((0.4*c(1))^2 + 0.001^2)/12 + (0.2*c(1))^2)+(2/5)*(((0.6*c(1))^2 + 0.001^2)/12 + (0.3*c(1))^2)) + m_n0*(x_n0^2 + z_n0^2);
Ixz = Ixz + x_n0*z_n0*m_n0;
m_n1 = 2*0.7*(const.dens_divinycell*6/1000 + 2*const.dens_carbono*0.25/1000)*(c(1)*area_perfilasa(j));
x_n1 = 0.4*c(1);
y_n1 = b(1)/Nn;
z_n1 = h_asa;
Ix = Ix + m_n1*(0.001^2+(c(1)*t)^2)/12 + m_n1*(y_n1^2 + z_n1^2);
Iy = Iy + m_n1*((3/5)*(((0.4*c(1))^2 + (t*c(1))^2)/12 + (0.2*c(1))^2)+(2/5)*(((0.6*c(1))^2 + (t*c(1))^2)/12 + (0.3*c(1))^2)) + m_n1*(x_n1^2 + z_n1^2);
Iz = Iz + m_n1*((3/5)*(((0.4*c(1))^2 + 0.001^2)/12 + (0.2*c(1))^2)+(2/5)*(((0.6*c(1))^2 + 0.001^2)/12 + (0.3*c(1))^2)) + m_n1*(x_n1^2 + z_n1^2);
Ixz = Ixz + x_n1*z_n1*m_n1;

Iz = Iz + m_long*(x_long^2+y_long^2) + (m_long*r_long^2)/2 + (m_long*(sum(b))^2)/12;
Ix = Ix + m_long*(z_long^2+y_long^2) + (m_long*r_long^2)/2 + (m_long*(sum(b))^2)/12;
Iy = Iy + m_long*(z_long^2+x_long^2) + m_long*r_long^2;

m_tp = 2*(((const.dens_divinycell)*0.003 + 2*const.dens_carbono*0.00075)*(1/2)*(2*r_long+0.02)*(h_asa+r_long-((const.D_rodinhas)/2)));
x_tp = xCG+0.025;
y_tp = 0.125;
z_tp = const.D_rodinhas/2 + (2/3)*(h_asa+r_long-((const.D_rodinhas)/2));
Iz = Iz + m_tp*(x_tp^2+y_tp^2) + (m_tp*(h_asa+r_long-((const.D_rodinhas)/2))^2/18)/2;
Ix = Ix + m_tp*(y_tp^2+z_tp^2) + (m_tp*(h_asa+r_long-((const.D_rodinhas)/2))^2/18)/2;
Iy = Iy + m_tp*(x_tp^2+z_tp^2) + m_tp*(h_asa+r_long-((const.D_rodinhas)/2))^2/18;

m_rodas_princip = (0.050)*((const.D_rodinhas/0.105)^2);
x_rodas_princip = xCG+0.025;
y_rodas_princip = 0.125;
z_rodas_princip = const.D_rodinhas/2;
Iz = Iz + 2*m_rodas_princip*(x_rodas_princip^2+y_rodas_princip^2) + (m_rodas_princip*(const.D_rodinhas/2)^2)/2;
Ix = Ix + 2*m_rodas_princip*(z_rodas_princip^2+y_rodas_princip^2) + (m_rodas_princip*(const.D_rodinhas/2)^2)/2;
Iy = Iy + 2*m_rodas_princip*(z_rodas_princip^2+x_rodas_princip^2) + m_rodas_princip*(const.D_rodinhas/2)^2;
Ixz = Ixz + x_rodas_princip*z_rodas_princip*2*m_rodas_princip;
   
m_rodas_beq = (0.050)*((const.D_rodinhas/0.105)^2);
x_rodas_beq = 0.040;
y_rodas_beq = 0;
z_rodas_beq = const.D_rodinhas/2;
Iz = Iz + m_rodas_beq*(x_rodas_beq^2+y_rodas_beq^2) + (m_rodas_beq*(const.D_rodinhas/2)^2)/4;
Ix = Ix + m_rodas_beq*(z_rodas_beq^2+y_rodas_beq^2) + (m_rodas_beq*(const.D_rodinhas/2)^2)/4;
Iy = Iy + m_rodas_beq*(z_rodas_beq^2+x_rodas_beq^2) + (m_rodas_beq*(const.D_rodinhas/2)^2)/2;
Ixz = Ixz + x_rodas_beq*z_rodas_beq*m_rodas_beq;

m_beq = 0.035;

x_tail = c(1)+d_BF_BA_x*0.5;
y_tail = 0;
z_tail = (h_asa + h_EH)/2;
r_tail = (9/16)*0.0254;
m_tail = sqrt((d_BF_BA_x + c(1)/2)^2 + (h_EH-h_asa)^2)*2*pi*r_tail*(0.5/1000)*const.dens_carbono;
Iz = Iz + m_tail*(x_tail^2+y_tail^2) + (m_tail*r_tail^2)/2 + m_tail*(d_BF_BA_x^2 + (h_EH-h_asa)^2)/12;
Ix = Ix + m_tail*(z_tail^2+y_tail^2) + m_tail*r_tail^2;
Iy = Iy + m_tail*(z_tail^2+x_tail^2) + (m_tail*r_tail^2)/2 + m_tail*(d_BF_BA_x^2 + (h_EH-h_asa)^2)/12;

m_ASA = m_nerv + m_n0 + m_n1 + m_BF + m_BA + m_tp + m_long + m_beq + m_tail;
%% Empenagem Horizontal

NnEH1 = ceil((b_EH1)/0.05);                                                %calcula a sessao 1 da EH
m_nervEH1 = 0;
for i = 1:1:NnEH1                                                           %nervuras da sessao 1 EH
   Cn = c_EH_root-((c_EH_root-c_EH_1)*i/NnEH1);                             %corda da nervura n
   m_capstripen = (const.dens_balsa)*0.001*0.006*2.1*Cn;
   m_nervn = (const.dens_balsa)*0.003*area_perfilEH(1)*Cn^2 + m_capstripen;
   m_nervEH1 = m_nervEH1 + m_nervn;
   Hn = Cn*t;
   z_nervn = h_EH;
   y_nervn = (b_EH1/NnEH1)*i;
   x_nervn = c(1) + d_BF_BA_x + 0.4*Cn;
   Inx = m_nervn*(0.003^2+Hn^2)/12;
   Inz = m_nervn*((3/5)*(((0.4*Cn)^2 + 0.003^2)/12 + (0.2*Cn)^2)+(2/5)*(((0.6*Cn)^2 + 0.003^2)/12 + (0.3*Cn)^2));
   Iny = m_nervn*((3/5)*(((0.4*Cn)^2 + Hn^2)/12 + (0.2*Cn)^2)+(2/5)*(((0.6*Cn)^2 + Hn^2)/12 + (0.3*Cn)^2));
   Ix = Ix + 2*(Inx + m_nervn*(y_nervn^2 + z_nervn^2));
   Iy = Iy + 2*(Iny + m_nervn*(x_nervn^2 + z_nervn^2));
   Iz = Iz + 2*(Inz + m_nervn*(x_nervn^2 + y_nervn^2));
   Ixz = Ixz + 2*(x_nervn*z_nervn*m_nervn);
end
m_BFEH1 = 2*(const.dens_balsa)*0.002*0.02*b_EH1;  
x_BFEH1 = c(1) + d_BF_BA_x + (c_EH_root+c_EH_1)/2;
y_BFEH1 = b_EH1/2;
z_BFEH1 = h_EH;
Iz = Iz + m_BFEH1*(x_BFEH1^2+y_BFEH1^2) + m_BFEH1*(0.04^2+b_EH1^2)/12;
Ix = Ix + m_BFEH1*(z_BFEH1^2+y_BFEH1^2) + m_BFEH1*(0.002^2 + b_EH1^2)/12;
Iy = Iy + m_BFEH1*(z_BFEH1^2+x_BFEH1^2) + m_BFEH1*(0.04^2 + 0.002^2)/12;
Ixz = Ixz + m_BFEH1*x_BFEH1*z_BFEH1;
m_BAEH1 = 2*(const.dens_balsa)*0.002*0.216*((c_EH_root+c_EH_1)/2)*b_EH1;
x_BAEH1 =c(j) + d_BF_BA_x;
y_BAEH1 = b_EH1/2 ;
z_BAEH1 = h_EH;
Iz = Iz + (m_BAEH1*(x_BAEH1^2+y_BAEH1^2) + m_BAEH1*((1/4)*(((c_EH_root+c_EH_1)/2)*t)^2+(b_EH1^2)/12));
Ix = Ix + (m_BAEH1*(z_BAEH1^2+y_BAEH1^2) + m_BAEH1*((1/4)*(((c_EH_root+c_EH_1)/2)*t)^2+(b_EH1^2)/12));
Iy = Iy + (m_BAEH1*(z_BAEH1^2+x_BAEH1^2) + m_BAEH1*((((c_EH_root+c_EH_1)/2)*t)^2)/2);
Ixz = Ixz + m_BAEH1*x_BAEH1*z_BAEH1;

NnEH2 = ceil((b_EH1)/0.05);                                                %calcula a sessao 2 da EH
m_nervEH2 = 0;
for i = 1:1:NnEH2  %nervuras da sessao 2 EH
   Cn = c_EH_1-((c_EH_1-c_EH_2)*i/NnEH2);
   m_capstripen = (const.dens_balsa)*0.001*0.006*2.1*Cn;
   m_nervn = (const.dens_balsa)*0.003*area_perfilEH(2)*Cn^2 + m_capstripen;
   m_nervEH2 = m_nervEH2 + m_nervn;
   Hn = Cn*t;
   z_nervn = h_EH;
   y_nervn = b_EH1 + (b_EH2/NnEH2)*i;
   x_nervn = c(1) + d_BF_BA_x + 0.4*Cn;
   Inx = m_nervn*(0.003^2+Hn^2)/12;
   Inz = m_nervn*((3/5)*(((0.4*Cn)^2 + 0.003^2)/12 + (0.2*Cn)^2)+(2/5)*(((0.6*Cn)^2 + 0.003^2)/12 + (0.3*Cn)^2));
   Iny = m_nervn*((3/5)*(((0.4*Cn)^2 + Hn^2)/12 + (0.2*Cn)^2)+(2/5)*(((0.6*Cn)^2 + Hn^2)/12 + (0.3*Cn)^2));
   Ix = Ix + 2*(Inx + m_nervn*(y_nervn^2 + z_nervn^2));
   Iy = Iy + 2*(Iny + m_nervn*(x_nervn^2 + z_nervn^2));
   Iz = Iz + 2*(Inz + m_nervn*(x_nervn^2 + y_nervn^2));
   Ixz = Ixz + 2*(x_nervn*z_nervn*m_nervn);
end
m_BFEH2 = 2*(const.dens_balsa)*0.002*0.02*b_EH2;  
x_BFEH2 = c(1) + d_BF_BA_x + (c_EH_1+c_EH_2)/2;
y_BFEH2 = b_EH1 + (b_EH1+b_EH2)/2;
z_BFEH2 = h_EH;
Iz = Iz + m_BFEH2*(x_BFEH2^2+y_BFEH2^2) + m_BFEH2*(0.04^2+b_EH2^2)/12;
Ix = Ix + m_BFEH2*(z_BFEH2^2+y_BFEH2^2) + m_BFEH2*(0.002^2 + b_EH2^2)/12;
Iy = Iy + m_BFEH2*(z_BFEH2^2+x_BFEH2^2) + m_BFEH2*(0.04^2 + 0.002^2)/12;
Ixz = Ixz + m_BFEH2*x_BFEH2*z_BFEH2;
m_BAEH2 = 2*(const.dens_balsa)*0.002*0.216*((c_EH_1+c_EH_2)/2)*b_EH2;
x_BAEH2 =c(1) + d_BF_BA_x;
y_BAEH2 = b_EH1/2 ;
z_BAEH2 = h_EH;
Iz = Iz + (m_BAEH2*(x_BAEH2^2+y_BAEH2^2) + m_BAEH2*((1/4)*(((c_EH_2+c_EH_1)/2)*t)^2+(b_EH2^2)/12));
Ix = Ix + (m_BAEH2*(z_BAEH2^2+y_BAEH2^2) + m_BAEH2*((1/4)*(((c_EH_2+c_EH_1)/2)*t)^2+(b_EH2^2)/12));
Iy = Iy + (m_BAEH2*(z_BAEH2^2+x_BAEH2^2) + m_BAEH2*((((c_EH_2+c_EH_1)/2)*t)^2)/2);
Ixz = Ixz + m_BAEH2*x_BAEH2*z_BAEH2;

m_EH = 2*(m_nervEH1 + m_nervEH2 + m_BFEH1 + m_BFEH2 + m_BAEH1 + m_BAEH2);
%% Empenagem Vertical

NnEV = ceil((b_EV)/.05);                                                  %calcula a EV
m_nervEV = 0;
for i = 1:1:NnEV                                                            %nervuras da sessao EV
   Cn = c_EV_root-((c_EV_root-c_EV_final)*i/NnEV);
   m_capstripen = (const.dens_balsa)*0.001*0.006*2.1*Cn;
   m_nervn = 0.7*(const.dens_balsa)*0.003*area_perfilEV*Cn + m_capstripen;
   m_nervEV = m_nervEV + m_nervn;
   Hn = Cn*t;
   z_nervn = h_EV + (b_EV/NnEV)*i;
   y_nervn = 0;
   x_nervn = c(1) + d_BF_BA_x - Cn + 0.4*Cn;
   Inx = m_nervn*(0.003^2+Hn^2)/12;
   Inz = m_nervn*((3/5)*(((0.4*Cn)^2 + 0.003^2)/12 + (0.2*Cn)^2)+(2/5)*(((0.6*Cn)^2 + 0.003^2)/12 + (0.3*Cn)^2));
   Iny = m_nervn*((3/5)*(((0.4*Cn)^2 + Hn^2)/12 + (0.2*Cn)^2)+(2/5)*(((0.6*Cn)^2 + Hn^2)/12 + (0.3*Cn)^2));
   Ix = Ix + 2*(Inx + m_nervn*(y_nervn^2 + z_nervn^2));
   Iy = Iy + 2*(Iny + m_nervn*(x_nervn^2 + z_nervn^2));
   Iz = Iz + 2*(Inz + m_nervn*(x_nervn^2 + y_nervn^2));
   Ixz = Ixz + 2*(x_nervn*z_nervn*m_nervn);
end
m_BFEV = 2*(const.dens_balsa)*0.002*0.02*b_EV;  
x_BFEV = c(1)+ d_BF_BA_x;
y_BFEV = 0;
z_BFEV = h_EV + b_EV/2;
Iz = Iz + m_BFEV*(x_BFEV^2+y_BFEV^2) + m_BFEV*(0.04^2+b_EV^2)/12;
Ix = Ix + m_BFEV*(z_BFEV^2+y_BFEV^2) + m_BFEV*(0.002^2 + b_EV^2)/12;
Iy = Iy + m_BFEV*(z_BFEV^2+x_BFEV^2) + m_BFEV*(0.04^2 + 0.002^2)/12;
Ixz = Ixz + m_BFEV*x_BFEV*z_BFEV;
m_BAEV = 2*(const.dens_balsa)*0.002*0.216*((c_EV_root+c_EV_final)/2)*b_EV;
x_BAEV =c(1) + d_BF_BA_x - c_EV_root;
y_BAEV = 0 ;
z_BAEV = h_EV + b_EV/2;
Iz = Iz + (m_BAEV*(x_BAEV^2+y_BAEV^2) + m_BAEV*(((c_EV_root+c_EV_final)/2*t)^2)/2);
Ix = Ix + (m_BAEV*(z_BAEV^2+y_BAEV^2) + m_BAEV*((1/4)*(((c_EV_root+c_EV_final)/2)*t)^2+(b_EV^2)/12));
Iy = Iy + (m_BAEV*(z_BAEV^2+x_BAEV^2) + m_BAEV*((1/4)*(((c_EV_root+c_EV_final)/2)*t)^2+(b_EV^2)/12));
Ixz = Ixz + m_BAEV*x_BAEV*z_BAEV;
m_nervEV = m_nervEV  +  2*(const.dens_ent)*(b_EV*(c_EV_root+c_EV_final)/2);
m_EV = m_nervEV + m_BFEV + m_BAEV ;

x_nerv = Knerv/m_nerv;
x_BF = KBF/m_BF;
x_BA = KBA/m_BA;
z_nerv = h_asa;
m_eletrica = 0.2277;

x_ASA = ( m_BF*x_BF + m_BA*x_BA + m_long*x_long + m_tail*x_tail + m_tp*x_rodas_princip + m_beq*x_rodas_beq + m_nerv*x_nerv + m_n0*x_n0 + m_n1*x_n1 )/m_ASA;
%x_ASA = c(1)/4;
z_ASA = ( m_BF*z_BF + m_BA*z_BA + m_long*z_long + m_tail*z_tail + m_tp*z_rodas_princip + m_beq*z_rodas_beq + m_nerv*z_nerv + m_n0*z_n0 + m_n1*z_n1 )/m_ASA;
x_nervEH1 = c(1) + d_BF_BA_x + 0.4*(c_EH_root+c_EH_2)/2;
x_nervEH2 = c(1) + d_BF_BA_x + 0.4*(c_EH_root+c_EH_2)/2;
x_EH = 2*(x_BFEH1*m_BFEH1 + x_BAEH1*m_BAEH1 + x_nervEH1*m_nervEH1 + x_BFEH2*m_BFEH2 + x_BAEH2*m_BAEH2 + x_nervEH2*m_nervEH2)/m_EH;
z_EH = (z_BFEH1*m_BFEH1 + z_BAEH1*m_BAEH1 + h_EH*m_nervEH1 + h_EH*m_BFEH2 + z_BAEH2*m_BAEH2 + h_EH*m_nervEH2)/m_EH;
x_nervEV = c(1) + d_BF_BA_x - Cn + 0.4*Cn;
x_EV = (x_BFEV*m_BFEV + x_BAEV*m_BAEV + x_nervEV*m_nervEV)/m_EV;
z_EV = (z_BFEV*m_BFEV + z_BAEV*m_BAEV + z_BAEV*m_nervEV)/m_EV;
p = m_ASA + m_EH + 2*m_EV + m_rodas_beq + 2*m_rodas_princip + m_eletrica;
zcg = (z_rodas_beq*m_rodas_beq + z_rodas_princip*m_rodas_princip + z_EV*m_EV + z_EH*m_EH + z_ASA*m_ASA )/p;
x_sem = (x_rodas_beq*m_rodas_beq + 2*x_rodas_princip*m_rodas_princip + x_EV*m_EV + 2*x_EH*m_EH + x_ASA*m_ASA + (3*x_tail/4)*m_eletrica)/p;
pv = p + m_motor + const.m_tanque + m_adesivos;                             %PESO VAZIO FINAL DO AVIÃO
%xmotor = (xCG - p*x_sem)/(m_motor + const.m_tanque + const.m_helice);
%xmotor = (pv*xCG - ( x_BF*m_BF + x_BA*m_BA  + x_nerv*m_nerv + x_tp*m_tp + x_rodas_princip*m_rodas_princip*2 + x_tail*m_tail + x_long*m_long + x_EV*m_EV + x_EH*m_EH))/(m_motor+const.m_tanque+const.m_helice+m_beq+m_n0+m_rodas_beq);
xmotor = (xCG*(m_motor + const.m_tanque + const.m_helice + p) - p*x_sem)/(m_motor + const.m_tanque + const.m_helice);
Iz = Iz + (m_motor + const.m_tanque + const.m_helice)*(xmotor^2);
Ix = Ix + (m_motor + const.m_tanque + const.m_helice)*(zcg^2);
Iy = Iy + (m_motor + const.m_tanque + const.m_helice)*(xmotor^2 + zcg^2);
Ixz = Ixz - pv*xCG*h_asa; 
Iz = Iz - pv*xCG^2;
Ix = Ix - pv*h_asa^2;
Iy = Iy - pv*(xCG^2+h_asa^2);
Ixz = Ixz - pv*xCG*h_asa; 

if zcg > 0.1651
    aviao.z_motor = zcg;
else
    aviao.z_motor = 0.1651;
zcg = (z_rodas_beq*m_rodas_beq + z_rodas_princip*m_rodas_princip + z_EV*m_EV + z_EH*m_EH + z_ASA*m_ASA + aviao.z_motor*(m_motor + const.m_tanque + const.m_helice))/(p*(m_motor + const.m_tanque + const.m_helice));
end