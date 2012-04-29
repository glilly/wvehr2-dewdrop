PRCVREA ;WOIFO/VC-Transmit HL7 message to IFCAP for RIL(cont);11/24/03 ; 2/29/08 1:54pm
        ;;5.1;IFCAP;**81,119**;Oct 20, 2000;Build 8
        ;Per VHA Directive 2004-038, this routine should not be modified
        ;
CALLIT  ;Call the IFCAP RIL build Routine
        ;
        D EN^PRCVRC1(PRCSUB)
        ;
SETUP   S PRCHD(1)=""
        ;Added 1,"T" node to stop crash
        S PRCHD(1,"T")="ORDER HEADER INFO"
        S PRCHD(2)="ORC"_PRCCS_PRCCS_3
        S PRCHD(2,"T")="FUND CONTROL POINT"
        S PRCHD(3)="ORC"_PRCCS_PRCCS_17
        S PRCHD(3,"T")="COST CENTER"
        S PRCHD(4)=""
        S PRCHD(5)="ORC"_PRCCS_PRCCS_21
        S PRCHD(5,"T")="SITE NUMBER"
        S PRCHD(6)=""
        S PRCHD(7)="ORC"_PRCCS_PRCCS_10
        S PRCHD(7,"T")="DUZ"
        S PRCHD(8)="ORC"_PRCCS_PRCCS_10
        S PRCHD(8,"T")="LAST NAME"
        S PRCHD(9)="ORC"_PRCCS_PRCCS_11
        S PRCHD(9,"T")="FIRST NAME"
        S PRCDET(1)="RQD"_PRCCS_PRCCS_3
        S PRCDET(1,"T")="ITEM NUMBER"
        S PRCDET(2)="RQD"_PRCCS_PRCCS_5
        S PRCDET(2,"T")="QUANTITY"
        S PRCDET(3)="RQ1"_PRCCS_PRCCS_4
        S PRCDET(3,"T")="VENDOR ID"
        S PRCDET(4)="RQ1"_PRCCS_PRCCS_1
        S PRCDET(4,"T")="UNIT COST"
        S PRCDET(5)="RQD"_PRCCS_PRCCS_10
        S PRCDET(5,"T")="DATE NEEDED"
        S PRCDET(6)="RQD"_PRCCS_PRCCS_2
        S PRCDET(6,"T")="DYNAMED DOCUMENT ID"
        S PRCDET(7)="RQ1"_PRCCS_PRCCS_5
        S PRCDET(7,"T")="NIF NUMBER"
        S PRCDET(8)="RQ1"_PRCCS_PRCCS_3
        S PRCDET(8,"T")="BOC"
        ;Check if IFCAP has returned any errors
        ;
        S ERRCNT=1
        S PRCVERR(0)="0"
HEAD    ;If there are errors in the "1" sub-segment, add all errors to all
        ;   line items
        S ERRCNT=1,MSGFLG=0,PRCSUB2=$P(PRCSUB,"*",2)
        I $D(^XTMP(PRCSUB,1,"ERR"))>0 D
        .S II=0
        .F I=1:1 S II=$O(^XTMP(PRCSUB,1,"ERR",II)) Q:II=""  D
        ..S ERRDAT=$G(^XTMP(PRCSUB,1,"ERR",II))
        ..Q:ERRDAT=""
        ..S MSGFLG=1
        ..S FLDNO=$P(ERRDAT,U,1),ERRCOD="PRCV"_$P(ERRDAT,U,2),ERRTXT=$P(ERRDAT,U,3)
        ..S SEVER=$P(ERRDAT,U,4)
        ..S ERRSTR="ERR"_PRCFS_PRCFS_PRCHD(FLDNO)_PRCFS_"207"_PRCCS_"Application internal error"_PRCCS_"HL70357"_PRCFS_SEVER_PRCFS_ERRCOD_PRCCS_ERRTXT_PRCFS
        ..S PRCVERR(ERRCNT)="Error in Requisition Header for "_PRCHD(FLDNO,"T")_" from HL7 MESSAGE "_PRCSUB2_" "_ERRCOD_" "_ERRTXT,ERRCNT=ERRCNT+1
        ..S J=0
        ..F IL=1:1 S J=$O(^XTMP(PRCSUB,2,J)) Q:J=""  D
        ...S ERRSUB=$P(ERRSTR,PRCFS,3)
        ...S $P(ERRSUB,U,2)=J
        ...S $P(ERRSTR,PRCFS,3)=ERRSUB
        ...;S $P($P(ERRSTR,PRCFS,3),U,2)=J
        ...S $P(ERRSTR,PRCFS,7)=$P($G(^XTMP(PRCSUB,2,J)),U,6)
        ...S ^TMP("PRCVRIL",$J,"NAK",ACKCNT)=ERRSTR,ACKCNT=ACKCNT+1
