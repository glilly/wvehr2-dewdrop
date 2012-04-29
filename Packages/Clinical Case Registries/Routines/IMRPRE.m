IMRPRE ;HCIOFO/NCA,FT-ICR Pre-Init V2.1 ;9/3/97  15:55
 ;;2.1;IMMUNOLOGY CASE REGISTRY;;Feb 09, 1998
 Q:+$$VERSION^XPDUTL("IMR")'>0  ;quit if virgin install
 Q:$D(^IMR(158.8))  ;quit if pre-init has been run
 D EN1,EN2
 Q
EN1 ; make file 158 data global FileMan compatible
 D BMES^XPDUTL("Fixing ICR ACCESS VIOLATION file (158.8) data subscripts...")
 S %X="^IMR(""SEC"",",%Y="^IMR(158.8," D %XY^%RCR K ^IMR("SEC")
 K %X,%Y,X
 Q
EN2 ; postpone data extract
 D BMES^XPDUTL("Unscheduling IMR REGISTRY DATA option while the installation is running...")
 K IMRAR
 S IMRDA=$O(^DIC(19,"B","IMR REGISTRY DATA",0)) Q:'IMRDA
 D FIND^DIC(19.2,"","2","Q",IMRDA,"","B","","","IMRAR")
 S IMRLOOP=0
 F  S IMRLOOP=$O(IMRAR("DILIST",2,IMRLOOP)) Q:'IMRLOOP  D
 .S IMRIEN=+$G(IMRAR("DILIST",2,IMRLOOP)) Q:'IMRIEN
 .S IMRDATE=$$GET1^DIQ(19.2,IMRIEN,2,"I")
 .S IMRFREQ=$$GET1^DIQ(19.2,IMRIEN,6,"I")
 .Q:IMRDATE<$$NOW^XLFDT  ;quit if queued time is in past
 .Q:IMRFREQ=""  ;quit if no rescheduling frequency
 .S IMRNDATE=$$FMADD^XLFDT(IMRDATE,7) ;add 7 days to schedule date
 .S IMR192(19.2,IMRIEN_",",2)=IMRNDATE
 .D FILE^DIE("K","IMR192","IMRERR")
 .Q
 K IMR192,IMRAR,IMRDA,IMRDATE,IMRFREQ,IMRIEN,IMRLOOP,IMRNDATE,X,Y
 Q
