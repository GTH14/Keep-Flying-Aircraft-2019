function [estab] = estab_Derivadas_de_estabilidade_laterod(aviao, const, estab)
    %Coeficientes laterodirecionais estão dados em relação ao eixo do vento,
    %logo não necessita de conversão para o eixo do corpo.

    %parametro importantes
    %aceleração da gravidade [m/s^2]
%     g = const.g;
    %massa total do avião [kg]
%     m = aviao.MTOW;
    %Velocidade do avião (eixo x do vento) [m/s]
    V = aviao.V_cruz;
    %Densidade do ar [kg/m³]
    rho = const.rho;
    %Informações geométricas e aerodinâmicas da asa (ou avião)
    %Envergadura [m]
%     b = aviao.b;
    %b_sec = aviao.b_sec;     %vetor com as envrgaduras das seções
    %Area [m^2]
    S = aviao.S;
    %AR da asa
    AR = aviao.AR;

    %eficiencia
    e = aviao.oswald;
    
    %% enflechamento no quarto de corda da asa[°]
    enf = aviao.l;
    
    c = aviao.c;
    y = aviao.y;
    %Corda média aerodinâmica [m]
    mac = aviao.MAC;
    %% Dados aerodinamicos
    %Coeficiente de sustentação para ângulo de ataque nulo
    CL0 = aviao.CL_0;
    %Derivada do coeficiente de sustentação em relação ao ângulo de ataque
    %[1/rad]
    CL_alfa = aviao.CL_alfa;

    %Coeficiente de arrasto para ângulo de ataque nulo
%     CD0 = aviao.CD_0;

    %Coeficiente de momento para ângulo de ataque nulo
    %CM0 = aviao.Cm_zero;
    %Derivada do coeficiente de momento em relação ao ângulo de ataque [1/rad]
%     CM_alfa = aviao.CM_alfa;
    
    %% Dados do profundor
    %deflexão do profundor para acondição analsada [°] 
    delta = 0;
    delta = delta/57.3;
    %Derivada do coefieiciente de arrasto em relação à deflexão do profundor [1/rad]
%     CD_N = 0;  %Nota: Saber se está admensionalizado em relação à area da asa
    %Derivada do coeficiente de sustentação em relação à deflexão do profundor [1/rad]
    CL_N = 0; %Idem
    %Derivadado coeficiente de momento em relação à deflexão do profundor [1/rad]
%     Cm_N = 0;
    
    %%
    %ângulo de ataque de trimagem [rad]
    alfa_trim = aviao.alfa_trim_motor;
    %Ângulo de atitude de trimagem [rad]
%     theta = alfa_trim; %quando o ângulo de trajetória, gama, é igual a zero, pois gama = theta - alfa

    %% Coeficientes de cada asa ao longo da envergadura
    cl_alfa_y = aviao.Cl_alfa;
    cl_0_y = aviao.Cl_0;
    %CD_alfay_w1 = aviao.cd_alfa_y1;
    %CD_alfay_w2 = aviao.cd_alfa_y2;
    cd_0_y = aviao.Cd_0;
    c_y = aviao.c_y;
    b = aviao.b;
    %% Coeficiente de sustentação em cruzeiro de cada asa
    CL = CL0 + CL_alfa*alfa_trim + CL_N*delta; 
    cl_y = cl_0_y + cl_alfa_y*alfa_trim;

    %% Coeficiente de arrasto em cruzeiro
    %CD = CD0 + CD_alfa*alfa_trim + CD_N*delta;
%     CD = CD0 + (CL^2)/(pi*e*AR) + CD_N*delta;
%     CD_alfa = 2*CL*CL_alfa/(pi*e*AR);
    cd_alfa_y = 2*cl_y.*cl_alfa_y./(pi*e*AR);
    cd_y = cd_0_y + cl_y.^2/(pi*e*AR);
    
    %% calculo do enflechamento ponderado (enflechamento medio)
    vet_b = aviao.b_sec;
    sweep_pond = vet_b.*enf;
    sweep_pond = sum(sweep_pond)/(0.5*b);
    
    %% Dados do leme e aileron
    %derivada do lift em relação à deflexão do aileron e leme
