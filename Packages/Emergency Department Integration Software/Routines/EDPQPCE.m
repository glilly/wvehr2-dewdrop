EDPQPCE ;SLC/KCM - Retrieve PCE information for ED Visits
        ;;1.0;EMERGENCY DEPARTMENT;;Sep 30, 2009;Build 74
        ;
DXPRI(AREA,LOG) ; return primary diagnosis
        N DXLST
        D DXALL(AREA,LOG,.DXLST)
        Q $G(DXLST(1)) ;$P( ,U,2)
        ;
DXALL(AREA,LOG,DXLST)   ; build list of diagnoses for a visit
        N EDPVISIT S EDPVISIT=$P(^EDP(230,LOG,0),U,12)
        I EDPVISIT,$P($G(^EDPB(231.9,AREA,1)),U,2) D DXPCE(EDPVISIT,.DXLST) I 1
        E  D DXFREE(LOG,.DXLST)
        Q
DXPCE(EDPVISIT,DXLST)   ; return a list of diagnoses from PCE
        N I,X,CODE,NAME,DX
        K ^TMP("PXKENC",$J)
        D ENCEVENT^PXAPI(EDPVISIT)
        S I=0,DX=0 F  S I=$O(^TMP("PXKENC",$J,EDPVISIT,"POV",I)) Q:'I  D
        . S X=^TMP("PXKENC",$J,EDPVISIT,"POV",I,0)
        . S CODE=$P(^ICD9($P(X,U),0),U)
        . S NAME=^AUTNPOV($P(X,U,4),0)
        . S DX=DX+1,DX($S($P(X,U,12)="P":DX,1:DX*10000))=CODE_U_NAME
        S X="",DXLST=DX F I=1:1 S X=$O(DX(X)) Q:X=""  S DXLST(I)=DX(X)
        Q
DXFREE(LOG,DXLST)       ; return free text diagnoses from ED LOG file
        N I,CODE,NAME,X4,DX
        S I=0,DX=0 F  S I=$O(^EDP(230,LOG,4,I)) Q:'I  D
        . S X4=^EDP(230,LOG,4,I,0)
        . S CODE=$P(X4,U,2) S:CODE CODE=$P(^ICD9(CODE,0),U)
        . S NAME=$P(X4,U,1)
        . S DX=DX+1,DX($S(+$P(X4,U,3):DX,1:DX*10000))=CODE_U_NAME
        S X="",DXLST=DX F I=1:1 S X=$O(DX(X)) Q:X=""  S DXLST(I)=DX(X)
        Q
