TIUHL7U1        ; SLC/AJB - TIUHL7 Utilities; March 23, 2005
        ;;1.0;TEXT INTEGRATION UTILITIES;**200,228**;Jun 20, 1997
        Q
ACK(CODE,ERLOC,TIUDA)   ;
        N HLA,RESULT,TIUMID,TIUREC,TIUSND
        S HLA("HLA",1)="MSA"_HL("FS")_CODE_HL("FS")_HL("MID")_HL("FS")_$G(HL("RAN"))_HL("FS")_$G(HL("SAN"))
        S TIUMID=$G(HL("MID")),TIUREC=HL("RAN"),TIUSND=HL("SAN")
        I CODE="AR" D
        . N TIUCNT
        . S TIUCNT=0 F  S TIUCNT=$O(@ERLOC@("MSGERR",TIUCNT)) Q:'+TIUCNT  S HLA("HLA",(TIUCNT+1))=@ERLOC@("MSGERR",TIUCNT)
        . I +$E($G(TIU("SSN")),1,5) D SNDALRT("TIUHL7 rejected an incoming HL7 message from "_TIUSND_" (Msg ID "_TIUMID_".")
        I CODE="AA" D
        . S HLA("HLA",2)="ERR"_TIUFS_TIUFS_TIUFS_TIUFS_+$G(TIUDA)_TIUCS_"Document creation successful."
        I HL("SAN")="HTAPPL" D  M @TIU("XTMP")@("MSGRESULT")=HLA("HLS") Q
        . N HL,HLL,HLP,TIUDNS,TIUEVT,TIUFAC,TIULLNK,TIUSUB
        . M HLA("HLS")=HLA("HLA") K HLA("HLA")
        . S TIUEVT="TIUHL7 HTAPPL ACK EVT",TIUSUB="TIUHL7 HTAPPL ACK SUB"
        . I '+$$LU^TIUHL7U1(101,TIUEVT) D SNDALRT("Unable to resolve Event Protocol for ACK to "_TIUSND_".")
        . I '+$$LU^TIUHL7U1(101,TIUSUB) D SNDALRT("Unable to resolve Subscriber Protocol for ACK to "_TIUSND_".")
        . S TIUFAC=$P(TIUMSG(1),TIUFS,4),TIUDNS=$P(TIUFAC,TIUCS,2) ; set facility & DNS address
        . S TIULLNK(1)=$$LU^TIUHL7U1(870,$$UP^XLFSTR(TIUDNS),,,"DNS"),TIULLNK(2)=$$LU^TIUHL7U1(870,$$LOW^XLFSTR(TIUDNS),,,"DNS")
        . S TIULLNK=$S(+TIULLNK(1):TIULLNK(1),+TIULLNK(2):TIULLNK(2),1:0) I '+TIULLNK D SNDALRT("Unable to resolve DNS for ACK to "_TIUSND_".")
        . S TIULLNK=$$GET1^DIQ(870,TIULLNK,.01) ; get logical link associated with DNS
        . D INIT^HLFNC2(TIUEVT,.HL) I +$G(HL) Q
        . S HLP("SUBSCRIBER")="^^^^"_TIUFAC
        . S HLL("LINKS",1)=TIUSUB_U_TIULLNK
        . D GENERATE^HLMA(TIUEVT,"LM",1,.TIURSLT,"",.HLP)
        D GENACK^HLMA1(HL("EID"),HLMTIENS,HL("EIDS"),"LM",1,.TIURSLT)
        M @TIU("XTMP")@("MSGRESULT")=HLA("HLA")
        Q
SNDALRT(MSG)    ;
        N XQA,XQAMSG
        S MSG("RECEIVER")=$P($$GETAPP^HLCS2(TIUREC),U),MSG("SENDER")=$P($$GETAPP^HLCS2(TIUSND),U)
        I '+$L(MSG("RECEIVER")),'+$L(MSG("SENDER")) Q
        I +$L(MSG("RECEIVER")) S XQA("G."_MSG("RECEIVER"))=""
        I +$L(MSG("SENDER")) S XQA("G."_MSG("SENDER"))=""
        S XQAMSG=MSG
        I $$SETUP1^XQALERT
        Q
