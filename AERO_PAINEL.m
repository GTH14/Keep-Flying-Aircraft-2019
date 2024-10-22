function geom_painel = AERO_PAINEL (geom_malha)
C1X_end=[]; C1Y_end = C1X_end; C1Z_end = C1X_end;
C2X_end = C1X_end; C2Y_end = C1X_end; C2Z_end = C1X_end;
C3X_end = C1X_end; C3Y_end = C1X_end; C3Z_end = C1X_end;
C4X_end = C1X_end; C4Y_end = C1X_end; C4Z_end = C1X_end;
CPX_end = C1X_end; CPY_end = C1X_end; CPZ_end = C1X_end;
NX_end = C1X_end; NY_end = C1X_end; NZ_end = C1X_end;
is_TE_end = C1X_end;
surf_idx_end = C1X_end; i_idx_end = C1X_end; j_idx_end = C1X_end;

for k=1:length(geom_malha)
    X = geom_malha(k).X; Y = geom_malha(k).Y; Z = geom_malha(k).Z;
    
    C1X=NaN(numel(X),1); C1Y=C1X; C1Z=C1X;
    C2X=C1X; C2Y=C1X; C2Z=C1X;
    C3X=C1X; C3Y=C1X; C3Z=C1X;
    C4X=C1X; C4Y=C1X; C4Z=C1X;
    CPX=C1X; CPY=C1X; CPZ=C1X;
    dA=C1X;
    N1=NaN(numel(X),3);
    i_idx = C1X; j_idx = C1X; surf_idx = C1X;
    
    is_TE=C1X;
    
    dx=diff(X)/4;
    dy=diff(Y)/4;
    dz=diff(Z)/4;
    
    Xp=X+[dx;dx(end,:)];
    Yp=Y+[dy;dy(end,:)];
    Zp=Z+[dz;dz(end,:)];

    count=1;
    
    for i=1:size(Xp,1)-1
        for j=1:size(Xp,2)-1
            C1X(count)=Xp(i,j); C2X(count)=Xp(i,j+1); C3X(count)=Xp(i+1,j+1); C4X(count)=Xp(i+1,j);
            C1Y(count)=Yp(i,j); C2Y(count)=Yp(i,j+1); C3Y(count)=Yp(i+1,j+1); C4Y(count)=Yp(i+1,j);
            C1Z(count)=Zp(i,j); C2Z(count)=Zp(i,j+1); C3Z(count)=Zp(i+1,j+1); C4Z(count)=Zp(i+1,j);
            CPX(count)=(X(i,j)+X(i,j+1))/2+3*dx(i,j);
            CPY(count)=(C1Y(count)+C2Y(count)+C3Y(count)+C4Y(count))/4;
            CPZ(count)=(Z(i,j)+Z(i,j+1))/2+3*dz(i,j);
%             CPZ(count) = (C1Z(count)+C2Z(count)+C3Z(count)+C4Z(count))/4;
            is_TE(count) = (i==(size(Xp,1)-1));
            A1=[X(i,j)-X(i+1,j+1),Y(i,j)-Y(i+1,j+1),Z(i,j)-Z(i+1,j+1)];
            B1=[X(i,j+1)-X(i+1,j),Y(i,j+1)-Y(i+1,j),Z(i,j+1)-Z(i+1,j)];
            N1(count,:)=cross(A1,B1); 
            A2=[X(i,j)-X(i+1,j),Y(i,j)-Y(i+1,j),Z(i,j)-Z(i+1,j)];
            B2=[X(i,j)-X(i,j+1),Y(i,j)-Y(i,j+1),Z(i,j)-Z(i,j+1)];
            dA(count)=norm(cross(A2,B2));
            i_idx(count) = i; j_idx(count) = j; surf_idx(count) = k;
            count=count+1;
        end
    end
    
    N=-N1./repmat(sqrt(N1(:,1).^2+N1(:,2).^2+N1(:,3).^2),1,3);
    NX=N(:,1);
    NY=N(:,2);
    NZ=N(:,3);
    
    NaN_idx=isnan(CPX);
    
    C1X(NaN_idx)=[]; C1Y(NaN_idx)=[]; C1Z(NaN_idx)=[];
    C2X(NaN_idx)=[]; C2Y(NaN_idx)=[]; C2Z(NaN_idx)=[];
    C3X(NaN_idx)=[]; C3Y(NaN_idx)=[]; C3Z(NaN_idx)=[];
    C4X(NaN_idx)=[]; C4Y(NaN_idx)=[]; C4Z(NaN_idx)=[];
    CPX(NaN_idx)=[]; CPY(NaN_idx)=[]; CPZ(NaN_idx)=[];
    NX(NaN_idx)=[]; NY(NaN_idx)=[]; NZ(NaN_idx)=[];
    is_TE(NaN_idx)=[];
    i_idx(NaN_idx)=[]; j_idx(NaN_idx)=[]; surf_idx(NaN_idx)=[];
    dA(NaN_idx)=[];
    
    C1X_end = [C1X_end;C1X]; C1Y_end = [C1Y_end;C1Y]; C1Z_end = [C1Z_end;C1Z];
    C2X_end = [C2X_end;C2X]; C2Y_end = [C2Y_end;C2Y]; C2Z_end = [C2Z_end;C2Z];
    C3X_end = [C3X_end;C3X]; C3Y_end = [C3Y_end;C3Y]; C3Z_end = [C3Z_end;C3Z];
    C4X_end = [C4X_end;C4X]; C4Y_end = [C4Y_end;C4Y]; C4Z_end = [C4Z_end;C4Z];
    CPX_end = [CPX_end;CPX]; CPY_end = [CPY_end;CPY]; CPZ_end = [CPZ_end;CPZ];
    NX_end = [NX_end;NX]; NY_end = [NY_end;NY]; NZ_end = [NZ_end;NZ];
    is_TE_end = [is_TE_end;is_TE];
    surf_idx_end = [surf_idx_end;surf_idx];
    i_idx_end = [i_idx_end; i_idx]; j_idx_end = [j_idx_end; j_idx];
end

geom_painel = struct( 'C1X',C1X_end,'C1Y',C1Y_end,'C1Z',C1Z_end,'C2X',C2X_end,'C2Y',C2Y_end,'C2Z',...
    C2Z_end,'C3X',C3X_end,'C3Y',C3Y_end,'C3Z',C3Z_end,'C4X',C4X_end,'C4Y',C4Y_end,'C4Z',C4Z_end,...
    'CPX',CPX_end,'CPY',CPY_end,'CPZ',CPZ_end,'NX',NX_end,'NY',NY_end,'NZ',NZ_end,'is_TE',is_TE_end,...
    'dA',dA,'i_idx',i_idx_end,'j_idx',j_idx_end,'surf_idx',surf_idx_end);