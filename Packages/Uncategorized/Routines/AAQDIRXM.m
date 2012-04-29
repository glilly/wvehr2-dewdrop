AAQDIRXM ;FGO/JHS;Directory Listing via MailMan ; 09-03-98 [2/26/04 11:32am]
 ;;1.0;AAQ LOCAL;;09-03-98;For Kernel V8.0 and OpenM-NT
 I ^%ZOSF("OS")'["OpenM-NT" W $C(7),!,"This routine should be run only on Alpha OpenM-NT systems!  Halting.",! H 1 Q
 I '$D(DTIME) W !,"DTIME is not set.  Calling XUP to set up required variables.",!,"Press RETURN at the Select OPTION NAME: prompt.",!! D ^XUP
 W !!,"This will List Files in a Selected Directory on an Alpha-NT",!,"system, and send the output to you in a MailMan message."
 D UCI^%ZOSV S AAQUCI=Y,AAQX=$$NOW^XLFDT W !!,^DD("SITE"),"   ",AAQUCI,"   ",$$FMTE^XLFDT(AAQX),!!,"The DOWNLOAD Directory for this system will be the default."
 W !!,"The default for this Site and UCI is: "
TST I AAQUCI="TST,ROU" S AAQDISK="Y:\",AAQDIR="DOWNLOAD\" W AAQDISK_AAQDIR G ASKOK
VAH I AAQUCI="VAH,ROU" S AAQDISK="T:\",AAQDIR="TEMP\" W AAQDISK_AAQDIR
ASKOK S %=1 W !,"Is this the correct directory" D YN^DICN G:%=1 INFO I %=0 W !!,"This routine will not work correctly if directory names are wrong." G ASKOK
 S AAQDIR="" W !!,"A null response or '^' for Drive will exit the routine.",!,"A null response is allowed for Directory, '^' will exit."
ASKDISK R !!,"Enter Drive Letter with colon and backslash: ",AAQDISK:60 G:(AAQDISK="^")!(AAQDISK="") KILL I AAQDISK'?1A1":\" W $C(7),!!,"Answer must be one letter, a colon, and backslash." G ASKDISK
ASKDIR R !!,"Enter Directory with trailing backslash: ",AAQDIR:60 G:AAQDIR="^" EXIT G:AAQDIR="" INFO I AAQDIR'?.E1"\" W $C(7),!!,"Answer must include a trailing backslash unless null." G ASKDIR
INFO W !!,"Directory Listing will be sent by MailMan to your IN Basket."
 W !,"An invalid path, or any failure to open the directory log file,",!,"will result in an alert and a message missing the file list.",!
 S (AAQFAIL,ALERT,CNT)=0,DIRLOG=AAQDISK_AAQDIR_"AAQDIR.LOG"
 O DIRLOG:"WA":5 I $T=0 S ALERT=1 D MSG(DIRLOG,ALERT) G EXIT
 U DIRLOG S AAQX=$$NOW^XLFDT W !,^DD("SITE"),"   ",AAQUCI,"   ",$$FMTE^XLFDT(AAQX),!
 S AAQFN="*.*",AAQFILE=$ZSEARCH(AAQDISK_AAQDIR_AAQFN)
 F  Q:AAQFILE=""  D  S AAQFILE=$ZSEARCH("")
 . I AAQFILE=(AAQDISK_AAQDIR_".") Q
 . I AAQFILE=(AAQDISK_AAQDIR_"..") Q
 . U DIRLOG W !,"  ",AAQFILE S CNT=CNT+1
 . Q
 U DIRLOG W !!,"The number of files is: "_CNT
 C DIRLOG
 D MSG(DIRLOG,ALERT)
 I '$D(XMZ) D FAILED
 G EXIT
MSG(DIRLOG,ALERT)  ;
 ; 0 (no alert) or 1 (send alert)
 S $ZT=$G(^%ZOSF("ERRTN"))
 S U="^",AAQTEXT="",AAQLOGOK=1
 I $G(DIRLOG)'="" D
 .O DIRLOG:"R":5
 .I '$T S AAQLOGOK=0
 .I 'AAQLOGOK D
 ..S AAQTEXT(1,0)="Log file: "_DIRLOG_" could not be opened!"
 I $G(DIRLOG)="" D
 .S AAQLOGOK=0
 .S AAQTEXT(1,0)="No AAQDIR.LOG file was created!  Please check"
 .S AAQTEXT(2,0)=" the "_AAQDISK_AAQDIR_" directory to confirm."
 I AAQLOGOK D TEXT
 S AAQNOW=$$NOW^XLFDT,AAQDATE=$$FMTE^XLFDT(AAQNOW)
 S XMDUZ=DUZ,XMSUB=AAQUCI_"  Directory Listing for "_AAQDISK_AAQDIR_"  "_AAQDATE
 S XMY(DUZ)="",XMTEXT="AAQTEXT("
 D ^XMD
 ; Send An Alert
 I $G(ALERT)=1 D
 .S XQA(DUZ)=""
 .S XQAMSG="AAQDIR.LOG Problem - See Directory Listing Message #"_XMZ
 .D SETUP^XQALERT
 .K XQA,XQAMSG
 Q
TEXT S $ZT="ENDLOG"
 S AAQLINE=0
 F  U DIRLOG R X:DTIME S AAQLINE=AAQLINE+1,AAQTEXT(AAQLINE,0)=X
ENDLOG C DIRLOG
 S $ZT=$G(^%ZOSF("ERRTN"))
 Q
FAILED S ALERT=1
 O DIRLOG:"WA":5 I $T=0 D MSG(DIRLOG,ALERT) Q
 U DIRLOG W !!,"Directory Message Failed."
 D MSG(DIRLOG,ALERT) I $T=0 S AAQFAIL=1
 I AAQFAIL=1 U DIRLOG W !!,"AAQDIRXM unable to create Alert."
 C DIRLOG S AAQFAIL=1 ;AAQDIR.LOG is not deleted when Failed
 Q
EXIT G:AAQFAIL=1 KILL S AAQFN="AAQDIR.LOG",AAQFILE=$ZSEARCH(AAQDISK_AAQDIR_AAQFN) G:AAQFILE="" KILL S X=$ZF(-1,"DEL "_AAQFILE)
KILL K %,%Y,AAQDATE,AAQDIR,AAQDISK,AAQFAIL,AAQFILE,AAQFN,AAQLINE,AAQLOGOK,AAQNOW,AAQTEXT,AAQUCI,AAQX,ALERT,CNT,DIRLOG,X,XMDUZ,XMSUB,XMTEXT,XMY,XMZ,Y
 Q
