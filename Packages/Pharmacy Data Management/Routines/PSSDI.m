PSSDI   ;BIR/LDT/TSS - API FOR FILEMAN CALLS ;5 Sep 03
        ;;1.0;PHARMACY DATA MANAGEMENT;**85,91,97,104,108,118,133**;9/30/97;Build 1
        ;
DIC(PSSFILE,PSSAPP,DIC,X,DLAYGO,PSSSCRDT,PSSSCRUS,PSSVACL)      ;
        N PSSX1 ;ADDED BY TS ON 09.20.2006
        S PSSDIY=""
        I +$G(PSSFILE)'>0 S PSSDIY=-1 G Q
        N PSRTEST S PSRTEST=$$TEST(PSSFILE)
        I 'PSRTEST S PSSDIY=-1 G Q
        K DIC("S")
        I +$G(PSSSCRDT)>0 N PSSSUBSC,PSSPIECE D SCREEN
        I $D(PSSVACL),$O(PSSVACL(0))'="",$G(PSSFILE)=50 D VACL I $D(PSSX1) S DIC("S")=$S($G(DIC("S"))'="":DIC("S")_" ",1:"")_PSSX1 K PSSX1
        I $G(PSSSCRUS)'="",$G(PSSFILE)=50 N PSSAPLP D
        .S DIC("S")=$S($G(DIC("S"))'="":DIC("S")_" ",1:"")_"F PSSAPLP=1:1:$L(PSSSCRUS) I $P($G(^(2)),""^"",3)[$E(PSSSCRUS,PSSAPLP) Q"
        I '$P(PSRTEST,"^",2) K DLAYGO I $G(DIC(0))'="" S DIC(0)=$TR(DIC(0),"L","") I $G(DIC(0))="" S PSSDIY=-1 G Q
        I $G(DIC(0))="",$G(X)="" S PSSDIY=-1 G Q
        K DTOUT,DUOUT D ^DIC
        G Q
DO(PSSFILE,PSSAPP,DIC)  ;
        S PSSDIY=""
        I +$G(PSSFILE)'>0 S PSSDIY=-1 G Q
        N PSRTEST S PSRTEST=$$TEST(PSSFILE)
        I 'PSRTEST S PSSDIY=-1 G Q
        K DTOUT,DUOUT D DO^DIC1
        Q
IX(PSSFILE,PSSAPP,DIC,D,X,DLAYGO)       ;
        S PSSDIY=""
        I +$G(PSSFILE)'>0 S PSSDIY=-1 G Q
        N PSRTEST S PSRTEST=$$TEST(PSSFILE)
        I 'PSRTEST S PSSDIY=-1 G Q
        I '$P(PSRTEST,"^",2) K DLAYGO I $G(DIC(0))'="" S DIC(0)=$TR(DIC(0),"L","") I $G(DIC(0))="" S PSSDIY=-1 G Q
        I $G(DIC(0))="",$G(X)="" S PSSDIY=-1 G Q
        K DTOUT,DUOUT D IX^DIC
        Q
MIX(PSSFILE,PSSAPP,DIC,D,X,DLAYGO,PSSSCRDT,PSSSCRUS,PSSVACL)    ;
        N PSSX1 ;ADDED BY TS ON 09.20.2006
        S PSSDIY=""
        I +$G(PSSFILE)'>0 S PSSDIY=-1 G Q
        N PSRTEST S PSRTEST=$$TEST(PSSFILE)
        I 'PSRTEST S PSSDIY=-1 G Q
        K DIC("S")
        I +$G(PSSSCRDT)>0 N PSSSUBSC,PSSPIECE D SCREEN
        I $D(PSSVACL),$O(PSSVACL(0))'="",$G(PSSFILE)=50 D VACL I $D(PSSX1) S DIC("S")=$S($G(DIC("S"))'="":DIC("S")_" ",1:"")_PSSX1 K PSSX1
        I $G(PSSSCRUS)'="",$G(PSSFILE)=50 N PSSAPLP D
        .S DIC("S")=$S($G(DIC("S"))'="":DIC("S")_" ",1:"")_"F PSSAPLP=1:1:$L(PSSSCRUS) I $P($G(^(2)),""^"",3)[$E(PSSSCRUS,PSSAPLP) Q"
        I '$P(PSRTEST,"^",2) K DLAYGO I $G(DIC(0))'="" S DIC(0)=$TR(DIC(0),"L","") I $G(DIC(0))="" S PSSDIY=-1 G Q
        I $G(DIC(0))="",$G(X)="" S PSSDIY=-1 G Q
        K DTOUT,DUOUT D MIX^DIC1
        G Q
FILE(PSSFILE,PSSAPP,DIC,DA,X,DINUM,DLAYGO)      ;
        S PSSDIY=""
        I +$G(PSSFILE)'>0 S PSSDIY=-1 G Q
        N PSRTEST S PSRTEST=$$TEST(PSSFILE)
        I 'PSRTEST S PSSDIY=-1 G Q
        I '$P(PSRTEST,"^",2) S PSSDIY=-1 G Q
        K DTOUT,DUOUT,DO D FILE^DICN
        Q
DIE(PSSFILE,PSSAPP,DIE,DA,DR,DIDEL)     ;
        S PSSDIY=""
        I +$G(PSSFILE)'>0 S PSSDIY=-1 G Q
        N PSRTEST S PSRTEST=$$TEST(PSSFILE)
        I 'PSRTEST S PSSDIY=-1 G Q
        I '$P(PSRTEST,"^",2) S PSSDIY=-1 G Q
        K DTOUT D ^DIE
        Q
EN1(PSSFILE,PSSAPP,DIC,L,FLDS,BY,FR,TO,DHD)     ;
        S PSSDIY=""
        I +$G(PSSFILE)'>0 S PSSDIY=-1 G Q
        N PSRTEST S PSRTEST=$$TEST(PSSFILE)
        I 'PSRTEST S PSSDIY=-1 G Q
        D EN1^DIP
        Q
EN(PSSFILE,PSSAPP,DIC,DR,DA,DIQ)        ;
        S PSSDIY=""
        I +$G(PSSFILE)'>0 S PSSDIY=-1 G Q
        N PSRTEST S PSRTEST=$$TEST(PSSFILE)
        I 'PSRTEST S PSSDIY=-1 G Q
        D EN^DIQ1
        Q
FNAME(PSSFNO,PSSFILE)   ;
        ;Return the label for the field of the File or Subfile passed in
        ;PSSFNO  - Field number
        ;PSSFILE - File or Subfile number
        Q $$FNAME^PSS50E($G(PSSFNO),$G(PSSFILE))
        ;
TEST(PSTFILE)   ;
        N CNT,PSSAPP2,PSFFLAG,PSFLOOP,PSFTEST,PSLNODE,PSRSLT S PSRSLT="0^0",PSFFLAG=0
        F PSFLOOP=1:1 S PSFTEST=$P($T(FILE2+PSFLOOP),";;",2) Q:+$G(PSFTEST)'>0!PSFFLAG  I +PSFTEST=PSTFILE S $P(PSRSLT,"^")=1 S PSLNODE=$T(FILE2+PSFLOOP) D
        .F CNT=3:1:$L(PSLNODE,";;") S PSSAPP2=$P(PSLNODE,";;",CNT) Q:$P(PSRSLT,"^",2)=1  I PSSAPP2=$G(PSSAPP) S PSFFLAG=1,$P(PSRSLT,"^",2)=1
        Q PSRSLT
        ;
FILE2   ;For DIC call, IF PACKAGE IS LISTED, PACKAGE HAS WRITE ACCESS          
        ;;50;;PSX;;PSD;;PSJ;;PSN;;PSO;;PSGW;;PSS
        ;;50.1;;PSX;;PSD;;PSJ;;PSN;;PSO;;PSGW;;PSS
        ;;50.0214;;PSX;;PSD;;PSJ;;PSN;;PSO;;PSGW;;PSS
        ;;50.037;;PSX;;PSD;;PSJ;;PSN;;PSO;;PSGW;;PSS
        ;;50.065;;PSX;;PSD;;PSJ;;PSN;;PSO;;PSGW;;PSS
        ;;50.0212;;PSX;;PSD;;PSJ;;PSN;;PSO;;PSGW;;PSS
        ;;50.0441;;PSX;;PSD;;PSJ;;PSN;;PSO;;PSGW;;PSS
        ;;50.01;;PSX;;PSD;;PSJ;;PSN;;PSO;;PSGW;;PSS
        ;;50.02;;PSX;;PSD;;PSJ;;PSN;;PSO;;PSGW;;PSS
        ;;50.0903;;PSX;;PSD;;PSJ;;PSN;;PSO;;PSGW;;PSS
        ;;50.0904;;PSX;;PSD;;PSJ;;PSN;;PSO;;PSGW;;PSS
        ;;50.4;;PSJ;;PSS
        ;;50.606;;PSJ;;PSN;;PSS
        ;;50.7;;PSJ;;PSO;;PSN;;PSS
        ;;50.76;;PSJ;;PSO;;PSN;;PSS
        ;;50.72;;PSJ;;PSO;;PSN;;PSS
        ;;51;;PSJ;;PSS
        ;;51.01;;PSJ;;PSS
        ;;51.1;;PSJ;;PSS
        ;;51.11;;PSJ;;PSS
        ;;51.17;;PSJ;;PSS
        ;;51.2;;PSJ;;PSS
        ;;51.5;;PSS
        ;;52.6;;PSJ;;PSN;;PSS
        ;;52.61;;PSJ;;PSN;;PSS
        ;;52.62;;PSJ;;PSN;;PSS
        ;;52.63;;PSJ;;PSN;;PSS
        ;;52.64;;PSJ;;PSN;;PSS
        ;;52.7;;PSJ;;PSN;;PSS
        ;;52.702;;PSJ;;PSN;;PSS
        ;;52.703;;PSJ;;PSN;;PSS
        ;;52.704;;PSJ;;PSN;;PSS
        ;;54;;PSS;;PSO
        ;;54.1;;PSS;;PSO
        ;;9009032.3;;PSS
        ;;9009032.5;;PSS
        ;;
        Q
        ;
FILE3   ;For Lookup calls, check for Inactive Date Screen
        ;;50;;I;;1
        ;;50.606;;0;;2
        ;;50.7;;0;;4
        ;;51.2;;0;;5
        ;;52.6;;I;;1
        ;;52.7;;I;;1
        ;;
        Q
SCREEN  ;Set screen if Inactive Date is passed in, and for File 50, addition screen if Application Packages Use is passed in
        N PSSILOOP,PSSILOC,PSSINFLG,PSSINODE S PSSINFLG=0
        F PSSILOOP=1:1 S PSSILOC=$P($T(FILE3+PSSILOOP),";;",2) Q:+$G(PSSILOC)'>0!PSSINFLG  I +PSSILOC=PSSFILE S PSSINFLG=1 S PSSINODE=$T(FILE3+PSSILOOP) D
        .S PSSSUBSC=$P(PSSINODE,";;",3),PSSPIECE=$P(PSSINODE,";;",4)
        .I PSSSUBSC'="",PSSPIECE'="" S DIC("S")="I $P($G(^(PSSSUBSC)),""^"",PSSPIECE)=""""!(+$P($G(^(PSSSUBSC)),""^"",PSSPIECE)>+$G(PSSSCRDT))"
        Q
VACL    S PSSVACL1=0,PSSX=$S($D(PSSVACL("R")):"=",1:"'=") K PSSX1
        F  S PSSVACL1=$O(PSSVACL(PSSVACL1)) Q:PSSVACL1=""  I PSSVACL1'="R",PSSVACL1'="P" S PSSX1=$S($G(PSSX1)="":"I $P(^PSDRUG(+Y,0),U,2)"_PSSX_""""_PSSVACL1_"""",1:PSSX1_$S(PSSX="=":"!",1:"&")_"($P(^PSDRUG(+Y,0),U,2)"_PSSX_""""_PSSVACL1_""""_")")
        Q
Q       K PSSVACL,PSSVACL1,PSSX,PSSX1,PSSFILE,PSSAPP,PSSINODE,PSSSCRUS Q
