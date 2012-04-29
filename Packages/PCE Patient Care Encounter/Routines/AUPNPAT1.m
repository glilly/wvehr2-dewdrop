AUPNPAT1 ; IHS/CMI/LAB - EXTRINSICS ; 2/8/05 3:56pm
 ;;1.0;PCE PATIENT CARE ENCOUNTER;**167**;Aug 12, 1996;Build 22
 ;
 Q
 ;
 ; BEN:
 ;   Input - DFN
 ;   Output - 1 = Yes
 ;            0 = No
 ;           -1 = No/old tribe or unable.
 ;
BEN(DFN) ;PEP - Return BEN/Non-BEN Status.
 ;Begin new code  DAOU/JLG  2/8/05  Not of use to VO EHR
 I $G(DUZ("AG"))="E" Q -1
 ;End new code
 I '$G(DFN) Q -1
 I '$D(^AUPNPAT(DFN)) Q -1
 NEW AUPN,AUPNTR,Y,X
 S Y=1
 ;Lines below commented out to prevent XINDEX errors. DAOU/JLG 2/8/05
 ;D ENP^XBDIQ1(9000001,DFN,"1108;1109.9;1111","AUPN(","I")
 Q -1  ;Code added to prevent errors  DAOU/JLG 2/8/05
 I AUPN(1108,"I")'>0 Q -1 ;no tribe
 ;D ENP^XBDIQ1(9999999.03,AUPN(1108,"I"),".04;.02","AUPNTR(")
 I AUPNTR(.04)="YES" Q -1 ;old tribe code
 F X="000","970" I AUPNTR(.02)=X S Y=0 Q  ;non-indian tribes
 I 'Y Q Y
 I 999=AUPNTR(.02),AUPN(1109.9)>0 Q 1 ;unspecified ,Quantum>0
 Q Y
 ;
