function [ geom_malha ] = DeflexaoMalha( geom_malha,geom )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
offset_X = geom.offset_X;
offset_Z = geom.offset_Z;
Xb = geom_malha.Xb;
Yb = geom_malha.Yb;
Zb = geom_malha.Zb;
cma_out = geom_malha.cma_out;
b = geom.b;
i_rel = geom.i_rel;
i_w = geom.i_w;
inicio = b/2*geom_malha.inicio_def;
fim = b/2*geom_malha.fim_def;
fd = geom.fd; %fração defletida
%Acha o vetor x, ou seja a distribição na direção da corda
x = geom_malha.x; % É constante para toda asao
%x vai de 0 a 1
x0_eixo = (1-fd)*cosd(i_w);
z0_eixo = -(1-fd)*sind(i_w);

% Acha as colunas que sofrerão deflexao
[row1,col1] = find(abs(Yb)>=inicio&abs(Yb)<=fim); %apenas as colunas importam
[row2,col2] = find(x>(1-fd)); %apenas as linhas importam
c = col1(1):col1(end);
r = row2(1):row2(end);
n_col = length(c);
n_row = length(r);
Xaux1 = Xb(r,c);
Yaux1 = Yb(r,c);
Zaux1 = Zb(r,c);
Caux = repmat(cma_out(1,c),n_row,1);
%Acha offset
OffSetX = repmat(Xaux1(1,:),n_row,1);
OffSetZ = repmat(Zaux1(:,1),1,n_col);

%prepara rotação
Xaux2 = Xaux1-OffSetX;%-x0_eixo*Caux;
Zaux2 = Zaux1-OffSetZ;%-z0_eixo*Caux;


%Faz a rotação 
[ Xaux3,Zaux3 ] = Rotaciona_Y( Xaux2,Zaux2,-i_rel ); %O menos é porque a rotação é no outro sentido
%disp(Xaux3)


Xdd = Xaux3+OffSetX;%+x0_eixo*Caux; %Volta para a base antiga
Zdd = Zaux3+OffSetZ;%+z0_eixo*Caux;


% Xdb = X;
% Zdb = Z;
% %coloca parte defletida
% Xdb(r,c) =  Xdbd;
% Zdb(r,c) =  Zdbd;

% Desacopla parte defletida
middle = NaN(size(Xb,1),1);
Xdb = zeros(size(Xb,1),size(Xb,2)+2);
Zdb = Xdb;
Ydb = Xdb;
%Antes da deflexao
Xdb(:,1:c(1)-1) = Xb(:,1:c(1)-1);
Zdb(:,1:c(1)-1) = Zb(:,1:c(1)-1);
Ydb(:,1:c(1)-1) = Yb(:,1:c(1)-1);
% desacopla começo
Xdb(:,c(1)) = middle;
Zdb(:,c(1)) = middle;
Ydb(:,c(1)) = middle;
%insere deflexao
Xdb(:,c(1)+1:c(end)+1) = Xb(:,c(1):c(end));
Zdb(:,c(1)+1:c(end)+1) = Zb(:,c(1):c(end));
Ydb(:,c(1)+1:c(end)+1) = Yb(:,c(1):c(end));
Xdb(r,c(1)+1:c(end)+1) = Xdd;
Zdb(r,c(1)+1:c(end)+1) = Zdd;
%desacopla fim
Xdb(:,c(end)+2) = middle;
Zdb(:,c(end)+2) = middle;
Ydb(:,c(end)+2) = middle;
%Insece o resto


Xdb(:,c(end)+3:end) = Xb(:,c(end)+1:end);
Zdb(:,c(end)+3:end) = Zb(:,c(end)+1:end);
Ydb(:,c(end)+3:end) = Yb(:,c(end)+1:end);

% Fazendo os dois lados da asa
Xdc=Xdb(:,2:end);
Ydc=Ydb(:,2:end);
Zdc=Zdb(:,2:end);

Xd=[fliplr(Xdb) Xdc];
Yd=[fliplr(-Ydb) Ydc];
Zd=[fliplr(Zdb) Zdc];

Xd=Xd+offset_X;
Zd=Zd+offset_Z;






geom_malha.Xd = Xd;
geom_malha.Zd = Zd;
geom_malha.Yd = Yd;

end

