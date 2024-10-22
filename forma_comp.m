function [comp] = forma_comp(geom_comp)
x = geom_comp.tam(1)/2 ; y = geom_comp.tam(2)/2; z = geom_comp.tam(3)/2;
x0 = geom_comp.pos0(1); z0 = geom_comp.pos0(3);
X0 = repmat(x0, 4, 5); Z0 = repmat(z0, 4, 5);
X = [-x -x -x -x -x; x x x x x;-x -x x x -x; -x -x x x -x];
Y = [-y -y y y -y; -y -y y y -y;-y -y -y -y -y; y y y y y ];
Z = [-z  z z -z -z; -z z z -z -z;-z z z -z -z; -z z z -z -z];
comp.X = X + X0;
comp.Y = Y;
comp.Z = Z + Z0;