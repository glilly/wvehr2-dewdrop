DVBAB82 ;ALB - CAPRI DVBA REPORTS;03/08/02
 ;;2.7;AMIE;**42,90,100,119**;Apr 10, 1995;Build 10
 Q
 ;
START(MSG,RPID,PARM) ; CALLED BY REMOTE PROCEDURE DVBAB REPORTS
 ;Parameters
 ;=============
 ; MSG  : Output - ^TMP("DVBA",$J)
 ; RPID : Report Identification Number
 ; PARM : Input parameters separated by "^"
 ;
 N DVBHFS,DVBERR,DVBGUI,I
 K ^TMP("DVBA",$J)
 S DVBGUI=1,DVBERR=0,DVBHFS=$$HFS(),RPID=$G(RPID)
 I RPID<1!(RPID>9) S ^TMP("DVBA",$J,1)="0^Undefined Report ID" G END
 D HFSOPEN("DVBRP",DVBHFS,"W") I DVBERR G END
 I RPID=1 D CRMS G END
 I RPID=3 D CPRNT G END
 D CHECK I DVBERR G END
 I RPID=2 D CRRR G END
 I RPID=4 D CRPON G END
 I RPID=5 D CIRPT G END
 I RPID=6 D DSRP G END
 I RPID=7 D SDPP G END
 I RPID=8 D SPRPT G END
 I RPID=9 D VIEW
 ;
END D HFSCLOSE("DVBRP",DVBHFS)
 S I=0 F  S I=$O(^TMP("DVBA",$J,1,I)) Q:'I  S ^TMP("DVBA",$J,1,I)=^TMP("DVBA",$J,1,I)_$C(13) S:^(I)["$END" ^(I)=""
 S MSG=$NA(^TMP("DVBA",$J))
 Q
CHECK ; VALIDATE INPUT PARAMETERS
 I $G(PARM)="" S DVBERR=1,^TMP("DVBA",$J,1)="0^Undefined Input Parameters"
 Q
 ;
