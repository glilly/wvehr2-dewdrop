PSOQUAP ;HINES/RMS - UNIFIED PROFILE BASED ON PORTLAND IDEA ; 30 Nov 2007  7:57 AM
        ;;7.0;OUTPATIENT PHARMACY;**294**;DEC 1997;Build 13
        ;
        ;Reference to BCMALG^PSJUTL2 supported by DBIA 5057
        ;Reference to CKP^GMTSUP supported by DBIA 4231
        ;Reference to COVER^ORWPS supported by DBIA 4954
EN      ;ENTRY POINT FOR HEALTH SUMMARY
        N RPC,RPCT,ALPHA,PSNUM,DRUGNM,RPCNODE,ORDER,SAVE
        D COVER^ORWPS(.RPC,DFN)
        S RPCT=0 F  S RPCT=$O(RPC(RPCT)) Q:'+RPCT  D  ;
        . S RPCNODE=RPC(RPCT)
        . S PSNUM=$P(RPCNODE,"^")
        . S DRUGNM=$$UP^XLFSTR($P(RPCNODE,"^",2))
        . S ORDER=+$P(RPCNODE,"^",3)
        . K SAVE(DRUGNM) S SAVE(DRUGNM,ORDER,PSNUM)=""
        . Q:"ACTIVE^ACTIVE/SUSP"'[$P(RPCNODE,"^",4)
        . S ALPHA(DRUGNM,ORDER,PSNUM)=""
        D HEADER
        D OUTPUT
        D FOOTER
        Q
HEADER  N ATEST,ADATE,AVALUE,ATEXT
        D NVADT^PSOQCF04(DFN,.ATEST,.ADATE,.AVALUE,.ATEXT)
        D CKP^GMTSUP Q:$D(GMTSQIT)
        W $$REPEAT^XLFSTR("-",IOM),!,"Alphabetical list of all prescriptions, inpatient orders and Non-VA meds"
        D CKP^GMTSUP Q:$D(GMTSQIT)
        W !,"Legend: OPT = VA issued outpatient prescription, INP = VA issued inpatient order"
        D CKP^GMTSUP Q:$D(GMTSQIT)
        W !,"Non-VA Meds Last Documented On: "
        W $S(+ADATE:$$FMTE^XLFDT(ADATE,"D"),1:"** Data not found **")
        D CKP^GMTSUP Q:$D(GMTSQIT)
        W !,$$REPEAT^XLFSTR("-",IOM)
        D CKP^GMTSUP Q:$D(GMTSQIT)
        Q
OUTPUT  N DRUGNM,ORDER,PSNUM
        N PACK,PACKREF,SIGLINE,ORDNUM
        N LASTACT,OTLINE
        S DRUGNM="" F  S DRUGNM=$O(ALPHA(DRUGNM)) Q:DRUGNM']""  D  K SAVE(DRUGNM)  ;
        . S ORDER="" F  S ORDER=$O(ALPHA(DRUGNM,ORDER)) Q:ORDER']""  D  ;
        .. S PSNUM="" F  S PSNUM=$O(ALPHA(DRUGNM,ORDER,PSNUM)) Q:PSNUM']""  D  ;
        ... S PACK=$P(PSNUM,";",2),ORDNUM=$P(PSNUM,";")
        ... I PACK="I" D INPDISP
        ... I PACK="O" D OPTDISP
        Q
FOOTER  D CKP^GMTSUP Q:$D(GMTSQIT)
        N BLINE
        S BLINE=$$REPEAT^XLFSTR("-",IOM)
        W !,BLINE,!,"Other medications previously dispensed in the last year:",!
        D CKP^GMTSUP Q:$D(GMTSQIT)
        N DRUGNM,ORDER,PSNUM
        N PACK,PACKREF,SIGLINE
        S DRUGNM="" F  S DRUGNM=$O(SAVE(DRUGNM)) Q:DRUGNM']""  D  ;
        . S ORDER="" F  S ORDER=$O(SAVE(DRUGNM,ORDER)) Q:ORDER']""  D  ;
        .. S PSNUM="" F  S PSNUM=$O(SAVE(DRUGNM,ORDER,PSNUM)) Q:PSNUM']""  D  ;
        ... S PACK=$P(PSNUM,";",2)
        ... I PACK="O" D OPTFOOT
        Q
