%% Dados perfil GEN
clear;
load('RUN_01.mat');
load('perfil_structure_v1')

perfil_structure(2).obj_cl = MASTER(8).CL_INTERP;
perfil_structure(3).obj_cl = MASTER(3).CL_INTERP;
perfil_structure(4).obj_cl = MASTER(2).CL_INTERP;
perfil_structure(5).obj_cl = MASTER(1).CL_INTERP;
perfil_structure(6).obj_cl = MASTER(7).CL_INTERP;
perfil_structure(7).obj_cl = MASTER(6).CL_INTERP;
perfil_structure(8).obj_cl = MASTER(5).CL_INTERP;
perfil_structure(9).obj_cl = MASTER(4).CL_INTERP;

perfil_structure(2).obj_cl0 = MASTER(8).Cl_0;
perfil_structure(3).obj_cl0 = MASTER(3).Cl_0;
perfil_structure(4).obj_cl0 = MASTER(2).Cl_0;
perfil_structure(5).obj_cl0 = MASTER(1).Cl_0;
perfil_structure(6).obj_cl0 = MASTER(7).Cl_0;
perfil_structure(7).obj_cl0 = MASTER(6).Cl_0;
perfil_structure(8).obj_cl0 = MASTER(5).Cl_0;
perfil_structure(9).obj_cl0 = MASTER(4).Cl_0;

perfil_structure(2).obj_cl_alpha = MASTER(8).Cl_alpha;
perfil_structure(3).obj_cl_alpha = MASTER(3).Cl_alpha;
perfil_structure(4).obj_cl_alpha = MASTER(2).Cl_alpha;
perfil_structure(5).obj_cl_alpha = MASTER(1).Cl_alpha;
perfil_structure(6).obj_cl_alpha = MASTER(7).Cl_alpha;
perfil_structure(7).obj_cl_alpha = MASTER(6).Cl_alpha;
perfil_structure(8).obj_cl_alpha = MASTER(5).Cl_alpha;
perfil_structure(9).obj_cl_alpha = MASTER(4).Cl_alpha;


