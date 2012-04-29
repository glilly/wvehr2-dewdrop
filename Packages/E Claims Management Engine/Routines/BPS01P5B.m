BPS01P5B ;BHAM ISC/BEE - Post-Install for BPS*1*5 (cont) ;13-DEC-06
 ;;1.0;E CLAIMS MGMT ENGINE;**5**;JUN 2004;Build 45
 ;;Per VHA Directive 2004-038, this routine should not be modified.
 ;
 Q
 ;
 ; Called by the BPS*1.0*5 Post-Install routine BPS01P5.
 ;
EN N DA,DIK,F,FILE,FIELD,FLDNUM,IFLD,XEC
 F F=2,201,31,56,56011,57,58,59,6,91,9102,99,9902,9903,9905,9904,992271,992273,992274,992279,9901,992388,992389 S FILE=$P($T(@F),";",3) F IFLD=1:1 S FLDNUM=$P($T(@F+IFLD),";",3) Q:FLDNUM="END"  D
 .I FLDNUM]"" S DIK="^DD("_FILE_",",DA=FLDNUM,DA(1)=FILE D ^DIK
 .S XEC=$P($T(@F+IFLD),";",4) I XEC]"" X XEC
 Q
 ;
 ;BPS CLAIMS (#9002313.02)
2 ;;9002313.02
 ;;1.02
 ;;1.03
 ;;308
 ;;315
 ;;316
 ;;317
 ;;318
 ;;319
 ;;320
 ;;327
 ;;329
 ;;498.09
 ;;END
 ;
 ;BPS CLAIMS - Medication(s) (#9002313.0201)
201 ;;9002313.0201
 ;;.02
 ;;404
 ;;410
 ;;416
 ;;422
 ;;425
 ;;428
 ;;432
 ;;437
 ;;439
 ;;440
 ;;441
 ;;END
 ;
 ;BPS CERTIFICATION (#9002313.31)
31 ;;9002313.31
 ;;.05
 ;;901
 ;;END
 ;
 ;BPS PHARMACIES (#9002313.56)
56 ;;9002313.56
 ;;.04
 ;;.05
 ;;.06
 ;;.07
 ;;3001.01
 ;;3001.02
 ;;END
 ;
 ;BPS PHARMACIES - PRESCRIBER (#9002313.56011) - Field 1 In OUTPATIENT SITE Multiple
56011 ;;9002313.56011
 ;;;N DIU S DIU=9002313.56011,DIU(0)="DS" D EN^DIU2 K DIU
 ;;END
 ;
 ;BPS LOG OF TRANSACTIONS (#9002313.57)
57 ;;9002313.57
 ;;.13
 ;;.14
 ;;.15
 ;;.16
 ;;1.05
 ;;1.06
 ;;1.14
 ;;8
 ;;8.0099
 ;;12
 ;;16
 ;;301
 ;;302
 ;;403
 ;;506
 ;;601
 ;;602
 ;;603
 ;;701
 ;;702
 ;;703
 ;;802
 ;;END
 ;
 ;BPS STATISTICS (#9002313.58)
58 ;;9002313.58
 ;;301
 ;;302
 ;;402
 ;;403
 ;;404
 ;;405
 ;;406
 ;;407
 ;;408
 ;;409
 ;;411
 ;;412
 ;;413
 ;;414
 ;;415
 ;;419
 ;;501
 ;;601
 ;;602
 ;;603
 ;;604
 ;;701
 ;;702
 ;;703
 ;;704
 ;;705
 ;;709
 ;;719
 ;;801
 ;;802
 ;;803
 ;;804
 ;;809
 ;;901
 ;;902
 ;;903
 ;;904
 ;;909
 ;;1001
 ;;1002
 ;;1101
 ;;1102
 ;;1103
 ;;END
 ;
 ;BPS TRANSACTION (#9002313.59)
59 ;;9002313.59
 ;;.13
 ;;.14
 ;;.15
 ;;.16
 ;;1.05
 ;;1.06
 ;;1.14
 ;;8
 ;;8.0099
 ;;12
 ;;16
 ;;301
 ;;302
 ;;403
 ;;506
 ;;601
 ;;602
 ;;603
 ;;701
 ;;702
 ;;703
 ;;802
 ;;END
 ;
 ;BPS PHARMACIES - INSURER-ASSIGNED # (#9002313.6)/Field 950
6 ;;9002313.6
 ;;;N DIU S DIU=9002313.6,DIU(0)="DS" D EN^DIU2 K DIU
 ;;END
 ;
 ;BPS NCPDP FIELD DEFS (#9002313.91)
91 ;;9002313.91
 ;;.02
 ;;.05
 ;;END
 ;
 ;BPS NCPDP FIELD DEFS - FORMAT CODE (#9002313.9102)/Field 20
9102 ;;9002313.9102
 ;;;N DIU S DIU=9002313.9102,DIU(0)="DS" D EN^DIU2 K DIU
 ;;END
 ;
 ;BPS SETUP (#9002313.99)
99 ;;9002313.99
 ;;2.01
 ;;115.01
 ;;115.02
 ;;119.01
 ;;119.02
 ;;119.03
 ;;119.04
 ;;119.05
 ;;120.01
 ;;120.02
 ;;120.03
 ;;120.04
 ;;120.05
 ;;120.06
 ;;120.07
 ;;140.01
 ;;140.02
 ;;140.03
 ;;170.01
 ;;230.01
 ;;235.01
 ;;235.02
 ;;235.03
 ;;235.04
 ;;235.05
 ;;235.06
 ;;235.07
 ;;370.01
 ;;370.02
 ;;370.03
 ;;440.01
 ;;577.01
 ;;577.02
 ;;577.03
 ;;577.04
 ;;577.05
 ;;665.01
 ;;665.02
 ;;665.03
 ;;665.04
 ;;667.01
 ;;667.02
 ;;941
 ;;942
 ;;943
 ;;951
 ;;952
 ;;953
 ;;960.01
 ;;960.02
 ;;960.03
 ;;960.04
 ;;960.05
 ;;1490
 ;;1501
 ;;1660.01
 ;;1801
 ;;1811.01
 ;;1960.01
 ;;1960.02
 ;;1960.03
 ;;1980.01
 ;;2128.13
 ;;2270.01
 ;;2270.02
 ;;2270.03
 ;;2270.04
 ;;2270.05
 ;;2270.06
 ;;2270.11
 ;;2270.12
 ;;2270.7
 ;;2270.8
 ;;2270.9
 ;;2272.01
 ;;2341.02
 ;;2341.04
 ;;2341.05
 ;;2341.06
 ;;2341.07
 ;;2341.08
 ;;2341.09
 ;;2341.1
 ;;2341.11
 ;;2342.01
 ;;2342.02
 ;;2342.03
 ;;2343.01
 ;;5151
 ;;END
 ;
 ;BPS SETUP - BILLING LOG FILE (#9002313.9902)/Field 240
9902 ;;9002313.9902
 ;;;N DIU S DIU=9002313.9902,DIU(0)="DS" D EN^DIU2 K DIU
 ;;END
 ;
 ;BPS SETUP - INS RULE ORDER (#9002313.9903)/Field 970.01
9903 ;;9002313.9903
 ;;;N DIU S DIU=9002313.9903,DIU(0)="DS" D EN^DIU2 K DIU
 ;;END
 ;
 ;BPS SETUP - UNBILLABLE NDC # (#9002313.9905)/Field 2128.11
9905 ;;9002313.9905
 ;;;N DIU S DIU=9002313.9905,DIU(0)="DS" D EN^DIU2 K DIU
 ;;END
 ;
 ;BPS SETUP - UNBILLABLE DRUG NAME (#9002313.9904)/Field 2128.12
9904 ;;9002313.9904
 ;;;N DIU S DIU=9002313.9904,DIU(0)="DS" D EN^DIU2 K DIU
 ;;END
 ;
 ;BPS SETUP - WO ARTYPE (#9002313.992271)/Field 2271
992271 ;;9002313.992271
 ;;;N DIU S DIU=9002313.992271,DIU(0)="DS" D EN^DIU2 K DIU
 ;;END
 ;
 ;BPS SETUP - WO CLINIC (#9002313.992273)/Field 2273
992273 ;;9002313.992273
 ;;;N DIU S DIU=9002313.992273,DIU(0)="DS" D EN^DIU2 K DIU
 ;;END
 ;
 ;BPS SETUP - WO DIAG (#9002313.992274)/Field 2274
992274 ;;9002313.992274
 ;;;N DIU S DIU=9002313.992274,DIU(0)="DS" D EN^DIU2 K DIU
 ;;END
 ;
 ;BPS SETUP - WO INSURER (#9002313.992279)/Field 2279
992279 ;;9002313.992279
 ;;;N DIU S DIU=9002313.992279,DIU(0)="DS" D EN^DIU2 K DIU
 ;;END
 ;
 ;BPS SETUP - WORKERS COMP (#9002313.9901)/Field 2380
9901 ;;9002313.9901
 ;;;N DIU S DIU=9002313.9901,DIU(0)="DS" D EN^DIU2 K DIU
 ;;END
 ;
 ;BPS SETUP - WRITE OFF INSURER (#9002313.992388)/Field 2388
992388 ;;9002313.992388
 ;;;N DIU S DIU=9002313.992388,DIU(0)="DS" D EN^DIU2 K DIU
 ;;END
 ;
 ;BPS SETUP - WRITE OFF SELF PAY (#9002313.992389)/Field 2389
992389 ;;9002313.992389
 ;;;N DIU S DIU=9002313.992389,DIU(0)="DS" D EN^DIU2 K DIU
 ;;END
 ;
 ; STAT - This procedure will adjust the Statistics buckets.
 ;  It should move some claims from the OTHER bucket to the Accepted
 ;    Reversal bucket
 ;  It should move claims from the REJECTED bucket to the Rejected
 ;    Reversal bucket
 ;
STAT ; EP - BPS01P5
 ; Initialize variables
 N RESPDT,RESPIEN,POS,REV,RESP,PIECE,RESP1
 N CLOSEDT,CLAIMIEN,DROP
 F PIECE=2:1:8,19 S $P(RESP1,U,PIECE)=0
 ;
 ; Get date when stats were last cleared
 ;   If missing, set to 1/1/2001, which preceeds initial ECME install
 ;   Subtract one second for starting time of loop
 S RESPDT=$$GET1^DIQ(9002313.58,1,2,"I")
 I RESPDT="" S RESPDT=3010101
 S RESPDT=$$FMADD^XLFDT(RESPDT,0,0,0,-1)
 S CLOSEDT=RESPDT
 ;
 ; Loop trough BPS Response starting with Zero-Out Date,
 ;   get response and update counters
 F  S RESPDT=$O(^BPSR("AE",RESPDT)) Q:RESPDT=""  D
 . S RESPIEN=""  F  S RESPIEN=$O(^BPSR("AE",RESPDT,RESPIEN)) Q:RESPIEN=""  D
 .. S POS=$O(^BPSR(RESPIEN,1000,0))
 .. I POS="" Q
 .. S REV=$$GET1^DIQ(9002313.03,RESPIEN,103)="B2"
 .. S RESP=$$GET1^DIQ(9002313.0301,POS_","_RESPIEN,501,"I")
 .. S PIECE=$S(RESP="R"&REV:7,RESP="R":2,RESP="P":3,RESP="D":4,RESP="C":5,RESP="A":6,1:19)
 .. S $P(RESP1,U,PIECE)=$P(RESP1,U,PIECE)+1
 ;
 ; Loop through Closed Date cross-reference of BPS Claims starting
 ;   with Zero-Out Date and update Dropped to Paper bucket
 F  S CLOSEDT=$O(^BPSC("AG",CLOSEDT)) Q:CLOSEDT=""  D
 . S CLAIMIEN=""  F  S CLAIMIEN=$O(^BPSC("AG",CLOSEDT,CLAIMIEN)) Q:CLAIMIEN=""  D
 .. S DROP=$$GET1^DIQ(9002313.02,CLAIMIEN,905,"I")
 .. I DROP="D" S $P(RESP1,U,8)=$P(RESP1,U,8)+1
 ;
 ; Set up XTMP global
 N X,X1,X2
 S X1=DT,X2=60 D C^%DTC
 S ^XTMP("BPS01P5B",0)=X_U_DT_U_"BPS Stats Update"
 M ^XTMP("BPS01P5B","STATS")=^BPSECX("S",1)
 ;
 ; Save off old stats and reset stats
 L +^BPSECX("S",1,"R"):5
 S $P(^BPSECX("S",1,"R"),U,2,8)=$P(RESP1,U,2,8)
 S $P(^BPSECX("S",1,"R"),U,19)=$P(RESP1,U,19)
 L -^BPSECX("S",1,"R")
 Q
 ;
 ; SUBMIT - Move Submit Date/Time from submit queue to
 ;   BPS Transaction
SUBMIT ;
 ; Initialize variables
 N RXI,RXR,IEN59,SUBDT
 ;
 ; Get RX/Fill from submit queue
 S RXI=""
 F  S RXI=$O(^XTMP("BPSOSRX",RXI)) Q:RXI=""  D
 . S RXR="" F  S RXR=$O(^XTMP("BPSOSRX",RXI,RXR)) Q:RXR=""  D
 .. ; Calculate IEN59
 .. S IEN59=$$IEN59^BPSOSRX(RXI,RXR)
 .. ; If no IEN59 or zero node not defined, quit
 .. I IEN59="" Q
 .. I '$D(^BPST(IEN59,0)) Q
 .. ; Get submit date and quit if not there
 .. S SUBDT=$G(^XTMP("BPSOSRX",RXI,RXR))
 .. I SUBDT="" Q
 .. ; If not processed yet, quit
 .. I $D(^XTMP("BPS-PROC","CLAIM",RXI,RXR)) Q
 .. I $D(^XTMP("BPS-PROC","UNCLAIM",RXI,RXR)) Q
 .. ; Store in BPS Transaction
 .. S $P(^BPST(IEN59,0),U,7)=SUBDT
 Q
