PSOQMCAL        ; SEA/HAM3 PMI - PHARMACY MEDICATION INSTRUCTION ; 30 Nov 2007  7:55 AM
        ;;7.0;OUTPATIENT PHARMACY;**294**;DEC 1997;Build 13
        ;
        ;Reference to CKP^GMTSUP supported by DBIA 4231
        ;Reference to COVER^ORWPS supported by DBIA 4954
        ;Credit to Herb Morriss and Al Hernandez for the original design
        ;Puget Sound Health Care System, Seattle WA
EN      N PSOQPEND,DAYSEP,DRUGHDR1,DRUGHDR2,DRUGSEP,INSTSEP1,INSTSEP2,INSTSEP3
        N EMPTYLN,PRETYPE,SUPTYPE,ADDR,AL,ALFLAG,ARLDASH
        N ARLDATE,ARLDFN,ARLDOB,ARLNAME,ARLSITE,ARLSN
        N BLANKLN,BLNKLN,DRUG1,FOOD,GMRAL,IDRUG,ISIG,ITYPE
        N NVA,NONE,PAGE,PGWIDTH,PGLENGTH,PHONE
        N RXIEN,SIGCNT,SIGPOS,XPOS1,XPOS2,XPOS3,XPOS4
        N FN,HP,IA,RPTDATE,TYPE,WP,ST,SUPCNT,SUPDRUG,X,X1,X2,ADDRFL
        N DIWF,DIWL,DIWR,INSTSEP1,INSTSEP2,INSTSEP3,DRUGHDR1,DRUGHDR2,DRUGSEP
        S PGWIDTH=IOM-5,PGLENGTH=IOSL-9
        Q:PGWIDTH<48  ;ensure that the IOM variable is wide enough
        S RPTDATE=$$FMTE^XLFDT($$NOW^XLFDT,"1D")
        S XPOS1=(PGWIDTH-26)\2  ;title
        S XPOS2=PGWIDTH-6       ;page number
        S XPOS3=(PGWIDTH-29)\2  ;site
        S XPOS4=(PGWIDTH-53)\2  ;refill info
        S BLANKLN="",$P(BLNKLN," ",PGWIDTH)=" "
        S EMPTYLN="!,""|"_$E(BLNKLN,1,PGWIDTH-2)_"|"""
        S DAYSEP="|       |       |       |       |"
        S DRUGHDR1="|                 |MORNING| NOON  |EVENING|BEDTIME|       COMMENTS"
        S DRUGHDR1=DRUGHDR1_$E(BLNKLN,$L(DRUGHDR1),PGWIDTH-2)_"|"
        S DRUGHDR2="|                 "_DAYSEP
        S DRUGHDR2=DRUGHDR2_$E(BLNKLN,$L(DRUGHDR2),PGWIDTH-2)_"|"
        S $P(DRUGSEP,"~",PGWIDTH-2)="~"
        S DRUGSEP="|"_DRUGSEP_"|"
        S $P(INSTSEP1,"-",PGWIDTH-2)="-"
        S INSTSEP1="|"_INSTSEP1_"|"
        S INSTSEP2="| UNITS PER DOSE: "_DAYSEP
        S INSTSEP2=INSTSEP2_$E(BLNKLN,$L(INSTSEP2),PGWIDTH-2)_"|"
        S INSTSEP3="|                 "_DAYSEP
        S INSTSEP3=INSTSEP3_$E(BLNKLN,$L(INSTSEP3),PGWIDTH-2)_"|"
        S X1=DT,X2=-45 D C^%DTC S ARLDATE=X
1       ;Patient
        S ARLDFN=""
        F IA=1:1 S ARLDFN=$P(ARLPAT,";",IA) Q:ARLDFN=""  D
        . S PAGE=1
        . D HD,SHOW(ARLDFN)
        Q
