RAPRINT ;HISC/FPT AISC/DMK-Abnormal Exam Report ;8/12/97  09:57
 ;;5.0;Radiology/Nuclear Medicine;;Mar 16, 1998
 ;
 ; This report uses the 'AD' cross reference on File 70 to create a
 ; report of exams that use certain diagnostic codes. The Diagnostic
 ; Codes file (78.3) has a field named PRINT ON ABNORMAL RPT. If this
 ; field is set to YES and the user enters that diagnostic code for an
 ; exam, then an entry is made in the 'AD' cross reference.
 ;
 I $O(RACCESS(DUZ,""))="" D SETVARS^RAPSET1(0) S RAPSTX=""
 W !!,?10,"ABNORMAL EXAM REPORT",!
 ; Select Imaging Type, if exists
 S RAXIT=$$SETUPDI^RAUTL7() I RAXIT G END
 K ^TMP($J,"RA D-TYPE"),^TMP($J,"RA I-TYPE"),^TMP($J,"RADLY")
 D SELDIV^RAUTL7 ; Select division(s)
 I '$D(^TMP($J,"RA D-TYPE"))!($G(RAQUIT)) D KILL^RADLY1 G END
 D SELIMG^RAUTL7 ; Select I-Type(s)
 I '$D(^TMP($J,"RA I-TYPE"))!($G(RAQUIT)) D KILL^RADLY1 G END
 S X="" F  S X=$O(RACCESS(DUZ,"DIV-IMG",X)) Q:X']""  D
 . Q:'$D(^TMP($J,"RA D-TYPE",X))  S Y=""
 . F  S Y=$O(RACCESS(DUZ,"DIV-IMG",X,Y)) Q:Y']""  D
 .. S:$D(^TMP($J,"RA I-TYPE",Y)) ^TMP($J,"RADLY",X,Y)=0
 .. Q
 . Q
 K ^TMP($J,"RA DX CODES") D OMADX(1)
 I '$D(^TMP($J,"RA DX CODES")) D  D END Q
 . W !!?3,"No Diagnostic Codes selected, try again later."
 . Q
 W !
 K DIR,DIROUT,DIRUT,DTOUT,DUOUT
 S DIR(0)="Y",DIR("A")="Print only those exams not yet printed",DIR("B")="Yes",DIR("?")="Enter 'Yes' to print only those exams not yet printed, 'No' to print all." D ^DIR K DIR
 I $D(DIRUT) D END Q
 S RASW=$S(+Y=1:0,1:1),ZTRTN="START^RAPRINT",ZTSAVE("BEGDATE")="",ZTSAVE("ENDDATE")="",ZTSAVE("RASW")="",ZTSAVE("^TMP($J,""RA D-TYPE"",")="",ZTSAVE("^TMP($J,""RA I-TYPE"",")="",ZTSAVE("^TMP($J,""RADLY"",")=""
 S ZTSAVE("^TMP($J,""RA DX CODES"",")=""
 D DATE^RAUTL G END:RAPOP S BEGDATE=9999999.9999-BEGDATE,ENDDATE=9999999.9999-ENDDATE
 W ! D ZIS^RAUTL G:RAPOP END
START ;
 S:$D(ZTQUEUED) ZTREQ="@"
 U IO K I S CNT=0,RAOUT=0,PDATE=+$E(DT,4,5)_"/"_+$E(DT,6,7)_"/"_$E(DT,2,3) S RAEND=ENDDATE-1,QQ="",$P(QQ,"=",80)="=",I1("DIV")="",I1("IT")="",I1("DX")=""
 D HDR^RAPRINT1 G:RAOUT END
 F I=0:0 S I=$O(^RADPT("AD",I)) Q:I'>0!(RAOUT)  I $D(^RA(78.3,I,0)),($D(^TMP($J,"RA DX CODES",$P(^RA(78.3,I,0),"^")))) F J=0:0 S J=$O(^RADPT("AD",I,J)) Q:J'>0!(RAOUT)  F K=RAEND:0 S K=$O(^RADPT("AD",I,J,K)) Q:K'>0!(K>BEGDATE)!(RAOUT)  D PAT1
 D DIV^RAPRINT1,NEGRPT
