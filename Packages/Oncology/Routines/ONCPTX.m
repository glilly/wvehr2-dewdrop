ONCPTX ;Hines OIFO/GWB - FIRST COURSE OF TREATMENT ;9/24/97
 ;;2.11;ONCOLOGY;**13,15,17,19,27,32,34,36,37,39,41,42,45,46**;Mar 07, 1995;Build 39
 ;
NCDS D FST^ONCOAIP
 S CC=$P($G(^ONCO(165.5,D0,0)),U,4)
 I CC=4 D
 .W !," **NOTE** CLASS OF CASE = 4 (Dx/1st tx before ref date)"
 .W !," The @FAC (at this facility) fields will be stuffed to"
 .W !," match the primary treatment fields."
 .W !,DASHES
 I (CC=0)!(CC=3)!(CC=6) D
 .S CCTXT=$S(CC=0:"0 (Dx here, 1st tx ew)",CC=3:"3 (Dx ew, 1st tx ew)",CC=6:"6 (Dx/1st tx in MD office)",1:CC)
 .W !," **NOTE** CLASS OF CASE = ",CCTXT
 .W !," The @FAC (at this facility) fields will be stuffed with the"
 .W !," appropriate value indicating that no treatment was given"
 .W !," at this facility."
 .W !,DASHES
 K CC,CCTXT
 N DI,DIC,DR,DA,DIQ K ONC
 S DIC="^ONCO(165.5,"
 S DR="58.1;58.3;58.4;58.5"
 S DA=D0,DIQ="ONC(" D EN^DIQ1
 F I=58.1,58.4 S X=ONC(165.5,D0,I) D UCASE S ONC(165.5,D0,I)=X
 W !," SURGICAL DIAGNOSTIC AND STAGING PROCEDURES"
 W !," ------------------------------------------"
 S TXT=ONC(165.5,D0,58.1),LEN=38 D TXT
 W !," Surgical Dx/Staging Proc.....: ",ONC(165.5,D0,58.3),?43,TXT1
 W:TXT2'="" !,?43,TXT2
 S TXT=ONC(165.5,D0,58.4),LEN=38 D TXT
 W !," Surg Dx/Staging Proc @fac....: ",ONC(165.5,D0,58.5),?43,TXT1 W:TXT2'="" !,?43,TXT2
 W !,DASHES
 Q
 ;
ROADS ;SURGICAL PROCEDURES (ROADS)
 N DI,DIC,DR,DA,DIQ K ONC
 S DIC="^ONCO(165.5,"
 S DR="50;58.6;50.3;58.7;59;138:138.5;139:139.5;435;14;58;23;74;58.2;50.2;140;140.1"
 S DA=D0,DIQ="ONC(" D EN^DIQ1
 F I=58.6,58.7,59,138,138.1,138.4,138.5,139,139.1,139.4,139.5,435,14,58,23,74,58.2,50.2,140,140.1 S X=ONC(165.5,D0,I) D UCASE S ONC(165.5,D0,I)=X
 D FST^ONCOAIP
 W !," SURGICAL PROCEDURES (ROADS)"
 W !," Pre-2003 cases require the following ROADS surgery items to be coded:"
 W !," ---------------------------------------------------------------------"
 S TXT=ONC(165.5,D0,58.2),LEN=46 D TXT
 W !," Surgery of primary.........(R): ",TXT1 W:TXT2'="" !,?33,TXT2
 W !," Surgical Approach..........(R): ",ONC(165.5,DA,74)
 S TXT=ONC(165.5,D0,50.2),LEN=46 D TXT
 W !," Surgery of primary @fac....(R): ",TXT1 W:TXT2'="" !,?33,TXT2
 S TXT=ONC(165.5,D0,138),LEN=46 D TXT
 W !," Scope of ln surgery........(R): ",TXT1 W:TXT2'="" !,?33,TXT2
 W !," Number of LN removed...... (R): ",ONC(165.5,D0,140)
 S TXT=ONC(165.5,D0,138.1),LEN=46 D TXT
 W !," Scope of ln surgery @fac...(R): ",TXT1 W:TXT2'="" !,?33,TXT2
 W !," Number of LN removed @fac..(R): ",ONC(165.5,D0,140.1)
 S TXT=ONC(165.5,D0,139),LEN=46 D TXT
 W !," Surg proc/other site.......(R): ",TXT1 W:TXT2'="" !,?33,TXT2
 S TXT=ONC(165.5,D0,139.1),LEN=46 D TXT
 W !," Surg proc/other site @fac..(R): ",TXT1 W:TXT2'="" !,?33,TXT2
 W !,DASHES
 Q
 ;