AUDIT(TIUDA,TIUCKSM0,TIUCKSM1)  ; Update audit trail
        N DA,DIC,DIE,DLAYGO,DR,X,Y
        S X=""""_"`"_TIUDA_"""",(DIC,DLAYGO)=8925.5,DIC(0)="FLX" D ^DIC Q:+Y'>0
        S DIE=DIC,DR=".02////"_$$NOW^TIULC_";.03////"_TIU("EBDA")_";.04////"_TIUCKSM0_";.05////"_TIUCKSM1
        S DA=+Y D ^DIE
        Q
CANEDIT(DA)     ; check whether or not document is released
        Q $S(+$P($G(^TIU(8925,+DA,0)),U,5)<4:1,1:0)
CLASS(CLNAME)   ;
        N TIUY S TIUY=+$O(^TIU(8925.1,"B",CLNAME,0))
        I +TIUY>0,$S($P($G(^TIU(8925.1,+TIUY,0)),U,4)="CL":0,$P($G(^(0)),U,4)="DC":0,1:1) S TIUY=0
        Q TIUY
CLEAN   ; removes messages older than 7 days
        N TIUDT
        S TIUDT=0
        F  S TIUDT=$O(^XTMP("TIUHL7",TIUDT)) Q:'+TIUDT  D
        . I $$FMDIFF^XLFDT($$NOW^XLFDT,TIUDT)'<7 K ^XTMP("TIUHL7",TIUDT)
        Q
COMPARE(NAME1,NAME2)    ; compare first and last names only
        N NAME,TIUX,TIUY
        S TIUY=0
        I $L(NAME1,",")=1,$L(NAME2,",")=1 S:NAME1=NAME2 TIUY=1 Q TIUY
        S NAME("L1")=$P(NAME1,","),NAME("F1")=$P(NAME1,",",2),NAME("F1")=$P(NAME("F1")," ")
        S NAME("L2")=$P(NAME2,","),NAME("F2")=$P(NAME2,",",2),NAME("F2")=$P(NAME("F2")," ")
        I NAME("L1")=NAME("L2"),NAME("F1")=NAME("F2") S TIUY=1
        Q TIUY
DELDOC(TIUDA)   ;
        N ERR
        D DELETE^TIUSRVP(.ERR,TIUDA,"",1)
        Q
ERR(TIUSEG,TIUP,TIUNUM,TIUTXT)  ;
        S TIU("EC")=TIU("EC")+1
        S @TIUNAME@("MSGERR",TIU("EC"))="ERR"_TIUFS_TIUSEG_TIUFS_TIUP_TIUFS_TIUFS_TIUNUM_TIUCS_TIUTXT
        Q
GETADMIT(DFN,TIUDT)     ;
        N TIUCNT,TIULIST,TIUY S (TIUCNT,TIUY)=0
        I '+$G(TIUDT) Q TIUY
        D:+$G(DFN) ADMITLST^ORWPT(.TIULIST,DFN)
        I $D(TIULIST) D
        . S TIULIST="" F  S TIULIST=$O(TIULIST(TIULIST)) Q:'+TIULIST  I $P($P(TIULIST(TIULIST),U),".")=$P(TIUDT,".") S TIUCNT=TIUCNT+1,TIUCNT(TIULIST)=TIULIST(TIULIST)
        . I TIUCNT=0 D ERR("ERR","44","0000.00","ADMISSION not found for "_$$FMTE^XLFDT(TIUDT)_".") Q
        . I TIUCNT=1 S TIULIST="",TIULIST=$O(TIUCNT(TIULIST)),TIU("VSTR")=$P(TIULIST(TIULIST),U,2)_";"_$P(TIULIST(TIULIST),U)_";H",TIUY=1 Q
        . I +TIU("HLOC") D
        . . S TIULIST="" F  S TIULIST=$O(TIUCNT(TIULIST)) Q:'+TIULIST!(+TIUY)  I $P(TIUCNT(TIULIST),U,2)=TIU("HLOC") S TIU("VSTR")=TIU("HLOC")_";"_$P(TIUCNT(TIULIST),U)_";H",TIUY=1
        Q TIUY
