%ZTM5 ;SEA/RDS-TaskMan: Manager, Part 5 (Short Subroutines) ;10/29/2003  22:07
 ;;8.0;KERNEL;**24,36,118,127,136,162,275,355**;JUL 10, 1995;Build 9
 ;
ER ;primary error trap for manager
 S %ZTERLGR=$$LGR^%ZOSV
 S $ETRAP="D ER2^%ZTM5"
 L  S ^%ZTSCH("RUN")=$H
 S ^%ZTSCH("STATUS",$J)=$H_"^ERROR^Recording A Trapped Error."
 ;
 S ZTERCODE=$$EC^%ZOSV,ZTE=""
 I '$$SCREEN^%ZTER(ZTERCODE) D
 . L ^%ZTSCH("ER") H 1 S ZT=$H
 . S ^%ZTSCH("ER",+ZT,$P(ZT,",",2))=ZTERCODE
 . S ^($P(ZT,",",2),1)="Caused by the manager." L
 . Q
 ;
 D ^%ZTER K ZTERCODE
 ;Lets wait before restarting.
ER2 H 10 S $ET="Q:$STACK  S $EC="""" G RESTART^%ZTM0" S $EC=",U99,"
 ;
UPDATE ;CHECK^%ZTM/LOOKUP^%ZTM0--update TaskMan site parameters
 L ^%ZTSCH("UPDATE",$J)
 S %ZTOS=^%ZOSF("OS"),U="^"
 D GETENV^%ZOSV
 S %ZTUCI=$P(Y,U),%ZTVOL=$P(Y,U,2),%ZTNODE=$P(Y,U,3),%ZTPAIR=$P(Y,U,4)
 S %ZTVSN=+$O(^%ZIS(14.5,"B",%ZTVOL,"")),%ZTVSS=$G(^%ZIS(14.5,%ZTVSN,0))
 S %ZTVLI=($P(%ZTVSS,U,2)="Y") ;Did site set Inhibit.
 S %ZTYPE("V")=$P(%ZTVSS,U,10) ;get vol set type
U1 ;
 S %ZTPN=+$O(^%ZIS(14.7,"B",%ZTPAIR,"")),%ZTPS=$G(^%ZIS(14.7,%ZTPN,0))
 S %ZTPT=+$P(%ZTPS,U,4) ;Priority
 S %ZTSIZ=+$P(%ZTPS,U,5) ;par size
 S %ZTRET=+$P(%ZTPS,U,6) ;Retention Time
 S %ZTVMJ=+$P(%ZTPS,U,7) ;TM job limit
 S %ZTSLO=+$P(%ZTPS,U,8) ;TM slow down
 S %ZTYPE=$P(%ZTPS,U,9) ;TM Mode
 S %ZTPFLG("DCL")=$P(%ZTPS,U,10) ;TM mode, VAX DCL
 S %ZTPFLG("BAL")=$E($G(^%ZIS(14.7,%ZTPN,2)),1,40)
 S %ZTPFLG("MINSUB")=$S($P(%ZTPS,U,12):$P(%ZTPS,U,12),1:1)
 S %ZTPFLG("LBT")=0,%ZTPFLG("BI")=$S($P(%ZTPS,U,14):$P(%ZTPS,U,14),1:30) ;Balance Interval
 S %ZTPFLG("TM-DELAY")=$P($G(^%ZIS(14.7,%ZTPN,3),"^60"),U,2) ;Start Delay
 S %ZTPFLG("START")=+$H
 S %ZTPFLG("XUSCNT")=0 I %ZTOS["GT.M" S %ZTPFLG("XUSCNT")=$L($T(^XUSCNT))
 S ^%ZTSCH("UPDATE",$J)=$H
 S %ZTMON("DAY")=+$H D MON^%ZTM ;Setup Task Counting
 K ^%ZTSCH("LOADA",%ZTPAIR) ;Clear LB in case we stop doing LB.
 L
 I "GP"'[%ZTYPE D  HALT
 . K ^%ZTSCH("STATUS")
 . S ^%ZTSCH("RUN")=%ZTNODE_" is the wrong type of volume set for TaskMan."
 . Q
 ;For Cache Map CPF to Node.
 I %ZTOS["OpenM",$ZV["VMS" D
 . N I,X,Y S Y=$P(%ZTPAIR,":"),X=Y
 . F  S X=$O(^%ZIS(14.7,"B",X)) Q:X'[Y  D
 . . S I=$O(^%ZIS(14.7,"B",X,0)),Z=^%ZIS(14.7,I,0)
 . . S I=$P(Z,U,10) S:$L(I) %ZTPFLG("Q",$P($P(Z,U),":",2))=I,%ZTPFLG("Q",I)=$P($P(Z,U),":",2)
 . Q
 Q
 ;
HOUR ;Run once an hour for each taskman
 D SUBCHK
 Q
 ;
DAY ;Run once a DAY for each Taskman
 D MON
 Q
 ;
MON ;Save off the monitor data
 N X S X=""
 F I=0:1:23 S X=X_$G(%ZTMON(I))_"^",%ZTMON(I)=0
 S ^%ZTSCH("MON",%ZTPAIR,%ZTMON("DAY"))=X
 S %ZTMON("DAY")=+$H
 Q
 ;
SUBCHK ;Job the SUB check routine
 J SUBCHK^%ZTMS5
 Q
 ;
REQUIR ;UPDATE/CHECK^%ZTM--ensure required links are available
 K ZTREQUIR N ZT1,ZTN,ZTS,ZTU S ZT1=0
 F  S ZT1=$O(^%ZIS(14.5,ZT1)) Q:'ZT1  I $D(^%ZIS(14.5,ZT1,0))#2 S ZTS=^(0) I $P(ZTS,U,5)="Y" D TEST I $D(ZTREQUIR)#2 Q
 K ZT,ZT1,ZTN,ZTS,ZTU
 Q
 ;
TEST ;REQUIR--test a required volume set
 N $ET,$ES,NULL
 S ZTN=$P(ZTS,U),NULL="" I ZTN="" Q
 I ZTN=%ZTVOL Q
 I $P(ZTS,U,3)="N" S ZTREQUIR=ZTN Q
 I $P(ZTS,U,4)="Y" S ZTREQUIR=ZTN Q
 S ZTU=$O(^%ZIS(14.6,"AV",ZTN,"")) I ZTU="" Q
 S $ET="S ZTREQUIR=ZTN,$EC=NULL Q"
 S X=$D(^[ZTU,ZTN]DIC(0))
 L +^%ZTSCH("LINK",ZTN)
 I $D(^%ZTSCH("LINK",ZTN)) S ^%ZTSCH("LINK")=0
 L -^%ZTSCH("LINK",ZTN)
 Q
 ;
LINK(ZTVOL) ;internal Kernel extrinsic function
 ;input--volume set where task should run
 ;output--UCI,volume set where record must be created
 ;after call check 1--if value is "", the input or file is bad
 ;after call check 2--if $P(value,",",2) is current volume set then
 ;...no extended reference should be used
 ;
L0 ;was a volume set passed in?
 N ZTN,ZTU,ZTV,ZTVD,ZTVN
 I $G(ZTVOL)'?2.7U Q ""
 ;
L1 ;is this volume set on file?
 S ZTVN=$O(^%ZIS(14.5,"B",ZTVOL,""))
 I ZTVN="" Q ""
 I $D(^%ZIS(14.5,ZTVN,0))[0 Q ""
 S ZTVD=^%ZIS(14.5,ZTVN,0)
 ;
L2 ;is there a TaskMan Files Volume Set?  if not, skip next section
 S ZTN=$P(ZTVD,"^",7)
 I ZTN="" S ZTV=ZTVOL G L4
 ;
L3 ;if there is a separate TaskMan Files Volume Set, is it on file?
 I $D(^%ZIS(14.5,ZTN,0))[0 Q ""
 S ZTVD=^%ZIS(14.5,ZTN,0)
 S ZTV=$P(ZTVD,"^")
 I ZTV="" Q ""
 ;
L4 ;if there is a TaskMan Files UCI, return UCI,volume set
 S ZTU=$P(ZTVD,"^",6)
 I ZTU="" Q ""
 Q ZTU_","_ZTV
 ;
 ;
INHIBIT(Y) ;Set/Clear the Inhibit logon field
 I Y=1 S $P(^%ZIS(14.5,%ZTVSN,0),U,2)="S",^%ZIS(14.5,"LOGON",%ZTVOL)=1 Q
 I Y=0 S $P(^%ZIS(14.5,%ZTVSN,0),U,2)="N" K ^%ZIS(14.5,"LOGON",%ZTVOL) Q
 Q
