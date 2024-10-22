function [ geom_malha] = MontaAsaSuperior( geom_malha,geom )
%Monta a asa de cima 
geom_malha(2) = geom_malha(1);
i_w_rel = geom.i_w_rel;
[ X_wu,Z_wu ] = Rotaciona_Y( geom_malha(2).X,geom_malha(2).Z,i_w_rel );
geom_malha(2).X = X_wu + geom.d_BA_BA_X;
geom_malha(2).Z = Z_wu + geom.d_BA_BA_Z;


end