%     CL_a = 0;
%     %Derivada do arrasto em relação à deflexão do aileron
%     CD_a = 0;

    %% Momênto de inercia do avião em relação ao eixo do corpo [kgm²] e conversão
    %para o eixo do vento
    Ixz = aviao.ixz;
    Iz = aviao.iz;
    Ix = aviao.ix;
    Ix = Ix*cos(alfa_trim)^2 + Iz*sin(alfa_trim)^2 - 2*Ixz*sin(alfa_trim)*cos(alfa_trim);
    Iz = Iz*cos(alfa_trim)^2 + Ix*sin(alfa_trim)^2 - 2*Ixz*sin(alfa_trim)*cos(alfa_trim);
    Ixz = Ixz*(cos(alfa_trim)^2 - sin(alfa_trim)^2)+(Ix-Iz)*sin(alfa_trim)*cos(alfa_trim);
    estab.Iz = Iz;
    estab.Ix = Ix;
    estab.Ixz = Ixz;

    %% Yv - Dy/dV é a derivada da força lateral em relação à velocidade de
    %sideslip (derrapagem). Os principais efeitos são dados pela asa, fuselagem
    %e pela EV. O método dado está no livro HOAK (Datcom). Contribuição das duas asas
    Cy_beta_w = CL^2*(6*tand(sweep_pond)*sind(sweep_pond)/(pi*AR*(AR+4*cosd(sweep_pond))));% -0.0001*57.3*diedro_pond1; %Yv = 0.5*rho*V*(-2*1.5*Sb - Sv*CL_alfa_v - 0.00573*abs(diedro));
    Cyv = Cy_beta_w*V;
    Yv_ev = 0.5*rho*V*aviao.S_EV*aviao.CL_alfa_EV;
    Yv = 0.5*rho*V*S*Cyv + Yv_ev;

    %% Lv - dL/dV é a derivada do momento lateral em relação à velocidade de
    %sideslip. Considera contribuições do diedro, enflechamento e leme. O
    %efeito da posição da asa não foi considerado.
    %-parcela dada pelo diedro: Notar que é uma integral e que no caso da asa
    %ter mais de uma sessão, deverá ser resolvida por intervalos
    %integral_1 = (C(y)*CL_alfa_w*diedro*y*dy)[0,b/2] sendo os valores no colchete
    %o intervalo da integral

    %-parcela dada pelo enflechamento: outra integral dada por integral_2 =
    %(cy*ydy)[0,b/2]    
    
    integral = 0;
    d = aviao.d;
    j = 2;
    fim_de_secao = zeros(1, length(c));
    for i = 1:length(c_y)
       if (c_y(i) <= c(j))
           fim_de_secao(j - 1) = i;
           j = j + 1;
       end
    end
    fim_de_secao = [1 fim_de_secao];
    for i = 1:length(vet_b)
        [indices] = fim_de_secao(i):fim_de_secao(i + 1);
        integral = integral + d(i)*trapz(y(indices), c_y(indices)*cl_alfa_y(indices)*y(indices));
    end
    Lv_diedro = -rho*V*integral;

    integral = 0;
    fim_de_secao = aviao.fim_de_secao;
    for i = 1:length(vet_b)
        [indices] = fim_de_secao(i):fim_de_secao(i + 1);
        integral = integral + d(i)*trapz(y(indices), c_y(indices)*cl_y(indices)*y(indices)*tand(enf(i)));
    end
    Lv_sweep = -2*rho*V*integral;
    
    Lv_ev = -0.5*rho*V*aviao.S_ev*aviao.CL_alfa_ev*aviao.zv;
    
    Lv = Lv_sweep + Lv_diedro + Lv_ev;
    
    %% Nv - dN/dv é a derivada do momento direcional em relação à velocidade de
    %sideslip. O Cook considera somente efeitos da EV. Mas parâmetros como
    %diedro, enflechamento e variação do arrasto lateral ao longo do corpo
    %podem ser importantes, dependendo da geometria. Vamos considerar o método
    %do HOAK
  
    Cn_beta_w = CL_w1*CL_w1*(1/(4*pi*AR) -(tand(sweep_pond)/(pi*AR*(AR + 4*cosd(sweep_pond))))*(cosd(sweep_pond) - AR/2-AR^2/(8*cosd(sweep_pond))+6*x1*sind(sweep_pond/(mac*AR))));
    Cn_beta = aviao.Cn_beta + Cn_beta_w;
    Cnv = Cn_beta*V;
    Nv = 0.5*rho*V*S*b*(Cnv);

    %% Yp - dY/dp é a derivada da força lateral em relação à taxa de rolagem.
    %Pode ser negligível caso a EV não tenha um AR muito elevado. O COOK
    %considera somente o efeito da EV. Usaremos o método do HOAK, que apresenta
    %umas fomulas bizarras e uns gráficos. Analisando-os, foi possível obter a
    %aproximação de que Cyp =~ 0,1*CL.
    Cyp = 0.1*CL; %Yp (admensional do COOK ) = cYP/2
    Yp = 0.25*rho*V*S*b*Cyp;

    %% Lp - dL/dp é a derivada do momento lateral em relação à taxa de
    %rolagem. Considera somente o efeito da asa. MÉTODO COOK
    %integral_4 = (C(y)*y²dy)[0,b/2]

    aux = trapz(y,(cl_alfa_y + cd_y_).*c_y1.*y.*y);
    Lp = -rho*V*aux;

    %% Np - dN/dp é a derivada do momento de guinada em relação à taxa de
    %rolagem. Considera novamente só o efeito da asa, pois efeitos do leme só
    %ocorrem quando este é muito grande.
    aux = trapz(y,(cl_y + cd_alfa_y).*c_y.*y.*y);

    Np = -rho*V*aux;

    %% Yr - dY/dr é a derivada da força lateral em relação à taxa de guinada.
    %Considera-se somente o efeito da EV, e pode ser negligível caso seja
    %pequeno.

    Yr = 0.5*rho*V*aviao.S_ev*aviao.lv*aviao.CL_alfa_ev;

    %% Lr - dL/dr é a derivada do momento lateral em relação à taxa de guinada.
    %contribuição da asa, devido a diferença nas velocidades do lado direito e
    %esquerdo causado pela guinada.
    aux = trapz(y, c_y.*cl_y.*y1.*y1);
    Lr = 2*rho*V*aux;
    Lr = Lr + 0.5*rho*V*aviao.S_ev*aviao.lv*aviao.zv*aviao.CL_alfa_ev;

    %% Nr - dN/dr é a derivada do momento direcional em relação à taxa de
    %guinada. As contribuições consideradas são da asa e da EV.

    aux = trapz(y,c_y.*cd_y.*y.*y);
    Nr = -2*rho*V*aux + Yr*aviao.lv;

    
    %% Derivadas de controle: aileron e leme.
    %aileron, terá o subscrito a e leme o subscrito l 

    %Ya - dY/da é a derivada da força lateral em rel à def do aileron
    %Efeito neglígivel
    Ya = 0;

    %La - dL/da é a derivada do momento lateral em rel à def do aileron
    %integral_5 = (C(y)*y*dy)[y1,y2] sendo y1 e y2 as posições na envergadura
    %onde começa e acaba o aileron
    La = 0;

    %Na - dN/da é a derivada do momento direcional em rel à def do aileron

    Na = 0;

    %Os efeitos da EV são influenciados pela fuselagem e pela EH. Como o COOK
    %desconsidera estes efeitos, as aproximações dadas abaixo não são muito
    %boas. Talvez seja interessante procurar outra metodologia de calculo.

    %Yl- dY/dl é a derivada da força lateral em rel à def do leme

    Yl = 0;%0.5*rho*V^2*Sv*CL_l;

    %Ll - dL/dl é a derivada do momento Lateral em rel à def do leme

    Ll = 0; %0.5*rho*V^2*Sv*CL_l*h_v;

    %Nl - dN/dl é a derivada do momento direcional em rel à def do leme

    Nl = 0; %-0.5*rho*V^2*Sv*lv*CL_l;

    estab.Yv = Yv;
    estab.Lv = Lv;
    estab.Nv = Nv;
    estab.Yp = Yp;
    estab.Lp = Lp;
    estab.Np = Np;
    estab.Yr = Yr;
    estab.Lr = Lr;
    estab.Nr = Nr;
    estab.Ya = Ya;
    estab.La = La;
    estab.Na = Na;
    estab.Yl = Yl;
    estab.Ll = Ll;
    estab.Nl = Nl;
end