GETDIV(USER)    ;
        N TIUY
        D DIV4^XUSER(.TIUY,USER) I +$D(TIUY) S TIUY="",TIUY=$O(TIUY(TIUY))
        I +$G(TIUY)'>0 S TIUY=$$GET1^DIQ(8989.3,1,217,"I")
        Q TIUY
GETVISIT(DFN,TIUDT)     ;
        N TIUCNT,TIULIST,TIUY
        S (TIUCNT,TIUY)=0
        I '+$G(TIUDT) Q TIUY
        D:+$G(DFN) VST1^ORWCV(.TIULIST,DFN,$P(TIUDT,"."),$$FMADD^XLFDT(TIUDT,1),1)
        I $D(TIULIST) D
        . S TIULIST="" F  S TIULIST=$O(TIULIST(TIULIST)) Q:'+TIULIST  I $P($P(TIULIST(TIULIST),U,2),".")=$P(TIUDT,".") S TIUCNT=TIUCNT+1,TIUCNT(TIULIST)=TIULIST(TIULIST)
        . I TIUCNT=1 S TIULIST="",TIULIST=$O(TIUCNT(TIULIST)),TIU("VSTR")=$P($P(TIULIST(TIULIST),U),";",3)_";"_$P(TIULIST(TIULIST),U,2)_";"_$S(TIU("AVAIL")="AV":"E",1:"A"),TIUY=1 Q
        . I +TIU("HLOC") D
        . . S TIULIST="" F  S TIULIST=$O(TIUCNT(TIULIST)) Q:'+TIULIST!(+TIUY)  I $P($P(TIULIST(TIULIST),U),";",3)=TIU("HLOC") S TIU("VSTR")=TIU("HLOC")_";"_$P(TIULIST(TIULIST),U,2)_";"_$S(TIU("AVAIL")="AV":"E",1:"A"),TIUY=1
        Q TIUY
LU(FILE,NAME,FLAGS,SCREEN,INDEXES)      ;
        Q $$FIND1^DIC(FILE,"",$G(FLAGS),NAME,$G(INDEXES),$G(SCREEN),"TIUERR")
MEMBEROF(TITLE,CLASS)   ;
        N TIUY S TIUY=0
        S CLASS=+$$CLASS(CLASS) Q:+CLASS'>0 TIUY
        S TITLE=$$LU(8925.1,TITLE,"X","I $P(^(0),U,4)=""DOC""") Q:+TITLE'>0 TIUY
        S TIUY=+$$ISA^TIULX(TITLE,CLASS)
        Q TIUY
PNAME(NAME)     ;
        N LAST,FIRST
        S LAST=$P(NAME,","),FIRST=$E($P(NAME,",",2),1)
        Q LAST_","_FIRST
