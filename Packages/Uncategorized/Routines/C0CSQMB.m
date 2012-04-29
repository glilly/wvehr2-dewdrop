C0CSQMB ; SQMCCR/ELN  - BATCH PROGRAM ;16/11/2010
 ;;0.1;SQM;;Nov 16,2010;Build 40
 ;
EN ;Traverse the DPT global and export CCR xml for each DFN
 ;and write to directory set in ^TMP("C0CCCR","ODIR")=
 ;
 I '$D(DUZ) Q
 S U="^",DT=$$DT^XLFDT
 D DUZ^XUP(DUZ)
 ; Get the output directory and filename prefix from env
 S ^TMP("C0CCCR","ODIR")=$ZTRNLNM("ccrodir")
 S ^TMP("C0CCCR","OFNP")=$ZTRNLNM("ccrofnprefix")
 N ZDFN
 ;F ZDFN=0:0 S ZDFN=$O(^DPT(ZDFN)) Q:'ZDFN!((ZDFN="+1,")!(ZDFN>10))  D
 F ZDFN=0:0 S ZDFN=$O(^DPT(ZDFN)) Q:'ZDFN!(ZDFN="+1,")  D
 . ;I ZDFN<350 S ZDFN=349
 . D XPAT^C0CCCR(ZDFN)
 Q
 ;