SDPP ; Report # 7 - Full (Patient Profile MAS) Report
 ;Parameters
 ;=============
 ; DFN : Patient Identification Number
 ; SDR : R/Range or A/All
 ; SDBD : Begining date
 ; SDED : Ending date
 ; SDP : Print the profile? 1 OR 0
 ; SDTYP(2) : Print appointments? 1 OR 0
 ; SDTYP(1) : Print add/edits? 1 or 0
 ; SDTYP(4) : Print enrollments? 1 or 0
 ; SDTYP(3) : Print dispositions? 1 OR 0
 ; SDTYP(7) : Print team information? 1 OR 0
 ; SDTYP(5) : Print means test? 1 OR 0
 ;
 N SDTYP,SDBD,SDED,SDACT,SDPRINT,SDYES,SDRANGE,SDBEG,SDEN
 S DFN=$P(PARM,"^",1),SDR=$P(PARM,"^",2),SDBD=$P(PARM,"^",3),SDED=$P(PARM,"^",4)
 S SDP=$P(PARM,"^",5),SDTYP(2)=$P(PARM,"^",6),SDTYP(1)=$P(PARM,"^",7)
 S SDTYP(4)=$P(PARM,"^",8),SDTYP(3)=$P(PARM,"^",9),SDTYP(7)=$P(PARM,"^",10),SDTYP(5)=$P(PARM,"^",11)
 D VAL Q:DVBERR
 S SDACT="",(SDYES,SDRANGE,SDPRINT)=0
 I SDR="R" S SDRANGE=1
 I SDP=1 S SDYES=1,SDPRINT=1
 I 'SDRANGE S (SDBD,SDBEG)=2800101,(SDED,SDEND)=$$ENDDT(),SDHDR=1
 D ENS^%ZISS
 N SDYN,DVB S SDPRINT=1,DVB(1)=SDBD_";"_SDED,DVB(4)=DFN,DVB("FLDS")=1
 ;I $$SDAPI^SDAMA301(.DVB)>0 D
 I $O(^DPT(DFN,"S",SDBD)) D
 . I SDTYP(2)=1 S SDTYP(2)="" Q
 . K SDTYP(2)
 IF $$EXOE^SDOE(DFN,SDBD,SDED) D
 . I SDTYP(1)=1 S SDTYP(1)="" Q
 . K SDTYP(1)
 I $D(^DPT(DFN,"DE")) D
 . I SDTYP(4)=1 S SDTYP(4)="",SDACT=0 Q
 . K SDTYP(4)
 I $D(^DPT(DFN,"DIS")),$S('SDRANGE:1,+$O(^("DIS",9999999-(SDED+.9)))&($O(^(9999999-(SDED+.9)))<(9999999-(SDBD-.1))):1,1:0) D
 . I SDTYP(3)=1 S SDTYP(3)="" Q
 . K SDTYP(3)
 S SDYN=$$LST^DGMTU(DFN) I SDYN D
 . I SDTYP(5)=1 S SDTYP(5)="" Q
 . K SDTYP(5)
 I SDTYP(7)=1 D
 . S SDTYP(7)="",GBL="^TMP(""SDPP"","_$J_")" Q
 . K SDTYP(7)
 D PRINT^SDPPRT
 K ^TMP($J,"SDAMA301") S VALMBCK="R"
 Q
ENDDT() ;Calculate end date for "all" date
 N X S X=$O(^DPT(DFN,"S",""),-1) S:X<DT X=DT_.24 Q X
 ;N X,X1,X2,%H S X1=DT,X2=36600
 ;D C^%DTC
 ;Q X_.24
 ;
VIEW ; Report # 9 - View Registration Data Report
 ; Parameters
 ; ==========
 ; DFN : Patient Identification Number
 ;
 U IO
 S DFN=$P(PARM,"^",1)
 D VAL Q:DVBERR
 D EN1^DGRP
 Q
DSRP ; Report # 6 - Reprint a Notice of Discharge Report
 ; Parameters
 ; % : 1=Report on all veterans for a given day (BDATE required)
 ;   : 0=Report on a single Veteran (DFN required)
 ; BDATE : Original Processing Date - $H/FileMan
 ; DFN  : Patient Identification Number
 ;
 N %,BDATE,DFN,DFNIEN
 S %=$P(PARM,"^",1),BDATE=$P(PARM,"^",2),DFN=$P(PARM,"^",3),DFNIEN=""
 I BDATE="" S DVBERR=1,^TMP("DVBA",$J,1)="0^Incorrect Date"  Q
 D DUZ2^DVBAUTIL
 U IO
 D VAL Q:DVBERR
 I %=1 D  Q
 . S HD="SINGLE NOTICE OF DISCHARGE REPRINTING"
 . D NOPARM^DVBAUTL2 G:$D(DVBAQUIT) KILL^DVBAUTIL S DTAR=^DVB(396.1,1,0),FDT(0)=$$FMTE^XLFDT(DT,"5DZ")
 . S HEAD="NOTICE OF DISCHARGE",HEAD1="FOR "_$P(DTAR,U,1)_" ON "_FDT(0)
 . I $D(^DVB(396.2,"B",DFN)) D
 . . S DFNIEN=$O(^DVB(396.2,"B",DFN,DFNIEN)),ADM=$P(^DVB(396.2,DFNIEN,0),U,3)
 . . I $D(^DGPM(+ADM,0)),$P(^(0),U,17)]"" S DCHPTR=$P(^DGPM(+ADM,0),U,17),DISCH=$S($P(^DGPM(DCHPTR,0),U,1)]"":$P(^(0),U,1),1:"") W ?($X+5),"Discharge date: ",$$FMTE^XLFDT(DISCH,"5DZ")
 . . I $P(^DVB(396.2,DFNIEN,0),U,7)'=DVBAD2 W *7,!!,"This does not belong to your RO.",!! H 3 Q
 . . I DFNIEN>0 S XDA=DFNIEN,DA=$P(^DVB(396.2,DFNIEN,0),U,1),ADMDT=$P(^DVB(396.2,DFNIEN,0),U,2),MB=$P(^(0),U,3)
 . . D REPRINT^DVBADSNT
 D DEQUE^DVBADSRP
 Q
 ;
SPRPT ; Report # 8 - OP(Operation Report)
 ;Parameters
 ;=============
 ; DFN : Patient Identification Number
 ; SRTN : Select Operation
 ;
 N DFN,SRTN,MAGTMPR2,SRSITE
 I $O(^SRO(133,1))'="B" S SRSITE=1
 S DFN=$P(PARM,"^",1),SRTN=$P(PARM,"^",2),MAGTMPR2=1
 D VAL Q:DVBERR
 D ^SROPRPT
 Q
 ;
