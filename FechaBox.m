function [ geom_malha ] = FechaBox( geom_malha )
%Essa função fecha a lateral entre as duas asas

xl = geom_malha(1).X(:,end);
xu = geom_malha(2).X(:,end);
y_box = geom_malha(1).Y(:,end);
zl = geom_malha(1).Z(:,end);
zu = geom_malha(2).Z(:,end);
comp_x = length(xl);

panels_b_box = ceil((zu(1)-zl(1))/(xl(end)-xl(1))*comp_x);

% vetorização
a = repmat(linspace(0,1,panels_b_box+1),comp_x,1);
Xl = repmat(xl,1,panels_b_box+1);
Xu = repmat(xu,1,panels_b_box+1);
Zl = repmat(zl,1,panels_b_box+1);
Zu = repmat(zu,1,panels_b_box+1);

X_box = Xl + (Xu-Xl).*a;
Z_box = Zl + (Zu-Zl).*a;
Y_box = repmat(y_box,1,panels_b_box+1);

%middle = NaN(comp_x,1);
% geom_malha(3).X = [X_box,middle,X_box];
% geom_malha(3).Z = [Z_box,middle,Z_box];
% geom_malha(3).Y = [Y_box,middle,-Y_box];
chord = X_box(1,:) - X_box(end,:);
%simetria
geom_malha(3).X = X_box;
geom_malha(3).Z = Z_box;
geom_malha(3).Y = Y_box;
geom_malha(3).chord = chord(1:end-1);
end

