function [malha, geom] = forma_malha(geom, perfil)
%%
b = geom.b;
corda_asa = geom.c;
corda_empenagem = geom.c_eh;
taper = geom.taper; 
twist = geom.twist; 
enflechamento = geom.l;
diedro  = geom.diedro;
numero_secoes = geom.n;
fb = geom.fb;
offset_Z = geom.offset_Z;
% offset_X = geom.offset_X;
perfil = geom.perfil;
%%
densidade_paineis = 350; paineis_b = round(densidade_paineis*b); 
paineis_corda1 = round(densidade_paineis*corda_asa); paineis_corda2 = round(densidade_paineis*corda_empenagem);
coef_b1 = [1, cumsum(1-fb)]; coef_b2 =[fb,1]; b_sec = b*coef_b1.*coef_b2; b_secao_paineis = ceil(b_sec*paineis_b/b);
posicaoY_sec = [0,cumsum(b_sec)];
coef_c = [1, cumprod(taper)]; c_raiz_secoes = corda_asa*coef_c;
malha(1).asa = [];
for i = 1:numero_secoes
    [malha_sec] = forma_secoes(c_raiz_secoes(i,i+1), posicaoY_sec(i,i+1), b_secao_paineis(i), paineis_corda1, enflechamento(i), twist(i));
    malha(1).asa= [malha(1).asa, malha_sec];
end
function [malha] = forma_secoes(corda_raiz_secao, posicaoY_secao, paineis_b, paineis_c, enflecha_sec, angulo_torcao)
%%
y = linspace(posicaoY_secao(1), posicaoY_secao(2), paineis_b);
Y = repmat(y, paineis_c);
