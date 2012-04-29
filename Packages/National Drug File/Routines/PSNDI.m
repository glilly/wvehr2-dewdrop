PSNDI   ;BIR/LDT - API FOR FILEMAN CALLS; 5 Sep 03
        ;;4.0; NATIONAL DRUG FILE;**80,109,157**; 30 Oct 98;Build 9
        ;
DIC(PSNFILE,PSNPACK,DIC,X,DLAYGO,PSNSCRDT)      ;
        S PSNDIY=""
        I +$G(PSNFILE)'>0 S PSNDIY=-1 Q
        N PSNRTEST S PSNRTEST=$$TEST(PSNFILE)
        I 'PSNRTEST S PSNDIY=-1 Q
        K DIC("S")
        N STNDRD S STNDRD=$$SCREEN^HDISVF01(PSNFILE)
        I STNDRD=1 D XSCREEN(PSNFILE)
        I STNDRD'=1 N PSNSUBSC,PSNPIECE D NONSTD
        I '$P(PSNRTEST,"^",2) K DLAYGO I $G(DIC(0))'="" S DIC(0)=$TR(DIC(0),"L","") I $G(DIC(0))="" S PSNDIY=-1
        D ^DIC
        Q
        ;
IX(PSNFILE,PSNPACK,DIC,D,X,DLAYGO,PSNSCRDT)     ;
        S PSNDIY=""
        I +$G(PSNFILE)'>0 S PSNDIY=-1 Q
        N PSNRTEST S PSNRTEST=$$TEST(PSNFILE)
        I 'PSNRTEST S PSNDIY=-1 Q
        K DIC("S")
        N STNDRD S STNDRD=$$SCREEN^HDISVF01(PSNFILE)
        I STNDRD=1 D XSCREEN(PSNFILE)
        I STNDRD'=1 N PSNSUBSC,PSNPIECE D NONSTD
        I '$P(PSNRTEST,"^",2) K DLAYGO I $G(DIC(0))'="" S DIC(0)=$TR(DIC(0),"L","") I $G(DIC(0))="" S PSNDIY=-1
        D IX^DIC
        Q
        ;
DIE(PSNFILE,PSNPACK,DIE,DA,DR,DIDEL)    ;
        S PSNDIY=""
        I +$G(PSNFILE)'>0 S PSNDIY=-1 Q
        N PSNRTEST S PSNRTEST=$$TEST(PSNFILE)
        I 'PSNRTEST S PSNDIY=-1 Q
        I '$P(PSNRTEST,"^",2) S PSNDIY=-1 Q
        D ^DIE
        Q
        ;
TEST(PSNTFILE)  ; Test to check if file is listed in the API
        N CNT,PSNAPP2,PSNFFLAG,PSNFLOOP,PSNFTEST,PSNLNODE,PSNRSLT S PSNRSLT="0^0",PSNFFLAG=0
        F PSNFLOOP=1:1 S PSNFTEST=$P($T(FILE1+PSNFLOOP),";;",2) Q:+$G(PSNFTEST)'>0!PSNFFLAG  I +PSNFTEST=PSNTFILE S $P(PSNRSLT,"^")=1 S PSNLNODE=$T(FILE1+PSNFLOOP) D
        .F CNT=3:1:$L(PSNLNODE,";;") S PSNAPP2=$P(PSNLNODE,";;",CNT) Q:$P(PSNRSLT,"^",2)=1  I PSNAPP2=$G(PSNPACK) S PSNFFLAG=1,$P(PSNRSLT,"^",2)=1
        Q PSNRSLT
        ;
NONSTD  ;
        I +$G(PSNSCRDT)>0 D SCREEN
        Q
        ;
SCREEN  ;Set screen if Inactive Date is passed in
        N PSNILOOP,PSNILOC,PSNINFLG,PSNINODE S PSNINFLG=0
        F PSNILOOP=1:1 S PSNILOC=$P($T(FILE2+PSNILOOP),";;",2) Q:+$G(PSNILOC)'>0!PSNINFLG  I +PSNILOC=PSNFILE S PSNINFLG=1 S PSNINODE=$T(FILE2+PSNILOOP) D
        .S PSNSUBSC=$P(PSNINODE,";;",3),PSNPIECE=$P(PSNINODE,";;",4)
        .I PSNSUBSC'="",PSNPIECE'="" S DIC("S")="I $P($G(^(PSNSUBSC)),""^"",PSNPIECE)=""""!(+$P($G(^(PSNSUBSC)),""^"",PSNPIECE)>+$G(PSNSCRDT))"
        Q
        ;
XSCREEN(PSNTFILE)       ; Set screen for standardized files
        I +$G(PSNSCRDT)>0 S DIC("S")="I '$$SCREEN^XTID("_PSNTFILE_",.01,+Y_"","",+$G(PSNSCRDT))"
        Q
        ;
FILE1   ;Package listed if Write access (DLAYGO) is allowed
        ;;50.416;;PSN
        ;;50.605;;PSN
        ;;50.6;;PSN
        ;;50.67;;PSN
        ;;56;;PSN;;PSS
        ;;
        Q
        ;
FILE2   ;For Lookup calls, check for Inactive Date Screen
        ;;50.67;;0;;7
        ;;56;;0;;7
        ;;
        Q
