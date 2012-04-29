BPSSCRRV        ;BHAM ISC/SS - ECME SCREEN REVERSE CLAIM ;11:12 AM  28 May 2009
        ;;1.0;E CLAIMS MGMT ENGINE;**1,5,6**;JUN 2004;Build 13;WorldVistA 30-Jan-08
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        ;
        ;Modified from FOIA VISTA,
        ;Copyright 2008 WorldVistA.  Licensed under the terms of the GNU
        ;General Public License See attached copy of the License.
        ;
        ;This program is free software; you can redistribute it and/or modify
        ;it under the terms of the GNU General Public License as published by
        ;the Free Software Foundation; either version 2 of the License, or
        ;(at your option) any later version.
        ;
        ;This program is distributed in the hope that it will be useful,
        ;but WITHOUT ANY WARRANTY; without even the implied warranty of
        ;MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
        ;GNU General Public License for more details.
        ;
        ;You should have received a copy of the GNU General Public License along
        ;with this program; if not, write to the Free Software Foundation, Inc.,
        ;51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
        ;
        Q
        ;IA 4702
        ;
REV     ;entry point for "Reverse" menu item
        N BPRET,BPSARR59
        I '$D(@(VALMAR)) Q
        D FULL^VALM1
        W !,"Enter the line numbers for the Payable claim(s) to be Reversed."
        S BPRET=$$ASKLINES^BPSSCRU4("Select item(s)","C",.BPSARR59,VALMAR)
        I BPRET="^" S VALMBCK="R" Q
        ;reverse selected lines
        ;update the content of the screen and display it
        ;only if at least one reversal was submitted successfully
        I $$RVLINES(.BPSARR59)>0 D REDRAW^BPSSCRUD("Updating screen for reversed claims...")
        E  S VALMBCK="R"
        Q
        ;/**
        ;Reverse selected lines
        ;input:
        ; BP59ARR(BP59)="line# in LM array "
        ;output:
        ; REVTOTAL - total number of claims for whose the reversal was submitted sucessfully
RVLINES(BP59ARR)        ;*/
        N BP59,REVTOTAL,BPRVREAS,BPDFN,BPQ
        N BPIFANY S BPIFANY=0
        N BPSTATS
        S REVTOTAL=0,BPQ=""
        S BP59="" F  S BP59=$O(BP59ARR(BP59)) Q:BP59=""  D  Q:BPQ="^"
        . I BPIFANY=0 W @IOF
        . S BPIFANY=1,BPQ=""
        . ;can't reverse Tricare claims
        . I $P($G(^BPST(BP59,9)),U,4)="T"  D  S BPQ=$$PAUSE() Q
        . . W !,"The claim: ",!,$G(@VALMAR@(+$G(BP59ARR(BP59)),0)),!,"is Tricare claim and cannot be Reversed."
        . S BPDFN=+$P($G(^BPST(BP59,0)),U,6)
        . S BPSTATS=$P($$CLAIMST^BPSSCRU3(BP59),U)
        . I BPSTATS'["E DUPLICATE",BPSTATS'["E REVERSAL REJECTED",BPSTATS'["E REVERSAL STRANDED",BPSTATS'["E PAYABLE" D  S BPQ=$$PAUSE() Q
        . . W !,"The claim: ",!,$G(@VALMAR@(+$G(BP59ARR(BP59)),0)),!,"is NOT Payable and cannot be Reversed."
        . ;
        . W !,"You've chosen to REVERSE the following prescription for "_$E($$PATNAME^BPSSCRU2(BPDFN),1,13)
        . W !,$G(@VALMAR@(+$G(BP59ARR(BP59)),0))
        . ; Begin WV EHR Change ;WVNEA*1.0*1 ;05/28/2009
        . ;F  S BPRVREAS=$$COMMENT^BPSSCRCL("Enter REQUIRED REVERSAL REASON",60) Q:BPRVREAS="^"  Q:($L(BPRVREAS)>0)&&(BPRVREAS'="^")&&('(BPRVREAS?1" "." "))  D
        . F  S BPRVREAS=$$COMMENT^BPSSCRCL("Enter REQUIRED REVERSAL REASON",60)  Q:BPRVREAS="^"  Q:($L(BPRVREAS)>0)&(BPRVREAS'="^")&('(BPRVREAS?1" "." "))  D
        . . ;End WV EHR Change
        . . W !,"Please provide the reason or enter ^ to abandon the reversal."
        . I BPRVREAS["^" W !,"The claim: ",!,$G(@VALMAR@(+$G(BP59ARR(BP59)),0)),!,"was NOT reversed!" S BPQ=$$PAUSE() Q
        . S BPQ=$$YESNO^BPSSCRRS("Are you sure?(Y/N)")
        . I BPQ=-1 S BPQ="^" Q
        . I BPQ'=1 Q
        . I $$REVERSIT(BP59,BPRVREAS)=0 S REVTOTAL=REVTOTAL+1
        W:BPIFANY=0 !,"No eligible items selected."
        W !,REVTOTAL," claim reversal",$S(REVTOTAL'=1:"s",1:"")," in progress.",!
        D PAUSE^VALM1
        Q REVTOTAL
        ;
        ;
        ;the similar to REVERSE
        ;with some information displayed for the user
        ;Input:
        ; BP59 ptr in file #9002313.59
        ; BPRVREAS - reversal reason (free text)
        ;Output:
        ;-1 Claim is not Payable
        ;-2 no reversal, it's unreversable
        ;-3 paper claim
        ;>0 - IEN of reversal claim if electronic claim submitted for
        ;   reversal.
REVERSIT(BP59,BPRVREAS) ;
        N BPRET
        N BPRX
        N BPRXRF
        S BPRXRF=$$RXREF^BPSSCRU2(BP59)
        S BPRET=+$$REVERSE(BP59,BPRVREAS,+BPRXRF,+$P(BPRXRF,U,2))
        S BPRX=$$RXNUM^BPSSCRU2(+BPRXRF)
        Q BPRET
        ;
        ;
        ;/**
        ;Reverse the claim
        ;Input:
        ; BP59 ptr in file #9002313.59
        ; BPRVREAS - reversal reason (free text)
        ; BPRX - RX ien (#52)
        ; BPFIL - refill number
        ;Output:
        ; code^message
        ; where
        ; code :
        ;  from $$EN^BPSNCPDP
        ;  0 Prescription/Fill successfully submitted to ECME for claims processing
        ;  1 ECME did not submit prescription/fill
        ;  2 IB says prescription/fill is not ECME billable or the data returned from IB is not valid
        ;  3 ECME closed the claim but did not submit it to the payer
        ;  4 Unable to queue the ECME claim
        ;  5 Invalid input
        ;  and additional
        ;  12 Claim has been deleted in Pharmacy.
        ; message - whatever $$EN^BPSNCPDP returns
        ; for 12 - "Claim has been deleted in Pharmacy."
        ;
REVERSE(BP59,BPRVREAS,BPRX,BPFIL)       ;*/
        N BPDOS S BPDOS=$$DOSDATE^BPSSCRRS(BPRX,BPFIL)
        N BPNDC S BPNDC=$$NDC^BPSSCRU2(BPRX,BPFIL)
        N BPRET
        I $$RXDEL^BPSOS(BPRX,BPFIL) D  Q 12_U_"Claim has been deleted in Pharmacy."
        . W !,"The claim cannot be reversed since it has been deleted in Pharmacy."
        S BPRET=$$EN^BPSNCPDP(BPRX,BPFIL,BPDOS,"EREV",BPNDC,BPRVREAS)
        ;print return value message
        W !!
        W:+BPRET>0 "Not Processed:",!,"  "
        W $P(BPRET,U,2)
        ;0 Prescription/Fill successfully submitted to ECME for claims processing
        ;1 ECME did not submit prescription/fill
        ;2 IB says prescription/fill is not ECME billable or the data returned from IB is not valid
        ;3 ECME closed the claim but did not submit it to the payer
        ;4 Unable to queue the ECME claim
        ;5 Invalid input
        I +BPRET=0 D ECMEACT^PSOBPSU1(+BPRX,+BPFIL,"Claim reversal sent to 3rd party payer: ECME USER's SCREEN")
        Q BPRET
        ;
PAUSE() ;
        N X
        W ! S DIR(0)="E" D ^DIR K DIR W !
        Q X
        ;
