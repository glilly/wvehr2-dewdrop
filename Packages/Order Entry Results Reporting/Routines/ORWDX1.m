ORWDX1  ; SLC/KCM/REV - Utilities for Order Dialogs ;06/06/2007
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**85,187,195,215,243**;Dec 17, 1997;Build 242
        ;
WRLST(LST,LOC)  ; Return list of dialogs for writing orders
        ; .Y(n): DlgName^ListBox Text
WRLST1  N ANENT
        S LOC=+$G(LOC)_";SC(" I 'LOC S LOC=""
        S ANENT="ALL^"_LOC_$S($G(^VA(200,DUZ,5)):"^SRV.`"_+$G(^(5)),1:"")
        D WRLSTB(.LST) Q:$D(LST)>1  ; check ORWDX WRITE ORDERS first
        N ORX,X0,X5,ORERR,I,SEQ,IEN,DGRP,FID,TXT,TYP
        D GETLST^XPAR(.ORX,ANENT,"ORWOR WRITE ORDERS LIST","Q",.ORERR) Q:ORERR
        S I=0 F  S I=$O(ORX(I)) Q:'I  D
        . S SEQ=+ORX(I),IEN=$P(ORX(I),U,2),X0=$G(^ORD(101.41,+IEN,0)),X5=$G(^(5))
        . S DGRP=+$P(X0,U,5),FID=+$P(X5,U,5),TXT=$P(X5,U,4),TYP=$P(X0,U,4)
        . S:'$L(TXT) TXT=$P(X0,U,2)
        . I $P(X0,U,4)="M" S:'FID FID=1001
        . S LST(SEQ)=IEN_";"_FID_";"_DGRP_";"_TYP_U_TXT
        Q
WRLSTB(LST)         ; return menu from which Write Orders list is built
        N MNU,SEQ,IEN,ITM,TXT,FID,DGRP,X,TYP
        S MNU=$$GET^XPAR(ANENT,"ORWDX WRITE ORDERS LIST",1,"I") Q:'MNU
        S SEQ=0 F  S SEQ=$O(^ORD(101.41,MNU,10,"B",SEQ)) Q:'SEQ  D
        . S IEN=0 F  S IEN=$O(^ORD(101.41,MNU,10,"B",SEQ,IEN)) Q:'IEN  D
        . . S X=$G(^ORD(101.41,MNU,10,IEN,0)),ITM=+$P(X,U,2),TXT=$P(X,U,4)
        . . S X=$G(^ORD(101.41,ITM,5)),FID=+$P(X,U,5)
        . . S X=$G(^ORD(101.41,ITM,0)),TYP=$P(X,U,4),DGRP=+$P(X,U,5)
        . . S:'$L(TXT) TXT=$P(X,U,2)
        . . I TYP="M" S:'FID FID=1001
        . . S LST(SEQ)=ITM_";"_FID_";"_DGRP_";"_TYP_U_TXT
        Q
