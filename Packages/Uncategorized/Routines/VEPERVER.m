VEPERVER        ;CJS/QRI ;11/5/07  15:40
        ; VOE Version display, 1.0.0;;;;;Build 13
        ;
DISP    ;
        N ANS,OS,ROOT,FILENAME,SAVEDUZ,DECRYPT,ERROR
        S SAVEDUZ=DUZ,DUZ=.5 K ^TMP($J)
        S ^TMP($J,1,0)="                    WorldVistA EHR /VOE 1.0 uncertified" G NOTDONE ; Remove line when routine is completed
        S FILENAME="VEPERVER_"_$J_".txt"
        ; depending on the OS, we get the directory and decrypt command
        I +^DD("OS")=18 D  ;for Cache' we need to know which OS it's running under
        . S OS=$S($ZV["VMS":"VMS",$ZV["Windows":"NT",$ZV["NT":"NT",$ZV["UNIX":"UNIX",1:"UNK")
        . I OS="NT" S ROOT="C:\TEMP\",DECRYPT="S X=$ZF(-1,""decrypt etc"")" ;What's the DOS command to decrypt?
        . I OS'="NT" S ERROR=1
        ;
        I +^DD("OS")=17 D  ;for GT.M(VAX) ... Is this needed?
        . S ROOT=""
        . S ERROR=1 ;Since we don't have the code for this yet
        ;
        I +^DD("OS")=19 D  ;for GT.M under UNIX
        . S ROOT="/tmp/"
        . S DECRYPT="ZSYstem ""echo Jix4uXDB | gpg --passphrase-fd 0 --output "_ROOT_FILENAME_" --decrypt "_ROOT_FILENAME_".asc"""
        ;
        I $D(ERROR) G EXIT
        ;
        D OPEN^%ZISH("OUTFILE",ROOT,FILENAME_".asc","W")
        I POP G EXIT
        U IO
        S LINE=0 F  S LINE=$O(^XTMP("VEPERVER",LINE,0)) Q:LINE'>0  S TEXT=^(LINE)  W TEXT,!
        D CLOSE^%ZISH("OUTFILE")
        ;
        X @DCRYPT ; invoke the decryption appropriate to the OS
        ; Now, read in the decrypted text
        S Y=$$FTG^%ZISH(ROOT,FILENAME,$NA(^TMP($J,1,0)),2) I 'Y W !,"Error copying to global" G EXIT
        ;
NOTDONE ; and display the text
        W #!!?21,$C(27),"[33m",$C(27),"[31m"
        S LINE=0 F  S LINE=$O(^TMP($J,LINE)) Q:LINE'>0  W !,^TMP($J,LINE,0)
        W !!,$C(27),"[0m",?30,"Press a key to continue" R ANS#1
        G EXIT
        ;
LOADPGP ; Load the PGP MESSAGE into ^XTMP
        S SAVEDUZ=DUZ,DUZ=.5 N ROOT,DIR,FILENAME K ^XTMP("VEPERVER")
        S DIR(0)="F^2:60",DIR("A")="Full path, up to but not including patch names" D ^DIR G:Y="^" EXIT S ROOT=Y
        S DIR(0)="F^2:60",DIR("A")="Enter the file name" D ^DIR G:Y="^" EXIT S FILENAME=Y
        S Y=$$FTG^%ZISH(ROOT,FILENAME,$NA(^XTMP("VEPERVER",1,0)),2) I 'Y W !,"Error copying to global" G EXIT
        S ^XTMP("VEPERVER",0)="3990101^"_DT_"^PGP MESSAGE for WorldVistA EHR certified" ; make it SACC compliant
EXIT    S DUZ=SAVEDUZ K ^TMP($J)
        Q
