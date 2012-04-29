PPPEDT21 ;ALB/JFP - EDIT BLANK DOMAIN ROUTINES ; 3/20/92
 ;;V1.0;PHARMACY PRESCRIPTION PRACTICE;**8,19**;APR 7,1995
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
 ; -- This routine displays unresolved domain in FFX file
 ;
DSPFF(SNIFN) ; -- List processor entry point
 ;
 ; This is the main entry point for calling the list manager
 ;
 ; Parameters:
 ;  SNIFN - The inistitution internal entry number
 ;
 N LSTARRAY,IDXARRAY,VALMCNT
 ;
 ;
 K XQORS,VALMEVL
 D EN^VALM("PPP UNRESOLVED DOM")
 Q
 ;
INIT ; -- Collects all the data and builds the display array
 ;
 N PPPINST,CNT
 ;
 S LSTARRAY="^TMP(""PPPL4"",$J)"
 S IDXARRAY="^TMP(""PPPIDX"",$J)"
 ;
 K @LSTARRAY,@IDXARRAY,DOMAIN
 ;
 S (VALMCNT,CNT)=0
 I '$D(^PPP(1020.2,"ARPOV",+SNIFN)) D NUL Q
 F PATDFN=0:0 D  Q:(PATDFN="")
 .S PATDFN=$O(^PPP(1020.2,"ARPOV",+SNIFN,PATDFN)) Q:PATDFN=""
 .S PATNAME=$$GETPATNM^PPPGET1(PATDFN)
 .S FFXIFN=$O(^PPP(1020.2,"ARPOV",+SNIFN,PATDFN,"")) Q:FFXIFN=""
 .S DOMAIN=$P($G(^PPP(1020.2,FFXIFN,1)),"^",5)
 .S DOMAIN=$S($G(DOMAIN)="":"Unknown",1:DOMAIN)
 .S LNUM=0 I DOMAIN]"" S LNUM=$O(^PPP(1020.128,"A",DOMAIN,0))
 .I LNUM S DOMAIN=$P(^PPP(1020.128,LNUM,0),"^",2) ;New Domain
 .S PPPINST=$S($D(DOMAIN):$P(DOMAIN,".",1),1:$P($P($G(^PPP(1020.2,FFXIFN,0)),"^",2),".",1))
 .D SETD
 Q
 ;
HDR ; -- Builds Header
 ;
 N SP25
 S SP25="                         "
 S VALMHDR(1)=""
 S VALMHDR(2)="Institution: "_$E($P(SNIFN,"^",2)_SP25,1,25)_" Default Domain: "_$P($G(^PPP(1020.8,+SNIFN,0)),"^",2)
 Q
 ;
NUL ; -- Sets null message
 ;
 S @LSTARRAY@(1,0)=""
 S @LSTARRAY@(2,0)=" There are no entries for "_$P(SNIFN,"^",2)
 S @LSTARRAY@(3,0)=""
 S @LSTARRAY@(4,0)=" Press <RETURN> to continue"
 S VALMCNT=4
 Q
FNL ; -- Clean up
 ;
 K @LSTARRAY,@IDXARRAY
 K SNIFN
 Q
 ;
SETD ; -- Sets up display for line for list processor
 S TXTLINE=" "
 S CNT=CNT+1
 S TXTLINE=$$SETFLD^VALM1(" "_CNT,TXTLINE,"ENTRY")
 S TXTLINE=$$SETFLD^VALM1(PATNAME,TXTLINE,"PATNAME")
 S TXTLINE=$$SETFLD^VALM1(PPPINST,TXTLINE,"INSTITUTION")
 S TXTLINE=$$SETFLD^VALM1(DOMAIN,TXTLINE,"DOMAIN")
 D SETL
 Q
 ;
SETL ; -- Sets up list manager display array
 S VALMCNT=VALMCNT+1
 S @LSTARRAY@(VALMCNT,0)=$E(TXTLINE,1,79)
 S @LSTARRAY@("IDX",VALMCNT,CNT)=""
 S @IDXARRAY@(CNT)=VALMCNT_"@"_SNIFN_"@"_FFXIFN_"@"_DOMAIN
 Q
 ;
END ; -- End of code
 Q
 ;
