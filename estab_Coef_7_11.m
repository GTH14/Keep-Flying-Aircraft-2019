function [Coef_7_11] = estab_Coef_7_11(sweep, AR, taper)
    %Válido para AR > 3
    if taper < 0.5
        if AR < 4
            %Considerando que a curva para taper 0 e AR 3 é mto próxima da
            %curva para taper 0 e 6 < AR < 8
            a = -5.47705824012736E-09*sweep^5 + 1.58044964961138E-07*sweep^4 + 2.3343025678158E-06*sweep^3 - 0.000248611892014429*sweep^2 - 0.0719256346602502*sweep - 0.00169729292666596; %taper 0, AR 3
            b = -4.5411537601534E-09*sweep^5 + 2.54819953203749E-07*sweep^4 - 9.60293732838996E-06*sweep^3 - 5.66105842597382E-05*sweep^2 - 0.0623969396682025*sweep - 0.00332062023422676; %taper 0.5, AR 2
            c = -7.12691970887582E-09*sweep^5 + 4.50308368588519E-07*sweep^4 - 1.35182330028813E-05*sweep^3 - 0.000141607834203887*sweep^2 - 0.0718823322874064*sweep + 0.0175547379224196; %taper 0.5, AR 4
            b = ((4 - AR)*b + (AR - 2)*c)/2; %médias ponderada em relação ao AR
            Coef_7_11 = ((0.5 - taper)*a + taper*b)/0.5; %média ponderada em relação ao taper
        elseif AR < 6
            a = -5.47705824012736E-09*sweep^5 + 1.58044964961138E-07*sweep^4 + 2.3343025678158E-06*sweep^3 - 0.000248611892014429*sweep^2 - 0.0719256346602502*sweep - 0.00169729292666596; %taper 0, AR 3
            b = -9.42503165107484E-09*sweep^5 + 5.6907885478276E-07*sweep^4 - 1.03663305089234E-05*sweep^3 - 0.000172634535775735*sweep^2 - 0.0764104104536349*sweep - 0.00181706345283717; %taper 0, 6< AR <8
            c = -7.12691970887582E-09*sweep^5 + 4.50308368588519E-07*sweep^4 - 1.35182330028813E-05*sweep^3 - 0.000141607834203887*sweep^2 - 0.0718823322874064*sweep + 0.0175547379224196; %taper 0.5, AR 4
            d = -8.82523577199251E-09*sweep^5 + 6.01673419123467E-07*sweep^4 - 1.75866769149279E-05*sweep^3 - 0.000269435055298707*sweep^2 - 0.0714340328583535*sweep + 0.0120650514461153; %taper 0.5, AR 6
            a = ((6 - AR)*a + (AR - 3)*b)/3; %médias ponderada em relação ao AR
            b = ((6 - AR)*c + (AR - 4)*d)/2;
            Coef_7_11 = ((0.5 - taper)*a + taper*b)/0.5; %média ponderada em relação ao taper
        elseif AR < 8
            a = -9.42503165107484E-09*sweep^5 + 5.6907885478276E-07*sweep^4 - 1.03663305089234E-05*sweep^3 - 0.000172634535775735*sweep^2 - 0.0764104104536349*sweep - 0.00181706345283717; %taper 0, 6< AR <8
            b = -8.82523577199251E-09*sweep^5 + 6.01673419123467E-07*sweep^4 - 1.75866769149279E-05*sweep^3 - 0.000269435055298707*sweep^2 - 0.0714340328583535*sweep + 0.0120650514461153; %taper 0.5, AR 6
            c = -7.61912139457536E-09*sweep^5 + 3.92164658183166E-07*sweep^4 - 1.14934875358948E-05*sweep^3 - 0.000161285139651213*sweep^2 - 0.0810229255587907*sweep + 0.03406704823609; %taper 0.5, AR 8
            b = ((8 - AR)*b + (AR - 6)*c)/2; %médias ponderada em relação ao AR
            Coef_7_11 = ((0.5 - taper)*a + taper*b)/0.5; %média ponderada em relação ao taper
        else
            %Por não haver dados para AR > 8, supor que o coeficiente é
            %limitado superiormente pela curva em que AR é 8
            a = sweep^5 + sweep^4 + sweep^3 + sweep^2 + sweep ; %taper 0, AR 8
            b = -7.61912139457536E-09*sweep^5 + 3.92164658183166E-07*sweep^4 - 1.14934875358948E-05*sweep^3 - 0.000161285139651213*sweep^2 - 0.0810229255587907*sweep + 0.03406704823609; %taper 0.5, AR 8
            Coef_7_11 = ((0.5 - taper)*a + taper*b)/0.5; %média ponderada em relação ao taper
        end
    else
        if AR < 4
            a = -4.5411537601534E-09*sweep^5 + 2.54819953203749E-07*sweep^4 - 9.60293732838996E-06*sweep^3 - 5.66105842597382E-05*sweep^2 - 0.0623969396682025*sweep - 0.00332062023422676; %taper 0.5, AR 2
            b = sweep^5 + sweep^4 + sweep^3 + sweep^2 + sweep ; %taper 0.5, AR 4
            c = 1.70734190403991E-08*sweep^5 - 4.01129606193049E-06*sweep^4 + 0.000272350558502799*sweep^3 - 0.0068995462674196*sweep^2 - 0.0329430265149208*sweep + 0.411223057657975; %taper 1, AR 2
            d = -7.63249110685435E-09*sweep^5 + 4.59713644914573E-07*sweep^4 - 1.26065848846799E-05*sweep^3 - 0.000142634720978102*sweep^2 - 0.0738050668481458*sweep +0.0151274074848899; %taper 1, AR 4
            a = ((4 - AR)*a + (AR - 2)*b)/2; %médias ponderada em relação ao AR
            b = ((4 - AR)*c + (AR - 2)*d)/2;
            Coef_7_11 = ((1 - taper)*a + (taper - 0.5)*b)/0.5; %média ponderada em relação ao taper
        elseif AR < 6
            a = -7.12691970887582E-09*sweep^5 + 4.50308368588519E-07*sweep^4 - 1.35182330028813E-05*sweep^3 - 0.000141607834203887*sweep^2 - 0.0718823322874064*sweep + 0.0175547379224196; %taper 0.5, AR 4
            b = -8.82523577199251E-09*sweep^5 + 6.01673419123467E-07*sweep^4 - 1.75866769149279E-05*sweep^3 - 0.000269435055298707*sweep^2 - 0.0714340328583535*sweep + 0.0120650514461153; %taper 0.5, AR 6
            c = -7.63249110685435E-09*sweep^5 + 4.59713644914573E-07*sweep^4 - 1.26065848846799E-05*sweep^3 - 0.000142634720978102*sweep^2 - 0.0738050668481458*sweep + 0.0151274074848899; %taper 1, AR 4
            d = -9.05782600005487E-09*sweep^5 + 5.21170277690984E-07*sweep^4 - 1.55187085876843E-05*sweep^3 - 0.000139825400511137*sweep^2 - 0.0807993060002518*sweep + 0.0275116977569762; %taper 1, AR 6
            a = ((6 - AR)*a + (AR - 4)*b)/2; %médias ponderada em relação ao AR
            b = ((6 - AR)*c + (AR - 4)*d)/2;
            Coef_7_11 = ((1 - taper)*a + (taper - 0.5)*b)/0.5; %média ponderada em relação ao taper
        elseif AR < 8
            a = -8.82523577199251E-09*sweep^5 + 6.01673419123467E-07*sweep^4 - 1.75866769149279E-05*sweep^3 - 0.000269435055298707*sweep^2 - 0.0714340328583535*sweep + 0.0120650514461153; %taper 0.5, AR 6
            b = -7.61912139457536E-09*sweep^5 + 3.92164658183166E-07*sweep^4 - 1.14934875358948E-05*sweep^3 - 0.000161285139651213*sweep^2 - 0.0810229255587907*sweep + 0.03406704823609; %taper 0.5, AR 8
            c = -9.05782600005487E-09*sweep^5 + 5.21170277690984E-07*sweep^4 - 1.55187085876843E-05*sweep^3 - 0.000139825400511137*sweep^2 - 0.0807993060002518*sweep + 0.0275116977569762; %taper 1, AR 6
            d = -1.1864184458611E-08*sweep^5 + 5.86839325407963E-07*sweep^4 - 0.000011405955980048*sweep^3 - 0.000250258340939995*sweep^2 - 0.0853403296241783*sweep + 0.0340828461736529; %taper 1, AR 8
            a = ((6 - AR)*a + (AR - 4)*b)/2; %médias ponderada em relação ao AR
            b = ((6 - AR)*c + (AR - 4)*d)/2;
            Coef_7_11 = ((1 - taper)*a + (taper - 0.5)*b)/0.5; %média ponderada em relação ao taper
        else
            %Por não haver dados para AR > 8, supor que o coeficiente é
            %limitado superiormente pela curva em que AR é 8
            a = -7.61912139457536E-09*sweep^5 + 3.92164658183166E-07*sweep^4 - 1.14934875358948E-05*sweep^3 - 0.000161285139651213*sweep^2 - 0.0810229255587907*sweep + 0.03406704823609; %taper 0.5, AR 8
            b = -1.1864184458611E-08*sweep^5 + 5.86839325407963E-07*sweep^4 - 0.000011405955980048*sweep^3 - 0.000250258340939995*sweep^2 - 0.0853403296241783*sweep + 0.0340828461736529; %taper 1, AR 8
            Coef_7_11 = ((1 - taper)*a + (taper - 0.5)*b)/0.5; %média ponderada em relação ao taper
        end
    end
    Coef_7_11 = Coef_7_11/1000;
end