DELPI   ; delete PI from ORDIALOG if PI = ""
        ;Called from SAVE^ORWDX
        N ORPI S ORPI=0
        S ORPI=$O(^ORD(101.41,"B","OR GTX PATIENT INSTRUCTIONS",ORPI))
        Q:'$D(ORDIALOG(ORPI))
        I '$D(ORDIALOG(ORPI,1)) K ORDIALOG(ORPI),ORDIALOG("WP",ORPI) Q
        N PINODE,PITX
        S PITX="",PINODE=$G(ORDIALOG(ORPI,1))
        S PITX=$G(@PINODE@(1,0))
        S PITX=$TR(PITX," ","")
        I '$L(PITX) K ORDIALOG(ORPI),ORDIALOG("WP",ORPI) Q
        N ORSIG S ORSIG=+$O(^ORD(101.41,"B","OR GTX SIG",0))
        I $$STR^ORWDXR(ORSIG)[$$STR^ORWDXR(ORPI) S ORDIALOG(ORPI,"FORMAT")="@"
        Q
FNDINFO(Y,ODIEN)        ;
        N ODI,CRTM,FRM,XX
        S FRM="",CRTM=$$NOW^XLFDT
        F  S FRM=$O(^ORD(101.43,XRF,FRM)) Q:FRM=""  D
        . S ODI=0 F  S ODI=$O(^ORD(101.43,XRF,FRM,ODI)) Q:'ODI  D
        .. S XX=^ORD(101.43,XRF,FRM,ODI)
        .. I +$P(XX,U,3),$P(XX,U,3)<CRTM Q
        .. I ODI=ODIEN D
        ... S NM=NM+1
        ... I 'XX S Y(NM)=ODIEN_U_$P(XX,U,2)_U_$P(XX,U,2)
        ... E  S Y(NM)=ODIEN_U_$P(XX,U,2)_$C(9)_"<"_$P(XX,U,4)_">"_U_$P(XX,U,4)
        Q
DLGDEF(LST,DLG) ; Format mapping for a dlg
        N I,IEN,ILST,X0,X2,XW  S ILST=0
        I $O(^ORD(101.41,"AB",DLG,0))>0 S DLG=$O(^ORD(101.41,"AB",DLG,0))
        E  S DLG=$O(^ORD(101.41,"B",DLG,0))
        Q:'DLG
        S I=0 F  S I=$O(^ORD(101.41,DLG,10,I)) Q:I'>0  D
        . S X0=$G(^ORD(101.41,DLG,10,I,0)),X2=$G(^(2)),IEN=+$P(X0,U,2)
        . S ILST=ILST+1,LST(ILST)=U_IEN_U_$P(X2,U,1,7)
        . I $P(X0,U,11) S $P(LST(ILST),U,11)=1
        . S $P(LST(ILST),U)=$P($G(^ORD(101.41,IEN,1)),U,3)
        . I $P($G(^ORD(101.41,IEN,0)),U)="OR GTX ADDITIVE" S $P(LST(ILST),U)="ADDITIVE"
        . I $P($G(^ORD(101.41,IEN,0)),U)="OR GTX ADDL DIETS" S $P(LST(ILST),U)="ADDLDIETS"
        . I $L($P(LST(ILST),U))=0 S $P(LST(ILST),U)="ID"_IEN
        . I $D(^ORD(101.41,DLG,10,"DAD",IEN)) D
        .. N SEQ,DA,CHILD S CHILD=""
        .. S SEQ=0 F  S SEQ=$O(^ORD(101.41,DLG,10,"DAD",IEN,SEQ)) Q:'SEQ  D
        ... S DA=0 F  S DA=$O(^ORD(101.41,DLG,10,"DAD",IEN,SEQ,DA)) Q:'DA  D
        .... S CHILD=CHILD_+$P($G(^ORD(101.41,DLG,10,DA,0)),U,2)_"~"
        .. S $P(LST(ILST),U,10)=CHILD
        Q
        ;
CHANGE(ORLST,ORCLST,DFN,ISIMO)  ;
        N CATCH,CHANGE,CNT,INP,INPDIEN,IVM,IVMDIEN,ORIEN,ORLOC,OR3,ORDG
        N CIEN,DIAL,TDIAL,TDIEN,UDIEN,QORDDG,PACKIEN
        S (INP,IVM,INPDIEN,IVMDIEN,UDIEN)=0
        S (TDIAL,TDIEN)=0
        S INP=$O(^ORD(101.41,"B","PSJ OR PAT OE","")) Q:INP'>0
        S IVM=$O(^ORD(101.41,"B","PSJI OR PAT FLUID OE","")) Q:IVM'>0
        S TDIAL=$O(^ORD(101.41,"B","OR GXTEXT WORD PROCESSING ORDER","")) Q:TDIAL'>0
        S INPDIEN=$O(^ORD(100.98,"B","INPATIENT MEDICATIONS","")) Q:INPDIEN'>0
        S IVMDIEN=$O(^ORD(100.98,"B","IV MEDICATIONS","")) Q:IVMDIEN'>0
        S UDIEN=$O(^ORD(100.98,"B","UNIT DOSE MEDICATIONS","")) Q:UDIEN'>0
        S TIEN=$O(^ORD(100.98,"B","NURSING","")) Q:TIEN'>0
        S CIEN=$O(^ORD(100.98,"B","CLINIC ORDERS","")) Q:CIEN'>0
        S CNT=0 F  S CNT=$O(ORCLST(CNT)) Q:CNT'>0  D
        .S CHANGE=0
        .S ORIEN=$P($G(ORCLST(CNT)),U),ORIEN=$P(ORIEN,";")
        .S ORDG=$P($G(^OR(100,ORIEN,0)),U,11)
        .S ORLOC=$P($G(ORCLST(CNT)),U,2)
        .S OR3=$G(^OR(100,ORIEN,3))
        .S DIAL=$P(OR3,U,4)
        .;Remove Treating Speciality if the order location is the clinic
        .I $P($G(^OR(100,ORIEN,0)),U,10)=(ORLOC_";SC("),$P($G(^SC(ORLOC,0)),U,3)="C" D  Q
        ..S $P(^OR(100,ORIEN,0),U,13)=""
        .;
        .;CHANGE PATIENT LOCATION AND PATIENT STATUS.
        .S $P(^OR(100,ORIEN,0),U,10)=ORLOC_";SC("
        .S PACKIEN=$P(^OR(100,ORIEN,0),U,14)
        .I $$GET1^DIQ(9.4,PACKIEN_",",1)'="PSO" S $P(^OR(100,ORIEN,0),U,12)="I"
        .;
        .;Check for IMO orders Nursing Dialog problem
        .S CATCH=$P($G(^OR(100,ORIEN,0)),U,11)
        .;
        .S $P(^OR(100,ORIEN,0),U,11)=$S(DIAL=(IVM_";ORD(101.41,"):IVMDIEN,DIAL=(INP_";ORD(101.41,"):INPDIEN,DIAL=(TDIAL_";ORD(101.41,"):TIEN,1:CATCH)
        .;
        .;Check for Quick Order Dialog
        .I CATCH=$P($G(^OR(100,ORIEN,0)),U,11),ISIMO=1 D
        ..S QORDDG=$P($G(^ORD(101.41,+DIAL,0)),U,5)
        ..I QORDDG=UDIEN!(QORDDG=INPDIEN) S $P(^OR(100,ORIEN,0),U,11)=INPDIEN,DIAL=(INP_";ORD(101.41,") Q
        ..I QORDDG=IVMDIEN S $P(^OR(100,ORIEN,0),U,11)=IVMDIEN,DIAL=(IVM_";ORD(101.41,") Q
        ..I QORDDG=TIEN S $P(^OR(100,ORIEN,0),U,11)=TIEN,DIAL=(TDIAL_";ORD(101.41,") Q
        .;
        .;Add treating spec if Inpatient order
        .;I (ISIMO=1)&(DIAL=(IVM_";ORD(101.41,"))!(DIAL=(INP_";ORD(101.41,")) D
        .;.S $P(^OR(100,ORIEN,0),U,13)=+$G(^DPT(DFN,.103))
        .I ISIMO=0 S $P(^OR(100,ORIEN,0),U,13)=+$G(^DPT(DFN,.103))
        Q
        ;
STCHANGE(ORY,DFN,ORYARR)        ;
        N CNT,DONE,NODE,PHARMID,STR,STATUS
        S ORY=0,DONE=0
        I '$$PATCH^XPDUTL("PSS*1.0*93") Q
        S CNT=0 F  S CNT=$O(ORYARR(CNT)) Q:CNT'>0!(DONE>0)  D
        . S NODE=$G(ORYARR(CNT))
        . S PHARMID=$P(NODE,U),STATUS=$P(NODE,U,2)
        . I $$UP^XLFSTR(STATUS)'=$$STATUS^PSSORUTE(DFN,PHARMID) S ORY=1,DONE=1
        Q
ORDMATCH(ORY,DFN,ORYARR)        ;
        N ACTION,CNT,IEN,MATCH,ORDERID,STATUS
        S CNT=0,MATCH=1
        F  S CNT=$O(ORYARR(CNT)) Q:CNT'>0!(MATCH=0)  D
        . S ORDERID=$P(ORYARR(CNT),U),STATUS=$P(ORYARR(CNT),U,2)
        . I ORDERID=0,$G(ACTION)="" Q
        . S IEN=$P(ORDERID,";"),ACTION=$P(ORDERID,";",2)
        . I STATUS=$P($G(^OR(100,IEN,3)),U,3) Q
        . I $P($G(^ORD(100.01,STATUS,0)),U)="DISCONTINUED/EDIT" Q
        . ;S MATCH=0
        . I $P($G(^OR(100,IEN,8,ACTION,0)),U,15)'=STATUS S MATCH=0
        S ORY=MATCH
        Q
        ;
DCREN(ORY,ORYARR)       ;
        N ACT,CNT,CNT1,I,OR3,ORG,ORGID,ORID,TEXT,STATUS
        S CNT1=0
        S CNT=0 F  S CNT=$O(ORYARR(CNT)) Q:CNT'>0  D
        .S ORGID=ORYARR(CNT)
        .S ORID=+ORGID,ACT=$P(ORGID,";",2),TEXT=""
        .S OR3=$G(^OR(100,ORID,3))
        .;Make sure current order status is pending
        .I $P($G(^ORD(100.01,$P(OR3,U,3),0)),U)'="PENDING" Q
        .S ORG=$P($G(OR3),U,5) Q:ORG'>0
        .;do not add original order if it is expired
        .S STATUS=$P(^OR(100,ORG,3),U,3)
        .I $P($G(^ORD(100.01,STATUS,0)),U)="EXPIRED" Q
        .;Do not add original order if Stop date has pass
        .I $P(^OR(100,ORG,0),U,9)'>$$NOW^XLFDT Q
        .;make sure current order is a renewed order
        .I $P(OR3,U,11)'=2 Q
        .S ACT=+$P($G(^OR(100,ORG,3)),U,7)
        .S CNT1=CNT1+1,ORY(CNT1)=ORGID_U_$P(OR3,U,5)_";"_ACT_U_TEXT
        Q
DCORIG(ORY,ORIEN)       ;
        S $P(^OR(100,+ORIEN,6),U,9)=1
        Q
UNDCORIG(ORY,ORYARR)    ;
        N CNT
        S CNT=0 F  S CNT=$O(ORYARR(CNT)) Q:CNT'>0  S $P(^OR(100,+ORYARR(CNT),6),U,9)=0
        Q
PATWARD(ORY,DFN)        ;
        S ORY=0
        I $G(^DPT(DFN,.1))'="" S ORY=1
        Q
ISPEND(ORIFN)   ;Is the order's status pending?
        N ISPEND,PENDST,N3 S ISPEND=0
        Q:'$D(^OR(100,+ORIFN,3))
        S PENDST=$O(^ORD(100.01,"B","PENDING",0))
        S N3=$G(^OR(100,+ORIFN,3))
        I $P(N3,U,3)=PENDST S ISPEND=1
        Q ISPEND
