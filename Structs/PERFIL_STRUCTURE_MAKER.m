clear; clc;

%%
perfil_structure(1).nome = 'KFVERAO_001';
perfil_structure(2).nome = 'KFVERAO_002';
perfil_structure(3).nome = 'KFVERAO_003';
perfil_structure(4).nome = 'KFVERAO_004';
perfil_structure(5).nome = 'KFVERAO_005';
perfil_structure(6).nome = 'KFVERAO_006';
perfil_structure(7).nome = 'KFVERAO_007';

%%
perfil_structure(1).pontos = perfil_import('KFVERAO_001.dat');
perfil_structure(2).pontos = perfil_import('KFVERAO_002.dat');
perfil_structure(3).pontos = perfil_import('KFVERAO_003.dat');
perfil_structure(4).pontos = perfil_import('KFVERAO_004.dat');
perfil_structure(5).pontos = perfil_import('KFVERAO_005.dat');
perfil_structure(6).pontos = perfil_import('KFVERAO_006.dat');
perfil_structure(7).pontos = perfil_import('KFVERAO_007.dat');

%%
perfil_structure(1).pontos_sup = perfil_structure(1).pontos(1:(length(perfil_structure(1).pontos))/2,1:2);
perfil_structure(2).pontos_sup = perfil_structure(2).pontos(1:(length(perfil_structure(2).pontos))/2,1:2);
perfil_structure(3).pontos_sup = perfil_structure(3).pontos(1:(length(perfil_structure(3).pontos))/2,1:2);
perfil_structure(4).pontos_sup = perfil_structure(4).pontos(1:(length(perfil_structure(4).pontos))/2,1:2);
perfil_structure(5).pontos_sup = perfil_structure(5).pontos(1:(length(perfil_structure(5).pontos))/2,1:2);
perfil_structure(6).pontos_sup = perfil_structure(6).pontos(1:(length(perfil_structure(6).pontos))/2,1:2);
perfil_structure(7).pontos_sup = perfil_structure(7).pontos(1:(length(perfil_structure(7).pontos))/2,1:2);

%%
perfil_structure(1).espessura = importdata('esp_KFVERAO_001.mat');
perfil_structure(2).espessura = importdata('esp_KFVERAO_002.mat');
perfil_structure(3).espessura = importdata('esp_KFVERAO_003.mat');
perfil_structure(4).espessura = importdata('esp_KFVERAO_004.mat');
perfil_structure(5).espessura = importdata('esp_KFVERAO_005.mat');
perfil_structure(6).espessura = importdata('esp_KFVERAO_006.mat');
perfil_structure(7).espessura = importdata('esp_KFVERAO_007.mat');
 
%%
perfil_structure(1).pontos_inf = perfil_structure(1).pontos(((length(perfil_structure(1).pontos))/2)+1:length(perfil_structure(1).pontos),1:2);
perfil_structure(2).pontos_inf = perfil_structure(1).pontos(((length(perfil_structure(2).pontos))/2)+1:length(perfil_structure(2).pontos),1:2);
perfil_structure(3).pontos_inf = perfil_structure(1).pontos(((length(perfil_structure(3).pontos))/2)+1:length(perfil_structure(3).pontos),1:2);
perfil_structure(4).pontos_inf = perfil_structure(1).pontos(((length(perfil_structure(4).pontos))/2)+1:length(perfil_structure(4).pontos),1:2);
perfil_structure(5).pontos_inf = perfil_structure(1).pontos(((length(perfil_structure(5).pontos))/2)+1:length(perfil_structure(5).pontos),1:2);
perfil_structure(6).pontos_inf = perfil_structure(1).pontos(((length(perfil_structure(6).pontos))/2)+1:length(perfil_structure(6).pontos),1:2);
perfil_structure(7).pontos_inf = perfil_structure(1).pontos(((length(perfil_structure(7).pontos))/2)+1:length(perfil_structure(7).pontos),1:2);

%%
perfil_structure(1).t_c = 0.1345;
perfil_structure(2).t_c = 0.1381;
perfil_structure(3).t_c = 0.1439;
perfil_structure(4).t_c = 0.1477;
perfil_structure(5).t_c = 0.1355;
perfil_structure(6).t_c = 0.1482;
perfil_structure(7).t_c = 0.1382;

%%
perfil_structure(1).maxt_x = 0.2873;
perfil_structure(2).maxt_x = 0.2873;
perfil_structure(3).maxt_x = 0.2873;
perfil_structure(4).maxt_x = 0.2863;
perfil_structure(5).maxt_x = 0.2062;
perfil_structure(6).maxt_x = 0.2062;
perfil_structure(7).maxt_x = 0.2312;

%%
perfil_structure(1).area_unit = 0.0868;
perfil_structure(2).area_unit = 0.0876;
perfil_structure(3).area_unit = 0.0833;
perfil_structure(4).area_unit = 0.0847;
perfil_structure(5).area_unit = 0.0716;
perfil_structure(6).area_unit = 0.0792;
perfil_structure(7).area_unit = 0.0743;

%%