FORDS ;SURGICAL PROCEDURES (FORDS)
 S TOPX=$P($G(^ONCO(165.5,D0,2)),U,1)
 I (TOPX=67420)!(TOPX=67421)!(TOPX=67423)!(TOPX=67424)!($E(TOPX,3,4)=76)!(TOPX=67809) D
 .S $P(^ONCO(165.5,D0,3.1),U,29)=1
 N DI,DIC,DR,DA,DIQ K ONC
 S DIC="^ONCO(165.5,"
 S DR="50;58.6;50.3;58.7;59;138:138.5;139:139.5;435;14;58;23;74;58.2;50.2;140;140.1;170;46;47"
 S DA=D0,DIQ="ONC(" D EN^DIQ1
 F I=58.6,58.7,59,138,138.1,138.4,138.5,139,139.1,139.4,139.5,435,14,58,23,74,58.2,50.2,140,140.1 S X=ONC(165.5,D0,I) D UCASE S ONC(165.5,D0,I)=X
 D FST^ONCOAIP
 W !," SURGICAL PROCEDURES (FORDS)"
 W !," ---------------------------"
 W !," Date First Surgical Procedure.: ",$E(ONC(165.5,D0,170),1,6)_$E(ONC(165.5,D0,170),9,10)
 S TXT=ONC(165.5,D0,58.6),LEN=38 D TXT
 W !," Surgery of primary.........(F): ",$E(ONC(165.5,D0,50),1,6)_$E(ONC(165.5,D0,50),9,10),?42,TXT1 W:TXT2'="" !,?42,TXT2
 S TXT=ONC(165.5,D0,58.7),LEN=38 D TXT
 W !," Surgery of primary @fac....(F): ",$E(ONC(165.5,D0,50.3),1,6)_$E(ONC(165.5,D0,50.3),9,10),?42,TXT1 W:TXT2'="" !,?42,TXT2
 W !," Surgical margins..............: ",ONC(165.5,DA,59)
 S TXT=ONC(165.5,D0,138.4),LEN=38 D TXT
 W !," Scope of ln surgery........(F): ",$E(ONC(165.5,D0,138.2),1,6)_$E(ONC(165.5,D0,138.2),9,10),?42,TXT1 W:TXT2'="" !,?42,TXT2
 S TXT=ONC(165.5,D0,138.5),LEN=38 D TXT
 W !," Scope of ln surgery @fac...(F): ",$E(ONC(165.5,D0,138.3),1,6)_$E(ONC(165.5,D0,138.3),9,10),?42,TXT1 W:TXT2'="" !,?42,TXT2
 S TXT=ONC(165.5,D0,139.4),LEN=38 D TXT
 W !," Surg proc/other site.......(F): ",$E(ONC(165.5,D0,139.2),1,6)_$E(ONC(165.5,D0,139.2),9,10),?42,TXT1 W:TXT2'="" !,?42,TXT2
 S TXT=ONC(165.5,D0,139.5),LEN=38 D TXT
 W !," Surg proc/other site @fac..(F): ",$E(ONC(165.5,D0,139.3),1,6)_$E(ONC(165.5,D0,139.3),9,10),?42,TXT1 W:TXT2'="" !,?42,TXT2
 S TXT=ONC(165.5,D0,23),LEN=38 D TXT
 W:DATEDX<3030000 !," Reconstruction/restoration....: ",?33,TXT1 W:TXT2'="" !,?33,TXT2
 W !," Date of surgical discharge....: ",$E(ONC(165.5,D0,435),1,6)_$E(ONC(165.5,D0,435),9,10)
 W !," Readmission w/i 30 days/surg..: ",ONC(165.5,D0,14)
 W !," Reason no surgery of primary..: ",ONC(165.5,D0,58)
 W !," CAP Protocol Review...........: ",ONC(165.5,D0,46)
 W:ONC(165.5,D0,46)="Failed" !," CAP Text......................: ",ONC(165.5,D0,47)
 W !,DASHES
 Q
 ;
RAD D FST^ONCOAIP
 W !," RADIATION"
 W !," ---------"
 N DI,DIC,DR,DA,DIQ K ONC
 S DIC="^ONCO(165.5,"
 S DR="51;51.2;51.3;51.4;51.5;56;75;125;126;363;442;363.1;443;361"
 S DA=D0,DIQ="ONC(" D EN^DIQ1
 F I=51.2,126,125,363,363.1,56,51.3,51.4,75,442,443 S X=ONC(165.5,D0,I) D UCASE S ONC(165.5,D0,I)=X
 W !," Radiation.....................: ",ONC(165.5,DA,51.2)
 W !," Date radiation started........: ",ONC(165.5,DA,51)
 W !," Radiation @fac................: ",ONC(165.5,DA,51.5)," ",ONC(165.5,DA,51.4)
 W !," Location of radiation tx......: ",ONC(165.5,DA,126)
 W !," Radiation treatment volume....: ",ONC(165.5,DA,125)
 W !," Regional treatment modality...: ",ONC(165.5,DA,363)
 W !," Regional dose:cGy.............: ",ONC(165.5,DA,442)
 W !," Boost treatment modality......: ",ONC(165.5,DA,363.1)
 W !," Boost dose:cGy................: ",ONC(165.5,DA,443)
 W !," Number of txs to this volume..: ",ONC(165.5,DA,56)
 W !," Radiation/surgery sequence....: ",ONC(165.5,DA,51.3)
 W !," Date radiation ended..........: ",ONC(165.5,DA,361)
 W !," Reason for no radiation.......: ",ONC(165.5,DA,75)
 W !,DASHES
 Q
 ;
