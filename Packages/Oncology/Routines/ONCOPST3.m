ONCOPST3 ;HIRMFO/RTK-DATA CONVERSION CONTINUED ;2/7/96
 ;;2.11;ONCOLOGY;**1**;Feb 07, 1996
 ;
 ;Routine to add any new entries from ONCOLOGY CONTACT file to new
 ;ACOS NUMBER file.  Any entries with a "#" in COMMENTS field will
 ;be added to the ACOS NUMBER file.
 ;
 K TMP S NEWIEN=0
 S FIEN=$O(^ONCO(160.19,"B",999000,"")) I FIEN="" S NEWIEN=999000
 I FIEN'="" S D=998999 F X=0:0 S D=$O(^ONCO(160.19,"B",D)) Q:D=999999  S TMP=D
 I $G(TMP) S NEWIEN=TMP+1 ;if some already there TMP will be last one
 F XCON=0:0 S XCON=$O(^ONCO(165,XCON)) Q:XCON'>""  D
 .S NOTADD=0,NEWNUM=$P($G(^ONCO(165,XCON,0)),"^",4)
 .Q:NEWNUM'="#"
 .D ADDNEW I NOTADD=1 S ^TMP($J,"NOTADD",XCON)="" Q  ; allow new entry into 160.19 FILE^DICN
 .;NEWENTRY = 6 digit # of newly added entry into 160.19. IF NOTADD=0
 .S $P(^ONCO(165,XCON,0),"^",4)="#"_NEWENTRY
 .S NEWIEN=NEWIEN+1
 .Q
 Q
ADDNEW ;
 I NEWIEN'?6N!($E(NEWIEN,1,3)'=999) S NOTADD=1 Q
 S HOSPNAME=$P($G(^ONCO(165,XCON,0)),"^",1)
 K DD,DO S DIC="^ONCO(160.19,",DIC(0)="L",DIC("DR")=".02///^S X=HOSPNAME",X=NEWIEN D FILE^DICN
 I Y=-1 S NOTADD=1 Q
 S NEWENTRY=NEWIEN
 Q
