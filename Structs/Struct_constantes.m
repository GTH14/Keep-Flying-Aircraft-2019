%% Cria struct constantes
const = struct;
%% Estabelece as constantes
const.D_tp = 0.11;              %[m] Diametro da roda do trem de pouso
const.D_bq = 0.11;              %[m] Diametro da roda da bequilha
const.rho = 1.1170;             %[kg/m^3] Massa especifica do Ar
const.visc = 1.846 * 1e-5;      %[Pa*s] Viscosidade dinamica do ar
const.pista = 60;               %[m] Comprimento da pista
const.mi = 0.1;                 %[-] Coeficiente de atrito da pista
const.gama_limite = 3;          %[°] Angulo de subida mínimo
const.massa_minima = 7;         %[kg] MTOW minimo aceito
const.g = 9.8;                  %[m/s^2] Aceleracao da gravidade
const.e_rodas = 8e-3;           %[m] Espessura das rodinhas do trem de pouso e bequilha
const.d_motor = .2;				%[m] Distancia em x fixa do eixo do motor ate o BA (com folga)
const.n_max = 2.5;              %[-] Fator de carga maximo

const.x_motor = 0.16;           %[m] Distancia (em x) que o motor ocupa
const.D_helice = 13*0.0254;     %[m] Diametro da helice
const.dist_helice_chao = 0.03;  %[m] Minima distancia da helice ao chÃ£o

const.d_carga = 7870*0.7;       %[kg/m^3] Densidade da carga
const.y_max_comp = 0.7;         %[m] Tamanho máximo em Y do compartimento de carga
const.z_min_comp = 0.05;        %[m] Tamanho mínimo em Z do compartimento de carga

%% Massas e Inercia %%
const.m_carga = 18;             %[kg] Massa fixa de carga
const.m_lastro = 6;             %[kg] Massa fixa de lastro
const.m_motor = 731e-3;         %[kg] Massa do motor OS 61
const.m_tanque = 30e-3;         %[kg] Massa do tanque de combustivel
const.m_helice = 50e-3;         %[kg] Massa da helice