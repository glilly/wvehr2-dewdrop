C0CCPT  ;;BSL;RETURN CPT DATA;
        ;;1.2;C0C;;May 11, 2012;Build 50
        ;Sequence Managers Software GPL;;;;;Build 2
        ;Copied into C0C namespace from SQMCPT with permission from
        ;Brian Lord - and with our thanks. gpl 01/20/2010
ENTRY(DFN,STDT,ENDDT,TXT)       ;BUILD TOTAL ARRAY OF ALL IEN'S FOR TIU NOTES
        ;DFN=PATIENT IEN
        ;STDT=START DATE IN 3100101 FORMAT (VA YEAR YYYMMDD)
        ;ENDDT=END DATE IN 3100101 FORMAT
        ;TXT=INCLUDE TEXT FROM ENCOUNTER NOTE
        ;THAT FALL INSIDE DATA RANGE. IF NO STDT OR ENDDT ASSUME 
               ;ALL INCLUSIVE IN THAT DIRECTION
               ;LIST OF TIU DOCS IN ^TIU(8925,"ACLPT",3,DFN)
               ;BUILD INTO NOTE(Y)=""
               S U="^",X=""
               F  S X=$O(^TIU(8925,"ACLPT",3,DFN,X)) Q:X=""  D
               . S Y=""
               . F  S Y=$O(^TIU(8925,"ACLPT",3,DFN,X,Y)) Q:Y=""  D
               .. S NOTE(Y)=""
               ;NOW DELETE ANY NOTES THAT DON'T FALL INTO DATE RANGE
               ;GET DATE OF NOTE
        ;RUT 3120109 Changing DATE in FILMAN's FORMAT
        ;;OHUM/RUT 3111228 Date Range for Notes
               ;S STDT=^TMP("C0CCCR","TIULIMIT") D NOW^%DTC S ENDDT=X
        N FLAGS1,FLAGS2
        S FLAGS1=$P(^C0CPARM(1,2),"^",1) S STDT=$$HTOF^C0CVALID(FLAGS1)
        S FLAGS2=$P(^C0CPARM(1,2),"^",2) S ENDDT=$$HTOF^C0CVALID(FLAGS2)
        ;S STDT=^TMP("C0CCCR","TIULIMIT"),ENDDT=^TMP("C0CCCR","TIUSTART")
               ;;OHUM/RUT
        ;RUT
               S Z=""
               F  S Z=$O(NOTE(Z)) Q:Z=""  D
               . S DT=$P(^TIU(8925,Z,0),U,7)
               . I $G(STDT)]"" D
               .. I STDT>DT S NOTE(Z)="D"  ;SET NOTE TO BE DELETED
               . I $G(ENDDT)]"" D
               .. I ENDDT<DT S NOTE(Z)="D"
               . I NOTE(Z)="D" K NOTE(Z)
        D VISIT
               Q
