PPPBLD1A ;ALB/DMB - BUILD FFX FROM CDROM - CONTINUED : 3/4/92
 ;;1.0;PHARMACY PRESCRIPTION PRACTICE;**2,26,38,41**;APR 7,1995
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
GETDATA ;
 ;
 S STARTTM=$$NOW^PPPCNV1
 ;VMP OIFO BAY PINES;PPP*1*41  CHANGED F I= TO F PPPI=
 NEW PPPI
 F PPPI=0:0 D  Q:(STATUS)
 .;
 .; 
 .;
CHKTM .;VMP OIFO BAY PINES;ELR;PPP*1*38
 .;REMOVE CHECKING FOR TIMEOUT ON MPD
GETSSN .S SSN=$O(@OUTARRY@("DONE",""))
 .I SSN'="" D
 ..S STARTTM=$$NOW^PPPCNV1
 ..S TSSN=TSSN+1
 ..S FOUND=$G(@OUTARRY@(SSN,"FOUND"))
 ..I FOUND<1 D  Q
 ...I FOUND<0 D
 ....S TMP=$$LOGEVNT^PPPMSC1(MPDERR2,PPPMRT,SSN_"/"_+FOUND)
 ...K @OUTARRY@(SSN)
 ...K @OUTARRY@("DONE",SSN)
 ...D DEL
 ..;
GETDFN ..; Get the DFN for the SSN.  If we can't then we have an invalid SSN.
 ..;
 ..S PATDFN=+$$GETDFN^PPPGET1(SSN)
 ..I PATDFN<1 D  Q
 ...S STARTTM=$$NOW^PPPCNV1
 ...S ERRTXT="Could not find SSN "_SSN_" in Patient File."
 ...S ERRORS=1
 ...S TMP=$$ADD2ERR^PPPBLD2(ERRARY2,ERRTXT)
 ...K @OUTARRY@("DONE",SSN)
 ...K @OUTARRY@(SSN)
 ...D DEL
 ..;
GETSTA ..; Now get the station number.  If its not in the institution file
 ..; then reject it.
 ..;
 ..S STANO=0
 ..F  D  Q:STANO=""
 ...S STANO=$O(@OUTARRY@(SSN,"SITES",STANO)) Q:STANO=""
 ...;
 ...; We need the station IFN to look up the entry in the FFX file.
 ...;
 ...;S SNIFN=$O(^DIC(4,"D",STANO,""))
 ...S SNIFN=STANO
 ...I SNIFN="" D  Q
 ....S SNIFN=$O(^PPP(1020.128,"AC",STANO,0)) I SNIFN]"" Q
 ....S STARTTM=$$NOW^PPPCNV1
 ....S ERRTXT="Could not find station "_STANO_" in Institution File for SSN "_SSN_"."
 ....S ERRORS=1
 ....S TMP=$$ADD2ERR^PPPBLD2(ERRARY2,ERRTXT)
 ...;
FFXIFN ...; Check to see if the entry already exists.  If it does then update
 ...; the last date of visit if necessary.  Else create a new entry.
 ...;
 ...S FFXIFN=$$GETFFIFN^PPPGET1(PATDFN,SNIFN)
 ...S MPDLDOV=$G(@OUTARRY@(SSN,"SITES",STANO))
 ...I FFXIFN>0 D
 ....S FFXLDOV=$P($G(^PPP(1020.2,FFXIFN,0)),"^",3)
 ....I MPDLDOV>FFXLDOV D
 .....S DIE=1020.2
 .....S DA=FFXIFN
 .....S DR="2///"_MPDLDOV
 .....D ^DIE
 ....S TEDTENT=TEDTENT+1
 ...E  D
 ....S X=PATDFN
 ....S DIC="^PPP(1020.2,"
 ....S DIC(0)=""
 ....S DIC("DR")="1////"_SNIFN_";2///"_MPDLDOV_";7///0"
 ....K DD,DO D FILE^DICN
 ....S TNEWENT=TNEWENT+1
 ....I $P(Y,"^",3)'=1 D
 .....S ERRTXT="Could not add "_SSN_"/"_STANO_" to FFX file."
 .....S ERRORS=1
 .....S TMP=$$ADD2ERR^PPPBLD2(ERRARY2,ERRTXT)
 ....;
 ....; Make sure the DOMAIN name got resolved.
 ....;
 ....I $P($G(^PPP(1020.2,+Y,1)),"^",5)="" D
 .....S ERRTXT="Could not resolve DOMAIN for "_SSN_"/"_STANO
 .....S ERRORS=1
 .....S TMP=$$ADD2ERR^PPPBLD2(ERRARY2,ERRTXT)
 ..;
 ..; We're done with that SSN, kill it off and set last SSN processed
 ..;VMP OIFO BAY PINES;ELR;PPP*1*38
 ..D DEL
 ..;
 ..K @OUTARRY@("DONE",SSN)
 ..;PPP*1*26 Dave Blocker - remove setting last SSN
 ..;messes up the build option
 ..K @OUTARRY@(SSN)
 ..;S $P(^PPP(1020.1,1,2),"^",1)=SSN
 ..S STARTTM=$$NOW^PPPCNV1
 .E  D
 ..;
 ..; There was no SSN available.  Check to see if we're done.
 ..; If not then check again.
 ..;
 ..S STATUS=+$G(@OUTARRY@("STATUS"))
 ..I STATUS<0 D
 ...S ERR=MPDSTERR
 ...S TMP=$$LOGEVNT^PPPMSC1(ERR,PPPMRT,"Status = "_$P($G(@OUTARRY@("STATUS")),U,2))
 ..E  H 1
 ;
 ; We're all done.  Check to see if we need to send an error bulletin.
 ;
 I ERRORS D
 .S TMP=$$SNDBLTN^PPPMSC1("PPP FFX BUILD MESSAGES","PRESCRIPTION PRACTICES",ERRARY1)
 ;
 Q
 ;
DEL ;VMP OIFO BAY PINES;ELR;PPP*1*38
 NEW PPPDA S PPPDA=0
 F  S PPPDA=$O(^PPP(1020.7,"B",SSN,PPPDA)) Q:PPPDA=""  D
 .I PPPDA S DA=PPPDA,DIK="^PPP(1020.7," D ^DIK K DIK
 Q