SHOW(PTIEN)     ;
        N LIST,NVA
        D COVER^ORWPS(.LIST,PTIEN)
        D GETOPORD(.LIST)
        D GETRXDAT(.LIST)
        S SUPTYPE=0,PRETYPE="D"
        S ITYPE="@"
        F  S ITYPE=$O(LIST(ITYPE)) Q:ITYPE]"ZZZ"  Q:ITYPE=""  D
        . I PRETYPE'=ITYPE D
        . . W !,DRUGSEP
        . . W @EMPTYLN
        . . W !,"|","SUPPLY ITEMS:"_$E(BLNKLN,14,PGWIDTH-2)_"|"
        . . S PRETYPE=ITYPE
        . . I (ITYPE="S")&(SUPTYPE=0) D
        . . . S SUPTYPE=1,SUPCNT=0,SUPDRUG=""
        . . . F  S SUPDRUG=$O(LIST(ITYPE,SUPDRUG)) Q:SUPDRUG=""  D
        . . . . S SUPCNT=SUPCNT+1
        . . . I $Y>(PGLENGTH-SUPCNT) W !,DRUGSEP,@IOF D HD3
        . S IDRUG=""
        . F  S IDRUG=$O(LIST(ITYPE,IDRUG)) Q:IDRUG=""  D
        . . I 'SUPTYPE D
        . . S SIGCNT=0,SIGPOS=""
        . . F  S SIGPOS=$O(LIST(ITYPE,IDRUG,SIGPOS)) Q:SIGPOS=""  D
        . . . S SIGCNT=SIGCNT+1
        . . I $Y>(PGLENGTH-SIGCNT) W !,DRUGSEP,@IOF D HD3
        . . W:'SUPTYPE !,DRUGSEP,@EMPTYLN
        . . W !,"|",IDRUG_$E(BLNKLN,$L(IDRUG),PGWIDTH-3)_"|"
        . . Q:SUPTYPE
        . . S ISIG=0
        . . F  S ISIG=$O(LIST(ITYPE,IDRUG,ISIG)) Q:ISIG<1  D
        . . . W !,"|     ",LIST(ITYPE,IDRUG,ISIG),$E(BLNKLN,$L(LIST(ITYPE,IDRUG,ISIG)),PGWIDTH-8),"|"
        . . W !,INSTSEP1,!,INSTSEP2 W:'$G(PSOQHS) !,INSTSEP3
NVA     ;NVA MEDS ADDED 5/6/05
        I $D(NVA) D
        . N NVACNT,NVADRUG
        . W !,DRUGSEP
        . W @EMPTYLN
        . W !,"|","NON-VA Medications:"_$E(BLNKLN,20,PGWIDTH-2)_"|"
        . W @EMPTYLN
        . S NVACNT=0
        . S NVADRUG=""
        . F  S NVADRUG=$O(NVA(NVADRUG)) Q:NVADRUG=""  D
        . . S NVACNT=NVACNT+1
        . . I $Y>(PGLENGTH-NVACNT) W !,DRUGSEP,@IOF D HD3
        . . W !,"|",NVADRUG_$E(BLNKLN,$L(NVADRUG),PGWIDTH-3)_"|"
        K NVACNT,NVADRUG
        W !,INSTSEP1
        D
        . Q:'$G(PSOQPEND)
        . W !!,"Any medication items listed as ""pending"" are those that have just been" D PGE Q:$D(GMTSQIT)
        . W !,"written by your provider(s).  These medication orders will be reviewed" D PGE Q:$D(GMTSQIT)
        . W !,"by your pharmacist, prior to the prescription(s) being dispensed.  When" D PGE Q:$D(GMTSQIT)
        . W !,"you receive your new prescription(s), by mail or from the pharmacy window," D PGE Q:$D(GMTSQIT)
        . W !,"be sure to follow the instructions on the prescription label.  If you" D PGE Q:$D(GMTSQIT)
        . W !,"have any question about your medication, please call your provider or " D PGE Q:$D(GMTSQIT)
        . W !,"your pharmacist." D PGE Q:$D(GMTSQIT)
        Q
PGE     D:$G(PSOQHS) CKP^GMTSUP
        Q
GETOPORD(ORDLIST)       ;
        N LISTIEN,KILLORD
        S LISTIEN=0
        F  S LISTIEN=$O(ORDLIST(LISTIEN)) Q:LISTIEN<1  D
        . S KILLORD=$$IPORD(ORDLIST(LISTIEN))
        . I 'KILLORD S KILLORD=$$CKSTATUS(ORDLIST(LISTIEN)) D
        . K:KILLORD ORDLIST(LISTIEN)
        Q