ST D FST^ONCOAIP
 W !," SYSTEMIC THERAPY"
 W !," ----------------"
 N DI,DIC,DR,DA,DIQ K ONC
 S DIC="^ONCO(165.5,"
 S DR="152;53;53.2;53.3;53.4;54;54.2;54.3;54.4;55;55.2;55.3;55.4;153;153.1;15"
 S DA=D0,DIQ="ONC(" D EN^DIQ1
 F I=53.2,53.3,54.2,54.3,55.2,55.3,153,15 S X=ONC(165.5,D0,I) D UCASE S ONC(165.5,D0,I)=X
 W !," Date systemic therapy started.: ",ONC(165.5,DA,152)
 W !," Chemotherapy..................: ",ONC(165.5,DA,53),?44,$E(ONC(165.5,DA,53.2),1,34)
 W !," Chemotherapy @fac.............: ",ONC(165.5,DA,53.4),?44,$E(ONC(165.5,DA,53.3),1,34)
 W !," Hormone therapy...............: ",ONC(165.5,DA,54),?44,$E(ONC(165.5,DA,54.2),1,34)
 W !," Hormone therapy @fac..........: ",ONC(165.5,DA,54.4),?44,$E(ONC(165.5,DA,54.3),1,34)
 W !," Immunotherapy.................: ",ONC(165.5,DA,55),?44,$E(ONC(165.5,DA,55.2),1,34)
 W !," Immunotherapy @fac............: ",ONC(165.5,DA,55.4),?44,$E(ONC(165.5,DA,55.3),1,34)
 W !," Hema Trans/Endocrine Proc.....: ",ONC(165.5,DA,153.1),?44,$E(ONC(165.5,DA,153),1,34)
 W:DATEDX>3051231 !," Systemic/Surgery Sequence.....: ",ONC(165.5,DA,15)
 W !,DASHES
 Q
OTH D FST^ONCOAIP
 W !," OTHER TREATMENT"
 W !," ---------------"
 N DI,DIC,DR,DA,DIQ K ONC
 S DIC="^ONCO(165.5,"
 S DR="57;57.2;57.3;57.4"
 S DA=D0,DIQ="ONC(" D EN^DIQ1
 F I=57,57.2,57.3,57.4 S X=ONC(165.5,D0,I) D UCASE S ONC(165.5,D0,I)=X
 W !," Other treatment...............: ",ONC(165.5,DA,57)," ",ONC(165.5,DA,57.2)
 W !," Other treatment @fac..........: ",ONC(165.5,DA,57.4)," ",ONC(165.5,DA,57.3)
 W !,DASHES
 Q
PRO D FST^ONCOAIP
 W !," PALLIATIVE CARE/PROTOCOL PARTICIPATION"
 W !," -------------------------------------------"
 N DI,DIC,DR,DA,DIQ K ONC
 S DIC="^ONCO(165.5,"
 S DR="133;560;154;12;13;346"
 S DA=D0,DIQ="ONC(" D EN^DIQ1
 F I=560,154,12,13,346 S X=ONC(165.5,D0,I) D UCASE S ONC(165.5,D0,I)=X
 ;W !," Pain assessment...............: ",ONC(165.5,DA,154)
 W !," Palliative care...............: ",ONC(165.5,DA,12)
 W !," Palliative care @fac..........: ",ONC(165.5,DA,13)
 W !
 W !," Protocol eligibility status...: "_ONC(165.5,DA,346)
 W !," Protocol participation........: "_ONC(165.5,DA,560)
 W !," Year put on protocol..........: "_ONC(165.5,DA,133)
 W !,DASHES
 Q
 ;
TXT S (TXT1,TXT2)="",LOS=$L(TXT) I LOS<LEN S TXT1=TXT Q
 S NOP=$L($E(TXT,1,LEN)," ")
 S TXT1=$P(TXT," ",1,NOP-1),TXT2=$P(TXT," ",NOP,999)
 Q
 ;
UCASE S X=$TR(X,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 Q
