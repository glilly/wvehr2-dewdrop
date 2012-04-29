PPPPDX2 ;ALB/DMB/DAD - PPP PDX ROUTINES ; 6/30/92
 ;;V1.0;PHARMACY PRESCRIPTION PRACTICE;**8**;APR 7,1995
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
PDXFFX(SSN,STATION) ; Get the FFX IFN or create a new entry for PDX
 ;
 ; This function is called by the PDX trigger to lookup or create
 ; an entry in the foreign facility cross-reference.
 ;
 ; Parameters:
 ;    SSN - The Patient SSN
 ;    STATION - The Station Number the patient visited
 ;
 ; Returns:
 ;    Normal Termination - The Internal File Number of the entry.
 ;    Error - -9002 = could not find SSN in patient file or Station
 ;                    number in institution file.
 ;            -9003 = An error occurred while creating the new entry.
 ;
 N LKUPERR,FMERR,ERR,PATDFN,SNIFN,FFXIFN,X,DIC,Y,DA,HDRNODE
 N TRECS,U,NEWREC
 ;
 S LOCKERR=-9004
 S LKUPERR=-9003
 S FMERR=-9002
 S ERR=0
 S U="^"
 ;
 ; Look up the patient and station IFN.
 ;
 S PATDFN=$O(^DPT("SSN",SSN,""))
 S:PATDFN<1 ERR=LKUPERR
 ;S SNIFN=$O(^DIC(4,"D",STATION,""))
 S SNIFN=STATION
 S:SNIFN<1 ERR=LKUPERR
 ;
 ; If the IFN's are good then see if there is an entry in the FFX file.
 ; First lock the file.  Return LOCKERR if we can't.
 ;
 L +(^PPP(1020.2)):5
 S:'$T ERR=LOCKERR
 ;
 I 'ERR D
 .S FFXIFN=$O(^PPP(1020.2,"APOV",PATDFN,SNIFN,""))
 .;
 .; If the entry isn't there then create a new one
 .;
 .I FFXIFN'>0 D
 ..S X=PATDFN
 ..;
 ..; Get the header node of the file
 ..;
 ..S HDRNODE=$G(^PPP(1020.2,0))
 ..;
 ..; Get the last record and total records values. Quit if NULL
 ..;
 ..S (FFXIFN,DA)=+$P(HDRNODE,U,3)+1
 ..S TRECS=+$P(HDRNODE,U,3)
 ..I +$P(HDRNODE,U,3)="" S ERR=FMERR Q
 ..;
 ..; Add the new record
 ..;
 ..S NEWREC=X
 ..S $P(NEWREC,U,2)=SNIFN
 ..S $P(NEWREC,U,4)=0
 ..S ^PPP(1020.2,FFXIFN,0)=NEWREC
 ..;
 ..; Create the necessary indexes
 ..;
 ..S ^PPP(1020.2,"B",$E(X,1,30),FFXIFN)=""
 ..S X=SNIFN D SDFNPOV^PPPFMX
 ..;
 ..; Update the header node
 ..;
 ..S $P(HDRNODE,U,3)=FFXIFN
 ..S $P(HDRNODE,U,4)=TRECS+1
 ..S ^PPP(1020.2,0)=HDRNODE
 .L -^PPP(1020.2)
 ;
 ; Return the IFN or ERR
 ;
 Q:ERR ERR
 Q FFXIFN
