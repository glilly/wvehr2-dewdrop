AAQPOST2 ;JFW/FGO - ADD LOCAL PACKAGE ENTRIES [1/14/00 4:01pm]
 ;;1.4;AHJL VISTA PACKAGE TRACKING;**L01**;JAN 14, 2000
 ; Use EN entry point.
 Q
 ; Loop and create new LOCAL NMSPZ KIDS BUILD entries, where
 ; NMSP represents the Namespace of existing entries and Z
 ; denotes that it is a Local Kids Build.
 ;
EN S U="^",L2=0 F K=0:0 S L2=$O(^DIC(9.4,L2)) Q:(+L2'>0)  D AAQPR
EXIT ;
 K AAQNAM,AAQPRE,AAQPREZ,AAQPV,L2,D0,DD,K
 Q
AAQPR ;
 ; AAQNAM is the .01 NAME field
 ; AAQPREZ is the PREFIX_"Z"
 ; AAQMAIL is the Mail group for the package.
 ;
 N DA,DIC,DIE,DLAYGO,DR,X,Y,K
 W !!," Reading IEN : ",L2," in Package file."
 ;
 ; Add only if PREFIX'="" or '["Z", and CLASS is "I"(National).
 S AAQPRE=$P($G(^DIC(9.4,L2,0)),U,2)
 I AAQPRE'="",AAQPRE'["Z",$P($G(^DIC(9.4,L2,7)),U,3)="I" D ADDREC
 Q
ADDREC ;
 ; Since Class is National at this point, if NAME["PATCH"
 ; or NAME["*" it is the name of a Patch(not a Package), so
 ; set the Class to "II"(Inactive). Since it is not the primary
 ; entry in the file for the package, bypass the ADDREC process.
 ;
 I $P($G(^DIC(9.4,L2,0)),U,1)["PATCH"!($P($G(^DIC(9.4,L2,0)),U,1)["*") S $P(^DIC(9.4,L2,7),U,3)="II" Q
 ;
 ; Process to Add an entry to the Package file
 ;
 S AAQPREZ=$P(AAQPRE,",",1)_"Z"
 S AAQNAM="LOCAL "_AAQPREZ_" KIDS BUILDS"
 W !," Checking for existing entry for : ",AAQNAM
 S X=AAQNAM,DIC="^DIC(9.4,",DIC(0)="XM" D ^DIC I +Y>0 S AAQPV=+Y
 I $D(^DIC(9.4,"B",AAQNAM)) W !,"  Entry already exits, NOT ADDED" Q
 ; Add new entry if B x-ref does not exist.
 I '$D(^DIC(9.4,"B",AAQNAM)) D
 .S X=AAQNAM,DIC="^DIC(9.4," S DIC(0)="ML" D FILE^DICN
 .S AAQPV=+Y
 .I AAQPV'="" D
 ..S $P(^DIC(9.4,AAQPV,0),U,2)=AAQPREZ
 ..S $P(^DIC(9.4,AAQPV,0),U,3)="Local "_AAQPREZ_" KIDS Builds"
 ..S ^DIC(9.4,AAQPV,1,0)="^^3^3^3000114^^"
 ..S ^DIC(9.4,AAQPV,1,1,0)=" "
 ..S ^DIC(9.4,AAQPV,1,2,0)=" 01-14-2000/JFW - Used for VISN 13 "_AAQNAM_"."
 ..S ^DIC(9.4,AAQPV,1,3,0)="                - Entry added by EN^AAQPOST2 routine."
 ..S ^DIC(9.4,AAQPV,7)="^^III"
 ..S ^DIC(9.4,AAQPV,"MG")=$G(^DIC(9.4,L2,"MG"))
 ..S ^DIC(9.4,AAQPV,"VERSION")=$G(^DIC(9.4,L2,"VERSION"))
 ..W !,"   ** Entry has been added **"
 Q