DETAIL  ;If there are errors in the detail lines, add them
        S II=0
        F I=1:1 S II=$O(^XTMP(PRCSUB,2,II)) Q:II=""  D
        .S DOCID=$P(^XTMP(PRCSUB,2,II),U,6)
        .S III=0
        .F J=1:1 S III=$O(^XTMP(PRCSUB,2,II,"ERR",III)) Q:III=""  D
        ..S ERRDAT=$G(^XTMP(PRCSUB,2,II,"ERR",III))
        ..Q:ERRDAT=""
        ..S MSGFLG=1
        ..S FLDNO=$P(ERRDAT,U,1),ERRCOD="PRCV"_$P(ERRDAT,U,2),ERRTXT=$P(ERRDAT,U,3)
        ..S ERRLOC=PRCDET(FLDNO),$P(ERRLOC,U,2)=II
        ..S SEVER=$P(ERRDAT,U,4)
        ..S ERRSTR="ERR"_PRCFS_PRCFS_ERRLOC_PRCFS_"207"_PRCCS_"Application internal error"_PRCCS_"HL70357"_PRCFS_SEVER_PRCFS_ERRCOD_PRCCS_ERRTXT_PRCFS_DOCID
        ..S ^TMP("PRCVRIL",$J,"NAK",ACKCNT)=ERRSTR,ACKCNT=ACKCNT+1
        ..S PRCVERR(ERRCNT)="Error in detail for Message Control ID "_PRCSUB2_". Field in error - "_PRCDET(FLDNO,"T")_". "_ERRTXT_" DynaMed Doc ID "_DOCID
        ..S ERRCNT=ERRCNT+1
        ;
        I MSGFLG=0 D ACKIT,CLEANUP^PRCVRE1 Q
SETNTE  ; If there are errors set an NTE segment
        ;
        S TOT=0,TOTREC=0,TOTERR=0
        F I=1:1 S TOT=$O(^XTMP(PRCSUB,2,TOT)) Q:TOT=""  D
        .S TOTREC=TOT
        .I $D(^XTMP(PRCSUB,2,TOT,"ERR"))>0 D
        ..S ERRS=0
        ..F J=1:1 S ERRS=$O(^XTMP(PRCSUB,2,TOT,"ERR",ERRS)) Q:ERRS=""  D
        ...S SEVER=$P($G(^XTMP(PRCSUB,2,TOT,"ERR",ERRS)),U,4)
        ...I SEVER'="W" S TOTERR=TOTERR+1,ERRS=99
        I $D(^XTMP(PRCSUB,2,"ERR",1))>1 S TOTERR=TOTREC
        S TOTGOOD=TOTREC-TOTERR
        S ^TMP("PRCVRIL",$J,"NAK",ACKCNT)="NTE"_PRCFS_PRCFS_PRCFS_TOTREC_"-"_TOTERR_"-"_TOTGOOD,ACKCNT=ACKCNT+1
        D NAKIT,CLEANUP^PRCVRE1 Q
        ;
NAKIT   ;Send an acknowledgement that the message is rejected
        ;
        I HL("APAT")'="AL" Q
        S MSG=""
        F I=1:1 S MSG=$O(^TMP("PRCVRIL",$J,"NAK",MSG)) Q:MSG=""  D
        .S ^TMP("HLA",$J,I)=^TMP("PRCVRIL",$J,"NAK",MSG)
        S PRCVRES=""
        D GENACK^HLMA1(HL("EID"),HLMTIENS,HL("EIDS"),"GM",1,.PRCVRES)
        ;I +$P(PRCVRES,U,2) D
        ;.S PRCVERR(ERRCNT)="Application ACK not processed. Contact EVS."
MAIL    ;Send MailMan message with error
        Q:LENVAL="NOTOK"
        N XMDUZ,XMMG,XMSUB,XMTEXT,XMY,XMZ
        S XMSUB="RIL build errors in HL7 message "_HL("MID")_" "
        S XMDUZ="IFCAP/DynaMed Interface"
        S XMTEXT="PRCVERR("
        D GETFCPU^PRCVLIC(.XMY,PRCSITE,PRCFCP)
        D ^XMD
        K XMDUZ,XMMG,XMSUB,XMTEXT,XMY,XMZ
        Q
        ;
ACKIT   ;Send an acknowledgement that everything went fine
        ;
        I HL("APAT")'="AL" Q
        F I=1:1:1 S ^TMP("HLA",$J,I)=$G(^TMP("PRCVRIL",$J,"ACK",I))
        ;
        D GENACK^HLMA1(HL("EID"),HLMTIENS,HL("EIDS"),"GM",1,.PRCVRES)
        ;I +P(PRCVRES,U,2) D
        ;.I $D(ERRCNT)=0 S ERRCNT=1
        ;.S PRCVERR(ERRCNT)="Application ACK not processed. Contact EVS."
        ;.D MAIL
        Q
