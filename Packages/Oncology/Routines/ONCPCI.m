ONCPCI ;Hines OIFO/GWB - Patient Identification/Cancer Identification screen display ;05/30/00
 ;;2.11;ONCOLOGY;**15,19,24,26,27,28,33,35,36,42,43,44,45,46,47**;Mar 07, 1995;Build 19
PI ;Patient Identification
 N DI,DIC,DR,DA,DIQ,ONC,TM1,TM2,TM3,DOTS1,DOTS2,DOTS3
 S DIC="^ONCO(165.5,"
 S DR=".03;1.2;2;2.1;2.2;2.3;2.4;8;8.1;8.2;9;10;11;16;18;147"
 S DA=D0,DIQ="ONC" D EN^DIQ1
 F I=.03,1.2,2,2.1,2.2,2.3,2.4,8,8.1,8.2,9,10,11,16,18 S X=ONC(165.5,D0,I) D UCASE S ONC(165.5,D0,I)=X
 W !," Reporting Hospital...........: ",ONC(165.5,D0,.03)
 W !," Marital Status at Dx.........: ",ONC(165.5,D0,11)
 W !," Patient Address at Dx........: ",ONC(165.5,D0,8)
 W !," Patient Address at Dx - Supp.: ",ONC(165.5,D0,8.2)
 W !," City/town at Dx..............: ",ONC(165.5,D0,8.1)
 W !," State at Dx..................: ",ONC(165.5,D0,16)
 W !," Postal Code at Dx............: ",ONC(165.5,D0,9)
 W !," County at Dx.................: ",ONC(165.5,D0,10)
 W !," Census Tract.................: ",ONC(165.5,D0,147)
 I DATEDX>3061231 D
 .W !," Managing Physician...........: ",ONC(165.5,D0,2.2)
 W !," Following Physician..........: ",ONC(165.5,D0,2.1)
 W !," Primary Surgeon..............: ",ONC(165.5,D0,2)
 W !," Physician #3.................: ",ONC(165.5,D0,2.3)
 W !," Physician #4       ..........: ",ONC(165.5,D0,2.4)
 W !," Primary Payer at Dx..........: ",ONC(165.5,D0,18)
 W !," Type of Reporting Source.....: ",ONC(165.5,D0,1.2)
 W !,DASHES
 Q
 ;
CI ;Cancer Identification
 N DI,DIC,DR,DA,DIQ,ONC,TM1,TM2,TM3,DOTS1,DOTS2,DOTS3
 S DIC="^ONCO(165.5,"
 S DR=".04;6;7;155;3;28;22;22.1;22.3;24;26;25.1;25.2;25.3;83;623;684;120;121;1010;5;171;172;173;21;96;102;156;159;193;194;195;196"
 S DA=D0,DIQ="ONC" D EN^DIQ1
 F I=.04,28,24,25.1,25.2,25.3,26,83,120,623,684,1010,5,21,102,159,194 S X=ONC(165.5,D0,I) D UCASE S ONC(165.5,D0,I)=X
 S COC=$$GET1^DIQ(165.5,D0,.04,"I")
 S TM1=$$PRINT^ONCOTM(D0,1)
 K DOTS1 S $P(DOTS1,".",25-$L(TM1))="."
 S TM2=$$PRINT^ONCOTM(D0,2)
 K DOTS2 S $P(DOTS2,".",25-$L(TM2))="."
 S TM3=$$PRINT^ONCOTM(D0,3)
 K DOTS3 S $P(DOTS3,".",25-$L(TM3))="."
 W !," Class of Case................: ",ONC(165.5,D0,.04)
 I COC=1 D
 .W !," Date of First Symptoms.......: ",ONC(165.5,D0,171)
 .W !," Date Start of Workup Ordered.: ",ONC(165.5,D0,172)
 .W !," Date Workup Started..........: ",ONC(165.5,D0,173)
 S TXT=ONC(165.5,D0,6),LEN=46 D TXT
 W !," Facility referred from.......: ",TXT1 W:TXT2'="" !,?32,TXT2
 S TXT=ONC(165.5,D0,7),LEN=46 D TXT
 W !," Facility referred to.........: ",TXT1 W:TXT2'="" !,?32,TXT2
 W !," Date of First Contact........: ",ONC(165.5,D0,155)
 W !," Date Dx......................: ",ONC(165.5,D0,3)
 I DATEDX>3061231 D
 .W !," Ambiguous Terminology Dx.....: ",ONC(165.5,D0,159)
 .W !," Date of Conclusive Dx........: ",ONC(165.5,D0,193)
 S TXT=ONC(165.5,D0,5),LEN=46 D TXT
 W !," Dx Facility..................: ",TXT1 W:TXT2'="" !,?32,TXT2
 S TXT=ONC(165.5,D0,28),LEN=46 D TXT
 I DATEDX>3061231 D
 .W !," Mult Tum Rpt as One Prim.....: ",ONC(165.5,D0,194)
 .W !," Date of Multiple Tumors......: ",ONC(165.5,D0,195)
 .W !," Multiplicity Counter.........: ",ONC(165.5,D0,196)
 W !," Laterality...................: ",TXT1 W:TXT2'="" !,?32,TXT2
 S HIST=$$HIST^ONCFUNC(D0)
 W !," Histology/Behavior Code......: ",ONC(165.5,D0,22.1)_" "_$E(ONC(165.5,D0,HSTFLD),1,42)
 W:$G(TOP)=67619 !," Gleason's Score..............: ",ONC(165.5,D0,623)
 W:$G(TOP)=67619 !," PSA..........................: ",ONC(165.5,D0,96)," ",ONC(165.5,D0,684)
 W:$G(TOP)=67619 !," DRE +/-......................: ",ONC(165.5,D0,156)," ",ONC(165.5,D0,102)
 W !," Grade/Diff/Cell Type.........: ",ONC(165.5,D0,24)
 W !," AFIP submission..............: ",ONC(165.5,D0,83)
 W !," Diagnostic Confirmation......: ",ONC(165.5,D0,26)
 W:($$GET1^DIQ(165.5,D0,.01,"E")="LIVER")!($G(TOP)=67220) !," Hepatitis C..................: ",ONC(165.5,D0,1010)
 ;I DATEDX<3030000 D
 ;.W !," ",TM1,DOTS1,"....: ",ONC(165.5,D0,25.1)
 ;.W !," ",TM2,DOTS2,"....: ",ONC(165.5,D0,25.2)
 ;.W !," ",TM3,DOTS3,"....: ",ONC(165.5,D0,25.3)
 W !," Presentation at Cancer Conf..: ",ONC(165.5,D0,121)," ",ONC(165.5,D0,120)
 W !," Casefinding Source...........: ",ONC(165.5,D0,21)
 W !,DASHES
 Q
 ;
TXT ;Text formatting
 S (TXT1,TXT2)="",LOS=$L(TXT) I LOS<LEN S TXT1=TXT Q
 S NOP=$L($E(TXT,1,LEN)," ")
 S TXT1=$P(TXT," ",1,NOP-1),TXT2=$P(TXT," ",NOP,999)
 Q
 ;
UCASE ;Mixed case to uppercase conversion
 S X=$TR(X,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 Q
