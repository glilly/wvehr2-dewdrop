PRCOT07 ;SF/SWS-PREINSTALL *ADD NEW OPTION ;4-26-94/3:45 PM
V       ;;5.1;IFCAP;**113**;Oct 20, 2000;Build 4
        ;Per VHA Directive 2004-038, this routine should not be modified.
        Q
FINDREC N DIC,Y,NREC,MREC,DIE,X
        D BMES^XPDUTL("Adding new option to APPROVING OFFICIAL MENU.")
        S DIC="^DIC(19,",X="PRCH AO CANCEL INCOM PC ORDER"
        D ^DIC
        I Y'=-1  S NREC=+Y
FINDMNU S (DIC,Y)=""
        S DIC="^DIC(19,",X="PRCH APPROVE"
        D ^DIC
        I Y'=-1  S MREC=+Y
UPDMNU  S (DIC,Y)=""
        S (BFLAG,NTHIS)=0
        F  S NTHIS=$O(^DIC(19,MREC,10,NTHIS))  Q:'NTHIS!(BFLAG=1)  D
        . S MYIEN=$G(^DIC(19,MREC,10,NTHIS,0))
        . I MYIEN=NREC  S BFLAG=1
        I BFLAG=0  D
        . S DIC="^DIC(19,"_MREC_",10,",DIC(0)="",DIC("P")="19.01IP"
        . S X=NREC
        . S DA(1)=MREC
        . D FILE^DICN
CLNREC  K BFLAG,NTHIS,MREC,NREC
        Q
