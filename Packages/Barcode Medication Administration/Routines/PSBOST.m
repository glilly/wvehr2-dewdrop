PSBOST  ;BIRMINGHAM/TEJ-UNABLE TO SCAN SUMMARY REPORT;Mar 2004 ; 29 Aug 2008  3:29 PM
        ;;3.0;BAR CODE MED ADMIN;**28**;Mar 2004;Build 9
        ;Per VHA Directive 2004-038 (or future revisions regarding same), this routine should not be modified.
        ;
        ; Reference/IA
        ; ^NURSF(211.4/1409
        ;
        ; Entry Point -  GUI Report used by PSB MAN SCAN FAILURE key holders to produce
        ;                total per BCMA scanning and scanning failures from the BCMA SCANNING FAILURE LOG File (#53.77).
        ;
EN      ;BCMA UNABLE TO SCAN (Summary) REPORT
        N PSBSEL,PSB05,PSBNU,PSBNULO
        K PSBOUTP
        S PSBDTST=+$P(PSBRPT(.1),U,6)_$P(PSBRPT(.1),U,7)
        S PSBDTSP=+$P(PSBRPT(.1),U,8)_$P(PSBRPT(.1),U,9)
        S Y=PSBDTST D DD^%DT S Y1=Y S Y=PSBDTSP D DD^%DT S Y2=Y
        D NOW^%DTC S Y=% D DD^%DT S PSBDTTM=Y
        S PSBLIST=""
        S (NEWPAGE,PSBPGNUM,PSBLNTOT,PSBMORE,PSBTM,PSBTW,PSBTWKEY,PSBTMKEY,PSBTWUAS,PSBTMUAS,PSBTMMME,PSBTWSF,PSBTMSF,PSBTMEVT,PSBTWEVT)=0
        I $P(PSBRPT(3),",",1)=1 D FACILITY
        I $P(PSBRPT(3),",",2)=1 D NURSE
        I $P(PSBRPT(3),",",3)=1 D WARD
        K %,NEWPAGE,PSBDTSP,PSBDTST,PSBDTTM,PSBLIST,PSBLNTOT,PSBMBYPS,PSBMORE,PSBPG,PSBPGNUM,PSBPGRM,PSBRPT,PSBSTWD,PSBTM
        K PSBTMEVT,PSBTMKEY,PSBTMMME,PSBOUTP,PSBTMSF,PSBTMUAS,PSBTSCAN,PSBTW,PSBTWEVT,PSBTWKEY,PSBTWSF,PSBTWUAS,PSBWBYPS
        K PSBWRD,PSBX1,PSBX2,Y,Y1,Y2
        Q
        ;
FACILITY        ;Entire Facility Option
        D WARDDIV(.PSBWARD,DUZ(2))
        S PSBX1=$$FMADD^XLFDT(PSBDTST,,,,-.1) F  S PSBX1=$O(^PSB(53.77,"ASFDT",PSBX1)) Q:(PSBX1>PSBDTSP)!(+PSBX1=0)  D
        .S PSBX2="" F  S PSBX2=$O(^PSB(53.77,"ASFDT",PSBX1,PSBX2)) Q:PSBX2=""  D
        ..S PSBWRD=$P($P($G(^PSB(53.77,PSBX2,0)),U,3),"$",1)_"$"
        ..I PSBWRD'["*UNIDENTIFIABLE PATIENT*",'$D(PSBWARD(PSBWRD)) Q  ;Filter to users institution
        ..S PSB05=$P($G(^PSB(53.77,PSBX2,0)),U,5)
        ..I PSB05="MUAS" S PSBTMUAS=PSBTMUAS+1
        ..I PSB05="MKEY" S PSBTMKEY=PSBTMKEY+1
        ..I PSB05="MMME" S PSBTMMME=PSBTMMME+1
        ..I PSB05="MSCN" S PSBTM=PSBTM+1
        ..I PSB05="WUAS" S PSBTWUAS=PSBTWUAS+1
        ..I PSB05="WKEY" S PSBTWKEY=PSBTWKEY+1
        ..I PSB05="WSCN" S PSBTW=PSBTW+1
        S PSBTMSF=PSBTMUAS+PSBTMKEY+PSBTMMME
        S PSBTWSF=PSBTWUAS+PSBTWKEY
        S PSBTMEVT=PSBTMSF+PSBTM
        S PSBTWEVT=PSBTWSF+PSBTW
        S PSBTSCAN=PSBTMEVT+PSBTWEVT
        S PSBMBYPS=PSBTMKEY+PSBTMUAS+PSBTMMME
        S PSBWBYPS=PSBTWKEY+PSBTWUAS
        D BLDRPT
        D WRTRPT
        Q
        ;
NURSE   ;Nurse Unit Option
        K PSBWARD D WARDDIV(.PSBWARD,DUZ(2))
        S PSBX1=$$FMADD^XLFDT(PSBDTST,,,,-.1) F  S PSBX1=$O(^PSB(53.77,"ASFDT",PSBX1)) Q:(PSBX1>PSBDTSP)!(+PSBX1=0)  D
        .S PSBX2="" F  S PSBX2=$O(^PSB(53.77,"ASFDT",PSBX1,PSBX2)) Q:PSBX2=""  D
        ..S PSBWRD=$P($P($G(^PSB(53.77,PSBX2,0)),U,3),"$",1) I PSBWRD="" S PSBWRD=" "
        ..I PSBWRD'["*UNIDENTIFIABLE PATIENT*",'$D(PSBWARD(PSBWRD_"$")) Q  ;Filter to users institution
        ..S PSB05=$P($G(^PSB(53.77,PSBX2,0)),U,5) I $G(PSB05)="" S PSB05=" "
        ..D  ;Set Nurse Location
        ...I PSBWRD["*UNIDENTIFIABLE PATIENT*" S PSBNULO=PSBWRD Q
        ...S PSBNULO=$G(PSBWARD(PSBWRD_"$")) I PSBNULO="" S PSBNULO=" "
        ..I PSB05="MUAS" S PSBNU(PSBNULO,PSB05)=$G(PSBNU(PSBNULO,PSB05))+1
        ..I PSB05="MKEY" S PSBNU(PSBNULO,PSB05)=$G(PSBNU(PSBNULO,PSB05))+1
        ..I PSB05="MMME" S PSBNU(PSBNULO,PSB05)=$G(PSBNU(PSBNULO,PSB05))+1
        ..I PSB05="MSCN" S PSBNU(PSBNULO,PSB05)=$G(PSBNU(PSBNULO,PSB05))+1
        ..I PSB05="WUAS" S PSBNU(PSBNULO,PSB05)=$G(PSBNU(PSBNULO,PSB05))+1
        ..I PSB05="WKEY" S PSBNU(PSBNULO,PSB05)=$G(PSBNU(PSBNULO,PSB05))+1
        ..I PSB05="WSCN" S PSBNU(PSBNULO,PSB05)=$G(PSBNU(PSBNULO,PSB05))+1
        S PSBNULO="" F  S PSBNULO=$O(PSBNU(PSBNULO)) Q:PSBNULO=""  D
        .S PSBNU(PSBNULO,"WSF")=$G(PSBNU(PSBNULO,"WUAS"))+$G(PSBNU(PSBNULO,"WKEY"))
        .S PSBNU(PSBNULO,"MSF")=$G(PSBNU(PSBNULO,"MUAS"))+$G(PSBNU(PSBNULO,"MKEY"))+$G(PSBNU(PSBNULO,"MMME"))
        .S PSBNU(PSBNULO,"MEVT")=$G(PSBNU(PSBNULO,"MSF"))+$G(PSBNU(PSBNULO,"MSCN"))
        .S PSBNU(PSBNULO,"WEVT")=$G(PSBNU(PSBNULO,"WSF"))+$G(PSBNU(PSBNULO,"WSCN"))
        .S PSBNU(PSBNULO,"SCAN")=$G(PSBNU(PSBNULO,"MEVT"))+$G(PSBNU(PSBNULO,"WEVT"))
        .S PSBNU(PSBNULO,"WBYPS")=$G(PSBNU(PSBNULO,"WKEY"))+$G(PSBNU(PSBNULO,"WUAS"))
        .S PSBNU(PSBNULO,"MBYPS")=$G(PSBNU(PSBNULO,"MKEY"))+$G(PSBNU(PSBNULO,"MUAS"))+$G(PSBNU(PSBNULO,"MMME"))
        .S PSBTMUAS=$G(PSBNU(PSBNULO,"MUAS"))
        .S PSBTMKEY=$G(PSBNU(PSBNULO,"MKEY"))
        .S PSBTMMME=$G(PSBNU(PSBNULO,"MMME"))
        .S PSBTM=$G(PSBNU(PSBNULO,"MSCN"))
        .S PSBTWUAS=$G(PSBNU(PSBNULO,"WUAS"))
        .S PSBTWKEY=$G(PSBNU(PSBNULO,"WKEY"))
        .S PSBTW=$G(PSBNU(PSBNULO,"WSCN"))
        .S PSBTWSF=$G(PSBNU(PSBNULO,"WSF"))
        .S PSBTMSF=$G(PSBNU(PSBNULO,"MSF"))
        .S PSBTMEVT=$G(PSBNU(PSBNULO,"MEVT"))
        .S PSBTWEVT=$G(PSBNU(PSBNULO,"WEVT"))
        .S PSBTSCAN=$G(PSBNU(PSBNULO,"SCAN"))
        .S PSBWBYPS=$G(PSBNU(PSBNULO,"WBYPS"))
        .S PSBMBYPS=$G(PSBNU(PSBNULO,"MBYPS"))
        .D BLDRPT
        I +$G(PSBTSCAN)=0 D BLDRPT  ;Call if data is not found so report will say 'not found'
        D WRTRPT
        Q
        ;
WARD    ;Ward Option
        S PSBSTWD=$P(PSBRPT(.1),U,3)
        I $G(PSBSTWD)'="" D LISTWD^PSBOSF
        S PSBX1=$$FMADD^XLFDT(PSBDTST,,,,-.1) F  S PSBX1=$O(^PSB(53.77,"ASFDT",PSBX1)) Q:(PSBX1>PSBDTSP)!(+PSBX1=0)  D
        .S PSBX2="" F  S PSBX2=$O(^PSB(53.77,"ASFDT",PSBX1,PSBX2)) Q:PSBX2=""  D
        ..S PSBWRD=$P($P($G(^PSB(53.77,PSBX2,0)),U,3),"$",1)_"$"
        ..I '$D(PSBWARD(PSBSTWD,PSBWRD)) Q
        ..S PSB05=$P($G(^PSB(53.77,PSBX2,0)),U,5)
        ..I PSB05="MUAS" S PSBTMUAS=PSBTMUAS+1
        ..I PSB05="MKEY" S PSBTMKEY=PSBTMKEY+1
        ..I PSB05="MMME" S PSBTMMME=PSBTMMME+1
        ..I PSB05="MSCN" S PSBTM=PSBTM+1
        ..I PSB05="WUAS" S PSBTWUAS=PSBTWUAS+1
        ..I PSB05="WKEY" S PSBTWKEY=PSBTWKEY+1
        ..I PSB05="WSCN" S PSBTW=PSBTW+1
        S PSBTMSF=PSBTMUAS+PSBTMKEY+PSBTMMME
        S PSBTWSF=PSBTWUAS+PSBTWKEY
        S PSBTMEVT=PSBTMSF+PSBTM
        S PSBTWEVT=PSBTWSF+PSBTW
        S PSBTSCAN=PSBTMEVT+PSBTWEVT
        S PSBMBYPS=PSBTMKEY+PSBTMUAS+PSBTMMME
        S PSBWBYPS=PSBTWKEY+PSBTWUAS
        D BLDRPT
        D WRTRPT
        Q
        ;
BLDRPT  ;Assemble report body from accumilated totals
        I '$D(^XUSEC("PSB UNABLE TO SCAN",DUZ)) D  Q
        .S PSBPGNUM=1
        .S PSBOUTP(0,14)="W !!,""<<<< BCMA UNABLE TO SCAN REPORTS HAVE RESTRICTED ACCESS >>>>"",!!"
        I +$G(PSBTSCAN)'>0 D  Q
        .S PSBPGNUM=1
        .S PSBOUTP(0,14)="W !!,""<<<< NO BCMA SCANNING ACTIVITY FOUND FOR THIS DATE RANGE >>>>"",!!"
        S NEWPAGE=1
        S PSBOUTP($$PGTOT,PSBLNTOT)="W !,?5,""Wristband Totals -"",?50,""     Count"",?82,""% total events"""
        S PSBOUTP($$PGTOT,PSBLNTOT)="W !,?50,"""_$TR($J(" ",21)," ","-")_$TR($J(" ",4)," "," ")_$TR($J(" ",21)," ","-")_""""
        S PSBOUTP($$PGTOT,PSBLNTOT)="W !,?7,""Processed via SCANNER "",$TR($J("""",(49-$X)),"" "","".""),"":"",?50,"""_$J($FN(PSBTW,","),10)_$TR($J(" ",25)," "," ")_$J($S(PSBTW>0:((PSBTW/PSBTWEVT)*100),1:0),5,1)_""""
        S PSBOUTP($$PGTOT(2),PSBLNTOT)="W !!,?7,""Processed via SCANNER BY-PASS"",$TR($J("""",(49-$X)),"" "","".""),"":"","""_$J($FN(PSBWBYPS,","),10)_$TR($J(" ",25)," "," ")_$J($S(PSBWBYPS>0:((PSBWBYPS/PSBTWEVT)*100),1:0),5,1)_""""
        S PSBOUTP($$PGTOT,PSBLNTOT)="W !,?15,""KEYED ENTRY"",$TR($J("""",(49-$X)),"" "","".""),"":"","""_$TR($J(" ",11)," "," ")_$J($FN(PSBTWKEY,","),10)_$TR($J(" ",20)," "," ")_$J($S(PSBTWKEY>0:((PSBTWKEY/PSBTWEVT)*100),1:0),5,1)_""""
        S PSBOUTP($$PGTOT,PSBLNTOT)="W !,?15,""BCMA UNABLE TO SCAN Option "",$TR($J("""",(49-$X)),"" "","".""),"":"","""_$TR($J(" ",11)," "," ")_$J($FN(PSBTWUAS,","),10)_$TR($J(" ",20)," "," ")_$J($S(PSBTWUAS>0:((PSBTWUAS/PSBTWEVT)*100),1:0),5,1)_""""
        S PSBOUTP($$PGTOT,PSBLNTOT)="W !,?50,"""_$TR($J(" ",21)," ","-")_$TR($J(" ",4)," "," ")_$TR($J(" ",21)," ","-")_""""
        S PSBOUTP($$PGTOT,PSBLNTOT)="W !,?7,""Total Wristband Scan Events "",$TR($J("""",(49-$X)),"" "","".""),"":"","""_$J($FN(PSBTWEVT,","),10)_""""
        S PSBOUTP($$PGTOT,PSBLNTOT)="W !,$TR($J("""",IOM),"" "",""-""),!"
        S PSBOUTP($$PGTOT,PSBLNTOT)="W !,?5,""Medication Label Totals -"",?50,""     Count"",?82,""% total events"""
        S PSBOUTP($$PGTOT,PSBLNTOT)="W !,?50,"""_$TR($J(" ",21)," ","-")_$TR($J(" ",4)," "," ")_$TR($J(" ",21)," ","-")_""""
        S PSBOUTP($$PGTOT,PSBLNTOT)="W !,?7,""Processed via SCANNER "",$TR($J("""",(49-$X)),"" "","".""),"":"",?50,"""_$J($FN(PSBTM,","),10)_$TR($J(" ",25)," "," ")_$J($S(PSBTM>0:((PSBTM/PSBTMEVT)*100),1:0),5,1)_""""
        S PSBOUTP($$PGTOT(2),PSBLNTOT)="W !!,?7,""Processed via SCANNER BY-PASS"",$TR($J("""",(49-$X)),"" "","".""),"":"","""_$J($FN(PSBMBYPS,","),10)_$TR($J(" ",25)," "," ")_$J($S(PSBMBYPS>0:((PSBMBYPS/PSBTMEVT)*100),1:0),5,1)_""""
        S PSBOUTP($$PGTOT,PSBLNTOT)="W !,?15,""KEYED ENTRY"",$TR($J("""",(49-$X)),"" "","".""),"":"","""_$TR($J(" ",11)," "," ")_$J($FN(PSBTMKEY,","),10)_$TR($J(" ",20)," "," ")_$J($S(PSBTMKEY>0:((PSBTMKEY/PSBTMEVT)*100),1:0),5,1)_""""
        S PSBOUTP($$PGTOT,PSBLNTOT)="W !,?15,""BCMA UNABLE TO SCAN "",$TR($J("""",(49-$X)),"" "","".""),"":"","""_$TR($J(" ",11)," "," ")_$J($FN(PSBTMUAS,","),10)_$TR($J(" ",20)," "," ")_$J($S(PSBTMUAS>0:((PSBTMUAS/PSBTMEVT)*100),1:0),5,1)_""""
        S PSBOUTP($$PGTOT,PSBLNTOT)="W !,?15,""VISTA MANUAL MED ENTRY "",$TR($J("""",(49-$X)),"" "","".""),"":"","""_$TR($J(" ",11)," "," ")_$J($FN(PSBTMMME,","),10)_$TR($J(" ",20)," "," ")_$J($S(PSBTMMME>0:((PSBTMMME/PSBTMEVT)*100),1:0),5,1)_""""
        S PSBOUTP($$PGTOT,PSBLNTOT)="W !,?50,"""_$TR($J(" ",21)," ","-")_$TR($J(" ",4)," "," ")_$TR($J(" ",21)," ","-")_""""
        S PSBOUTP($$PGTOT,PSBLNTOT)="W !,?7,""Total Medication Label Scan Events "",$TR($J("""",(49-$X)),"" "","".""),"":"","""_$J($FN(PSBTMEVT,","),10)_""""
        I $P(PSBRPT(3),",",2)=1 S PSBOUTP(PSBPGNUM)=PSBNULO
        Q
        ;
WRTRPT  ;Actually "WRITE" the report to output device
        I $O(PSBOUTP(""),-1)<1 D  Q
        .D HDR
        .X PSBOUTP($O(PSBOUTP(""),-1),14)
        .D FTR
        S PSBPGNUM=1
        I $P(PSBRPT(3),",",2)=1 S PSBNULO=PSBOUTP(PSBPGNUM)
        D HDR
        S PSBX1="" F  S PSBX1=$O(PSBOUTP(PSBX1)) Q:PSBX1=""  D
        .I PSBPGNUM'=PSBX1 D FTR S PSBPGNUM=PSBX1,PSBNULO=PSBOUTP(PSBPGNUM) D HDR
        .S PSBX2="" F  S PSBX2=$O(PSBOUTP(PSBX1,PSBX2)) Q:PSBX2=""  D
        ..X PSBOUTP(PSBX1,PSBX2)
        D FTR
        Q
        ;
HDR     ;Create Report Header
        W:$Y>1 @IOF
        W:$X>1 !
        S PSBPG="Page: "_PSBPGNUM_" of "_$S(+$O(PSBOUTP(""),-1)=0:1,1:+$O(PSBOUTP(""),-1))
        S PSBPGRM=IOM-($L(PSBPG)+12)
        I $P(PSBRPT(0),U,4)="" S $P(PSBRPT(0),U,4)=DUZ(2)
        W !!,"BCMA UNABLE TO SCAN (Summary)" W ?PSBPGRM,PSBPG
        W !!,"Date/Time: "_PSBDTTM,!,"Report Date Range:  Start Date: "_Y1_"   Stop Date: "_Y2
        W !,"Division: ",$P($G(^DIC(4,DUZ("2"),0)),U,1)
        W "   Nurse Location: " D
        .I $G(PSBNULO)]"" W $$NURLOC(PSBNULO) Q
        .I $G(PSBSTWD)]"" W $$NURLOC(PSBSTWD) Q
        .W "All"
        W !!,?5,"This is a summary report of BCMA Unable to Scan Events that have occurred within the given date range."
        W !!,"Note: * Access to BCMA Unable to Scan Reports is RESTRICTED. *"
        W !,$TR($J("",IOM)," ","="),!!
        Q
        ;
FTR     ;Create Report Footer
        I (IOSL<100) F  Q:$Y>(IOSL-12)  W !!
        W !!,$TR($J("",IOM)," ","="),!
        W !,PSBDTTM,!,"BCMA UNABLE TO SCAN (Summary)"
        W ?PSBPGRM,PSBPG,!
        Q
        ;
PGTOT(X)        ;Keep track of lines and PAGE Number...
        S:'$D(X) PSBLNTOT=PSBLNTOT+1
        S:$D(X) PSBLNTOT=PSBLNTOT+X
        I PSBPGNUM=1,PSBLNTOT=1 S PSBLNTOT=14 S PSBMORE=PSBLNTOT+23 Q PSBPGNUM
        I PSBLNTOT=PSBMORE S PSBMORE=PSBLNTOT+23
        I (PSBMORE>(IOSL-7))!(NEWPAGE) S PSBPGNUM=PSBPGNUM+1,PSBLNTOT=14,PSBMORE=PSBLNTOT+23,NEWPAGE=0
        Q PSBPGNUM
        ;
NURLOC(X)       ;Nursing Location Name
        I X["*UNIDENTIFIABLE PATIENT*" Q X
        N PSBNURLC
        S PSBNURLC=$G(^NURSF(211.4,X,0))
        I PSBNURLC="" Q PSBNURLC
        S PSBNURLC=$P($G(^SC(PSBNURLC,0)),"^",1)
        Q PSBNURLC
        ;
WARDDIV(RESULTS,PSBINST)        ; wards filtered by institution
        N PSBIEN,PSBWIEN,PSBX
        S PSBIEN=0 F  S PSBIEN=$O(^NURSF(211.4,PSBIEN)) Q:PSBIEN'?.N  D
        .I $P($G(^SC($P($G(^NURSF(211.4,PSBIEN,0)),U,1),0)),U,4)'=PSBINST Q  ;Screen out by INSTITUTION
        .S PSBX=0 F  S PSBX=$O(^NURSF(211.4,PSBIEN,3,PSBX)) Q:PSBX=""  D
        ..S PSBWIEN=$P(^NURSF(211.4,PSBIEN,3,PSBX,0),"^")
        ..I $$GET1^DIQ(42,PSBWIEN_",",.01)]"" S RESULTS($$GET1^DIQ(42,PSBWIEN_",",.01)_"$")=PSBIEN
        Q
