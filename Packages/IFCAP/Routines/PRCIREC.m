PRCIREC ;WISC/SWS-PRCIREC continued ;9/7/06  14:22
V       ;;5.1;IFCAP;**113**;Oct 20, 2000;Build 4
        ;Per VHA Directive 2004-038, this routine should not be modified.
        ;This routine serves as the input transform for the field Final Charge in File ^PRCH(440.6
        Q
START   S MYIEN=$P($G(^PRCH(440.6,DA,1)),U,1)
        I '$G(MYIEN) Q
        S VALUE2=$P($P($G(^PRC(442,MYIEN,0)),U,1),"-",2),VALUE3=0,BFLAG=0
        F  S VALUE3=$O(^PRCH(440.6,"C",VALUE2,VALUE3)) Q:'VALUE3!(BFLAG=1)  D
        .I VALUE3'=DA D
        ..I $P($G(^PRCH(440.6,VALUE3,1)),U,4)="Y" D
        ...S BFLAG=1
        ...K MSG
        ...S MSG(1)="Sorry, there is already a final charge for this PC Order."
        ...S MSG(2)="You need to remove the first final charge to continue."
        ...S MSG(2,"F")="!"
        ...S MSG(3)=""
        ...S MSG(3,"F")="!"
        ...D EN^DDIOL(.MSG)
        ...K MSG,X
        ...S BFLAG=1
        K BFLAG
        Q