VISIT     ;GET VISIT INFO FOR A GIVEN NOTE. BUILD INTO RETURN ARRAY .VISIT
        S ILST=1,X0="",X12="",VISIT="",LST="",X811=""
        S IEN=""  F  S IEN=$O(NOTE(IEN)) Q:IEN=""  D
        . S X0=^TIU(8925,IEN,0),X12=$G(^(12))
        . S VISIT=$P(X12,U,7)
        . I 'VISIT S VISIT=$P(X0,U,3)
        . K ^TMP("PXKENC",$J)
        . Q:VISIT=""!(VISIT'>0)
        . D ENCEVENT^PXKENC(VISIT,1)
        . I '$D(^TMP("PXKENC",$J,VISIT,"VST",VISIT,0)) Q
        . S IPRV=0 F  S IPRV=$O(^TMP("PXKENC",$J,VISIT,"PRV",IPRV)) Q:'IPRV  D
        .. S X0=^TMP("PXKENC",$J,VISIT,"PRV",IPRV,0)
        .. ;Q:$P(X0,U,4)'="P"
        .. S CODE=$P(X0,U),NARR=$P($G(^VA(200,CODE,0)),U)
        .. S PRIM=($P(X0,U,4)="P")
        .. S ILST=ILST+1
        .. S LST(ILST)="PRV"_U_CODE_"^^^"_NARR_"^"_PRIM
        .. S VISIT(IEN,"PRV",ILST)=CODE_"^^^"_NARR_"^"_PRIM
        . S IPOV=0 F  S IPOV=$O(^TMP("PXKENC",$J,VISIT,"POV",IPOV)) Q:'IPOV  D
        .. S X0=^TMP("PXKENC",$J,VISIT,"POV",IPOV,0),X802=$G(^(802)),X811=$G(^(811))
        .. S CODE=$P(X0,U)
        .. S:CODE CODE=$P(^ICD9(CODE,0),U)
        .. S CAT=$P(X802,U)
        .. S:CAT CAT=$P(^AUTNPOV(CAT,0),U)
        .. S NARR=$P(X0,U,4)
        .. S:NARR NARR=$P(^AUTNPOV(NARR,0),U)
        .. S PRIM=($P(X0,U,12)="P")
        .. S PRV=$P(X12,U,4)
        .. S ILST=ILST+1
        .. S LST(ILST)="POV"_U_CODE_U_CAT_U_NARR_U_PRIM_U_PRV
        .. S VISIT(IEN,"POV",ILST)=CODE_U_CAT_U_NARR_U_PRIM_U_PRV
        . S ICPT=0 F  S ICPT=$O(^TMP("PXKENC",$J,VISIT,"CPT",ICPT)) Q:'ICPT  D
        .. S X0=^TMP("PXKENC",$J,VISIT,"CPT",ICPT,0),X802=$G(^(802)),X12=$G(^(12)),X811=$G(^(811))
        .. ;S CODE=$P(X0,U)
        .. S CODE=$O(^ICPT("B",$P(X0,U),0))
        .. S:CODE CODE=$P(^ICPT(CODE,0),U)
        .. S CAT=$P(X802,U)
        .. S:CAT CAT=$P(^AUTNPOV(CAT,0),U)
        .. S NARR=$P(X0,U,4)
        .. S:NARR NARR=$P(^AUTNPOV(NARR,0),U)
        .. S QTY=$P(X0,U,16)
        .. S PRV=$P(X12,U,4)
        .. S MCNT=0,MIDX=0,MODS=""
        .. F  S MIDX=$O(^TMP("PXKENC",$J,VISIT,"CPT",ICPT,1,MIDX)) Q:'MIDX  D
        ... S MIEN=$G(^TMP("PXKENC",$J,VISIT,"CPT",ICPT,1,MIDX,0))
        ... I +MIEN S MCNT=MCNT+1,MODS=MODS_";/"_MIEN
        .. I +MCNT S MODS=MCNT_MODS
        .. S ILST=ILST+1
        .. S LST(ILST)="CPT"_U_CODE_U_CAT_U_NARR_U_QTY_U_PRV_U_U_U_MODS
        .. S VISIT(IEN,"CPT",ILST)=CODE_U_CAT_U_NARR_U_QTY_U_PRV_U_U_U_MODS
        . S VISIT(IEN,"DATE",0)=$P($P(^TIU(8925,IEN,0),U,7),".")
        . S VISIT(IEN,"CLASS")=$$GET1^DIQ(8925,IEN_",",.04) ;GPL 5/21/10
        . I $G(TXT)=1 D GETNOTE(IEN)
        Q
GETNOTE(IEN)    ;GET THE TEXT THAT GOES WITH VISIT
        ;EXTRACT NOTE TEXT FROM ^TIU(8925,IEN,"TEXT"
        Q:'$D(VISIT(IEN,"CPT"))
        S TXTCNT=0
        F  S TXTCNT=TXTCNT+1 Q:'$D(^TIU(8925,IEN,"TEXT",TXTCNT,0))  D
        . S VISIT(IEN,"TEXT",TXTCNT)=^TIU(8925,IEN,"TEXT",TXTCNT,0)
        Q
