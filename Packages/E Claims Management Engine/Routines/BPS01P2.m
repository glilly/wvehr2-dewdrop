BPS01P2 ;BHAM ISC/DMB - NPI Drop Dead Date Checking ;04/19/2006
 ;;1.0;E CLAIMS MGMT ENGINE;**2**;JUN 2004;Build 12
 ;
 ; Pre-Install routine for BPS*1.0*2
 ; Fileman calls to SCHEDULE OPTION file (#19.2) are allowed
 ;   by IA3732
 ;
 ; Must call this routine at the EN entry point
 Q
 ;
 ;
EN ; Remove Automated Registration as a scheduled job as
 ; this is now called by the ECME Nightly Background Job
 ; (BPSBCKJ), which is also an ECME scheduled job.
 N DIC,X,Y,DTOUT,DUOUT,DIK,DA
 ;
 ; Get BPS APP REG TASKMAN option
 S DIC=19.2,DIC(0)="BX",X="BPS APP REG TASKMAN"
 D ^DIC
 ;
 ; Quit if it is not found
 I Y=-1 Q
 ;
 ; Cleanup DIC variables and delete the option
 K DIC,X,DTOUT,DUOUT
 S DA=+Y,DIK="^DIC(19.2,"
 D ^DIK
 Q
