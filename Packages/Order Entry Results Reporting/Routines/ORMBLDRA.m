ORMBLDRA        ; SLC/MKB - Build outgoing Radiology ORM msgs ;05/30/06  11:30AM
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**75,97,190,195,243**;Dec 17, 1997;Build 242
HL7DATE(DATE)   ; -- FM -> HL7 format
        Q $$FMTHL7^XLFDT(DATE)  ;**97
        ;
PTR(NAME)       ; -- Returns ptr value of prompt in Dialog file
        Q $O(^ORD(101.41,"AB",$E("OR GTX "_NAME,1,63),0))
        ;
EN      ; -- Segments for new Radiology order
        N ORSEX,OI,START,IP,URG,ILOC,MODE,CATG,PREOP,PREG,MODS,CLHIST,PROV,REASON,QT,I,J,Z,J0,LIN,RA75
        S OI=$G(ORDIALOG($$PTR("ORDERABLE ITEM"),1))
        S START=$P($G(^OR(100,IFN,0)),U,8),IP=$G(ORDIALOG($$PTR("YES/NO"),1))
        S URG=$P($G(^ORD(101.42,+$G(ORDIALOG($$PTR("URGENCY"),1)),0)),U,2)
        S ILOC=$G(ORDIALOG($$PTR("IMAGING LOCATION"),1))
        S MODE=$G(ORDIALOG($$PTR("MODE OF TRANSPORT"),1))
        S CATG=$G(ORDIALOG($$PTR("CATEGORY"),1))
        S PREOP=$G(ORDIALOG($$PTR("PRE-OP SCHEDULED DATE/TIME"),1))
        S PREG=$G(ORDIALOG($$PTR("PREGNANT"),1))
        S REASON=$G(ORDIALOG($$PTR("STUDY REASON"),1))
        S MODS=$$PTR("MODIFIERS"),CLHIST=$$PTR("WORD PROCESSING 1")
        S MODS=$$MULT(MODS) S:ILOC ILOC=ILOC_U_$P($G(^RA(79.1,+ILOC,0)),U)
        S MODE=$S(MODE="A":"WALK",MODE="P":"PORT",MODE="S":"CART",1:"WHLC")
        S PREG=$S(PREG="Y":"YES",PREG="N":"NO",1:"UNKNOWN")
        S QT="^^^"_$$HL7DATE(START)_"^^"_URG,$P(ORMSG(4),"|",8)=QT
        S PROV=+$G(ORDIALOG($$PTR("PROVIDER"),1)) S:PROV $P(ORMSG(4),"|",12)=PROV
        S RA75=$$PATCH^XPDUTL("RA*5.0*75")
        S ORMSG(5)="OBR||||"_$$USID^ORMBLD(OI)_"||||||||"_$S(IP:"isolation",1:"")_"||||||"_MODS_"|"_ILOC_"|||||||||||"_MODE,I=5
        I +RA75 S $P(ORMSG(5),"|",32)=U_REASON
        ; Create DG1 & ZCL segment(s) for Billing Awareness (BA) Project
        D DG1^ORWDBA3($G(IFN),"I",I)
OBX     S J0=0
        I 'RA75 D
        . S I=I+1,ORMSG(I)="OBX|1|TX|2000.02^CLINICAL HISTORY^AS4|1|"_"REASON FOR STUDY: "_REASON
        . S $P(LIN,"-",55)=""
        . S I=I+1,ORMSG(I)="OBX|2|TX|2000.02^CLINICAL HISTORY^AS4|1|"_LIN
        . S J0=2
        S J=0 F  S J=$O(^TMP("ORWORD",$J,CLHIST,1,J)) Q:J'>0  S I=I+1,J0=J0+1,ORMSG(I)="OBX|"_J0_"|TX|2000.02^CLINICAL HISTORY^AS4|1|"_^(J,0)
        S ORSEX=$P($G(^DPT(+ORVP,0)),U,2)
        S:ORSEX="F" I=I+1,ORMSG(I)="OBX|1|TX|2000.33^PREGNANT^AS4||"_PREG
        S:PREOP I=I+1,ORMSG(I)="OBX|1|TS|^PRE-OP SCHEDULED DATE/TIME||"_$$HL7DATE(PREOP)
        I "CS"[CATG S Z=$$PTR("CONTRACT/SHARING SOURCE"),I=I+1,ORMSG(I)="OBX|1|CE|34^CONTRACT/SHARING SOURCE^99DD||"_+$G(ORDIALOG(Z,1))_U_$P($G(^DIC(34,+$G(ORDIALOG(Z,1)),0)),U)
        I CATG="R" S Z=$$PTR("RESEARCH SOURCE"),I=I+1,ORMSG(I)="OBX|1|TX|^RESEARCH SOURCE||"_$G(ORDIALOG(Z,1))
        Q
MULT(M) ; -- Returns string of MODIFIER~MODIFIER~...
        N I,X S X="" Q:'$O(ORDIALOG(M,0)) X
        S I=$O(ORDIALOG(M,0)),X=$P($G(^RAMIS(71.2,+ORDIALOG(M,I),0)),U)
        F  S I=$O(ORDIALOG(M,I)) Q:I'>0  S X=X_"~"_$P($G(^RAMIS(71.2,+ORDIALOG(M,I),0)),U)
        Q X
