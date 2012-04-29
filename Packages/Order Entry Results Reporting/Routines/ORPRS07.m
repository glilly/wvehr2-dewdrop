ORPRS07 ; slc/dcm - Managing multiple reportz ;6/10/97  15:43
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**281**;Dec 17, 1997;Build 14
EN      ;Entry point
        N ORVP
        D MAIN("")
        Q
MAIN(ORVP)      ; Controls branching
        N DFN,DIC,GMTYP,I,ORANSI,ORDG,OREND,ORH,ORH2,ORPRES,ORSCPAT,ORSDG
        N ORSHORT,ORSRI,ORSRPT,ORSSTOP,ORSSTRT,ORTIT,ORWHL,VAROOT,XQORSPEW,X,Y
        N ORAGE,ORATTEND,ORDOB,ORL,ORNP,ORPD,ORPNM,ORPV,ORSEX,ORSSN,ORTS,ORWARD
        N ORSDG,ORURMBD,ORX,ORCONT,OROPREF
        I '+$G(ORVP) D P^ORPRS01 Q:$D(ORSCPAT)'>9
        S ORANSI=0,XQORFLG("SH")=1
        S (ORANSI,OREND,X)=0
        I +$G(ORSCPAT)=1,+$G(ORSCPAT(1)) S ORVP=+$G(ORSCPAT(1))_";DPT(",Y=+ORVP D HOMO^ORUDPA
        S DIC=101 S X="ORS REPORT MENU" D EN^XQOR
        K VA200,VAERR,VAIN,VADM
        Q
EXIT    ; Queue output
        N DUOUT,ORSRI,ORSRPT,ZTDESC,ZTRTN,ZTSAVE S OREND=+$G(OREND)
        S ORSRI=0 F  S ORSRI=$O(Y(ORSRI)) Q:ORSRI'>0  S ORSRPT=ORSRI,ORSRPT(ORSRI)=Y(ORSRI)
        I $S($D(XQORPOP):1,$G(OREND)=1:1,$D(DUOUT):1,$D(DIROUT):1,'$D(ORSRPT):1,'$D(ORSCPAT)&'+$G(ORVP):1,1:0) Q
        S (ZTSAVE("OR*"),ZTSAVE("GM*"),ZTSAVE("LR*"))="",IO("Q")=1
        S ZTRTN="OUTPUT^ORPRS07",ZTDESC="Results Reporting" W ! D DEVICE
        Q
OUTPUT  ; Loops through ORSRPT( and queues each report
        N DIROUT,DIRUT,ORH,ORH2,ORMETHOD,ORSEND,ORSHORT,ORSI,ORSJ,ORSRI,ORTIT,ORWHL,X
        N XQORNOD,XQORSPEW,XY,ORSLTR,ORSPNM,ORDG,ORION S ORION=$G(ION)
        I +$G(ORVP) D REPORT(ORVP) K OROLOC,ORSSTOP,ORSSTRT,VAROOT,VA,X1 Q
        S ORSI=0 F  S ORSI=$O(ORSCPAT(ORSI)) Q:ORSI'>0!($G(DIROUT))!($$S^%ZTLOAD)  S:'$O(ORSCPAT(ORSI)) ORSEND=1  D
        . S ORVP=+ORSCPAT(ORSI)_";DPT(",ORSPNM=$P(ORSCPAT(ORSI),U,2)
        . D REPORT(ORVP)
        K ORNO,ORSPG
        Q
REPORT(ORVP)    ; Loops through ORSRPT( and prints all reports for ea patient
        N ORSJ,ORSSTFLG,XQORNOD
        U IO
        S ORSJ=0 F  S ORSJ=$O(ORSRPT(ORSJ)) Q:ORSJ'>0!+$G(DIROUT)!$G(OREND)  D
        . S XQORNOD=$P(ORSRPT(ORSJ),U,2)_";ORD(101,",ORMETHOD=$G(^ORD(101,+XQORNOD,101.05,20,1))
        . I $D(ORSSTRT)>9,+XQORNOD S ORSSTRT=+$G(ORSSTRT(+XQORNOD)),ORH=$P($G(ORSSTRT(+XQORNOD)),U,2)
        . I $D(ORSSTOP)>9,+XQORNOD S ORSSTOP=+$G(ORSSTOP(+XQORNOD)),ORH2=$P($G(ORSSTOP(+XQORNOD)),U,2)
        . I $D(ORSDG(+XQORNOD)) S ORDG=$G(ORSDG(+XQORNOD))
        . I $L(ORMETHOD) X ORMETHOD I $G(ION)'=ORION S IOP=ORION D ^%ZIS
        . I +$G(ORSSTFLG) D STOP^ORPRS01 S ORSSTFLG=0
        Q
DEVICE  ; Device Handling/Output control
        N IO,IOP,%ZIS
        S %ZIS="Q",%ZIS("B")="HOME" D ^%ZIS Q:POP
        I +$G(ORSRPT)>1,(IO'=IO(0)),'$D(IO("Q")) W !,"Printing of multiple reports requires queueing.",!
        D @$S(+$G(ORSRPT)>1&(IO'=IO(0)):"QUE",$D(IO("Q")):"QUE",1:"NOQUE")
        Q
QUE     ; Set ZT parameters and tasks ZTRTN
        N ZTIO K IO("Q")
        S ZTIO=ION
        D ^%ZTLOAD W !,$S($D(ZTSK):"Request Queued!",1:"Request Cancelled!")
        K ZTSK,ZTDESC,ZTDTH,ZTIO,ZTRTN,ZTSAVE D ^%ZISC
        Q
NOQUE   ; Calls ZTRTN in interactive mode
        I IO'=IO(0) U IO
        D @ZTRTN
        D ^%ZISC
        Q
