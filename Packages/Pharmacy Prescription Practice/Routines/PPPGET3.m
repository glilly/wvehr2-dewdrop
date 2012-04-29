PPPGET3 ;ALB/DMB/DAD - MISC GET ROUTINES ; 3/4/92
 ;;V1.0;PHARMACY PRESCRIPTION PRACTICE;**8,17,21**;APR 7,1995
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
GETUCI(GLOBAL) ; Returns the UCI & Volume for the requested global
 ;         as ["UCI","VOL"]
 ;         GLOBAL = "DPT" gets DPT, "TMP" gets TMP
 ;
 N Y
 Q:$S($G(GLOBAL)="DPT":0,$G(GLOBAL)="TMP":0,1:1) ""
 S:GLOBAL="DPT" Y=$P($G(^PPP(1020.1,1,1)),"^")
 S:GLOBAL="TMP" Y=$P($G(^PPP(1020.1,1,1)),"^",2)
 Q "["""_$E(Y,1,3)_""","""_$E(Y,5,7)_"""]"
 ;
GETDOM(SNIFN) ; Returns the network address for institution
 ;
 N DOMIFN,DOMNM
 ;
 ;DAVE B (PPP*1*17 29OCT98)
 ;old way relied on dinummed valued pointer to domain file
 ;
 I $D(^PPP(1020.8,"D",SNIFN)) S SITEIEN=$O(^PPP(1020.8,"D",SNIFN,0)),DOMNM=$P($G(^PPP(1020.8,SITEIEN,0)),"^",2) G DMN
 I $D(^PPP(1020.8,SNIFN)) S DOMNM=$P($G(^PPP(1020.8,SNIFN,0)),"^",2)
 ;
DMN S DOMNM=$G(DOMNM) I $G(DOMNM)="" S DOMNN=" " Q DOMNM
 S LNUM=0 I $G(DOMNM)]"" S LNUM=$O(^PPP(1020.8,"A",DOMNM,0))
 I LNUM S DOMNM=$P(^PPP(1020.128,LNUM,0),"^",2)
 Q DOMNM
 ;
GETXREF() ; Gets patient for edit from FF Xref file or adds new from
 ;         Pateint file
 ;
 N PPPPOP,USRABORT,DIR,DIRUT,RESULT
 ;
 S USRABORT=-1001,PPPPOP=0
 S DIR("A")="Select Patient Name"
 S DIR(0)="P^1020.2:EQMZL"
 W ! D ^DIR
 ;
 I $D(DIRUT) S RESULT=USRABORT
 E  S RESULT=Y
 ;
 W !,"RESULT = ",RESULT
 Q RESULT
 ;
GETINST() ; Gets Institution
 ;
 N PPPPOP,USRABORT,DIR,DIRUT,RESULT
 ;
 S USRABORT=-1001,PPPPOP=0
 S DIR("A")="Select Institution Name: "
 S DIR(0)="FAO^1:30^K:(X'=$C(32)&($L(X)<3)) X"
 S DIR("?")="^D HLPINST1^PPPHLP01"
 S DIR("??")="^D HLPI1^PPPHLP01"
 W ! D ^DIR
 ;
 I $D(DIRUT) S RESULT=USRABORT
 E  S RESULT=Y
 ;
 Q RESULT
 ;
GETSNIFN(STATION,VERBOSE) ;RETURN IFN OF INSTITUTION
 ;THIS WILL RETURN THE SAME INFORMATION THAT DIC RETURNS IN Y
 ;
 N DIC,X,Y,DTOUT,DUOUT,RESULT,USRABORT
 ;
 S USRABORT=-1001
 S:'$D(STATION) STATION=""
 S:'$D(VERBOSE) VERBOSE=0
 S VERBOSE=$S(VERBOSE:"E",1:"")
 ;
 ;USER INTERFACE
 S DIC(0)="M"_VERBOSE
 I STATION="" D
 .S DIC(0)=DIC(0)_"AQ"
 S X=STATION
 S DIC=4
 D ^DIC
 ;
 ;USER ABORTED PROCESS
 ;
 I $D(DTOUT)!($D(DUOUT)) S RESULT=USRABORT
 E  S RESULT=Y
 ;
 Q RESULT
 ;
GETDOMNM(SNIFN) ; -- gets Domain name from DOMAIN file (4.2)
 ;
 ; SNIFN = pointer to domain file
 ;
 Q:SNIFN'?1N.N SNIFN
 ;
 N DIC,DA,DR,DIQ,PPPTMP,NAME
 ;
 I $D(^PPP(1020.8,"B",SNIFN)) S PPPIEN=$O(^PPP(1020.8,"B",SNIFN,0)),NAME=$P($G(^PPP(1020.8,PPPIEN,0)),"^",2)
 S LNUM=0 I $G(NAME)]"" S LNUM=$O(^PPP(1020.128,"A",NAME,0))
 I LNUM S NAME=$P(^PPP(1020.128,LNUM,0),"^",2),DMNNEW=$G(DMNNEW)+1
 ;
 Q $G(NAME)
