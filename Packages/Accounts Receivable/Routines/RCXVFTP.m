RCXVFTP ;DAOU/ALA-FTP AR Data Extract Batch Files ;08-SEP-03
        ;;4.5;Accounts Receivable;**201,256**;Mar 20, 1995;Build 6
        ;
        ;**Program Description**
        ;  This code will ftp a batch file
        ;
EN(FILE,DIREC)  ;
        ;  Input Parameter
        ;    FILE = Filename
        ;    DIREC = Directory
        S RCXVPTH=$S($G(DIREC)'="":DIREC,1:RCXVDIR)
        ;
SYS     ;  Get system type
        S RCXVSYS=$$VERSION^%ZOSV(1)
        I RCXVSYS["DSM" S RCXVSYS="VMS",RCXVSYT="DSM"
        I RCXVSYS["MSM" D
        . I RCXVSYS["NT"!(RCXVSYS["PC") S RCXVSYS="MSM",RCXVSYT="MSM" Q
        . E  S RCXVSYS="UNIX",RCXVSYT="MSM"
        I RCXVSYS["Cache" D
        . I RCXVSYS["VMS" S RCXVSYS="VMS",RCXVSYT="CACHE" Q
        . S RCXVSYS="CACHE",RCXVSYT="CACHE"
        ;
        I RCXVSYS="VMS" S RCXVNME=FILE_";1"
        I RCXVSYS'="VMS" S RCXVNME=FILE
        ;
ARC     ;  Directly FTP to the Boston Allocation Resource Center
        I $$GET1^DIQ(342,"1,",20.06,"I")="P" D
        . S RCXVIP="MORPHEUS.ARC.MED.VA.GOV"
        . S RCXVUSR="mccf"
        . S RCXVPAS="1qaz2wsx"
        ;
        I $$GET1^DIQ(342,"1,",20.06,"I")'="P" D
        . S RCXVIP="MORPHEUS.ARC.MED.VA.GOV"
        . S RCXVUSR="cbotest1"
        . S RCXVPAS="1qaz2wsx"
        ;
        I RCXVSYS="VMS" D ^RCXVFTV
        I RCXVSYS'="VMS" D ^RCXVFTC
        ;
        S RCXVARRY(RCXVTXT)="",RCXVARRY(RCXVBAT)="",RCXVARRY(RCXVNME)=""
        S Y=$$DEL^%ZISH(RCXVPTH,$NA(RCXVARRY))
        K RCXVARRY,%ZISHF,%ZISHO,%ZISUB,DIREC,FILE,I,RCXCT,RCXI,RCXOKAY,RCXVBAT
        K RCXVFTP,RCXVHNDL,RCXVIP,RCXVNME,RCXVOUT,RCXVPAS,RCXVPTH,RCXVSCR,XMY
        K RCXVSYS,RCXVSYT,RCXVTXT,RCXVUSR,RCXVVMS,CNT,QER,QFL,RCXMGRP,XMSUB
        K VALMSG,RCXVROOT
        Q
        ;
FCK     ;  Check that file is ready to read
        S QFL=0,CNT=0,QER=0
FQT     I QFL Q
        D OPEN^%ZISH(RCXVHNDL,RCXVPTH,RCXVSCR,"R")
        I POP D  G FQT
        . HANG 5
        . S CNT=CNT+1
        . I CNT>10 S QFL=1,QER=1 D CLOSE^%ZISH(RCXVHNDL)
        S QFL=1 D CLOSE^%ZISH(RCXVHNDL)
        G FQT
        ;