REMESC(TIUSTR)  ;
        ; Remove Escape Characters from HL7 Message Text
        ; Escape Sequence codes:
        ;         F = field separator (TIUFS)
        ;         S = component separator (TIUCS)
        ;         R = repitition separator (TIURS)
        ;         E = escape character (TIUES)
        ;         T = subcomponent separator (TIUSS)
        N I1,I2,J1,J2,K,TIUCHR,TIUREP,VALUE
        F TIUCHR="F","S","R","E","T" S TIUREP(TIUES_TIUCHR_TIUES)=$S(TIUCHR="F":TIUFS,TIUCHR="S":TIUCS,TIUCHR="R":TIURS,TIUCHR="E":TIUES,TIUCHR="T":TIUSS)
        S TIUSTR=$$REPLACE^XLFSTR(TIUSTR,.TIUREP)
        F  S I1=$P(TIUSTR,TIUES_"X") Q:$L(I1)=$L(TIUSTR)  D
        .S I2=$P(TIUSTR,TIUES_"X",2,99)
        .S J1=$P(I2,TIUES) Q:'$L(J1)
        .S J2=$P(I2,TIUES,2,99)
        .S VALUE=$$BASE^XLFUTL($$UP^XLFSTR(J1),16,10)
        .S K=$S(VALUE>255:"?",VALUE<32!(VALUE>127&(VALUE<160)):"",1:$C(VALUE))
        .S TIUSTR=I1_K_J2
        Q TIUSTR
SIGNDOC(TIUDA)  ;
        N TIUDEL
        I $G(TIU("COMP"))="LA",'+TIU("EC") D
        . I '+$G(TIU("SIGNED")),'+$G(TIU("CSIGNED")) D  Q
        . . I TIU("AVAIL")'="AV" D DELDOC(TIUDA),ERR("TIU","","2100.040","SIGNATURE DATE[TIME] missing from HL7 message & availability not 'AV'; document has been deleted.")
        . I +TIU("SIGNED") D
        . . N TIUACT,TIUAUTH,TIUES,TIUSTAT S TIUACT="SIGNATURE",TIUAUTH=$$CANDO^TIULP(TIUDA,TIUACT,TIU("AUDA")) I '+TIUAUTH D
        . . . D ERR("TIU","15","0000.000",$P(TIUAUTH,U,2)) I TIU("AVAIL")="AV" Q
        . . . S TIUDEL=1 D ERR("TIU","","0000.000","Legal authentication failed & availability not 'AV'; document has been deleted.")
        . . I '+$G(TIUDEL) S TIUES=1_U_$$GET1^DIQ(200,TIU("AUDA"),20.2)_U_$$GET1^DIQ(200,TIU("AUDA"),20.3)
        . . I '+$G(TIUDEL) D ES^TIUHL7U2(TIUDA,TIUES,"",TIU("AUDA"))
        . . I '+$G(TIUDEL) S TIUSTAT=$P($G(^TIU(8925,TIUDA,0)),U,5) I TIUSTAT<6,TIU("AVAIL")'="AV" D
        . . . S TIUDEL=1 D ERR("TIU","","0000.000","Legal authentication failed & availability not 'AV'; document has been deleted.")
        . I +TIU("CSIGNED") D
        . . N TIUACT,TIUAUTH,TIUES,TIUSTAT S TIUACT="COSIGNATURE",TIUAUTH=$$CANDO^TIULP(TIUDA,TIUACT,TIU("CSDA")) I '+TIUAUTH D
        . . . D ERR("TIU","29","0000.000",$P(TIUAUTH,U,2)) I TIU("AVAIL")="AV" Q
        . . . S TIUDEL=1 D ERR("TIU","29","0000.000","Legal authentication failed & availability not 'AV'; document has been deleted.")
        . . I '+$G(TIUDEL) S TIUES=1_U_$$GET1^DIQ(200,TIU("CSDA"),20.2)_U_$$GET1^DIQ(200,TIU("CSDA"),20.3)
        . . I '+$G(TIUDEL) D ES^TIURS(TIUDA,TIUES,"",TIU("CSDA"))
        . . I '+$G(TIUDEL) S TIUSTAT=$P($G(^TIU(8925,TIUDA,0)),U,5) I TIUSTAT'=7,TIU("AVAIL")'="AV" D
        . . . S TIUDEL=1 D ERR("TIU","29","0000.000","Legal authentication failed & availability not 'AV'; document has been deleted.")
        I +$G(TIUDEL) D DELDOC(TIUDA)
        Q
