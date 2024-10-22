function [Coef_7_14] = estab_Coef_7_14(AR, taper)
%     Aproximação válida para taper > 0.5
    Coef_7_14 = 0.0033*AR^5 - 0.0907*AR^4 + 0.9891*AR^3 - 5.4614*AR^2 + 16.03*AR;
    Coef_7_14 = Coef_7_14 - 22.697 - 18.0550145419829*(1 - taper)*(taper - 1.18432684857127);
%     Média ponderada para considerar taper < 0.5
    if taper < 0.5
        aux = 0.0018*AR^5 - 0.0515*AR^4 + 0.5932*AR^3 - 3.999*AR^2 + 9.976*AR - 12.542;
        Coef_7_14 = (taper*Coef_7_14 + (0.5 - taper)*aux)/0.5;
    end
    Coef_7_14 = Coef_7_14/1000;
end