OPTFOOT N PSOQLRD,PSOQYEAR
        S PACKREF=+$G(^OR(100,ORDER,4))
        S X1=DT,X2=-365 D C^%DTC S PSOQYEAR=X
        S PSOQLRD=$$LRDFUNC^PSOQ0076(PACKREF)
        D CKP^GMTSUP Q:$D(GMTSQIT)
        Q:PSOQLRD<PSOQYEAR
        Q:$P(PSNUM,";")["N"
        W !,"OPT "_DRUGNM_" ("_$$GET1^DIQ(52,+PACKREF,100,"E")_"/"_$$DAYSSUPP^PSOQ0076(PACKREF)_" Days Supply Last Released: "_$$FMTE^XLFDT(PSOQLRD,"2D")_")"  D CKP^GMTSUP Q:$D(GMTSQIT)
        S SIGLINE=0 F  S SIGLINE=$O(^PSRX(PACKREF,"SIG1",SIGLINE)) Q:'+SIGLINE  D  ;
        . W !?5,$G(^PSRX(PACKREF,"SIG1",SIGLINE,0)) D CKP^GMTSUP Q:$D(GMTSQIT)
        W ! D CKP^GMTSUP Q:$D(GMTSQIT)
        Q
INPDISP D CKP^GMTSUP Q:$D(GMTSQIT)
        W !,"INP "_DRUGNM D CKP^GMTSUP Q:$D(GMTSQIT)
        S LASTACT=$O(^OR(100,+ORDER,8,":"),-1)
        S OTLINE=1 F  S OTLINE=$O(^OR(100,+ORDER,8,LASTACT,.1,OTLINE)) Q:'+OTLINE  D  ;
        . W !?5,$$LSIG^PSOQUTIL($G(^OR(100,+ORDER,8,LASTACT,.1,OTLINE,0))) D CKP^GMTSUP Q:$D(GMTSQIT)
        . W !?5,$$BCMALG^PSJUTL2(DFN,ORDNUM) D CKP^GMTSUP Q:$D(GMTSQIT)
        W ! D CKP^GMTSUP Q:$D(GMTSQIT)
        Q
OPTDISP N PSOQEXP,PSOQREF
        D CKP^GMTSUP Q:$D(GMTSQIT)
        S PACKREF=+$G(^OR(100,ORDER,4))
        S PSOQLRD=$$LRDFUNC^PSOQ0076(PACKREF)
        S PSOQEXP=$$EXPDATE^PSOQ0076(PACKREF)
        S PSOQREF=$$REFILLS^PSOQ0076(PACKREF)
        I $P(PSNUM,";")["N" G NVADISP
        W !,"OPT "_DRUGNM
        S SIGLINE=0 F  S SIGLINE=$O(^PSRX(PACKREF,"SIG1",SIGLINE)) Q:'+SIGLINE  D  ;
        . W !?5,$G(^PSRX(PACKREF,"SIG1",SIGLINE,0)) D CKP^GMTSUP Q:$D(GMTSQIT)
        W !?15,"Last Released: "_$$FMTE^XLFDT(PSOQLRD,"2D"),?55,"Days Supply: "_$$DAYSSUPP^PSOQ0076(PACKREF) D CKP^GMTSUP Q:$D(GMTSQIT)
        W !?15,"Rx Expiration Date: ",$$FMTE^XLFDT(PSOQEXP,"2D"),?55,"Refills Remaining: ",PSOQREF D CKP^GMTSUP Q:$D(GMTSQIT)
        W ! D CKP^GMTSUP Q:$D(GMTSQIT)
        Q
NVADISP D CKP^GMTSUP Q:$D(GMTSQIT)
        W !,"Non VA "_DRUGNM D CKP^GMTSUP Q:$D(GMTSQIT)
        S LASTACT=$O(^OR(100,ORDER,8,":"),-1)
        S OTLINE=1 F  S OTLINE=$O(^OR(100,ORDER,8,LASTACT,.1,OTLINE)) Q:'+OTLINE  D  ;
        . W !?5,$G(^OR(100,ORDER,8,LASTACT,.1,OTLINE,0)) D CKP^GMTSUP Q:$D(GMTSQIT)
        W ! D CKP^GMTSUP Q:$D(GMTSQIT)
        Q
