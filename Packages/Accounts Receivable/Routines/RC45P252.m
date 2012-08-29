RC45P252        ;ALB/CLT - PATCH PRCA*4.5*252 POST INIT ROUTINE ;13-JUN-2008
        ;;4.5;Accounts Receivable;**252**;Mar 20, 1995;Build 63
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        ;
        ; Review all entries in file 344.4 looking for any IDENTITY TYPE QUALIFIER fields
        ; that contain a zero (0).  If the field is equal to 0, change it to NULL
        ; 
        Q
        ;
EN      ;
        D MESSAGE("Queuing PRCA*4.5*252 POST-INSTALL process")
        N %DT,X,Y,ZTDESC,ZTSAVE,ZTIO,ZTDTH,ZTRTN
        S X="N",%DT="ST"
        D ^%DT
        S ZTDTH=Y
        S ZTIO=""
        S ZTDESC="PRCA*4.5*252 POST INSTALL PROCESS"
        S ZTSAVE("DUZ")=""
        S ZTRTN="EN1^RC45P252"
        D ^%ZTLOAD
        Q
        ;
EN1     ;PRIMARY ENTRY POINT
        N RCDPX,RCDPY,RCDPZ1,RCDPZ2,RCDPZ3,RCDPMSG1,RCDPMSG2,RCDPMSG3  ;variables used in the search
        S (RCDPX,RCDPZ1,RCDPZ2,RCDPZ3)=0  ;Initial value setup
        F  S RCDPX=$O(^RCY(344.4,RCDPX)) Q:'+RCDPX  S RCDPZ1=RCDPZ1+1 S RCDPY=0 D
        . F  S RCDPY=$O(^RCY(344.4,RCDPX,1,RCDPY))  Q:'+RCDPY  S RCDPZ2=RCDPZ2+1 D:$D(^RCY(344.4,RCDPX,1,RCDPY,3))
        . .  I $P(^RCY(344.4,RCDPX,1,RCDPY,3),U,3)=0 S $P(^RCY(344.4,RCDPX,1,RCDPY,3),U,3)="" S RCDPZ3=RCDPZ3+1
        S RCDPMSG1=RCDPZ1_" ERA records have been reviewed"
        S RCDPMSG2=RCDPZ2_" ERA details have been reviewed"
        S RCDPMSG3=RCDPZ3_" ERA details have been corrected"
        D SNDMAIL("PRCA*4.5*252 installation has been completed",RCDPMSG1,RCDPMSG2,RCDPMSG3)
        Q
        ;
        ; RCDPMSG - message text
MESSAGE(RCDPMSG)        ;
        D BMES^XPDUTL(RCDPMSG)
        Q
        ; Send mail to the user
SNDMAIL(RCDPSUBJ,RCDPM1,RCDPM2,RCDPM3)  ;
        N DIFROM
        N RCDPARR,XMDUZ,XMSUB,XMTEXT,XMY,RCDPUSR,XMZ,XMMG
        S RCDPARR(1)=""
        S RCDPARR(2)=RCDPM1
        S RCDPARR(3)=RCDPM2
        S RCDPARR(4)=RCDPM3
        S RCDPARR(5)=""
        S XMSUB=RCDPSUBJ
        S XMDUZ="ACCOUNTS RECEIVABLE - PRCA*4.5*252 POST INSTALL"
        S XMTEXT="RCDPARR("
        S RCDPUSR=$S($G(DUZ)']"":.5,1:DUZ)
        S XMY(RCDPUSR)=""
        D ^XMD
        Q
