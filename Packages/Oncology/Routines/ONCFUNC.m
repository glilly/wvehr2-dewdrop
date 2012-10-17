ONCFUNC ;Hines OIFO/GWB - OncoTrax functions ;06/23/10
        ;;2.11;ONCOLOGY;**24,25,26,27,28,30,32,33,35,36,41,49,51**;Mar 07, 1995;Build 65
        ;
SHN()   ;STATE HOSPITAL NUMBER (160.1,1.03)
        N OSP,SHN
        S OSP=$O(^ONCO(160.1,"C",DUZ(2),0))
        I OSP="" S OSP=$O(^ONCO(160.1,0))
        S SHN=$$GET1^DIQ(160.1,OSP,1.03,"I")
        Q SHN
        ;
IIN()   ;INSTITUTION ID NUMBER (160.1,27)
        N IIN,OSP
        S OSP=$O(^ONCO(160.1,"C",DUZ(2),0))
        I OSP="" S OSP=$O(^ONCO(160.1,0))
        S IIN=$$GET1^DIQ(160.1,OSP,27,"I")
        S IIN=$$GET1^DIQ(160.19,IIN,.01,"I")
        Q IIN
        ;
FLNAME(NAME)    ;COMPUTED EXPRESSION for FIRST-LAST (160,.012)
        N DFN,FIRST,LAST,MIDDLE,PL,SUFFIX,TNAME
        S TNAME=NAME,DFN=D0
        S LAST=$P(TNAME,","),TNAME=$P(TNAME,",",2)
        S FIRST=$P(TNAME," "),MIDDLE=$P(TNAME," ",2)
        S SUFFIX=$P(TNAME," ",3)
        I MIDDLE["""" S MIDDLE=""
        S TNAME=FIRST_" "_MIDDLE_" "_LAST_" "_SUFFIX
SP      I $F(TNAME,"  ") S PL=$F(TNAME,"  "),TNAME=$E(TNAME,1,PL-2)_$E(TNAME,PL,$L(TNAME)) G SP
        Q TNAME
        ;
DIV(IEN)        ;DIVISION (165.5,2000)
        N DIV
        S DIV=$G(^ONCO(165.5,IEN,"DIV"))
        Q DIV
        ;
SUSDIV(IEN,SUSIEN)      ;DIVISION (160,30)
        N DIV
        S DIV=$P($G(^ONCO(160,IEN,"SUS",SUSIEN,0)),U,4)
        Q DIV
        ;
PFTD(IEN)       ;Primaries for this division
        N PFTD,PRI
        S PFTD="N"
        S PRI=0 F  S PRI=$O(^ONCO(165.5,"C",IEN,PRI)) Q:PRI'>0  I $P($G(^ONCO(165.5,PRI,"DIV")),U,1)=DUZ(2) S PFTD="Y"
        Q PFTD
        ;
PRICNT  ;TOTAL PRIMARIES FOR PATIENT (160,17)
        S PRI=0,PRICNT=0 F  S PRI=$O(^ONCO(165.5,"C",D0,PRI)) Q:PRI'>0  I $P($G(^ONCO(165.5,PRI,"DIV")),U,1)=DUZ(2) D
        .S PRICNT=PRICNT+1
        S X=PRICNT
        K PRI,PRICNT
        Q
        ;
DIDIV(IEN)      ;Disease Index DIVISION screen
        ;Supported by IAs #417 and #2028
        N DIVMATCH
        S DIVMATCH="N"
        S VIPNT=$P($G(^AUPNVPOV(D0,0)),U,3) G:VIPNT="" DIDIVEX
        S HLPNT=$P($G(^AUPNVSIT(VIPNT,0)),U,22) G:HLPNT="" DIDIVEX
        S MCPNT=$P($G(^SC(HLPNT,0)),U,15) G:MCPNT="" DIDIVEX
        S INPNT=$P($G(^DG(40.8,MCPNT,0)),U,7)
        I (INPNT=DUZ(2))!(AFLDIV[INPNT) S DIVMATCH="Y"
DIDIVEX K HLPNT,INPNT,MCPNT,VIPNT
        Q DIVMATCH
        ;
HIST(IEN,HSTFLD,HISTNAM,ICDFILE,ICDNUM) ;
        ;Histology ICD-O-2 (165.5,22) or Histology ICD-O-3 (165.5,22.3)
        N HISTICD,HNODE,ONCDTDX
        S ONCDTDX=$P($G(^ONCO(165.5,IEN,0)),U,16)
        S ICDNUM=3 I ONCDTDX<3010000 S ICDNUM=2
        S HNODE=$S(ICDNUM=3:2.2,1:2),ICDFILE=$S(ICDNUM=3:169.3,1:164.1)
        S HSTFLD=$S(ICDNUM=3:22.3,1:22)
        S HISTICD=$P($G(^ONCO(165.5,IEN,HNODE)),U,3)
        S HISTNAM=""
        I HISTICD'="" S HISTNAM=$P($G(^ONCO(ICDFILE,HISTICD,0)),U,1)
        Q HISTICD
        ;
LYMPHOMA(IEN)   ;Hodgkin and non-Hodgkin Lymphomas
        N LYMPHOMA
        S LYMPHOMA=0
        S ONCDTDX=$P($G(^ONCO(165.5,IEN,0)),U,16)
        S HSTICD=$$HIST^ONCFUNC(IEN)
        S HST123=$E(HSTICD,1,3)
        I ONCDTDX<3010000,(HST123>958)&(HST123<972) S LYMPHOMA=1
        I ONCDTDX>3001231,(HST123>958)&(HST123<973) S LYMPHOMA=1
        I ONCDTDX>3091231,(HSTICD=97353)!(HSTICD=97373)!(HSTICD=97383) S LYMPHOMA=1
        K HST123,HSTICD,ONCDTDX
        Q LYMPHOMA
        ;
LYMPH(IEN)      ;Lymphomas
        N LYMPHOMA
        S LYMPHOMA=0
        S ONCDTDX=$P($G(^ONCO(165.5,IEN,0)),U,16)
        S HSTICD=$$HIST^ONCFUNC(IEN)
        S HST14=$E(HSTICD,1,4)
        I ONCDTDX<3100000 D
        .I ((HST14>9589)&(HST14<9597))!((HST14>9649)&(HST14<9720))!((HST14>9726)&(HST14<9730)) S LYMPHOMA=1
        I ONCDTDX>3091221 D
        .I ((HST14>9589)&(HST14<9727))!((HST14>9727)&(HST14<9733))!((HST14>9733)&(HST14<9741))!((HST14>9749)&(HST14<9763))!((HST14>9810)&(HST14<9832))!(HST14=9940)!(HST14=9980)!(HST14=9971) S LYMPHOMA=1
        K HST14,HSTICD,ONCDTDX
        Q LYMPHOMA
        ;
HEMATO(IEN)     ;Hematopoietic, reticuloendothelial, immunoproliferative or
        ; myeloproliferative disease
        N HEMATO
        S HEMATO=0
        S ONCDTDX=$P($G(^ONCO(165.5,IEN,0)),U,16)
        S HSTICD=$$HIST^ONCFUNC(IEN)
        S HST14=$E(HSTICD,1,4)
        I ONCDTDX<3100000 D
        .I (HST14=9750)!((HST14>9759)&(HST14<9765))!((HST14>9799)&(HST14<9821))!(HST14=9826)!((HST14>9830)&(HST14<9921))!((HST14>9930)&(HST14<9965))!((HST14>9979)&(HST14<9990)) S HEMATO=1
        I ONCDTDX>3091221 D
        .I (HST14=9727)!(HST14=9733)!(HST14=9741)!(HST14=9742)!((HST14>9763)&(HST14<9810))!(HST14=9832)!((HST14>9839)&(HST14<9932))!(HST14=9945)!(HST14=9946)!((HST14>9949)&(HST14<9968))!((HST14>9974)&(HST14<9993)) S HEMATO=1
        K HST14,HSTICD,ONCDTDX
        Q HEMATO
        ;
CC      ;COMORBIDITY/COMPLICATION #1-10 (160,25-25.9) screen
        I $E($P(^ICD9(Y,0),U,1),1)="V",+($E($P(^ICD9(Y,0),U,1),2,9)>7.1)&+($E($P(^ICD9(Y,0),U,1),2,9)<7.4) Q 
        I $E($P(^ICD9(Y,0),U,1),1)="V",+($E($P(^ICD9(Y,0),U,1),2,9)>9.91)&+($E($P(^ICD9(Y,0),U,1),2,9)<16) Q 
        I $E($P(^ICD9(Y,0),U,1),1)="V",+($E($P(^ICD9(Y,0),U,1),2,9)>21.9)&+($E($P(^ICD9(Y,0),U,1),2,9)<23.2) Q 
        I $E($P(^ICD9(Y,0),U,1),1)="V",+($E($P(^ICD9(Y,0),U,1),2,9)>25.3)&+($E($P(^ICD9(Y,0),U,1),2,9)<25.5) Q 
        I $E($P(^ICD9(Y,0),U,1),1)="V",+($E($P(^ICD9(Y,0),U,1),2,9)>43.89)&+($E($P(^ICD9(Y,0),U,1),2,9)<46) Q 
        I $E($P(^ICD9(Y,0),U,1),1)="V",+($E($P(^ICD9(Y,0),U,1),2,9)>50.4)&+($E($P(^ICD9(Y,0),U,1),2,9)<50.8) Q 
        I $E($P(^ICD9(Y,0),U,1),1)'="V",$E($P(^ICD9(Y,0),U,1),1)="E",($E($P(^ICD9(Y,0),U,1),2,9)>869.9)&($E($P(^ICD9(Y,0),U,1),2,9)<880) Q 
        I $E($P(^ICD9(Y,0),U,1),1)'="V",$E($P(^ICD9(Y,0),U,1),1)="E",($E($P(^ICD9(Y,0),U,1),2,9)>929.9)&($E($P(^ICD9(Y,0),U,1),2,9)<950) Q 
        I $E($P(^ICD9(Y,0),U,1),1)'="V",$E($P(^ICD9(Y,0),U,1),1)'="E",($P(^ICD9(Y,0),U,1)<140)!($P(^ICD9(Y,0),U,1)>239.9) Q
        Q
        ;
DSTS(IEN)       ;DATE SYSTEMIC THERAPY STARTED
        N X
        S X=$$GET1^DIQ(165.5,IEN,53,"I") I X'="" S DSTSDT(X)=""
        S X=$$GET1^DIQ(165.5,IEN,54,"I") I X'="" S DSTSDT(X)=""
        S X=$$GET1^DIQ(165.5,IEN,55,"I") I X'="" S DSTSDT(X)=""
        S DSTS=$O(DSTSDT(0))
        S X=$$DATE^ONCACDU1(DSTS)
        K DSTS,DSTSDT
        Q X
        ;
DUPPRI  ;Check for duplicate primaries belonging to another DIVISION
        K TMP
        S XD1=0
        F  S XD1=$O(^ONCO(165.5,"C",XD0,XD1)) Q:XD1'>0  D
        .S PS=$$GET1^DIQ(165.5,XD1,20,"I")
        .S SN=$$GET1^DIQ(165.5,XD1,.06,"I")
        .S DIV=$$GET1^DIQ(165.5,XD1,2000,"I")
        .S TMP(PS_U_SN,DIV)=XD1
        .S TMP(PS_U_SN)=$G(TMP(PS_U_SN))+1
        S PSSN="" F  S PSSN=$O(TMP(PSSN)) Q:PSSN'>0  I TMP(PSSN)>1 D
        .S DIV="" F  S DIV=$O(TMP(PSSN,DIV)) Q:DIV'>0  I DIV=DUZ(2) D  Q 
        ..W !
        ..W !," NOTE: This patient has more than one primary with the same"
        ..W !,"       SEQUENCE NUMBER and PRIMARY SITE.  These primaries"
        ..W !,"       belong to different divisions.  You may wish to notify"
        ..W !,"       the other division of any significant changes for this patient."
        ..W !
        ..S J=0,XD1=0 F  S XD1=$O(^ONCO(165.5,"C",XD0,XD1)) Q:XD1'>0  I $D(^ONCO(165.5,XD1,0)) S J=J+1 D ^ONCOCOML
        ..K DIR S DIR(0)="E" D ^DIR
        K DIR,DIV,J,PS,PSSN,SN,TMP,XD0,XD1
        ;
CLEANUP ;Cleanup
        K AFLDIV,D0,Y
