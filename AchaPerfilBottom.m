function [ perfil_bottom] = AchaPerfilBottom( pontos,x )
%Acha o centro do perfil (linha média) para o vetor x escolhido


%Ajusta os pontos

%pontos(diff(pontos)==0)=[];
pontos=reshape(pontos,numel(pontos)/2,2);



%Divide o vetor em top e bottom
ba_idx=find( diff(pontos(1:end-1,1)) .* diff(pontos(2:end,1)) <0) + 1;

perfil_top=interp1(pontos(1:ba_idx,1),pontos(1:ba_idx,2),x,'pchip');
perfil_top(1) = 0;

perfil_bottom=interp1(pontos(ba_idx:end,1),pontos(ba_idx:end,2),x,'pchip');
perfil_bottom(1) = 0;
end