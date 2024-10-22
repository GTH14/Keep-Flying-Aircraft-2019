function [Coef_7_15] = estab_Coef_7_15(AR, sweep, taper)
    if sweep < 0
        sweep = -sweep;
    end
    if taper < 0.5
        if sweep > 60
            a = 6.13171*AR^5/100000 - 0.001650604*AR^4 + 0.018671759*AR^3 - 0.12268*AR^2 + 0.551193*AR + 0.009645; %curva para taper 0 e sweep = 60
            b = 0.000049984*AR^5 - 0.001264896*AR^4 + 0.014095238*AR^3 - 0.104235*AR^2 + 0.5797867*AR + 0.02071719; %curva para taper 0.5 e sweep = 60
            Coef_7_15 = ((0.5 - taper)*a + taper*b)/0.5; %média ponderada em relação ao taper
        elseif sweep > 40
            a = -2.52652*AR^5/100000 + 0.000297514*AR^4 + 0.002655921*AR^3 - 0.06707*AR^2 + 0.532677*AR  + 0.017393; %curva para taper 0 e sweep = 40
            b = 6.13171*AR^5/100000 - 0.001650604*AR^4 + 0.018671759*AR^3 - 0.12268*AR^2 + 0.551193*AR + 0.009645 ; %curva para taper 0 e sweep = 60
            c = -0.00005712679*AR^5 + 0.00101602*AR^4 - 0.003585099*AR^3 - 0.0426768*AR^2 + 0.55040966*AR + 0.017383; %curva para taper 0.5 e sweep = 40
            d = 0.000049984*AR^5 - 0.001264896*AR^4 + 0.014095238*AR^3 - 0.104235*AR^2 + 0.5797867*AR + 0.02071719; %curva para taper 0.5 e sweep = 60
            a = ((60 - taper)*a + (taper - 40)*b)/20; %médias ponderadas em relação ao sweep
            b = ((60 - taper)*c + (taper - 40)*d)/20;
            Coef_7_15 = ((0.5 - taper)*a + taper*b)/0.5; %média ponderada em relação ao taper
        else
            a = 8.87148*AR^5 - 0.002244149*AR^4 + 0.023220422*AR^3 - 0.13811*AR^2 + 0.643006*AR + 0.007926; %curva para taper 0 e sweep = 0
            b = -2.52652*AR^5/100000 + 0.000297514*AR^4 + 0.002655921*AR^3 - 0.06707*AR^2 + 0.532677*AR  + 0.017393; %curva para taper 0 e sweep = 40
            c = -0.000040110179*AR^5 + 0.00088635*AR^4 - 0.00465411*AR^3 - 0.031159*AR^2 + 0.55657*AR + 0.012657; %curva para taper 0.5 e sweep = 0
            d = -0.00005712679*AR^5 + 0.00101602*AR^4 - 0.003585099*AR^3 - 0.0426768*AR^2 + 0.55040966*AR + 0.017383; %curva para taper 0.5 e sweep = 40
            a = ((40 - taper)*a + taper*b)/40; %médias ponderadas em relação ao sweep
            b = ((40 - taper)*c + taper*d)/40;
            Coef_7_15 = ((0.5 - taper)*a + taper*b)/0.5; %média ponderada em relação ao taper
        end
    else
        if sweep > 60
            a = 0.000049984*AR^5 - 0.001264896*AR^4 + 0.014095238*AR^3 - 0.104235*AR^2 + 0.5797867*AR + 0.02071719; %curva para taper 0.5 e sweep = 60
            b = 0.000022204*AR^5 - 0.0006731888*AR^4 + 0.0099752*AR^3 - 0.094738*AR^2 + 0.589875*AR + 0.00754286; %curva para taper 1 e sweep = 60
            Coef_7_15 = ((1 - taper)*a + (taper - 0.5)*b)/0.5; %média ponderada em relação ao taper
        elseif sweep > 40
            a = -0.00005712679*AR^5 + 0.00101602*AR^4 - 0.003585099*AR^3 - 0.0426768*AR^2 + 0.55040966*AR + 0.017383; %curva para taper 0.5 e sweep = 40
            b = 0.000049984*AR^5 - 0.001264896*AR^4 + 0.014095238*AR^3 - 0.104235*AR^2 + 0.5797867*AR + 0.02071719; %curva para taper 0.5 e sweep = 60
            c = -0.000040831*AR^5 - 0.000040831*AR^4 - 0.006136768*AR^3 - 0.0216437*AR^2 + 0.525927*AR + 0.01081547; %curva para taper 1 e sweep = 40
            d = 0.000022204*AR^5 - 0.0006731888*AR^4 + 0.0099752*AR^3 - 0.094738*AR^2 + 0.589875*AR + 0.00754286; %curva para taper 1 e sweep = 60
            a = ((60 - taper)*a + (taper - 40)*b)/20; %médias ponderadas em relação ao sweep
            b = ((60 - taper)*c + (taper - 40)*d)/20;
            Coef_7_15 = ((1 - taper)*a + (taper - 0.5)*b)/0.5; %média ponderada em relação ao taper
        else
            a = -0.000040110179*AR^5 + 0.00088635*AR^4 - 0.00465411*AR^3 - 0.031159*AR^2 + 0.55657*AR + 0.012657; %curva para taper 0.5 e sweep = 0
            b = -0.00005712679*AR^5 + 0.00101602*AR^4 - 0.003585099*AR^3 - 0.0426768*AR^2 + 0.55040966*AR + 0.017383; %curva para taper 0.5 e sweep = 40
            c = -0.000093205*AR^5 + 0.002059137*AR^4 - 0.014579*AR^3 + 0.0077726*AR^2 + 0.5154*AR + 0.0033256; %curva para taper 1 e sweep = 0
            d = -0.000040831*AR^5 - 0.000040831*AR^4 - 0.006136768*AR^3 - 0.0216437*AR^2 + 0.525927*AR + 0.01081547; %curva para taper 1 e sweep = 40
            a = ((40 - taper)*a + taper*b)/40; %médias ponderadas em relação ao sweep
            b = ((40 - taper)*c + taper*d)/40;
            Coef_7_15 = ((1 - taper)*a + (taper - 0.5)*b)/0.5; %média ponderada em relação ao taper
        end
    end
    Coef_7_15 = -Coef_7_15/10000;
end