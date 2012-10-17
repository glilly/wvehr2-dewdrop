PSBML   ;BIRMINGHAM/EFC-BCMA MED LOG FUNCTIONS ; 1/7/09 9:57am
        ;;3.0;BAR CODE MED ADMIN;**6,3,4,9,11,13,25,45,33**;Mar 2004;Build 14
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        ; Reference/IA
        ; ^DPT/10035
        ; DIC(42/10039
        ; DIC(42/2440
        ; File 200/10060
        ; EN^PSJBCMA3/3320
        ; $$SITE^VASITE/10112
        ; ^XUSEC(/10076
        ;
RPC(RESULTS,PSBHDR,PSBREC)      ;BCMA MedLog Filing
        S PSBEDTFL=0
        N PSBORD,PSBTRAN,PSBFDA
        K PSBIEN,PSBHL7
        S PSBIEN=$P(PSBHDR,U,1)
        S PSBTRAN=$P(PSBHDR,U,2),PSBHL7=PSBTRAN
        S PSBINST=$P($G(PSBHDR),U,3)
        ;PSB*3*45 We should be recording the first entry in the audit log.
        ;S PSBAUDIT=$S(PSBIEN="+1":0,1:1)
        S PSBAUDIT=1
        D NOW^%DTC S PSBNOW=%
        I $D(^XUSEC("PSB STUDENT",DUZ)),PSBINST="" S RESULTS(0)=1,RESULTS(1)="-1^Instructor not present" Q
        I $D(^XUSEC("PSB STUDENT",DUZ)),'$D(^XUSEC("PSB INSTRUCTOR",PSBINST)) S RESULTS(0)=1,RESULTS(1)="-1^Instructor doesn't have authority" Q
        S PSBINST(0)=$$GET1^DIQ(200,PSBINST_",",.01)
        I PSBTRAN="ADD COMMENT" D COMMENT^PSBML1 Q
        I PSBTRAN="PRN EFFECTIVENESS" D PRN^PSBML1 Q
        I PSBTRAN="UPDATE STATUS" D  Q
        .I '$D(^PSB(53.79,PSBIEN)) S RESULTS(0)=1,RESULTS(1)="-1^Administration is at an UNKNOWN STATUS" Q
        .D UPDATED^PSBML2
        I PSBTRAN="EDIT" D EDIT^PSBML2 Q
        ;SAGG
        N PSBWARD S PSBWARD=$G(^DPT(+$G(PSBREC(0)),.1),"UNKNOWN"),^PSB("SAGG",PSBWARD,DT)=$G(^PSB("SAGG",PSBWARD,DT))+1
        I PSBREC(1)?1U1";"1.6N S PSBREC(1)=$P(PSBREC(1),";",1)_$E(PSBREC(1))
        D PSJ1^PSBVT(PSBREC(0),$P(PSBREC(1),";",2)_$P(PSBREC(1),";",1))
        S PSBTAB=$P(PSBREC(9),U,1),PSBUID=$P(PSBREC(9),U,2)
        D:PSBTRAN="MEDPASS"
        .I (PSBDOSEF["PATCH"),(PSBREC(3)="G") D  Q:+$G(RESULTS(1))<0
        ..S PSBXDT="" F  S PSBXDT=$O(^PSB(53.79,"AORDX",PSBDFN,PSBONX,PSBXDT)) Q:PSBXDT=""  D  Q:+$G(RESULTS(1))<0
        ...S PSBYZ="" F  S PSBYZ=$O(^PSB(53.79,"AORDX",PSBDFN,PSBONX,PSBXDT,PSBYZ)) Q:'PSBYZ  I ("G"[$$GET1^DIQ(53.79,PSBYZ,.09,"I")) D  Q
        ....S:($$GET1^DIQ(53.79,PSBYZ,.09,"I")="G") RESULTS(0)=1,RESULTS(1)="-1^Previous Patch has not been removed. Administration canceled."
        ....S:($$GET1^DIQ(53.79,PSBYZ,.09,"I")="")&(($$GET1^DIQ(53.79,PSBYZ,.07,"I")'=DUZ)&('$D(^XUSEC("PSB MANAGER",DUZ)))) RESULTS(0)=1,RESULTS(1)="-1^Patch status ""*UNKNOWN*"". Administration canceled."
        .I PSBREC(7)="BCMA/CPRS Interface Entry." S PSBNOW=PSBREC(5)  ;MOB
        .F X=0:1:9 S PSBREC(X)=$G(PSBREC(X))
        .I PSBREC(1)?1U1";".N S PSBREC(1)=$P(PSBREC(1),";",2)_$P(PSBREC(1),";",1)
        .I PSBREC(1)["V",+PSBREC(5)>0,+$P(PSBREC(5),".",2)=0,PSBIVT'["P" D NOW^%DTC S PSBREC(5)=$P(PSBREC(5),".",1)_"."_$P(%,".",2)
        .I $P(PSBREC(9),U,1)="IVTAB",$P(PSBREC(9),U,2)="" S PSBUID=$$GETWSID^PSBVDLU2(PSBREC(0),PSBREC(1))
        .I $P(PSBREC(9),U,1)="PBTAB",$P(PSBREC(9),U,2)="",PSBREC(1)'["U",PSBREC(3)'="M",PSBREC(3)'="R",PSBREC(3)'="H" S PSBUID=$$GETWSID^PSBVDLU2(PSBREC(0),PSBREC(1))
        .;OnCal
        .D:PSBREC(2)="OC"
        ..S X=$O(^PSB(53.79,"AORD",PSBREC(0),PSBREC(1),"")) Q:X=""
        ..S Y=$O(^PSB(53.79,"AORD",PSBREC(0),PSBREC(1),X,0))
        ..I $P(^PSB(53.79,Y,0),U,9)="G"&('$$GET^XPAR("DIV","PSB ADMIN MULTIPLE ONCALL")) D ERR(1,"On-Call already given")
        .;1x
        .D:PSBREC(2)="O"
        ..S X=$O(^PSB(53.79,"AORD",PSBREC(0),PSBREC(1),"")) Q:X=""
        ..S Y=$O(^PSB(53.79,"AORD",PSBREC(0),PSBREC(1),X,0))
        ..I $P(^PSB(53.79,Y,0),U,9)="G" D ERR(1,"One Time already Given")
        .;PRN
        .I PSBREC(2)="P",PSBREC(3)'="M",$P(PSBREC(9),U,1)'="IVTAB" D
        ..I PSBREC(6)="" D ERR(1,"PRN Medications MUST Have a PRN Reason")
        ..I PSBREC(5)]"" D ERR(1,"PRN Orders don't have scheduled times")
        ..I PSBREC(3)'="G" D ERR(1,"PRN Orders cannot be marked NOT Given")
        .;Cnt
        .I PSBREC(2)="C",PSBTAB'="IVTAB" D
        ..D:PSBREC(5)="" ERR(1,"Continuous Order needs admin time")
        ..D:PSBREC(6)]"" ERR(1,"No PRN Reason allowed on Continuous Orders")
        .I PSBREC(2)="C",$D(^PSB(53.79,"AORD",PSBREC(0),PSBREC(1),+PSBREC(5))),PSBIEN="+1" D  K PSBADMBY,PSBADMAT Q:PSBSIEN=""  Q:$P(^PSB(53.79,PSBSIEN,0),U,9)'="N"
        ..S PSBSIEN=$O(^PSB(53.79,"AORD",PSBREC(0),PSBREC(1),PSBREC(5),""))
        ..I PSBSIEN]"" I '(($P(^PSB(53.79,PSBSIEN,0),U,7)=DUZ)!($D(^XUSEC("PSB MANAGER",DUZ)))) S PSBSIEN=""
        ..I PSBSIEN']"" S RESULTS(0)=2,RESULTS(1)="-2^Error Filing Transaction MEDPASS",RESULTS(2)="The PSB MANAGER key is required to modify this scheduled admin" Q
        ..D:$P(^PSB(53.79,PSBSIEN,0),U,9)'="N"
        ...K PSBINCX I $P(^PSB(53.79,PSBSIEN,0),U,9)="" S PSBINCX=PSBSIEN L +^PSB(53.79,PSBINCX):1 Q:'$T  L -^PSB(53.79,PSBINCX)
        ...S Y=$P(^PSB(53.79,PSBSIEN,0),U,6) D DD^%DT S PSBADMAT=Y
        ...S PSBADMBY=$$GET1^DIQ(200,$P(^PSB(53.79,PSBSIEN,0),U,7),.01,)
        ...S RESULTS(0)=3,RESULTS(1)="-2^Error Filing Transaction MEDPASS"
        ...S RESULTS(2)="Continuous Administration Date/Time already on file."
        ...S RESULTS(3)="Administered by "_PSBADMBY_" at "_PSBADMAT_"."
        ...I $D(XWB) S RESULTS(0)=RESULTS(0)+2,RESULTS(4)="                                         ",RESULTS(5)="            VDL will now be updated."
        .;NonGvn
        .I PSBREC(3)'="G",PSBREC(3)'="M",PSBUID'["V",PSBUID'["W" D
        ..I PSBREC(7)="",PSBTAB'="IVTAB" D ERR(1,"Comment needed if Not Marked Given")
        ..I PSBREC(7)="",PSBTAB="IVTAB" D ERR(1,"Comment needed if Not Marked Completed")
        .S:PSBREC(3)="H" PSBREC(7)="Held: "_PSBREC(7)    ;.3
        .S:PSBREC(3)="R" PSBREC(7)="Refused: "_PSBREC(7) ;.3
        .S:PSBREC(3)="S" PSBREC(7)="Stopped: "_PSBREC(7) ;.3
        .;Vald?
        .I $G(PSBSIEN)'="" I $D(^PSB(53.79,PSBSIEN,0)) I $P(^PSB(53.79,PSBSIEN,0),U,9)="N" S PSBIEN=+PSBSIEN_",",$P(PSBHDR,U)=PSBIEN,PSBTRAN="UPDATE STATUS",PSBAUDIT=1   ;do UPDATE
        .D:PSBIEN="+1"  ;New?
        ..D VAL(53.79,PSBIEN,.01,"`"_PSBREC(0)) ;Pt
        ..S X=$G(^DPT(PSBREC(0),.1))_" "_$G(^(.101)) ;WrdRmBd
        ..D VAL(53.79,PSBIEN,.02,X) ;PtLoc
        ..D:$G(^DPT(PSBREC(0),.1))'=""
        ...S Y=$O(^DIC(42,"B",$G(^DPT(PSBREC(0),.1)),"")),Y=$$GET1^DIQ(42,Y,.015,"I"),PSBDIV=$$SITE^VASITE(DT,Y)
        ...D VAL(53.79,PSBIEN,.03,"`"_$P(PSBDIV,U,1)) ;Div
        ..D VAL(53.79,PSBIEN,.04,PSBNOW)  ;EntDT
        ..D VAL(53.79,PSBIEN,.05,"`"_DUZ) ;Who
        ..D VAL(53.79,PSBIEN,.06,PSBNOW)  ;AdmDT
        ..D VAL(53.79,PSBIEN,.07,"`"_DUZ) ;AdmBy
        ..D VAL(53.79,PSBIEN,.08,"`"_PSBREC(4)) ;OrdblItm
        ..D VAL(53.79,PSBIEN,.11,PSBREC(1)) ;OrdTpeIEN
        ..D VAL(53.79,PSBIEN,.12,PSBREC(2)) ;OrdSchdTpe
        ..D VAL(53.79,PSBIEN,.13,PSBREC(5)) ;SchdAdmDT
        ..D:PSBTAB'="UDTAB" VAL(53.79,PSBIEN,.26,PSBUID) ;Bag
        ..D:PSBTAB="IVTAB" VAL(53.79,PSBIEN,.13,"") ;no SchdAdm - lvIV
        ..D:PSBREC(1)?.N1"U" VAL(53.79,PSBIEN,.15,PSBDOSE) ;UDDsage
        ..D:PSBREC(1)?.N1"V" VAL(53.79,PSBIEN,.35,PSBIFR)  ;IVInfRt
        .;Ovrwrt if exsts
        .I PSBREC(3)="G"!(PSBREC(3))="C" D  ;Gvn/Cmpltd?
        ..D VAL(53.79,PSBIEN,.06,PSBNOW)   ;AdmDT
        ..D VAL(53.79,PSBIEN,.07,"`"_DUZ)  ;AdmBy
        .D:PSBREC(8)]"" VAL(53.79,PSBIEN,.16,PSBREC(8)) ;InjctSte
        .D:'$G(PSBMMEN) VAL(53.79,PSBIEN,.09,PSBREC(3)) ;AStats
        .D:PSBREC(6)]"" VAL(53.79,PSBIEN,.21,$P(PSBREC(6),U)),VAL(53.79,PSBIEN,.27,$P(PSBREC(6),U,2)) ;PRNRsn
        .D:PSBREC(7)]""
        ..D VAL(53.793,"+2,"_PSBIEN,.01,PSBREC(7)) ;Cmnt
        ..D VAL(53.793,"+2,"_PSBIEN,.02,"`"_DUZ)   ;Who
        ..D VAL(53.793,"+2,"_PSBIEN,.03,PSBNOW)
        .;DD/SOL/ADD
        .I PSBREC(3)="G"!(PSBREC(3)="I")!(PSBREC(3)="H")!(PSBREC(3)="R")!(PSBREC(3)="M") D  ;gvn/infs?
        ..I PSBTRAN="UPDATE STATUS" K ^PSB(53.79,+PSBIEN,.5),^PSB(53.79,+PSBIEN,.6),^PSB(53.79,+PSBIEN,.7)
        ..F PSBCNT=10:1 Q:'$D(PSBREC(PSBCNT))  D
        ...S Y=$P(PSBREC(PSBCNT),U)
        ...S PSBDD=$S(Y="DD":53.795,Y="ADD":53.796,Y="SOL":53.797,1:0)
        ...Q:'PSBDD
        ...S PSBIENS="+"_PSBCNT_","_PSBIEN
        ...D VAL(PSBDD,PSBIENS,.01,"`"_$P(PSBREC(PSBCNT),U,2))
        ...D VAL(PSBDD,PSBIENS,.02,$P(PSBREC(PSBCNT),U,3))
        ...D VAL(PSBDD,PSBIENS,.03,$P(PSBREC(PSBCNT),U,4))
        ...D:(PSBTAB="UDTAB")!(PSBTAB="PBTAB") VAL(PSBDD,PSBIENS,.04,$E($P(PSBREC(PSBCNT),U,5),1,40))
        .I $O(RESULTS("")) S RESULTS(0)=1,RESULTS(1)="-1^Error(s) Filing Transaction MEDPASS"  Q
        .D FILEIT
        .;PSB*3*33
        .D:((PSBREC(2)="O")!($$ONE^PSJBCMA(PSBREC(0),PSBREC(1))="O"))&(PSBREC(3)="G") EXPIRE^PSBML1  ;1x exp?
        .D:(PSBREC(2)="O")&(PSBREC(3)="G") EXPIRE^PSBML1  ;1x exp?
        .I $P(RESULTS(0),U,1)=1,PSBTAB'="UDTAB",PSBUID]"",PSBUID'["WS" S PSBON=+PSBREC(1) D EN^PSJBCMA3(PSBREC(0),PSBON,PSBUID,PSBREC(3),PSBNOW)
        Q
BCBU    ;HL7,NatContng
        Q:+$G(RESULTS(0))'>0
        N PSBIEN1 S PSBIEN1=$S($P(PSBIEN,",",2)'="":+$P(PSBIEN,",",2),$G(PSBIEN)="+1":PSBIEN(1),1:+$G(PSBIEN))
        I $G(PSBIEN1)="" S RESULTS(0)=1,RESULTS(1)="-1^Contingency NOT processed" Q
        I $G(PSBIEN)="+1" S PSBHL7="MEDPASS"
        E  S:$G(PSBHL7)="" PSBHL7="UPDATE STATUS"
        D:('$D(Y(0))!($G(Y(0))="SAVE")!($G(Y(0))="YES")) EN^PSBSVHL7(+PSBIEN1,PSBHL7),MEDL^ALPBCBU(+PSBIEN1) K PSBHL7
        ;<<HDR-VDEF(frm *3)
        Q
VAL(PSBDD,PSBIEN,PSBFLD,PSBVAL) ;
        K ^TMP("DIERR",$J),PSBRET
        D VAL^DIE(PSBDD,PSBIEN,PSBFLD,"F",PSBVAL,.PSBRET,"PSBFDA")
        I PSBRET="^" F X=0:0 S X=$O(^TMP("DIERR",$J,X)) Q:'X  D ERR(2,^TMP("DIERR",$J,X)_": "_$G(^(X,"TEXT",1),"**"))
        K ^TMP("DIERR",$J),PSBRET
        Q
FILEIT  ;Updt
        N PSBMSG,PSBAUD
        S (PSB1,PSB2)=""
        D APATCH^PSBML3
        D CLEAN^DILF
        D RESETADM^PSBUTL
        D UPDATE^DIE("","PSBFDA","PSBIEN","PSBMSG")
        I '$G(PSBMMEN) S X=+PSBIEN I $F("HR",$P(^PSB(53.79,X,0),U,9))>1 F Y=.5,.6,.7 S Z=0 F  S Z=$O(^PSB(53.79,+X,Y,Z)) Q:+Z=0  S $P(^PSB(53.79,+X,Y,Z,0),U,3)=0
        I $D(PSBMSG("DIERR")) S RESULTS(0)=1,RESULTS(1)="-1^"_PSBMSG("DIERR",1)_": "_PSBMSG("DIERR",1,"TEXT",1)  Q
        I $G(PSB1)]"" X PSB1 I $G(PSB2)]"" X PSB2
        I $D(PSBHDR) D:"NHMR"[$P(^PSB(53.79,$S($P(PSBHDR,"^",1)="+1":PSBIEN(1),1:+PSBIEN),0),U,9)
        .N PSBINDX S PSBINDX=$S($P(PSBHDR,"^",1)="+1":PSBIEN(1),1:+PSBIEN)
        .K ^PSB(53.79,"APATCH",$P(^PSB(53.79,PSBINDX,0),U),$P(^PSB(53.79,PSBINDX,0),U,6),PSBINDX)
        S RESULTS(0)=1,RESULTS(1)="1^Data Successfully Filed^"_$S($G(PSBIEN(1))'="":$G(PSBIEN(1)),1:+$G(PSBIEN))
        D BCBU  ;NatContng
        I $G(PSBINST,0) S PSBAUD=$S($P(PSBHDR,"^",1)="+1":PSBIEN(1),1:$P(PSBHDR,"^",1)) D AUDIT^PSBMLU(PSBAUD,"Instructor "_PSBINST(0)_" present.",PSBTRAN)
        Q
ERR(X,Y)        ;
        S X=$P("Business Logic Error^Data Validation Error",U,X)
        S RESULTS($O(RESULTS(""),-1)+1)=X_": "_Y
        Q
COMMENT(DA,PSBCMT)      ;
        N PSBFDA,PSBIEN,PSBNOW
        S PSBIEN="+1,"_DA_","
        D NOW^%DTC S PSBNOW=%
        D VAL(53.793,PSBIEN,.01,PSBCMT)
        S PSBFDA(53.793,PSBIEN,.02)=DUZ
        S PSBFDA(53.793,PSBIEN,.03)=PSBNOW
        D FILEIT
        Q
