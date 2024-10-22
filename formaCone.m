function [Cone] = formaCone(h, raio,n,x0)
X0 = repmat(x0,10,n);
% Z0 = repmat(z0,10,n);
x = cos(linspace(0,pi,n/2));
y = sqrt(1 - x.^2);
x1 = [fliplr(x),x];
y1 = [fliplr(-y),y];
z = linspace(0,h,10);
X = repmat(x1,10,1);
Y = repmat(y1,10,1);
Z = repmat(z,n,1);
Z = Z';
aux = raio/h;
Cone.X = aux*(h-Z).*X+X0;
Cone.Y = aux*(h-Z).*Y;
Cone.Z = Z ;