CRPON ; Report # - 4 Reprint C&P Final Report
 ;Parameters
 ;=============
 ; RTYPE : Select Reprint Option (D)ate or (V)eteran
 ; RUNDATE : ORIGINAL PROCESSING date
 ; ANS : Reprinted by the RO or MAS
 ; % : LAB 1 OR 0
 ; DA(1) : Patient IEN for lab results
 ; DFN  : Patient Identification Number
 ;
 U IO
 N ONE
 S RTYPE=$P(PARM,"^",1),RUNDATE=$P(PARM,"^",2),ANS=$P(PARM,"^",3),%=$P(PARM,"^",4),DA(1)=$P(PARM,"^",5),DFN=$P(PARM,"^",6),DA=DA(1)
 I RTYPE="V" D VAL Q:DVBERR
 S XDD=^DD("DD"),$P(ULINE,"_",70)="_",ONE="N",Y=DT
 X XDD S HD="Reprint C & P Exams",SUPER=0
 I $D(^XUSEC("DVBA C SUPERVISOR",DUZ)) S SUPER=1
 S DVBCDT(0)=Y,PGHD="Compensation and Pension Exam Report",LOC=DUZ(2),PG=0,DVBCSITE=$S($D(^DVB(396.1,1,0)):$P(^(0),U,1),1:"Not specified")
 I "^D^V^"'[RTYPE S DVBERR=1,^TMP("DVBA",$J,1)="0^Incorrect Data Type" Q
 I ANS="R" K AUTO
 I ANS="M" S AUTO=1
 I "^M^R^"'[ANS S DVBERR=1,^TMP("DVBA",$J,1)="0^Incorrect Data Type" Q
 I RTYPE="D" D GO^DVBCRPRT Q
 I RTYPE="V" D
 . S ONE="Y",RO=$P(^DVB(396.3,DA,0),U,3)
 . I RO'=DUZ(2)&('$D(AUTO))&(SUPER=0) W !!,*7,"Those results do not belong to your office.",!! Q
 . I RO=DUZ(2)&('$D(AUTO))&("RC"'[($P(^DVB(396.3,DA,0),U,18))) W *7,!!,"This request has not been released to the Regional Office yet.",!! Q
 . S PRTDATE=$P(^DVB(396.3,DA,0),U,16) I PRTDATE="" W *7,!!,"This has never been printed.",!! I SUPER=0 S OUT=1 Q
 . I %=1 D REN2^DVBCLABR Q
 . ;D OV^DVBCRPON
 . K DVBAON2 D SETLAB^DVBCPRNT,VARS^DVBCUTIL,STEP2^DVBCRPRT
 Q
 ;
CIRPT ; Report # 5 - Insufficient Exam Report
 ;Parameters
 ;=============
 ; RPTTYPE : D/Detailed or S/Summary
 ; BEGDT : Beginning date $H/FileMan
 ; ENDDT : Ending date $H/FileMan
 ; RESANS : Insufficient Reason
 ;
 U IO
 S RPTTYPE=$P(PARM,"^",1),BEGDT=$P(PARM,"^",2),ENDDT=$P(PARM,"^",3),RESANS=$P(PARM,"^",4)
 I RPTTYPE="S" D SUM^DVBCIRPT Q
 I RPTTYPE="D" D
 . I RESANS="" S Y=-1 D INREAS
 . I '$D(DVBAARY("REASON")) S DVBAQTSL=""
 . S DVBCYQ=""
 . I RESANS'="" S Y=RESANS D INREAS
 . K DTOUT,DUOUT
 . S Y=-1 D EXMTPE,DETAIL^DVBCIRP1
 Q
 ;
EXMTPE ;
 N YSAVE,DVBAXIFN
 S YSAVE=Y
 F DVBAXIFN=0:0 S DVBAXIFN=$O(^DVB(396.6,DVBAXIFN)) Q:+DVBAXIFN=0  DO
 . S ^TMP($J,"XMTYPE",DVBAXIFN)=""
 S Y=-1
 I +YSAVE>0 S ^TMP($J,"XMTYPE",+YSAVE)=""
 S Y=YSAVE
 Q
INREAS ;
 N YSAVE,DVBXIFN
 S YSAVE=Y
 F DVBAXIFN=0:0 S DVBAXIFN=$O(^DVB(396.94,DVBAXIFN)) Q:+DVBAXIFN=0  DO
 . S DVBAARY("REASON",DVBAXIFN)=""
 S Y=-1
 I +YSAVE>0 S DVBAARY("REASON",+YSAVE)=""
 S Y=YSAVE
 Q
 ;
CRMS ; Report # 1 - Regional Office 21- day Certificate Printing Report.
 ; No Parameters
 ;
 U IO
 D ^DVBACRMS
 Q
 ;
CRRR ; Report # 2 - Reprint a 21 - day Certificate for the RO
 ;Parameters
 ;=============
 ; DVBSEL : Select one of the following:
 ;       N         Patient Name
 ;       D         ORIGINAL PROCESSING DATE
 ; SDATE : ORIGINAL PROCESSING date - $H/FileMan
 ; XDA : Patient IEN
 ;
 U IO
 S DVBSEL=$P(PARM,"^",1),SDATE=$P(PARM,"^",2),XDA=$P(PARM,"^",3)
 I "^D^N^"'[DVBSEL S DVBERR=1,^TMP("DVBA",$J,1)="0^Incorrect Data Type" Q
 I DVBSEL="D" D  I DVBERR Q
 . I SDATE="" S DVBERR=1,^TMP("DVBA",$J,1)="0^Undefined Date" Q
 . S %DT="X" S X=SDATE D ^%DT I Y<0 D  Q
 . . S DVBERR=1,^TMP("DVBA",$J,1)="0^Incorrect Date Format"
 I DVBSEL="N" D  I DVBERR Q
 . I XDA="" S DVBERR=1,^TMP("DVBA",$J,1)="0^Undefined Patient IEN" Q
 . S DIC=2,DIC(0)="NZX",X=XDA D ^DIC I Y<0 D  I DVBERR Q
 . . S DVBERR=1,^TMP("DVBA",$J,1)="0^Invalid Patient Name."
 . S DFN=XDA
 D INIT^DVBACRRR I 'CONT Q
 D HDR^DVBACRRR,DATA^DVBACRRR
 Q
 ;
CPRNT ; Report # 3 - Print C&P Final Report (manual) Report
 ; No Parameters
 ;
 S XDD=^DD("DD"),$P(ULINE,"_",70)="_",Y=DT
 X XDD S DVBCDT(0)=Y,PGHD="Compensation and Pension Exam Report",DVBCSITE=$S($D(^DVB(396.1,1,0)):$P(^(0),U,1),1:"Not Specified")
 D GO^DVBCPRNT
 Q
VAL ; VALIDATE PATIENT
 I $G(DFN)="" S DVBERR=1,^TMP("DVBA",$J,1)="0^Undefined Patient IEN" G END
 S DIC=2,DIC(0)="NZX",X=DFN D ^DIC
 I Y<0 S DVBERR=1,^TMP("DVBA",$J,1)="0^Invalid Patient Name." G END
 Q
 ;
HFS() ; -- get hfs file name
 N H
 S H=$H
 Q "DVBA_"_$J_"_"_$P(H,",")_"_"_$P(H,",",2)_".DAT"
 ;
HFSOPEN(HANDLE,DVBHFS,DVBMODE) ; Open File
 S DVBDIRY=$$GET^XPAR("DIV","DVB HFS SCRATCH")
 ;I DVBDIRY="" S ECERR=1 D  Q
 ;. S ^TMP("DVBA",$J,1)="0^A scratch directory for reports doesn't exist"
 D OPEN^%ZISH(HANDLE,,DVBHFS,$G(DVBMODE,"W")) D:POP  Q:POP
 .S DVBERR=1,^TMP("DVBA",$J,1)="0^Unable to open file "
 Q
 ;
HFSCLOSE(HANDLE,DVBHFS) ;Close HFS and unload data
 N DVBDEL,X,%ZIS
 D CLOSE^%ZISH(HANDLE)
 S ROOT=$NA(^TMP("DVBA",$J,1)),DVBDEL(DVBHFS)=""
 K @ROOT
 S X=$$FTG^%ZISH(,DVBHFS,$NA(@ROOT@(1)),4)
 S X=$$DEL^%ZISH(,$NA(DVBDEL))
 Q
