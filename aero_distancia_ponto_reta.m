function [d]=aero_distancia_ponto_reta(P1x,P1y,P1z,P2x,P2y,P2z,Cx,Cy,Cz)

    V1x=Cx-P1x;    V1y=Cy-P1y;    V1z=Cz-P1z;
    V2x=Cx-P2x;    V2y=Cy-P2y;    V2z=Cz-P2z;
    V3x=P2x-P1x;   V3y=P2y-P1y;   V3z=P2z-P1z;

    V1V2x=V1y.*V2z-V1z.*V2y;
    V1V2y=V1z.*V2x-V1x.*V2z;
    V1V2z=V1x.*V2y-V1y.*V2x;
    
    v3=(V3x.^2+V3y.^2+V3z.^2).^0.5;
    v1v2=(V1V2x.^2+V1V2y.^2+V1V2z.^2).^0.5;
    d=v1v2.*(v3.^-1);
    
%     V1=C-P1;
%     V2=C-P2;
%     V3=P2-P1;
%     d=(1/norm(V3))*norm(cross(V1,V2));

end