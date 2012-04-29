IBCNEPY ;DAOU/BHS - IIV PAYER EDIT OPTION ;28-JUN-2002
 ;;2.0;INTEGRATED BILLING;**184**;21-MAR-94
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
 ; Call only from a tag
 Q
 ;
EN ; Main entry point
 ; Input:  n/a
 ; Output: Modifies entries in the Payer File (#365.12)
 ;
 ; Initialize variables
 NEW PYRIEN
 ;
 D CLRSCRN
 F  S PYRIEN=$$PAYER() Q:'PYRIEN  D EDIT(PYRIEN)
 ;
ENX ; EN exit point
 Q
 ;
 ;
CLRSCRN ;
 W @IOF
 W !?35,"Payer Edit"
 W !!?1,"This option allows you to view the data in the Payer file for a particular"
 W !?1,"Payer.  You may only edit local flags.  Most of the fields in the Payer file"
 W !?1,"are not editable.  This data comes into VistA electronically.  If an"
 W !?1,"application has been deactivated, the local flag cannot be edited."
 Q
 ;
 ;
EDIT(IEN) ; Modify Payer application settings
 ; Input:  IEN - key to Payer File (#365.12)
 ; Output: Modifies entries in the Payer File
 ;
 ; Initialize variables
 NEW IBDATA,LN,APPIEN
 ;
 S LN=26
 ; Display non-editable fields:
 ;  Payer Name, VA National ID, CMS National ID, Date/Time Created,
 ;  EDI ID Number - Prof., EDI ID Number - Inst.
 S IBDATA=$G(^IBE(365.12,+IEN,0))
 ;
 D CLRSCRN
 W !!,$$FO^IBCNEUT1("Payer Name: ",LN,"R"),$P(IBDATA,U,1)
 W !,$$FO^IBCNEUT1("VA National ID: ",LN,"R"),$P(IBDATA,U,2)
 W !,$$FO^IBCNEUT1("CMS National ID: ",LN,"R"),$P(IBDATA,U,3)
 W !,$$FO^IBCNEUT1("Inst Electronic Bill ID: ",LN,"R"),$P(IBDATA,U,6)
 W !,$$FO^IBCNEUT1("Prof Electronic Bill ID: ",LN,"R"),$P(IBDATA,U,5)
 W !,$$FO^IBCNEUT1("Date/Time Created: ",LN,"R"),$$FMTE^XLFDT($P(IBDATA,U,4),"5Z")
 ;
 ; Select Payer application - from those set up for Payer ONLY
 S APPIEN=$$PYRAPP(+IEN) I APPIEN D APPEDIT(+IEN,+APPIEN)
 ;
 Q
 ;
APPEDIT(PIEN,AIEN) ; Modify Payer application settings
 ; Input:  PIEN - key to Payer File (#365.12),
 ;         AIEN - key to Payer Application File (#365.13)
 ; Output: Modifies entries in the Payer File
 ;
 ; Initialize variables
 NEW IBNODE,LN,FDA,DR,DA,DTOUT,DIE,DIRUT,DIR,X,Y
 ;
 ; Determine if the application is already defined for the Payer
 S LN=35
 S IBNODE=$G(^IBE(365.12,+PIEN,1,+AIEN,0))
 ;
 I IBNODE="" W !,"Payer Application not found - ERROR!" S DIR(0)="E" D ^DIR K DIR G APPEDX
 ;
 ; Display non-editable fields:
 ;  National Active, Id Requires Subscriber ID, Use SSN for Subscriber ID
 ;  Transmit SSN
 W !,$$FO^IBCNEUT1("Payer Application: ",LN,"R"),$P($G(^IBE(365.13,+$P(IBNODE,U),0)),U)
 W !,$$FO^IBCNEUT1("National Active: ",LN,"R"),$S(+$P(IBNODE,U,2):"Active",1:"Not Active")
 W !,$$FO^IBCNEUT1("Id Requires Subscriber ID: ",LN,"R"),$S(+$P(IBNODE,U,8):"YES",1:"NO")
 W !,$$FO^IBCNEUT1("Use SSN for Subscriber ID: ",LN,"R"),$S(+$P(IBNODE,U,9):"YES",1:"NO")
 W !,$$FO^IBCNEUT1("Transmit SSN: ",LN,"R"),$S(+$P(IBNODE,U,10):"YES",1:"NO")
 W !,$$FO^IBCNEUT1("Future Service Days: ",LN,"R"),$P(IBNODE,U,14)
 W !,$$FO^IBCNEUT1("Past Service Days: ",LN,"R"),$P(IBNODE,U,15)
 ; Display deactivation info only when it exists
 I +$P(IBNODE,U,11) D  G APPEDX
 . W !,$$FO^IBCNEUT1("Deactivated: ",LN,"R"),$S(+$P(IBNODE,U,11):"YES",1:"NO")
 . W !,$$FO^IBCNEUT1("Deactivation Date/Time: ",LN,"R"),$S(+$P(IBNODE,U,12):$$FMTE^XLFDT($P(IBNODE,U,12),"5Z"),1:"")
 . ; Local Active is non-editable if application is deactivated
 . W !,$$FO^IBCNEUT1("Local Active: ",LN,"R"),$S(+$P(IBNODE,U,3):"Active",1:"Not Active")
 ;
 ; Allow user to edit Local Active flag
 ; Also file the user who edited this local flag and the date/time
 S DR=".03                     Local Active;.04////"_$G(DUZ)_";.05////"_$$NOW^XLFDT
 S DIE="^IBE(365.12,"_+PIEN_",1,"
 S DA=+AIEN,DA(1)=+PIEN
 D ^DIE
 ;
APPEDX Q
 ;
PAYER() ; Select Payer - File #365.12
 ; Init vars
 NEW DIC,DTOUT,DUOUT,X,Y
 ;
 W !!!
 S DIC(0)="ABEQ"
 S DIC("A")=$$FO^IBCNEUT1("Payer Name: ",15,"R")
 ; Do not allow editing of '~NO PAYER' entry
 S DIC("S")="I $P(^(0),U,1)'=""~NO PAYER"""
 S DIC="^IBE(365.12,"
 D ^DIC
 I $D(DUOUT)!$D(DTOUT)!(Y<1) S Y=""
 ;
 Q $P(Y,U,1)
 ;
PYRAPP(PIEN) ; Select Payer Application - based on values in File #365.121
 ; Init vars
 NEW DIC,DTOUT,DUOUT,X,Y,APPIEN
 ;
 ; If no applications are defined for this Payer, quit with message
 I $O(^IBE(365.12,+PIEN,1,0))="" W !!,"There are no applications associated with this Payer!" S DIR="E" D ^DIR K DIR Q ""
 ;
 W !
 ; If applications are defined for this Payer, allow user to select
 S DIC(0)="ABEQ"
 S DIC("A")=$$FO^IBCNEUT1("Payer Application: ",35,"R")
 S DIC="^IBE(365.12,"_+PIEN_",1,"
 ;
 ; if only one application defined, then default that one
 I $P($G(^IBE(365.12,+PIEN,1,0)),U,4)=1 D
 . S APPIEN=$O(^IBE(365.12,+PIEN,1,0)) Q:'APPIEN
 . S APPIEN=$P($G(^IBE(365.12,+PIEN,1,APPIEN,0)),U,1) Q:'APPIEN
 . S DIC("B")=$P($G(^IBE(365.13,APPIEN,0)),U,1)
 . Q
 D ^DIC
 I $D(DTOUT)!$D(DUOUT)!(Y<1) S Y=""
 ;
 Q $P(Y,U,1)
 ;
