ZSTU ; Cache calls this routine at startup to perform these tasks automatically ; 2/22/05 2:33pm
 ;
 S $ZT="ERR"
 ; Copy the set and job commands for each namespace
 S NSP="EHR"
 ; Start TaskMan
 J ^ZTMB:NSP
 ; Start MailMan
 J ^XMRONT:NSP
 ; Start Broker (modify port as needed)
 J STRTALL^XWBTCP
 ; This command only needs to be done once
 ;D 0CDS587
 ;U $P W !!
 Q
ERR ; Error Trap
 U $P W !,$ZE,!
 Q
 ;