IPORD(LISTNODE) ;
        N RETURN,PKG
        S RETURN=0
        S PKG=$P($P(LISTNODE,"^",1),";",2)
        I "UI"[PKG S RETURN=1
        I $P(LISTNODE,"^",1)["N;" D
        . S:$P(LISTNODE,"^",4)="ACTIVE" NVA($P(LISTNODE,"^",2),+LISTNODE)=LISTNODE
        . S RETURN=1
        Q RETURN
CKSTATUS(LISTNODE)      ;
        N RETURN,RXIEN
        S RETURN=0 ; ASSUME ACTIVE AND NOT PASS MED
        S:$P(LISTNODE,"^",4)["DISCONTINUED" RETURN=1
        S:$P(LISTNODE,"^",4)["EXPIRED" RETURN=1
        Q RETURN
GETRXDAT(RXS)   ;
        N RXSIEN,DRUGNAME,FSIG,RXTYPE
        S RXSIEN=0
        F  S RXSIEN=$O(RXS(RXSIEN)) Q:RXSIEN<1  D
        . I $P(RXS(RXSIEN),";")["P" D GETPEND(RXSIEN) S PSOQPEND=1 Q  ;->
        . S RXIEN=+RXS(RXSIEN)
        . S DRUGNAME=$$ZZ^PSOSUTL(RXIEN)
        . D FSIG^PSOUTLA("R",RXIEN,PGWIDTH-8)
        . S RXTYPE=$$GETTYPE(RXIEN)
        . M RXS(RXTYPE,DRUGNAME)=FSIG
        . N PSOQSUB
        . S PSOQSUB=$O(RXS(RXTYPE,DRUGNAME,":"),-1)+1
        . S RXS(RXTYPE,DRUGNAME,PSOQSUB)=$$REFILLS^PSOQ0076(RXIEN)_" refill(s) remaining prior to "_$$FMTE^XLFDT($$EXPDATE^PSOQ0076(RXIEN))
        Q
GETPEND(RXSIEN) ;RMS/HINES 8-16-07 ADD PENDING RX'S
        N PSOQPDN,PSOQDIND,PSOQOIND,PSOQ100,PSOQSIND,PSOQSCT,PSOQRAW,SUB
        S PSOQ100=$P(RXS(RXSIEN),U,3) Q:'+PSOQ100
        S PSOQOIND=$O(^OR(100,PSOQ100,4.5,"ID","ORDERABLE",0)) Q:'+PSOQOIND
        S PSOQPDN=$P($G(^ORD(101.43,+$G(^OR(100,PSOQ100,4.5,PSOQOIND,1)),0)),U)
        S PSOQDIND=$O(^OR(100,PSOQ100,4.5,"ID","DRUG",0)) D
        . Q:'+PSOQDIND
        . S PSOQPDN=$P($G(^PSDRUG(+$G(^OR(100,PSOQ100,4.5,PSOQDIND,1)),0)),U)
        S PSOQSIND=$O(^OR(100,PSOQ100,8,":"),-1) Q:'+PSOQSIND
        F PSOQSCT=2:1:$O(^OR(100,PSOQ100,8,PSOQSIND,.1,":"),-1) D
        . S PSOQRAW=$G(^OR(100,PSOQ100,8,PSOQSIND,.1,PSOQSCT,0))
        . N WORDS,COUNT,LINE,NEXTWORD
        . S WORDS=$L(PSOQRAW," "),SUB=$G(SUB,0)+1
        . F COUNT=1:1:WORDS D
        .. S NEXTWORD=$P(PSOQRAW," ",COUNT)
        .. Q:NEXTWORD=""
        .. S LINE=$G(LINE)_NEXTWORD_" "
        .. I $L($G(LINE))>65&(COUNT'=WORDS) K LINE S SUB=SUB+1
        .. S RXS("D","**PENDING**"_PSOQPDN,SUB)=$G(RXS("D","**PENDING**"_PSOQPDN,SUB))_NEXTWORD_" "
        Q
GETTYPE(IEN52)  ;
        N RETURN,CLASS
        S RETURN="D"
        S CLASS=$$GETCLASS(IEN52)
        S:$E(CLASS,1,1)="X" RETURN="S"
        S:$E(CLASS,1,2)="DX" RETURN="S"
        Q RETURN
GETCLASS(IENRX) ;
        N RETURN,NODE0RX,IENDRUG,NODE0DRG,NODEND50,IENCLASS,NODE0CLS,VACLASS
        S RETURN=""
        S NODE0RX=$G(^PSRX(IENRX,0))
        S IENDRUG=$P(NODE0RX,"^",6)
        Q:+IENDRUG=0 RETURN
        S NODE0DRG=$G(^PSDRUG(IENDRUG,0))
        S NODEND50=$G(^PSDRUG(IENDRUG,"ND"))
        S IENCLASS=$P(NODEND50,"^",6)
        Q:+IENCLASS=0 RETURN
        S NODE0CLS=$G(^PS(50.605,IENCLASS,0))
        S VACLASS=$P(NODE0CLS,"^",1)
        S RETURN=VACLASS
        Q RETURN
HD      ;
        S FN=ARLDFN
        S ARLNAME=$E($P(^DPT(ARLDFN,0),"^",1),1,28)
        S ARLSN=$P(^(0),"^",9),ARLDOB=$P(^(0),"^",3)
        S PHONE=$S($D(^DPT(ARLDFN,.13)):^(.13),1:"")
        S HP=$P(PHONE,"^",1),WP=$P(PHONE,"^",2)
        S ADDR=$S($D(^DPT(ARLDFN,.11)):^(.11),1:"")
        I $D(^DPT(ARLDFN,.121)),$P(^(.121),"^",9)="Y" D
        . S X=$S($P(^(.121),"^",8):$P(^(.121),"^",8),1:9999999)
        . I DT'<$P(^(.121),"^",7),DT'>X D
        . . S ADDR=^(.121)
        . . S ADDRFL="(temporary)"
        . . S HP=$P(ADDR,"^",10)
        S ST=$S($D(^DIC(5,+$P(ADDR,"^",5),0)):$P(^(0),"^",2),1:"UNKNOWN")
        S ADDR(4)=$P(ADDR,"^",4)_", "_ST_"  "_$P(ADDR,"^",6)
        S ADDR(3)=$P(ADDR,"^",3),ADDR(2)=$P(ADDR,"^",2),ADDR(1)=$P(ADDR,"^",1)
        I ADDR(2)']"" D
        . S ADDR(2)=ADDR(3)
        . S ADDR(3)=""
HD1     ; Header for 1st page
        S ARLSITE=^PS(59,PSOSITE,0)
        D PGE Q:$D(GMTSQIT)
        W !,"Date: ",RPTDATE,?XPOS1,"PATIENT MEDICATION INFORMATION"
        I $D(PAGE) D
        . W ?XPOS2,"Page: ",PAGE
        . S PAGE=PAGE+1
        W !,?XPOS4,"PRINTED BY THE VA MEDICAL CENTER AT: "_$P($G(^DIC(4,+$G(^PS(59,PSOSITE,"INI")),0)),U,1)
        W !,?XPOS4,"FOR PRESCRIPTION REFILLS CALL ("_$P(ARLSITE,U,3)_") "_$P(ARLSITE,U,4)
HD2     W !!,"Name: ",$E(ARLNAME,1,40)," - ",$E(ARLSN,6,9)
        W ?30," PHARMACY - ",$P(ARLSITE,"^",7)," DIVISION (",$P(ARLSITE,"^",3),"-",$P(ARLSITE,"^",4),")",!
        W !,INSTSEP1,!,DRUGHDR1 ;!,DRUGHDR2
        Q
HD3     ;Header for subsequent pages
        W !,"Date: ",RPTDATE,?XPOS1,"PATIENT MEDICATION INFORMATION"
        I $D(PAGE) W ?XPOS2,"Page: ",PAGE S PAGE=PAGE+1
        W !,?XPOS4,"PRINTED BY THE VA MEDICAL CENTER AT: "_$P($G(^DIC(4,+$G(^PS(59,PSOSITE,"INI")),0)),U,1)
        W !,?XPOS4,"FOR PRESCRIPTION REFILLS CALL ("_$P(ARLSITE,U,3)_") "_$P(ARLSITE,U,4),!
        W !?1,"Name: ",$E(ARLNAME,1,40)," - ",$E(ARLSN,6,9)
        W ?30," PHARMACY - ",$P(ARLSITE,"^",7)," DIVISION (",$P(ARLSITE,"^",3),"-",$P(ARLSITE,"^",4),")",!
        W !,INSTSEP1
        W:$G(SUPCNT)&'$G(NVACNT) !,"|","SUPPLY ITEMS:"_$E(BLNKLN,14,PGWIDTH-2)_"|",@EMPTYLN
        W:$G(NVACNT) @EMPTYLN,!,"|","NON-VA Medications:"_$E(BLNKLN,20,PGWIDTH-2)_"|",@EMPTYLN
        W:'$G(NVACNT)&'$G(SUPCNT) !,DRUGHDR1
        Q
RE      ;Allergies
        S ARLDASH="",$P(ARLDASH,"=",$E(BLNKLN,1,PGWIDTH-10))=ARLDASH W !,ARLDASH,!!
        S NONE="NO INFORMATION (COMPLETE SECTION BELOW)",ALFLAG=0 D ALL
        W "REACTIONS/ALLERGIES currently on file : ",$S($D(GMRAL):"",1:NONE) Q:'$D(GMRAL)
        S X=DRUG1_FOOD,DIWL=5,DIWR=PGWIDTH-5,DIWF="W" D ^DIWP,^DIWW
        Q
ALL     ;Gets allergy info
        K GMRA,GMRAL
        N IFN,DATA,VER,ARLEND
        S ARLEND=0,DFN=ARLDFN,GMRA="0^0^011" D ^GMRADPT S (DRUG1,FOOD)=""
        I $D(GMRAL),GMRAL=0 S DRUG1="NO KNOWN ALLERGIES"
        I $D(GMRAL),GMRAL=1 S IFN="" F  S IFN=$O(GMRAL(IFN)) Q:IFN=""!(ARLEND)  S DATA=GMRAL(IFN),AL=$P(DATA,U,2),TYPE=$P(DATA,U,3),VER=$S($P(DATA,U,4)=1:"V",1:"NV") D
        .I $L(DRUG1)>300 S DRUG1="TOO MANY TO LIST",ARLEND=1
        .S:TYPE="D" DRUG1=AL_" ("_VER_"),"_DRUG1
        .S:TYPE="F" FOOD="Food Allergies on File"
        Q
