RORUTL11 ;HCIOFO/SG - ACCESS AND SECURITY UTILITIES ; 7/21/03 10:28am
 ;;1.5;CLINICAL CASE REGISTRIES;;Feb 17, 2006
 ;
 Q
 ;
 ;***** REBUILDS THE "ACL" CROSS-REFERENCE (USER ACCESS)
 ;
 ; Return Values:
 ;       <0  Error code
 ;        0  Ok
 ;
RNDXACL() ;
 N DA,DIK,REGIEN,ROOT
 S ROOT=$$ROOT^DILFD(798.1,,1)  K @ROOT@("ACL")
 S REGIEN=0
 F  S REGIEN=$O(@ROOT@(REGIEN))  Q:'REGIEN  D
 . S DIK=$$ROOT^DILFD(798.118,","_REGIEN_","),DIK(1)=".01^ACL"
 . S DA(1)=REGIEN  D ENALL^DIK
 Q 0
 ;
 ;***** CHECKS IF THE RPC CAN BE CALLED BY THE CURRENT USER
 ;
 ; RPCNAME       Name of the RPC
 ;
 ; [REGIEN]      Registry IEN
 ;
 ; [FLAGS]       Flags that control the execution (can be combined):
 ;                 A  Administrator Only
 ;                 I  IRM Only
 ;
 ; Return Values:
 ;       <0  Error code
 ;        0  Ok
 ;       >0  Access denied
 ;
RPCHECK(RPCNAME,REGIEN,FLAGS) ;
 N ACCESS,KEY,RC
 Q:$G(DUZ)'>0 $$ERROR^RORERR(-40,,,,"DUZ")
 S FLAGS=$G(FLAGS),REGIEN=+$G(REGIEN)
 ;---
 S (ACCESS,RC)=0
 D  Q:ACCESS 0
 . I REGIEN  Q:$D(^ROR(798.1,"ACL",DUZ,REGIEN))<10
 . E  Q:$D(^ROR(798.1,"ACL",DUZ))<10
 . I FLAGS["I"  Q:'$D(^XUSEC("ROR VA IRM",DUZ))
 . I FLAGS["A"  S RC=1,KEY=""  D  Q:RC
 . . F  S KEY=$O(^ROR(798.1,"ACL",DUZ,REGIEN,KEY))  Q:KEY=""  D  Q:'RC
 . . . I KEY?1"ROR"1.E  S:KEY["ADMIN" RC=0
 . S ACCESS=1
 ;---
 D ACVIOLTN^RORLOG(X,$G(REGIEN),RPCNAME)
 Q 1
