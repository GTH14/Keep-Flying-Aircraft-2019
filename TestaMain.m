run.Q = 10;
run.alpha = 0;
run.beta = 0;
run.xCG = 0;
run.rho = 1.1;
run.sym = true;
run.ground = false;

geom.AR = 8;
geom.b = 2;
geom.i_wl=20;
geom.fb = [.5 .5 0.5 0.8 0.5];
geom.t = [1 0.9 0.8 1 1 1];
geom.l = [10 0 0 20 20 20];
geom.died = [0 0 0 10 20 30 ];
geom.twist = [0 0 0 0 0 0 ];
geom.offset_X = 0;
geom.offset_Z = 0.25;
geom.corda_raiz = 0.4;
geom.perfis = [2 2 2 2 2 2 2 ];
geom.dens = 200;
geom.def = 20;
%geom.h_BA_asa = 0.25;
geom.i_w_rel = 3;
geom.d_BA_BA_X = 0;
geom.d_BA_BA_Z = 0.4;
geom.S = 1.9/2;
geom.MAC = 0.7;
geom.fim_def = 0.5; % Como começa a deflexão começa na raíz o fim é o próprio fb_e
geom.fd = 0.3;
%% Testa main
%[ aviao ] = AeroMainGenetico( geom);
 %AeroMainGenetico( run,geom );
