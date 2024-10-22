clear;
load('C:\Users\JHGPupin\usp.br\Keep Flying - Documentos\KF18\Genetico\ESCOLHIDO\aviao_RSA3.mat');

offset_w2_range = linspace(.9925, 1.3, 20);

MTOW = zeros(size(offset_w2_range)); PV = MTOW; Pont = MTOW;

for i=1:length(offset_w2_range)
    i
    aviao.offset_w2=offset_w2_range(i);
    %% GEOMETRIA - ok
    [aviao,mortes]=geometria_MAIN(aviao,mortes,perfil_structure);
    %% AERODINAMICA
    save('aviao')
%     [aviao] = AeroMainGenetico( aviao,const,perfil_structure);
    %% ESTABILIDADE ESTÁTICA - ok
%     if aviao.morte == 0
%         [aviao,mortes] = estab_main_estatica(aviao,mortes);
        %% EST. FUSELAGEM - ok
%         if aviao.morte == 0
            [aviao]=ETT_OtimizaFuselagem(aviao,perfil_structure,const);
            %% DESEMPENHO
%             if aviao.morte == 0
                [aviao,mortes]=desempenho_MAIN(aviao,mortes,tracao_structure,const);
                %% ESTRUTURAS  - ok
%                 if aviao.morte == 0
                    [aviao,mortes] = ETT_Main(aviao,perfil_structure,const,mortes);
                    %% ESTABILIDADE DINÂMICA
%                     if aviao.morte == 0
                        [aviao,mortes] = estab_main_dinamica(aviao,const,mortes);
%                     end
%                 end
%             end
%         end
%     end
    MTOW(i) = aviao.MTOW;
    PV(i) = aviao.PV;
    Pont(i) = aviao.Pontuacao;
end

%%
figure()
% hold on
% plot(MTOW)
plot(offset_w2_range,PV)