END ;
 K ^TMP($J),BEGDATE,CNT,DIR,DIROUT,DIRUT,DTOUT,DUOUT,ENDDATE,I,I1,J,K,L,PDATE,POP,QQ
 K RACASE,RADIC,RADFN,RADIAG,RADIVNME,RADIVNUM,RADXCODE,RAEND,RAEXAM,RAEXDT,RAITNAME,RAITNUM,RAMD,RAOUT,RAPAT,RAPATNME,RAPOP,RAPROC,RAQUIT,RASDXDTE,RASDXIEN,RASSN,RASW,RAUTIL,RAWARD,RAXIT,X,Y
 K POP,ZTRTN,ZTSAVE,RAMES,ZTDESC
 K:$D(RAPSTX) RACCESS,RAPSTX
 D CLOSE^RAUTL
 Q
PAT1 F L=0:0 S L=$O(^RADPT("AD",I,J,K,L)) Q:L'>0!(RAOUT)  I $D(^RADPT(J,"DT",K,"P",L,0)) D BTG
 Q
BTG ; build tmp global
 I $D(ZTQUEUED) D STOPCHK^RAUTL9 S:$G(ZTSTOP)=1 RAOUT=1 Q:RAOUT
 S RARE(0)=$G(^RADPT(J,"DT",K,0))
 S RADIVNUM=+$P(RARE(0),U,3),RADIVNME=$P($G(^DIC(4,RADIVNUM,0)),U)
 I RADIVNME]"",('$D(^TMP($J,"RA D-TYPE",RADIVNME))) Q
 S RADIVNME=$S(RADIVNME]"":RADIVNME,1:"Unknown")
 S RAITNUM=+$P(RARE(0),U,2),RAITNAME=$P($G(^RA(79.2,RAITNUM,0)),U)
 I RAITNAME]"",('$D(^TMP($J,"RA I-TYPE",RAITNAME))) Q
 S RAITNAME=$S(RAITNAME]"":RAITNAME,1:"Unknown")
 K RARE(0)
 Q:'$D(^TMP($J,"RADLY",RADIVNME,RAITNAME))
 S RAPATNME=$P($G(^DPT(J,0)),U,1) S:RAPATNME="" RAPATNME="UNKNOWN"
 S ^TMP($J,RADIVNME,RAITNAME,I,RAPATNME,J,K,L)=""
 Q
NEGRPT ; negative reports
 Q:+$G(RAOUT)
 I $D(ZTQUEUED) D STOPCHK^RAUTL9 S:$G(ZTSTOP)=1 RAOUT=1 Q:RAOUT
 S RADIVNME="",RAOUT=0
 F  S RADIVNME=$O(^TMP($J,"RADLY",RADIVNME)) Q:RADIVNME=""!(RAOUT=1)  S RAITNAME="" F  S RAITNAME=$O(^TMP($J,"RADLY",RADIVNME,RAITNAME)) Q:RAITNAME=""!(RAOUT=1)  I +^TMP($J,"RADLY",RADIVNME,RAITNAME)=0 D
 .D:CNT>0 HANG^RAPRINT1 Q:RAOUT=1
 .D:CNT>0 HDR^RAPRINT1 Q:RAOUT
 .W !?22,"Division: ",RADIVNME,!?18,"Imaging Type: ",RAITNAME,!
 .W !?32,"***********************"
 .W !?32,"*  No Abnormal Exams  *"
 .W !?32,"***********************",!
 .S CNT=1
 Q
OMADX(RAAB) ; One-Many-All selector for Dx codes.
 ; Input : RAAB=0 - doesn't need 'Print On Abnormal Rpts' set to 'yes'
 ;         RAAB=1 - must have 'Print On Abnormal Rpts' set to 'yes'
 N RADIC,RAQUIT,RAUTIL
 S RADIC="^RA(78.3,",RADIC(0)="QEANZ",RAUTIL="RA DX CODES"
 S RADIC("A")="Select Diagnostic Codes: ",RADIC("B")="All"
 S:RAAB RADIC("S")="I $P(^(0),""^"",3)=""Y"""
 W ! D EN1^RASELCT(.RADIC,RAUTIL)
 Q
