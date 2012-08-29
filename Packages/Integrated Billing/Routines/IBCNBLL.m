IBCNBLL ;ALB/ARH - Ins Buffer: LM main screen, list buffer entries ;1 Jun 97
 ;;2.0;INTEGRATED BILLING;**82,149,153,183,184,271,345**;21-MAR-94;Build 28
 ;;Per VHA Directive 2004-038, this routine should not be modified.
 ;
EN ; - main entry point for screen
 D EN^VALM("IBCNB INSURANCE BUFFER LIST")
 Q
 ;
HDR ;  header code for list manager display
 S VALMHDR(1)="Buffer File entries not yet processed."
 S VALMHDR(1)=VALMHDR(1)_"   (sorted by "_$P(IBCNSORT,U,2)
 I $P(IBCNSORT,U,3)="" S VALMHDR(1)=VALMHDR(1)_")"
 E  S VALMHDR(1)=VALMHDR(1)_", """_$P(IBCNSORT,U,3)_""" first)"
 Q
 ;
INIT ;  initialization for list manager list
 K ^TMP("IBCNBLL",$J),^TMP("IBCNBLLX",$J),^TMP("IBCNBLLY",$J),^TMP($J,"IBCNBLLS")
 I '$G(IBCNSORT) S IBCNSORT="1^Patient Name"
 D BLD
 Q
 ;
HELP ;  list manager help
 D FULL^VALM1
 W @IOF
 W !,"This screen lists all Insurance plans and policies in the Insurance Buffer",!,"that have not yet been processed (accepted or rejected).",!
 W !,"Flags displayed on screen if they apply to the Buffer entry:",!,"   i - Patient has other currently effective Insurance",!,"   I - Patient is currently admitted as an Inpatient"
 W !,"   E - Patient has Expired",!,"   Y - Means Test Copay Patient",!,"   H - Patient has Bills On Hold",!,"   * - Buffer entry Verified by User"
 ;
 ; ESG - 6/7/02 - SDD 5.1.9
 ; Help screen description of new symbols
 ;
 D PAUSE^VALM1
 W !!,"IIV Electronic Insurance Verification Status"
 W !,"  The following IIV Status indicators may appear to the left of the"
 W !,"  patient name:"
 W !,"   + - The IIV payer indicated that this is an active policy via"
 W !,"           electronic inquiry/response."
 W !,"   ? - IIV inquiry was sent; awaiting reply from Payer."
 W !,"   # - IIV received an electronic response from the Payer, but was not able to"
 W !,"           determine whether or not the Payer is indicating active coverage.  "
 W !,"           Carefully review the associated IIV Response Report, specifically "
 W !,"           focusing on the Eligibility/Benefits section, if present."
 W !,"           Manual confirmation is required."
 W !,"   ! - IIV was unable to send an electronic inquiry for this insurance "
 W !,"           information. User correction may be required to allow IIV to send "
 W !,"           this inquiry."
 W !,"           Please use the Expand Entry option to see more information."
 W !,"   - - The IIV payer indicated that this is NOT an active policy via "
 W !,"           electronic inquiry/response."
 D PAUSE^VALM1
 W !!,"When an entry is Processed it is either:"
 W !,?3,"Accepted - the Buffer entry's data is stored in the main Insurance files.",!,?12,"- the modified Insurance entry is flagged as Verified.",!,?3,"Rejected - the Buffer entry's data is not stored in the main Insurance files."
 W !!,"Once an entry is processed (either accepted or rejected) most of the data in ",!,"the Buffer File entry is deleted leaving only a stub entry for tracking ",!,"and reporting purposes."
 W !!,"The IB INSURANCE SUPERVISOR key is required to either Accept or Reject an entry."
 D PAUSE^VALM1 S VALMBCK="R"
 Q
 ;
EXIT ;  exit list manager option and clean up
 K ^TMP("IBCNBLL",$J),^TMP("IBCNBLLX",$J),^TMP("IBCNBLLY",$J),^TMP($J,"IBCNBLLS"),IBCNSORT,IBCNSCRN,DFN,IBINSDA,IBFASTXT,IBBUFDA
 D CLEAR^VALM1
 Q
 ;
BLD ;  build screen display
 N IBCNT,IBCNS1,IBCNS2,IBBUFDA,IBLINE
 ;
 D SORT S IBCNT=0,VALMCNT=0,IBBUFDA=0
 ;
 S IBCNS1="" F  S IBCNS1=$O(^TMP($J,"IBCNBLLS",IBCNS1)) Q:IBCNS1=""  D
 . S IBCNS2="" F  S IBCNS2=$O(^TMP($J,"IBCNBLLS",IBCNS1,IBCNS2)) Q:IBCNS2=""  D
 ..  S IBBUFDA=0 F  S IBBUFDA=$O(^TMP($J,"IBCNBLLS",IBCNS1,IBCNS2,IBBUFDA)) Q:'IBBUFDA  D
 ...  ;
 ...  S IBCNT=IBCNT+1 I '$D(ZTQUEUED),'(IBCNT#15) W "."
 ...  S IBLINE=$$BLDLN(IBBUFDA,IBCNT)
 ...  D SET(IBLINE,IBCNT)
 ;
 I VALMCNT=0 D SET("",0),SET("There are no Buffer entries that have not been processed.",0)
 Q
 ;
BLDLN(IBBUFDA,IBCNT) ; build line to display on List screen for one Buffer entry
 N DFN,IB0,IB20,IB60,IBLINE,IBY,VAIN,VADM,VA,VAERR,X,Y,IBMTS S IBLINE="",IBBUFDA=+$G(IBBUFDA)
 S IB0=$G(^IBA(355.33,IBBUFDA,0)),IB20=$G(^IBA(355.33,IBBUFDA,20)),IB60=$G(^IBA(355.33,IBBUFDA,60))
 S DFN=+IB60 I +DFN D DEM^VADPT,INP^VADPT
 ;
 S IBY=$G(IBCNT),IBLINE=$$SETSTR^VALM1(IBY,"",1,4)
 ;
 ; ESG - 6/6/02 - SDD 5.1.8
 ; pull the symbol from the symbol function
 ;
 S IBY=$$SYMBOL(IBBUFDA)
 S IBY=IBY_$P($G(^DPT(+DFN,0)),U,1),IBLINE=$$SETSTR^VALM1(IBY,IBLINE,5,16)
 S IBY=$G(VA("BID")),IBLINE=$$SETSTR^VALM1(IBY,IBLINE,23,4)
 S IBY=$P(IB20,U,1),IBLINE=$$SETSTR^VALM1(IBY,IBLINE,29,17)
 S IBY=$P(IB60,U,4),IBLINE=$$SETSTR^VALM1(IBY,IBLINE,48,10)
 S IBY=$$GET1^DIQ(355.12,$P(IB0,U,3),.03),IBLINE=$$SETSTR^VALM1(IBY,IBLINE,60,5)
 S IBY=$$DATE(+IB0),IBLINE=$$SETSTR^VALM1(IBY,IBLINE,66,8)
 S IBY="" D  S IBLINE=$$SETSTR^VALM1(IBY,IBLINE,76,5)
 . S IBY=IBY_$S(+$$INSURED^IBCNS1(DFN,DT):"i",1:" ")
 . S IBY=IBY_$S(+$G(VAIN(1)):"I",1:" ")
 . S IBY=IBY_$S(+$G(VADM(6)):"E",1:" ")
 . S IBMTS=$P($$LST^DGMTU(DFN),U,4)
 . S IBY=IBY_$S(IBMTS="C":"Y",IBMTS="G":"Y",1:" ")
 . S IBY=IBY_$S(+$$HOLD(DFN):"H",1:" ")
 Q IBLINE
 ;
SET(LINE,CNT) ;  set up list manager screen display array
 S VALMCNT=VALMCNT+1
 S ^TMP("IBCNBLL",$J,VALMCNT,0)=LINE Q:'CNT
 S ^TMP("IBCNBLL",$J,"IDX",VALMCNT,+CNT)=""
 S ^TMP("IBCNBLLX",$J,CNT)=VALMCNT_U_IBBUFDA
 S ^TMP("IBCNBLLY",$J,IBBUFDA)=VALMCNT_U_+CNT
 Q
 ;
SORT ;  set up sort for list screen
 ;  1^PATIENT NAME, 2^INS NAME, 3^SOURCE OF INFO, 4^DATE ENTERED, 5^INPATIENT (Y/N), 6^MEANS TEST (Y/N), 7^ON HOLD, 8^VERIFIED, 9^IIV STATUS
 N IBCNDT,IBBUFDA,IBCNDFN,IBCNPAT,IBCSORT1,IBCSORT2,DFN,VAIN,VA,VAERR,IBX,IBCNT,X,Y S IBCNT=0
 ;
 K ^TMP($J,"IBCNBLLS") I '$G(IBCNSORT) S IBCNSORT="1^Patient Name"
 ;
 S IBCNDT=0 F  S IBCNDT=$O(^IBA(355.33,"AEST","E",IBCNDT)) Q:'IBCNDT  D
 .  S IBBUFDA=0 F  S IBBUFDA=$O(^IBA(355.33,"AEST","E",IBCNDT,IBBUFDA)) Q:'IBBUFDA  D
 ..   S IBCNT=IBCNT+1 I '$D(ZTQUEUED),'(IBCNT#15) W "."
 ..   ;
 ..   S IBCNDFN=+$G(^IBA(355.33,IBBUFDA,60)),IBCNPAT="" I +IBCNDFN S IBCNPAT=$P($G(^DPT(IBCNDFN,0)),U,1)
 ..   ;
 ..   I +IBCNSORT=1 S IBCSORT1=IBCNPAT
 ..   I +IBCNSORT=2 S IBCSORT1=$P($G(^IBA(355.33,IBBUFDA,20)),U,1)
 ..   I +IBCNSORT=3 S IBCSORT1=$P($G(^IBA(355.33,IBBUFDA,0)),U,3)
 ..   I +IBCNSORT=4 S IBCSORT1=$P(+$G(^IBA(355.33,IBBUFDA,0)),".",1)
 ..   I +IBCNSORT=5 I +IBCNDFN S DFN=+IBCNDFN D INP^VADPT S IBCSORT1=$S($G(VAIN(1)):1,1:2)
 ..   I +IBCNSORT=6 I +IBCNDFN S IBX=$P($$LST^DGMTU(IBCNDFN),U,4) S IBCSORT1=$S(IBX="C":1,IBX="G":1,1:2)
 ..   I +IBCNSORT=7 I +IBCNDFN S IBX=$$HOLD(IBCNDFN) S IBCSORT1=$S(+IBX:1,1:2)
 ..   I +IBCNSORT=8 S IBCSORT1=$S(+$P($G(^IBA(355.33,IBBUFDA,0)),U,10):1,1:2)
 ..   ; Sort by symbol and then within the symbol, sort by date entered
 ..   ; Build a numerical subscript with format ##.FM date
 ..   I +IBCNSORT=9 S IBCSORT1=$G(IBCNSORT(1,$$SYMBOL(IBBUFDA)))_"."_$P(+$G(^IBA(355.33,IBBUFDA,0)),".",1),IBCSORT1=+IBCSORT1
 ..   ;
 ..   S IBCSORT1=$S($G(IBCSORT1)="":"~UNKNOWN",1:IBCSORT1),IBCSORT2=$S(IBCNPAT="":"~UNKNOWN",1:IBCNPAT)
 ..   ;
 ..   S ^TMP($J,"IBCNBLLS",IBCSORT1,IBCSORT2,IBBUFDA)="" K VAIN,IBCSORT1
 I IBCNT,'$D(ZTQUEUED) W "|"
 Q
 ;
DATE(X) ;
 Q $E(X,4,5)_"/"_$E(X,6,7)_"/"_$E(X,2,3)
HOLD(DFN) ; returns true if patient has bills On Hold
 Q $D(^IB("AH",+$G(DFN)))
 ;
SYMBOL(IBBUFDA) ; Returns the symbol for this buffer entry
 NEW IB0,SYM
 S IB0=$G(^IBA(355.33,IBBUFDA,0)),SYM=""
 I +$P(IB0,U,12) S SYM=$C($P($G(^IBE(365.15,+$P(IB0,U,12),0)),U,2))
 ; If the entry has been manually verified, override the symbol displayed
 I $P(IB0,U,10)'="",'+$P(IB0,U,12) S SYM="*"
 I SYM="" S SYM=" "
 Q SYM
 ;
 ;
UPDLN(IBBUFDA,ACTION) ; *** called by any action that modifies a buffer entry, so list screen can be updated if screen not recompiled
 ; modifies a single line in the display array for a buffer entry that has been modified in some way
 ; ACTION = REJECTED, ACCEPTED, EDITED
 N IBARRN,IBOLD,IBNEW,IBO,IBN S IBO="0123456789",IBN="----------"
 ;
 S IBARRN=$G(^TMP("IBCNBLLY",$J,+$G(IBBUFDA))) Q:'IBARRN
 S IBOLD=$G(^TMP("IBCNBLL",$J,+IBARRN,0)) Q:IBOLD=""
 ;
 ; if action is REJECTED or ACCEPTED then the patient name is replaced by the Action in the display array
 ; and the buffer entry is removed from the list of entries that can be selected
 I (ACTION="REJECTED")!(ACTION="ACCEPTED") D
 . S IBNEW=$TR($E(IBOLD,1,5),IBO,IBN)_ACTION_$J("",7)_$E(IBOLD,21,999)
 . S ^TMP("IBCNBLL",$J,+IBARRN,0)=IBNEW
 ;
 ; if the action is EDITED then the line for the buffer entry is recomplied and the updated line is set into 
 ; the display array
 I ACTION="EDITED" D
 . S IBNEW=$$BLDLN(IBBUFDA,+$P(IBARRN,U,2))
 . S ^TMP("IBCNBLL",$J,+IBARRN,0)=IBNEW
 Q
