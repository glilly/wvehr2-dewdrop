PPPFMX ;ALB/DMB/DAD - FILEMAN UTILITIES FOR PPP ; 1/10/92
 ;;1.0;PHARMACY PRESCRIPTION PRACTICE;**26,39**;APR 7,1995
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
SDFNPOV ;
 N PPPDFN
 ;S VAQFLAG=1
 S PPPDFN=$P($G(^PPP(1020.2,DA,0)),"^",1)
 Q:PPPDFN=""
 S ^PPP(1020.2,"APOV",PPPDFN,X,DA)=""
 S ^PPP(1020.2,"ARPOV",X,PPPDFN,DA)=""
 Q
 ;
KDFNPOV ;
 N PPPDFN
 S PPPDFN=$P($G(^PPP(1020.2,DA,0)),"^",1)
 Q:PPPDFN=""
 K:$D(^PPP(1020.2,"APOV",PPPDFN,X,DA)) ^PPP(1020.2,"APOV",PPPDFN,X,DA)
 ;VMP OIFO BAY PINES;VGF;PPP*1*39
 ;CORRECTED THE FOLLOWING KILL COMMAND
 K:$D(^PPP(1020.2,"ARPOV",X,PPPDFN,DA)) ^PPP(1020.2,"ARPOV",X,PPPDFN,DA)
 Q
 ;
SDFNDT ;
 N PPPDFN
 S PPPDFN=$P($G(^PPP(1020.2,DA,0)),"^",1)
 Q:PPPDFN=""
 S ^PPP(1020.2,"ADT",PPPDFN,X,DA)=""
 Q
 ;
KDFNDT ;
 N PPPDFN
 S PPPDFN=$P($G(^PPP(1020.2,DA,0)),"^",1)
 Q:PPPDFN=""
 K:$D(^PPP(1020.2,"ADT",PPPDFN,X,DA)) ^PPP(1020.2,"ADT",PPPDFN,X,DA)
 Q
 ;
SNSSN ;
 N PPPNOD0,PPPTR
 N ZTRTN,ZTIO,ZTDTH,ZTDESC,ZTSAVE
 ;
 ; Check that this is either an edit or a new entry to avoid
 ;   setting during a re-index of the Patient file.
 ; PPPOK is defined in the kill logic below if the new entry
 ;   does not equal the old.
 ; DPTDFN is defined in the Patient Registration routines.
 ;
 I ($D(PPPOK))!($D(DPTDFN)) D
 .S PPPNOD0=$G(^PPP(1020.7,0))
 .Q:PPPNOD0=""
 .;
 .; Get the File Descriptor Node for updating.
 .;
 .S PPPTR=$P(PPPNOD0,"^",4)
 .;
 .; Set the entry and the "B" Xref
 .;
 .S ^PPP(1020.7,DA,0)=PPP
 .S ^PPP(1020.7,"B",PPP,DA)=""
 .;
 .; Update the Descriptor node.
 .;
 .S $P(PPPNOD0,"^",3)=DA
 .S $P(PPPNOD0,"^",4)=PPPTR+1
 .S ^PPP(1020.7,0)=PPPNOD0
 .;
 .; Task out the MPD lookup.
 .;PPP*1*26 Dave Blocker : Remove MPD access attempt
 .;because the PPP BATCH job will do the MPD request each night.
 .Q
 Q
 ;
KNSSN ;
 N PPPNOD0
 ;
 ; Check that this is an edit and not a re-index.
 ;
 S X="I PPP'=$P($G(^"_"DPT("_DA_","_"0)),"_"""^"""_",9) S PPPERR=1" X X I $G(PPPERR)=1 K PPPERR D
 .S PPPOK=1
 .;
 .; Check that the node currently exists, kill it if it does.
 .;
 .I $D(^PPP(1020.7,"B",PPP)) D
 ..K:$D(^PPP(1020.7,DA)) ^PPP(1020.7,DA)
 ..K:$D(^PPP(1020.7,"B",PPP,DA)) ^PPP(1020.7,"B",PPP,DA)
 ..;
 ..; If the record count is alredy 0 then quit.
 ..;
 ..S PPPNOD0=^PPP(1020.7,0)
 ..Q:+$P(PPPNOD0,"^",4)=0
 ..S $P(PPPNOD0,"^",4)=$P(PPPNOD0,"^",4)-1
 ..S ^PPP(1020.7,0)=PPPNOD0
 Q
 ;
DOMAIN(IFN) ; Find domain name from institution number to stuff into #1.5.
 ;
 ; Get the station number from the institution file
 ; to resolve domain
 ;
 ;   Input:  IFN  --  Pointer to record in #1020.2
 ;   Output: Domain name in field #1.5
 ;
 ;VMP OIFO BAY PINES;VGF;PPP*1.0*39
 N PPPINST,PPPIEN
 S PPPINST=+$P($G(^PPP(1020.2,IFN,0)),"^",2)
 S PPPIEN=$O(^PPP(1020.8,"B",PPPINST,0))
 Q $$GET1^DIQ(1020.8,PPPIEN_",",.02)
 ;
