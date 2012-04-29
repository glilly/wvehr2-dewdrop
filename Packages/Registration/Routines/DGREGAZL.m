DGREGAZL        ;ALB/DW - ZIP LINKING UTILITY ; 5/27/04 10:54am
        ;;5.3;Registration;**522,560,581,730,760**;Aug 13, 1993;Build 11
        ;
EN(RESULT,DFN)  ;Let user edit zip+4, city, state, county based on zip-linking
        ; Output: RESULT(field#) = User Input External ^ Internal
        K RESULT
        N DGIND,DGTOT
        I $G(DFN)="" S RESULT=-1 Q
        N DGR,DGDFLT,DGALW,DGZIP,DGN
        S DGN=""
        I $$FOREIGN() D  Q
        . D FRGNEDT(.DGR,DFN)
        . I $G(DGR)=-1 S RESULT=-1 Q
        . F DGN=.1112,.114,.115,.117 S RESULT(DGN)=$G(DGR(DGN))
        S DGZIP=$$ZIP(DFN)
        I DGZIP=-1 S RESULT=-1 Q
        S RESULT(.1112)=DGZIP
        S DGIND=$$CITY(.DGR,DGZIP,DFN)
        I DGIND=$G(DGTOT)+1 S DGIND=""
        I $G(DGR)=-1 S RESULT=-1 Q
        S RESULT(.114)=$G(DGR)
        S DGALW=$$ALWEDT^DGREGDD1($G(DUZ),DGZIP)
        I DGALW=1 D
        . K DGR D STCNTY(.DGR,DGZIP,DFN,DGIND)
        . I $G(DGR)=-1 S RESULT=-1 Q
        . S RESULT(.115)=$G(DGR(.115))
        . S RESULT(.117)=$G(DGR(.117))
        I DGALW=0 D
        . I DGZIP'="" D LINK(.DGDFLT,DGZIP,1)
        . S RESULT(.115)=$G(DGDFLT(.115))
        . S RESULT(.117)=$G(DGDFLT(.117))
        Q
ZIP(DFN)        ;Let user input zip+4
ZAGN    N DIR,DTOUT,DUOUT,DIROUT,DGDATA
        S DIR(0)="2,.1112"
        S DA=DFN
        D ^DIR
        I $D(DTOUT) Q -1
        I $D(DUOUT)!$D(DIROUT) D UPCT^DGREGAED G ZAGN
        S DGZIP=$G(Y)
        ;allow bogus zip:
        I $D(^XUSEC("EAS GMT COUNTY EDIT",+DUZ)) Q DGZIP
        I DGZIP="" Q DGZIP
        D POSTALB^XIPUTIL(DGZIP,.DGDATA)
         ;DG*730 - later commented out by DG*760
        ;I $G(DGDATA(1,"CITY ABBREVIATION"))'="",$G(DGDATA(1,"CITY ABBREVIATION"))=$G(DGDATA(2,"CITY")) S DGDATA=1 K DGDATA(2)
        I $D(DGDATA("ERROR")) D  G ZAGN
        . W $C(7)," ??"
        Q DGZIP
CITY(RESULT,ZIP,DFN)    ;Base on zip, let user input city(#.114)
        ; Input:
        ;   ZIP - user input zip for the patient primary address
        ;   DFN - Interal entry number of Patient File (#2)
        ; Output:RESULT=-1 (input error or timed or ^ out)
        ;        or    =user input city
        ;        Array index # of selected city.
        K RESULT
        N DGDATA,DIR,DA,Y,DTOUT,DUOUT,DIROUT,DGIND
        N DGCITY,DGST,DGCNTY,DGABRV,DGN,DGECH,DGSOC
        N DOLDCITY,DGSAME,DGELEVEN
        ; DG*760 brought in DGCITI
        N DGCITI
        S DGIND=""
        D POSTALB^XIPUTIL(ZIP,.DGDATA)
        ;DG*730 - later commented out by DG*760
        ;I $G(DGDATA(1,"CITY ABBREVIATION"))'="",$G(DGDATA(1,"CITY ABBREVIATION"))=$G(DGDATA(2,"CITY")) S DGDATA=1 K DGDATA(2)
        D FIELD^DID(2,.114,"N","LABEL","DGCITY")
        S DGN=""
        I '$D(DGDATA("ERROR")) D
        . S DOLDCITY=$$GET1^DIQ(2,DFN_",",.114)
        . S DGSAME=0
        . F  S DGN=$O(DGDATA(DGN)) Q:DGN=""  D
        .. S DGCITI=$P($G(DGDATA(DGN,"CITY")),"*",1)
        .. S DGABRV=$G(DGDATA(DGN,"CITY ABBREVIATION"))
        .. I DOLDCITY'="",DGCITI=DOLDCITY!(DGABRV=DOLDCITY) S DGSAME=1
        .. ; next 4 commented out lines done by DG*760
        .. ;I DGABRV="" S DGABRV=$P($G(DGDATA(DGN,"CITY")),"*",1)
        .. ;I DOLDCITY'="",DGABRV=DOLDCITY S DGSAME=1
        .. ;I $G(DGDATA(DGN,"CITY"))["*" S:DGABRV'="" DGABRV=DGABRV_"*"
        .. I $G(DGDATA(DGN,"CITY"))["*" S DGCITI=DGCITI_"*"
        .. ;S DGECH=DGN_":"_DGABRV
        .. S DGECH=DGN_":"_DGCITI
        .. S DGSOC=$S($G(DGSOC)="":DGECH,1:DGSOC_";"_DGECH)
        .. S DGTOT=DGN
        .I 'DGSAME S DGELEVEN=$G(^DPT(DFN,.11)) D
        ..Q:$P(DGELEVEN,U,6)'=$G(DGDATA(DGTOT,"POSTAL CODE"))
        ..Q:$P(DGELEVEN,U,14)'="VAMC"
        ..Q:$P(DGELEVEN,U,15)'=$$GETSITE^DGMTU4($G(DUZ))
        ..Q:$P(DGELEVEN,U,17)'>.5
        ..S DGN=DGTOT+1,DGECH=DGN_":"_DOLDCITY,DGSOC=DGSOC_";"_DGECH
        .;
        . I $D(^XUSEC("EAS GMT COUNTY EDIT",+DUZ)) D
        .. S DGSOC=$G(DGSOC)_";"_99_":"_"FREE TEXT"
        . S DIR(0)="SO^"_$G(DGSOC)
        . ;if zip '= zip on file, default = ""; else default=city on file
        . ;I ($G(DFN)'="")&($E(ZIP,1,5)=$$GET1^DIQ(2,DFN_",",.116)) D
        . S DIR("B")=$$GET1^DIQ(2,DFN_",",.114)
        . S DIR("A")=$G(DGCITY("LABEL"))
CAGN1   . D ^DIR
        . I $D(DTOUT) S RESULT=-1 Q
        . I $D(DUOUT)!$D(DIROUT) D UPCT^DGREGAED G CAGN1
        . S RESULT=$P($G(Y(0)),"*")
        . S DGIND=$G(Y)
        I ($G(Y)=99)!($D(DGDATA("ERROR"))) D
CAGN2   . I '$D(^XUSEC("EAS GMT COUNTY EDIT",+DUZ)) Q
        . N DIR,X,Y
        . S DIR(0)="2,.114"
        . S DA=DFN
        . D ^DIR
        . I $D(DTOUT) S RESULT=-1 Q
        . I $D(DUOUT)!$D(DIROUT) D UPCT^DGREGAED G CAGN2
        . S RESULT=$G(Y)
        I $L($G(RESULT))>15 D
        . S DGN=Y
        . S RESULT=$G(DGDATA(DGN,"CITY ABBREVIATION"))
        Q DGIND
        ;
LINK(RESULT,ZIP,DGN)    ;From zip, get the linked state,county
        K RESULT
        N DGDATA,CNTYIEN
        S CNTYIEN=""
        S DGN=$G(DGN)
        I (DGN="")&($$MLT^DGREGDD1(ZIP)) S DGN=1
        I (DGN=99)&($$MLT^DGREGDD1(ZIP)) S DGN=1
        I (DGN="")!(DGN=99) Q
        D POSTALB^XIPUTIL(ZIP,.DGDATA)
        S:$G(DGDATA(DGN,"STATE POINTER"))'="" CNTYIEN=$$FIND1^DIC(5.01,","_$G(DGDATA(DGN,"STATE POINTER"))_",","MOXQ",$E($G(DGDATA(DGN,"FIPS CODE")),3,5),"C")
        D:'CNTYIEN  ;could be duplicate county codes in subfile #5.01
        .Q:'$D(^DIC(5,+$G(DGDATA(DGN,"STATE POINTER")),1))
        .Q:$E($G(DGDATA(DGN,"FIPS CODE")),3,5)=""
        .S CNTYIEN=$O(^DIC(5,$G(DGDATA(DGN,"STATE POINTER")),1,"C",$E($G(DGDATA(DGN,"FIPS CODE")),3,5),""))
        S RESULT(.115)=$G(DGDATA(DGN,"STATE"))_U_$G(DGDATA(DGN,"STATE POINTER"))
        S RESULT(.117)=$G(DGDATA(DGN,"COUNTY"))_U_$G(CNTYIEN)_U_$E($G(DGDATA(DGN,"FIPS CODE")),3,5)
        Q
        ;
STCNTY(RESULT,ZIP,DFN,DGNUM)    ;Based on zip,input state (#.115) and county (#.117)
        K RESULT
        S DGNUM=$G(DGNUM)
        N DGN,DGDFLT,DGST,POP,DIR,X,Y,DTOUT,DUOUT,DIROUT
        S POP=0
        D LINK(.DGDFLT,ZIP,DGNUM)
        F DGN=.115,.117 Q:POP  D
SCAGN   . I DGN=.115 S DIR(0)=2_","_DGN
        . I ($G(DGST)="")&(DGN=.117) Q
        . I DGN=.117 S DIR(0)="POA^DIC(5,DGST,1,:AEMQ"
        . S DIR("B")=$P($G(DGDFLT(DGN)),U)
        . D ^DIR
        . I $D(DTOUT) S POP=1 Q
        . I $D(DUOUT)!$D(DIROUT) D UPCT^DGREGAED G SCAGN
        . S RESULT(DGN)=$P($G(Y),U,2)_U_$P($G(Y),U)
        . I DGN=.115 S DGST=$P($G(Y),U)
        . I DGN=.117 S RESULT(.117)=$$CNTY(DGST,$P($G(RESULT(.117)),U,2))
        I POP=1 S RESULT=-1
        Q
CNTY(DGST,DGCIEN)       ;Return county name and code
        ;Input:state number and county IEN
        ;Output: CountyName^CountyIEN^CountyCode
        I ($G(DGST)="")!($G(DGCIEN)="") S RESULT=-1 Q RESULT
        N DGR,RESULT
        S DGR=$G(^DIC(5,DGST,1,DGCIEN,0))
        S RESULT=$P($G(DGR),U)_U_DGCIEN_U_$P($G(DGR),U,3)
        Q RESULT
FOREIGN()       ;Manila (Philippines) doesn't need zip linking.
        ;Output: 1 - area need no zip linking
        ;        0 - zip-linking area
        I $$STA^XUAF4(+$$KSP^XUPARAM("INST"))=358 Q 1
        ;;;I $$STA^XUAF4(+$$KSP^XUPARAM("INST"))=500 Q 1 ;;HERE TEST
        Q 0
FRGNEDT(DGINPUT,DFN)    ;Edit zip+4, city, state, county for no zip-linking area
        K DGINPUT
        N DGN,DIR,DTOUT,DUOUT,DIROUT,X,Y,POP,DGST
        S POP=0
        F DGN=.1112,.114,.115,.117 Q:POP  D
FAGN    . I ($G(DGST)="")&(DGN=.117) Q
        . S DIR(0)=2_","_DGN
        . I DGN=.117 D
        .. S DIR(0)="POA^DIC(5,DGST,1,:AEMQ"
        .. S DIR("B")=$$GET1^DIQ(2,DFN_",",.117)
        . I DGN'=.117 S DA=DFN
        . D ^DIR
        . I $D(DTOUT) S POP=1 Q
        . I $D(DUOUT)!$D(DIROUT) D UPCT^DGREGAED G FAGN
        . I (DGN=.114)!(DGN=.1112) S DGINPUT(DGN)=$G(Y)
        . I (DGN=.115) D
        .. S DGST=$P($G(Y),U)
        .. I DGST=$$GET1^DIQ(2,DFN_",",.115,"I") D
        ... S DGINPUT(.115)=$$GET1^DIQ(2,DFN_",",.115)_U_DGST
        .. I DGST'=$$GET1^DIQ(2,DFN_",",.115,"I") D
        ... S DGINPUT(.115)=$P($G(Y(0)),U)_U_DGST
        . I DGN=.117 S DGINPUT(DGN)=$P($G(Y),U,2)_U_$P($G(Y),U)
        I POP=1 S RESULT=-1
        Q
