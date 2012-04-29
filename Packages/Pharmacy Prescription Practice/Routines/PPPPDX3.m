PPPPDX3 ;ALB/DMB/DAD - ppp pdx routines ; 6/30/92
 ;;1.0;PHARMACY PRESCRIPTION PRACTICE;**1,2,21,32,39**;APR 7,1995
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
PDXFFX(SSN,DOMAIN) ; Get the FFX IFN or create a new entry for PDX
 ;
 ; This function is called by the PDX trigger to lookup or create
 ; an entry in the foreign facility cross-reference.
 ;
 ; Parameters:
 ;    SSN - The Patient SSN
 ;    DOMAIN - The Domain name the patient visited
 ;
 ; Returns:
 ;    Normal Termination - The Internal File Number of the entry.
 ;    Error - -9002 = could not find SSN in patient file or Domain
 ;                    name.
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
 ; -- Check Input
 Q:'$D(DOMAIN) FMERR
 Q:DOMAIN="" FMERR
 Q:'$D(^PPP(1020.8,"C",DOMAIN)) FMERR
 ;
 ; Look up the patient IFN
 ;
 S PATDFN=$O(^DPT("SSN",SSN,""))
 S:PATDFN<1 ERR=LKUPERR
 ;PPP*1*32 (Dave B - Check B & C xref for domain name)
 S SNIFN=$$FIND1^DIC(4.2,"","MX",DOMAIN,"B^C","","EMSG")
 S SNIFN=+$P(^DIC(4.2,SNIFN,0),"^",13)
 ;VMP OIFO BAY PINES;VGF;PPP*1.0*39
 S SNIFN=$O(^DIC(4,"D",SNIFN,0))
 S:SNIFN<1 ERR=LKUPERR
DAVE ;
 ; If the INPUTS are good then see if there is an entry in the FFX file.
 I 'ERR D
 .S FFXIFN=$O(^PPP(1020.2,"AC",PATDFN,DOMAIN,""))
 .;
 .; If the entry isn't there then create a new one
 .;
 .I FFXIFN'>0 D
 ..S X=PATDFN
 ..S DIC="^PPP(1020.2,"
 ..S DLAYGO="1020.2"
 ..S DIC(0)="L"
 ..S DIC("DR")="1////"_SNIFN_";7////0;8////"_$G(DT)
 ..K DD,DO D FILE^DICN K DIC,DLAYGO,DO,DD
 ..;(PPP*1*32 Fix Quit without return value on next line - Dave B)
 ..I $P(Y,U,3)'=1 S ERR=LKUPERR
 Q:ERR ERR
 Q $P(Y,U,1)
