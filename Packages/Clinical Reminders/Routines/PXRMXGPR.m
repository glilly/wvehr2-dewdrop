PXRMXGPR        ; SLC/PJH - Reminder Due print calls ;07/17/2009
        ;;2.0;CLINICAL REMINDERS;**4,6,12**;Feb 04, 2005;Build 73
        ;
        ;Called from PXRMXPR
        ;
DOPER(TOTAL,APPL,DUE)   ;
        N PERAPPL,PERDONE,PERDUE
        I APPL=0 Q "0^0^0"
        S PERAPPL=(APPL/TOTAL)*100 I $P(PERAPPL,".",2)>4 S PERAPPL=PERAPPL+1
        S PERDUE=(DUE/APPL)*100 I $P(PERDUE,".",2)>4 S PERDUE=PERDUE+1
        S PERDUE=$P(PERDUE,"."),PERAPPL=$P(PERAPPL,".")
        S PERDONE=$S(PERDUE=0:100,1:(100-PERDUE))
        Q PERAPPL_U_PERDUE_U_PERDONE
        ;
        ;Print Selection criteria
HEAD(PSTART)    ;
        I SUB="TOTAL" N NAM S NAM="TOTAL REPORT"
        I PXRMTABS="Y" D  Q
        .N FFAC,FNAM
        .S FNAM=NAM
        .I "CES"[PXRMTABC S FNAM=$TR(FNAM,SEP,"_")
        .I PXRMFCMB="N","LT"[PXRMSEL D  Q
        ..S FFAC=$TR(FACPNAME,SEP,"_")
        ..W !,"0"_SEP_FFAC_"_"_FNAM_SEP_SEP
        .I PXRMFCMB="N","LT"'[PXRMSEL W !,"0"_SEP_FNAM_SEP_SEP Q
        .I PXRMFCMB="Y" W !,"0"_SEP_"COMBINED_REPORT_"_FNAM_SEP_SEP Q
        I "LT"[PXRMSEL D
        .I PXRMFCMB="N" W !,?PSTART,"Facility: ",FACPNAME Q
        .W !,?PSTART,"Combined Report: "
        .N FACN,LENGTH,TEXT
        .S FACN=0,LENGTH=17+PSTART
        .F  S FACN=$O(PXRMFACN(FACN)) Q:'FACN  D
        ..S TEXT=$P(PXRMFACN(FACN),U)_" ("_FACN_")"
        ..I $O(PXRMFACN(FACN)) S TEXT=TEXT_", "
        ..I (LENGTH+$L(TEXT))>80 S LENGTH=17+PSTART W !,?(17+PSTART)
        ..W TEXT S LENGTH=LENGTH+$L(TEXT)
        I "PTO"[PXRMSEL D
        .I SUB="TOTAL" W !,?PSTART,NAM Q
        .W !,?PSTART,"Reminders "_PXRMTX_" for ",NAM
        I PXRMSEL="L" D
        .N CNT,NOUT,TEXTIN,TEXTOUT
        .S TEXTIN(1)="Reminders "_PXRMTX_" "_SD_" - "_NAM
        .I "PF"[PXRMFD S TEXTIN(1)=TEXTIN(1)_" for "_BD_" to "_ED
        .I PXRMFD="A" S TEXTIN(1)=TEXTIN(1)_" admissions from "_BD_" to "_ED
        .I PXRMFD="C" S TEXTIN(1)=TEXTIN(1)_" for current inpatients"
        .D FORMAT^PXRMTEXT(PSTART,75,1,.TEXTIN,.NOUT,.TEXTOUT)
        .F CNT=1:1:NOUT W !,TEXTOUT(CNT)
        I PXRMSEL="R" W !,"Patient List: "_SUB
        I PXRMSEL'="L" W " for ",SD
        W:PXRMSEL="I" !
        ;
        Q
        ;
        ;Output the provider report criteria
CRIT(PSTART,PLSTCRIT)   ;
        N CNT,RCCNT,RCDES,RICNT,RIDES,UNDL
        S CNT=0
        S UNDL=$TR($J("",79)," ","_") D LITS^PXRMXPR1
        S PLSTCRIT(CNT)=$$RJ^XLFSTR(" ",PSTART-8)_"Report Criteria:",CNT=CNT+1
        I PXRMTMP'="" S PLSTCRIT(CNT)=$$RJ^XLFSTR(" ",PSTART)_$$LJ^XLFSTR("Report Title:",22)_$P(PXRMTMP,U,3),CNT=CNT+1
        S PLSTCRIT(CNT)=$$RJ^XLFSTR(" ",PSTART)_$$LJ^XLFSTR("Patient Sample:",22)_PXRMFLD,CNT=CNT+1
        I PXRMSEL'="L" S PLSTCRIT(CNT)=$$RJ^XLFSTR(" ",PSTART)_$$LJ^XLFSTR(PXRMFLD_":",22) D DISP(.CNT,.PLSTCRIT)
        I PXRMSEL="L" D
        .S PLSTCRIT(CNT)=$$RJ^XLFSTR(" ",PSTART)_$$LJ^XLFSTR(PXRMFLD_":",22)_DES,CNT=CNT+1
        .I $E(PXRMLCSC,2)'="A" S PLSTCRIT(CNT)=$$RJ^XLFSTR(" ",10) D DISP(.CNT,.PLSTCRIT)
        I $D(PXRMRCAT) D
        .S RCCNT=0
        .F  S RCCNT=$O(PXRMRCAT(RCCNT)) Q:'RCCNT  D
        ..S RCDES=$P(PXRMRCAT(RCCNT),U,2)
        ..I RCCNT=1 S PLSTCRIT(CNT)=$$RJ^XLFSTR(" ",PSTART)_$$LJ^XLFSTR("Reminder Category:",22)_RCDES_U_6,CNT=CNT+1
        ..I RCCNT>1 S PLSTCRIT(CNT)=$$RJ^XLFSTR(" ",22)_RCDES
        .S RICNT=0
        .F  S RICNT=$O(PXRMREM(RICNT)) Q:'RICNT  D
        ..S RIDES=$P(PXRMREM(RICNT),U,2)
        ..I RICNT=1 S PLSTCRIT(CNT)=$$RJ^XLFSTR(" ",PSTART)_$$LJ^XLFSTR("Individual Reminder:",22)_RIDES_U_6,CNT=CNT+1
        ..I RICNT>1 S PLSTCRIT(CNT)=$$RJ^XLFSTR(" ",22)_RIDES,CNT=CNT+1
        S PLSTCRIT(CNT)=U_6,CNT=CNT+1
        I PXRMREP="D" D
        .S PLSTCRIT(CNT)=$$RJ^XLFSTR(" ",PSTART)_$$LJ^XLFSTR("Reminder:",22)_RDES,CNT=CNT+1
        .;Display future appointments for Reminder Due report only
        .I PXRMRT="PXRMX" S PLSTCRIT(CNT)=$$RJ^XLFSTR(" ",PSTART)_"Appointments:" D
        ..I PXRMFUT="Y" S PLSTCRIT(CNT)=PLSTCRIT(CNT)_$$LJ^XLFSTR(" ",32-$L(PLSTCRIT(CNT)))_"All Future Appointments",CNT=CNT+1
        ..I PXRMFUT="N" S PLSTCRIT(CNT)=PLSTCRIT(CNT)_$$LJ^XLFSTR(" ",32-$L(PLSTCRIT(CNT)))_"Next Appointment only",CNT=CNT+1
        I PXRMSEL="P" S PLSTCRIT(CNT)=$$RJ^XLFSTR(" ",PSTART)_$$LJ^XLFSTR("All/Primary:",22)_CDES,CNT=CNT+1
        I PXRMSEL="L" D  S CNT=CNT+1
        .S PLSTCRIT(CNT)=$$RJ^XLFSTR(" ",PSTART)_$$LJ^XLFSTR("Date Range:",22)
        .I "PAF"[PXRMFD S PLSTCRIT(CNT)=PLSTCRIT(CNT)_BD_" to "_ED Q
        .I PXRMFD="C" S PLSTCRIT(CNT)=PLSTCRIT(CNT)_"not applicable" Q
        S PLSTCRIT(CNT)=$$RJ^XLFSTR(" ",PSTART)_$$LJ^XLFSTR("Effective Due Date:",22)_SD,CNT=CNT+1
        S PLSTCRIT(CNT)=$$RJ^XLFSTR(" ",PSTART)_$$LJ^XLFSTR("Date run:",22)_RD,CNT=CNT+1
        I PXRMTMP'="" D 
        .S PLSTCRIT(CNT)=$$RJ^XLFSTR(" ",PSTART)_$$LJ^XLFSTR("Template Name:",22)_$P(PXRMTMP,U,2),CNT=CNT+1
        .I PXRMUSER S PLSTCRIT(CNT)=$$RJ^XLFSTR(" ",PSTART)_$$LJ^XLFSTR("Requested by:",22)_$$GET1^DIQ(200,DUZ,.01)_U_3,CNT=CNT+1
        I (PXRMFCMB="Y")!(PXRMLCMB="Y")!(PXRMTCMB="Y") D
        .N LIT,TEXT
        .S LIT=$S(PXRMSEL="P":"Providers","OT"[PXRMSEL:"Teams",1:"Locations")
        .S PLSTCRIT(CNT)=$$RJ^XLFSTR(" ",PSTART)_$$LJ^XLFSTR("Combined report:",22)
        .I PXRMFCMB="Y",PXRMLCMB="Y" S TEXT="Combined Facility and Combined "_LIT
        .I PXRMFCMB="Y",PXRMLCMB="N" S TEXT="Combined Facility by Individual "_LIT
        .I PXRMLCMB="Y",PXRMFCMB="N" S TEXT="Combined "_LIT
        .I PXRMTCMB="Y" S TEXT="Combined "_LIT
        .S PLSTCRIT(CNT)=PLSTCRIT(CNT)_TEXT,CNT=CNT+1
        .S PLSTCRIT(CNT)=U_3,CNT=CNT+1
        I PXRMREP="S","IRT"[PXRMTOT,"IR"'[PXRMSEL D
        .N LIT1,LIT2,LIT3,TEXT
        .D LIT^PXRMXD
        .S PLSTCRIT(CNT)=$$RJ^XLFSTR(" ",PSTART)_$$LJ^XLFSTR("Summary report:",22)
        .I PXRMTOT="I" S TEXT=LIT1
        .I PXRMTOT="R" S TEXT=LIT2
        .I PXRMTOT="T" S TEXT=LIT3
        .S PLSTCRIT(CNT)=PLSTCRIT(CNT)_TEXT,CNT=CNT+1
        .S PLSTCRIT(CNT)=U_3,CNT=CNT+1
        I $D(PXRMSCAT),PXRMSCAT]"",PXRMFD="P" D OSCAT(PXRMSCAT,PSTART,.CNT,.PLSTCRIT)
        N CHECK,CNT,NODE,STR
        S CNT=0 F  S CNT=$O(PLSTCRIT(CNT)) Q:CNT'>0  D
        .S NODE=$G(PLSTCRIT(CNT)),CHECK=$P(NODE,U,2),STR=$P(NODE,U)
        .I CHECK>0 D CHECK(CHECK) I STR="" Q
        .W !,STR
        W !,UNDL,!
        Q
        ;
        ;Display selected teams/providers
DISP(CNT,PLSTCRIT)      ;
        N IC
        S IC=""
        I PXRMSEL="P" F  S IC=$O(PXRMPRV(IC)) Q:IC=""  D
        .I IC=1 S PLSTCRIT(CNT)=PLSTCRIT(CNT)_$P(PXRMPRV(IC),U,2),CNT=CNT+1
        .I IC>1 S PLSTCRIT(CNT)=$$RJ^XLFSTR(" ",32)_$P(PXRMPRV(IC),U,2),CNT=CNT+1
        .S PLSTCRIT(CNT)=U_3,CNT=CNT+1
        I PXRMSEL="T" F  S IC=$O(PXRMPCM(IC)) Q:IC=""  D
        .I IC=1 S PLSTCRIT(CNT)=PLSTCRIT(CNT)_$P(PXRMPCM(IC),U,2),CNT=CNT+1
        .I IC>1 S PLSTCRIT(CNT)=$$RJ^XLFSTR(" ",32)_$P(PXRMPCM(IC),U,2),CNT=CNT+1
        .S PLSTCRIT(CNT)=U_3,CNT=CNT+1
        I PXRMSEL="O" F  S IC=$O(PXRMOTM(IC)) Q:IC=""  D
        .I IC=1 S PLSTCRIT(CNT)=PLSTCRIT(CNT)_$P(PXRMOTM(IC),U,3),CNT=CNT+1
        .I IC>1 S PLSTCRIT(CNT)=$$RJ^XLFSTR(" ",32)_$P(PXRMOTM(IC),U,2),CNT=CNT+1
        .S PLSTCRIT(CNT)=U_3,CNT=CNT+1
        I PXRMSEL="I" F  S IC=$O(PXRMPAT(IC)) Q:IC=""  D
        .I IC=1 S PLSTCRIT(CNT)=PLSTCRIT(CNT)_$P(PXRMPAT(IC),U,2),CNT=CNT+1
        .I IC>1 S PLSTCRIT(CNT)=$$RJ^XLFSTR(" ",32)_$P(PXRMPAT(IC),U,2),CNT=CNT+1
        .S PLSTCRIT(CNT)=U_3,CNT=CNT+1
        I PXRMSEL="R" F  S IC=$O(PXRMLIST(IC)) Q:IC=""  D
        .I IC=1 S PLSTCRIT(CNT)=PLSTCRIT(CNT)_$P(PXRMLIST(IC),U,2),CNT=CNT+1
        .I IC>1 S PLSTCRIT(CNT)=$$RJ^XLFSTR(" ",32)_$P(PXRMLIST(IC),U,2),CNT=CNT+1
        .S PLSTCRIT(CNT)=U_3,CNT=CNT+1
        I PXRMSEL="L" D
        .I $E(PXRMLCSC)="H" F  S IC=$O(^XTMP(PXRMXTMP,"HLOC",IC)) Q:IC=""  D
        ..S PLSTCRIT(CNT)=$$RJ^XLFSTR(" ",32)_$P(^XTMP(PXRMXTMP,"HLOC",IC),U,2),CNT=CNT+1
        ..S PLSTCRIT(CNT)=U_3,CNT=CNT+1
        .I $E(PXRMLCSC)="C" F  S IC=$O(PXRMCS(IC)) Q:IC=""  D
        ..S PLSTCRIT(CNT)=$$RJ^XLFSTR(" ",32)_$P(PXRMCS(IC),U,1)_" "_$P(PXRMCS(IC),U,3),CNT=CNT+1
        ..S PLSTCRIT(CNT)=U_3,CNT=CNT+1
        ..I PXRMCCS="I" S PLSTCRIT(CNT)=$$RJ^XLFSTR(" ",32)_"Report by Individual Clinic(s)",CNT=CNT+1
        ..I PXRMCCS="B" S PLSTCRIT(CNT)=$$RJ^XLFSTR(" ",32)_"Report by Clinic Stops and Individual Clinic(s)",CNT=CNT+1
        .I $E(PXRMLCSC)="G" F  S IC=$O(PXRMCGRP(IC)) Q:IC=""  D
        ..S PLSTCRIT(CNT)=$$RJ^XLFSTR(" ",32)_$P(PXRMCGRP(IC),U,2),CNT=CNT+1
        ..S PLSTCRIT(CNT)=U_3,CNT=CNT+1
        Q
        ;
        ;Output the service categories
OSCAT(SCL,PSTART,CNT,PLSTCRIT)  ;
        N IC,CSTART,EM,SC,SCTEXT
        S CSTART=PSTART+3
        S PLSTCRIT(CNT)=$$RJ^XLFSTR(" ",PSTART)_$$LJ^XLFSTR("Service categories:",22)_SCL,CNT=CNT+1
        F IC=1:1:$L(SCL,",") D
        .S SC=$P(SCL,",",IC)
        .S SCTEXT=$$EXTERNAL^DILFD(9000010,.07,"",SC,.EM)
        .S PLSTCRIT(CNT)=U_3,CNT=CNT+1
        .S PLSTCRIT(CNT)=$$RJ^XLFSTR(" ",CSTART)_SC_" - "_SCTEXT,CNT=CNT+1
        Q
        ;
        ;If necessary, write the header
COL(NEWPAGE)    ;
        I NEWPAGE D  Q:DONE
        .I PXRMTABS="N" D PAGE
        .I PXRMTABS="Y" W !!
        D CHECK(0) Q:DONE
        D HEAD(0)
        S HEAD=0
        I PXRMTABS="Y" Q
        I PXRMREP="D" D
        .N PNAM
        .S PNAM=$P(PXRMREM(1),U,4) I PNAM="" S PNAM=$P(PXRMREM(1),U,2)
        .W !!,PNAM,":  ",COUNT
        .W:COUNT>1 " patients have the reminder "_PXRMTX
        .W:COUNT=1 " patient has the reminder "_PXRMTX
        N IC F IC=0:1:2 W !,?PXRMT(IC),PXRMH(IC)
        Q
        ;
        ;form feed to new page
PAGE    I ($E(IOST,1,2)="C-")&(IO=IO(0))&(PAGE>0) D
        .S DIR(0)="E"
        .W !
        .D ^DIR K DIR
        I $D(DUOUT)!($D(DTOUT))!($D(DIROUT)) S DONE=1 Q
        W:$D(IOF)&(PAGE>0) @IOF
        S PAGE=PAGE+1,FIRST=0
        I $E(IOST,1,2)="C-",IO=IO(0) W @IOF
        E  W !
        N TEMP,TEXTLEN
        S TEMP=$$NOW^XLFDT,TEMP=$$FMTE^XLFDT(TEMP,"P")
        S TEMP=TEMP_"  Page "_PAGE
        S TEXTLEN=$L(TEMP)
        W ?(IOM-TEXTLEN),TEMP
        S TEXTLEN=$L(PXRMOPT)
        I TEXTLEN>0 D
        .W !!
        .W ?((IOM-TEXTLEN)/2),PXRMOPT
        Q
        ;
        ;count of patients in sample
TOTAL   ;
        N LIT,PERAPPL,PERDONE,PERDUE,PERCENT
        ;determine percentages for detail reports
        I PXRMREP="D",PXRMPER="1" D
        .S PERCENT=$$DOPER(TOTAL,APPL,COUNT)
        .S PERAPPL=$P(PERCENT,U),PERDUE=$P(PERCENT,U,2),PERDONE=$P(PERCENT,U,3)
        ;delimited reports
        I PXRMTABS="Y" D  Q
        .I PXRMREP="D" D  Q
        ..I PXRMPER="1" W !,"0"_SEP_"PATIENTS"_SEP_TOTAL_SEP_"APPLICABLE"_SEP_APPL_SEP_"%APPL"_SEP_PERAPPL_SEP_"%DUE"_SEP_PERDUE_SEP_"%DONE"_SEP_PERDONE Q
        ..W !,"0"_SEP_"PATIENTS"_SEP_TOTAL_SEP_"APPLICABLE"_SEP_APPL
        .I PXRMREP="S" W !,"0"_SEP_"PATIENTS"_SEP_TOTAL_SEP_SEP_$TR(SUB,SEP,"_") Q
        ;
        I (PXRMRT="PXRMX")!(PXRMREP="S") W !
        ;S LIT=" patient."
        ;I TOTAL>1 S LIT=" patients."
        S LIT=$S(TOTAL=0:" patients.",TOTAL=1:" patient.",1:" patients.")
        W !,"Report run on "_TOTAL_LIT
        I PXRMREP="D" D
        .S LIT=$S(APPL=0:" patients.",APPL=1:" patient.",1:" patients.")
        .W !,"Applicable to "_APPL_LIT
        .I PXRMPER="1" D
        ..W !,"%Applicable "_PERAPPL
        ..W !,"%Due "_PERDUE
        ..W !,"%Done "_PERDONE
        Q
        ;
        ;Null report prints if no patients found
NULL    I PXRMSEL="L" D
        .I PXRMFD="P" W !!,"No patient visits found"
        .I PXRMFD="A" W !!,"No patient admissions found"
        .I PXRMFD="C" W !!,"No current inpatient found"
        .I PXRMFD="F" W !!,"No patient appointments found"
        I PXRMSEL="P" W !!,"No patients found for provider(s) selected"
        I "OT"[PXRMSEL W !!,"No patients found for team(s) selected"
        Q
        ;
        ;Null report if no patients due/satisfied - detailed report only
NONE    D PAGE
        D HEAD(0)
        W !!,"No patients with reminders "_PXRMTX
        Q
        ;
SPACER(TEXT,LENGTH)     ;
        Q
        ;
        ;Check for page throw
CHECK(CNT)      ;
        I PXRMTABS="N",$Y>(IOSL-BMARG-CNT) D PAGE
        Q
