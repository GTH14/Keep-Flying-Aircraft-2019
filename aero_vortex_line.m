function [v_indx,v_indy,v_indz]=aero_vortex_line(Cx,Cy,Cz,P1x,P1y,P1z,P2x,P2y,P2z)
    err=1e-4;
    distancias=aero_distancia_ponto_reta(P1x,P1y,P1z,P2x,P2y,P2z,Cx,Cy,Cz);
    
    R1x=Cx-P1x;        R1y=Cy-P1y;          R1z=Cz-P1z;
    R2x=Cx-P2x;        R2y=Cy-P2y;          R2z=Cz-P2z;
    R0x=P2x-P1x;       R0y=P2y-P1y;         R0z=P2z-P1z;
    
    R12x=R1y.*R2z-R1z.*R2y;
    R12y=R1z.*R2x-R1x.*R2z;
    R12z=R1x.*R2y-R1y.*R2x;
    
    r1=(R1x.^2+R1y.^2+R1z.^2).^0.5;
    r2=(R2x.^2+R2y.^2+R2z.^2).^0.5;
    r12=(R12x.^2+R12y.^2+R12z.^2).^0.5;
    
    r1x=R1x.*(r1.^-1);        r1y=R1y.*(r1.^-1);          r1z=R1z.*(r1.^-1);
    r2x=R2x.*(r2.^-1);        r2y=R2y.*(r2.^-1);          r2z=R2z.*(r2.^-1);
    
    dotR0r1r2=R0x.*(r1x-r2x)+R0y.*(r1y-r2y)+R0z.*(r1z-r2z);
    
    denominador=(0.25/pi)*r12.^-2;
    
    v_indx=dotR0r1r2.*(denominador.*R12x);
    v_indy=dotR0r1r2.*(denominador.*R12y);
    v_indz=dotR0r1r2.*(denominador.*R12z);
    
    %     v_indx=((dotR0r1r2)/(4*pi*r12*r12))*R12x;
    %     v_indy=((dotR0r1r2)/(4*pi*r12*r12))*R12y;
    %     v_indz=((dotR0r1r2)/(4*pi*r12*r12))*R12z;
    
    erros=find(distancias<err);
    v_indx(erros)=0;
    v_indy(erros)=0;
    v_indz(erros)=0;
    
    %         R1=C-P1;
    %         R2=C-P2;
    %         R0=P2-P1;
    %         R12=cross(R1,R2);r12=norm(R12);
    %         N1=(1/norm(R1))*R1;
    %         N2=(1/norm(R2))*R2;
    %         v_ind=(1/(4*pi*r12*r12))*dot(R0,(N1-N2))*R12;

end