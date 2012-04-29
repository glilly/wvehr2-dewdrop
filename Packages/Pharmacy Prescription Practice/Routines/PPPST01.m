PPPST01 ;ALB/JFP - PPP, POST INIT ROUTINE ;01MAR94
 ;;V1.0;PHARMACY PRESCRIPTION PRACTICE;;APR 7,1995
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
EP ; -- Entry point
 ;
 N XQABT1,XQABT2,XQABT3,XQABT4,XQABT5,X
 ;
 W @IOF
 W !,">>> Beginning Post Init Process"
 ;
PROT ; -- Installs protocols used by list processor, D ^ORVOM
 S XQABT1=$H
 W !!,">>> Installing protocols for use by the list processor"
 D ^PPPONIT
 W "..... Completed"
 ;
LIST ; -- Installs list templates used by list processor, D ^VALMW3
 W !!,">>> Installing list templates for use by list processor"
 D ^PPPPSL
 W ".....Completed"
 ;
FILEI ; -- File initialization
 S XQABT2=$H
 D PARMEDT^PPPST04
 D DOMXREF^PPPST04
 W !," "
 D:$D(^PPP(1020.3)) CLR1^PPPMSC1
 ;
MAIL ; -- Mail groups
 S XQABT4=$H
 W !!,">>> Setting up Prescription Practices mail groups"
 S X=$$MAIL^PPPST08
 I X=0 W !,"    'PRESCRIPTION PRACTICES'... mail group created",!
 I X<0 W !,"   Error...Creating 'PRESCRIPTION PRACTICES' mail group, Post init HALTED" Q
 ;
XREF ; -- Sets cross ref in PDX transaction file for PPP
 D EN^PPPST09
 ;
END ; -- Sends mail message to G.PPP DEVELOPERS@ISC-ALBANY.VA.GOV, when comp
 S XQABT5=$H
 ; -- File Conversion
 W !,">>> Test sites will receive special instructions to convert data",!
 ;
 W !,">>> The building of the PPP FOREIGN FACILITY XREF needs to be"
 W !,"    scheduled at this time.  See Build/Rebuild Other Facility"
 W !,"    Xref option off [PPP MAIN].",!
 S X="PPPINITY" X ^%ZOSF("TEST") I $T D @("^"_X)
 ;
 W !!!,">>> Post init process completed"
 QUIT
 ;
