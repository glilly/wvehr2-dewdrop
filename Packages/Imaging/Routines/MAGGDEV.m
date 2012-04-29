MAGGDEV ;WOIFO/LB - Routine to enter Imaging device entries ; [ 06/20/2001 08:56 ]
 ;;3.0;IMAGING;;Mar 01, 2002
 ;; +---------------------------------------------------------------+
 ;; | Property of the US Government.                                |
 ;; | No permission to copy or redistribute this software is given. |
 ;; | Use of unreleased versions of this software requires the user |
 ;; | to execute a written test agreement with the VistA Imaging    |
 ;; | Development Office of the Department of Veterans Affairs,     |
 ;; | telephone (301) 734-0100.                                     |
 ;; |                                                               |
 ;; | The Food and Drug Administration classifies this software as  |
 ;; | a medical device.  As such, it may not be changed in any way. |
 ;; | Modifications to this software may result in an adulterated   |
 ;; | medical device under 21CFR820, the use of which is considered |
 ;; | to be a violation of US Federal Statutes.                     |
 ;; +---------------------------------------------------------------+
 ;;
 Q
EN ;Create an entry in the Device file for an Imaging workstation.
 ;
TERM N A,DA,DD,DO,DIC,DIE,DR,ENTRY,X,Y
 W !,"I will setup the 'P-IMAGING' entry in the Terminal Type file."
 I $$FIND1^DIC(3.2,,,"P-IMAGING","B") D  G DEV
 . W !,"An entry already exists for 'P-IMAGING' in the Terminal Type file."
 ;Set the entry
 S DIC="^%ZIS(2,"
 S X="P-IMAGING",DIC(0)="O" K DD,D0 D FILE^DICN
 S ENTRY=+Y G:'ENTRY ERRDEV
 S DR=".02///0;1///80;2///"_"#"_";4///"_"$C(8)"_";7///"_"D CLOSE^MAGGTU5;3///64"
 S DA=ENTRY,DIE="^%ZIS(2," D ^DIE
 ;.02/SELECTABLE AT SIGNON;1/RIGHT MARGIN;2/FORM FEED;4/BACK SPACE
 ;7/CLOSE EXECUTE;3/PAGE LENGTH
DEV N A,DA,DD,DO,DIC,DIE,ENTRY,X,Y,MAGOS
 W !,"I will setup an 'Imaging Workstation' entry in the Device file."
 I $$FIND1^DIC(3.5,,,"IMAGING WORKSTATION","B") D  Q
 . W !,"An entry already exists for 'IMAGING WORKSTATION' in the Device file."
 S DIC="^%ZIS(1,"
 S X="IMAGING WORKSTATION",DIC(0)="O" K DD,D0 D FILE^DICN
 S ENTRY=+Y G:'ENTRY ERRDEV
 I ^%ZOSF("OS")["DSM" D
 . S MAGOS="DSM"
 . S DA=ENTRY,DR=".02///"_"BROKER"_";3///"_"P-IMAGING"_";1///"_"WS.DAT"
 . S DR=DR_";4///0;5///0;19///"_"(NEWVERSION,DELETE)"_";2///"_"HFS"
 . S DIE="^%ZIS(1,"
 I ^%ZOSF("OS")["OpenM" D
 . S MAGOS="OPENM"
 . S DA=ENTRY,DR=".02///"_"BROKER"_";3///"_"P-IMAGING"_";1///"_"WS.DAT"
 . S DR=DR_";4///0;5///0;19///"_"""NWS"""_";2///"_"HFS"
 . S DIE="^%ZIS(1,"
 I ^%ZOSF("OS")["MSM" D
 . S MAGOS="MSM"
 . S DA=ENTRY,DR=".02///"_"BROKER"_";3///"_"P-IMAGING"_";1///"_"WS.DAT"
 . S DR=DR_";4///0;5///0;19///"_"(""WS.DAT"":""M"")"_";2///"_"HFS"
 . S DIE="^%ZIS(1,"
 I $D(MAGOS) D ^DIE
 ; The following lines describe the field number/name for the DR string.
 ;.02/LOCATION OF TERMINAL;3/SUBTYPE;1/$I;4=ASK DEVICE;5/ASK PARAMETERS
 ;19/OPEN PARAMETERS;2/TYPE
 Q
ERRDEV ;
 W !,"Could not setup the IMAGING WORKSTATION entry in the Device file."
 W !,"Could not setup the P-IMAGING entry in the Terminal Type file."
MSG W !,"Please review the Installation Manual to create this entry."
 Q
