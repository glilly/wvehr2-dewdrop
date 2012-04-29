VEPERDSC ;Display Description for DOQ-IT Topic Indicators ; 13 Jun 2005  5:15 PM
 ;;1.0;;;;Build 1
DESC(FLDNO) ;Display topic indicator description before prompts
 ;  FLDNO = Field number of 19904.4 fields.
 ;          .21 - CAD 1
 ;          .22 - CAD 2
 ;          .23 - CAD 3
 ;          .24 - CAD 4
 ;          .25 - CAD 5
 ;          .26 - CAD 6
 ;          .27 - CAD 7
 ;          .31 - DM 1
 ;          .32 - DM 2
 ;          .33 - DM 3
 ;          .34 - DM 4
 ;          .35 - DM 5
 ;          .36 - DM 6
 ;          .37 - DM 7
 ;          .38 - DM 8
 ;          .41 - HTN 1
 ;          .42 - HTN 2
 ;          .43 - HTN 3
 ;          .51 - HF 1
 ;          .52 - HF 2
 ;          .53 - HF 3
 ;          .54 - HF 4
 ;          .55 - HF 5
 ;          .56 - HF 6
 ;          .57 - HF 7
 ;          .58 - HF 8
 ;          .61 - PC 1
 ;          .62 - PC 2
 ;          .63 - PC 3
 ;          .64 - PC 4
 ;          .65 - PC 5
 ;          .66 - PC 6
 ;          .67 - PC 7
 ;          .68 - PC 8
 ;          .69 - PC 9
 ;          .7  - PC 10
 ;          .71 - PC 11
 ;          .72 - PC 12
 ;
 N DSCDATA,SUB,TT,TOPTYP,TOPIND
 K DSCDATA D GETS^DIQ(19904.5,"1,","**","","DSCDATA")
 ; SUB=TOPIND,TOPTYP,1,
 ; DESCRIPTION DATA IS AT LEVEL 2
 ;
 S TT=$E(FLDNO,2),TOPIND=$E(FLDNO,3)
 S TOPTYP=$S(TT=2:1,TT=3:2,TT=4:4,TT=5:3,1:5)
 I TOPTYP=5 D
 .I TT=7 S TOPIND=TOPIND+10
 .I TOPIND>1,TOPIND<5 S TOPIND=99 Q  ;TOP INDICATOR 2-4 IS N/A
 .I TOPIND>1 S TOPIND=TOPIND-3
 S SUB=TOPIND_","_TOPTYP_",1,"
 I '$D(DSCDATA(19904.532,SUB,2)) W !,"DESC:  <<*** Not activated yet***>>" Q
 W !,"DESC:  <<",DSCDATA(19904.532,SUB,2),">>"
 Q
 Q
