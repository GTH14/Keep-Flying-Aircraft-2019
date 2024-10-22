function [ geom_malha_def ] = DeflexaoMalhaV2( geom_malha,geom )
% Essa função deflete a malha para poder calcular coeficientes com deflexão


% offset_X = geom.offset_X;
% offset_Z = geom.offset_Z;
Xb = geom_malha.X;
Yb = geom_malha.Y;
Zb = geom_malha.Z;
b = geom.b;
def = geom.def;
inicio = b/2*geom.inicio_def;
fim = b/2*geom.fim_def;
fd = geom.fd; %fração defletida na corda
%Acha o vetor x, ou seja, a distribição na direção da corda
x = geom_malha.x; % É constante para toda asa
%x vai de 0 a 1
eps =1e-4; 
% Acha as colunas que sofrerão deflexao
[~,col1] = find(abs(Yb)>=inicio-eps&abs(Yb)<=fim+eps); %apenas as colunas importam
[row2,~] = find(x>(1-fd)-eps); %apenas as linhas importam
c = col1(1):col1(end);
r = row2(1):row2(end);
n_col = length(c);
n_row = length(r);
Xaux1 = Xb(r,c);
Zaux1 = Zb(r,c);
%Acha offset
OffSetX = repmat(Xaux1(1,:),n_row,1);
OffSetZ = repmat(Zaux1(:,1),1,n_col);

%prepara rotação
Xaux2 = Xaux1-OffSetX;%-x0_eixo*Caux;
Zaux2 = Zaux1-OffSetZ;%-z0_eixo*Caux;


%Faz a rotação 
[ Xaux3,Zaux3 ] = Rotaciona_Y( Xaux2,Zaux2,-def ); %O menos é porque a rotação é no outro sentido

Xdd = Xaux3+OffSetX;
Zdd = Zaux3+OffSetZ;

c_1 = c(1);
c_end = c(end);

% Desacopla parte defletida
middle = NaN(size(Xb,1),1);
Xdb = zeros(size(Xb,1),size(Xb,2)+4);
Zdb = Xdb;
Ydb = Xdb;
%Antes da deflexao
Xdb(:,1:c_1-1) = Xb(:,1:c_1-1);
Zdb(:,1:c_1-1) = Zb(:,1:c_1-1);
Ydb(:,1:c_1-1) = Yb(:,1:c_1-1);
% Fecha o começo da parte defletida
Xdb(:,c_1) = Xb(:,c_1);
Zdb(:,c_1) = Zb(:,c_1);
Ydb(:,c_1) = Yb(:,c_1);
% desacopla começo
Xdb(:,c_1+1) = middle;
Zdb(:,c_1+1) = middle;
Ydb(:,c_1+1) = middle;



%insere deflexao
Xdb(:,c_1+2:c_end+2) = Xb(:,c_1:c_end);
Zdb(:,c_1+2:c_end+2) = Zb(:,c_1:c_end);
Ydb(:,c_1+2:c_end+2) = Yb(:,c_1:c_end);
Xdb(r,c_1+2:c_end+2) = Xdd;
Zdb(r,c_1+2:c_end+2) = Zdd;
%desacopla fim
Xdb(:,c_end+3) = middle;
Zdb(:,c_end+3) = middle;
Ydb(:,c_end+3) = middle;

%Fecha o fim da parte defletida
Xdb(:,c_end+4) = Xb(:,c_end);
Zdb(:,c_end+4) = Zb(:,c_end);
Ydb(:,c_end+4) = Yb(:,c_end);

%Insece o resto

Xdb(:,c_end+5:end) = Xb(:,c_end+1:end);
Zdb(:,c_end+5:end) = Zb(:,c_end+1:end);
Ydb(:,c_end+5:end) = Yb(:,c_end+1:end);

% Fazendo os dois lados da asa
% Xdc=Xdb(:,2:end);
% Ydc=Ydb(:,2:end);
% Zdc=Zdb(:,2:end);
% 
% Xd=[fliplr(Xdb) Xdc];
% Yd=[fliplr(-Ydb) Ydc];
% Zd=[fliplr(Zdb) Zdc];

% Xdb=Xdb+offset_X;
% Zdb=Zdb+offset_Z;



geom_malha_def = geom_malha;


geom_malha_def(1).X = Xdb;
geom_malha_def(1).Z = Zdb;
geom_malha_def(1).Y = Ydb;

end

