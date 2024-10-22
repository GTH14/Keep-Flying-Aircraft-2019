clear; close all;
Struct_aviao
Struct_constantes
Struct_mortes
load('perfil_structure_v1.mat')
testeaviao

[aviao] = geometria_MAIN(aviao,const);
[ aviao ] = AeroMainGenetico( aviao,const,perfil_structure);
