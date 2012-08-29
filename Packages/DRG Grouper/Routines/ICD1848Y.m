ICD1848Y ;ALB/EG/MJB - PX UPDATES;6/24/05 3:29pm
 ;;18.0;DRG Grouper;**48**;Oct 13,2000;Build 17
 ;
 ; 2 line tags are in this routine. See ICD18XXP to find which tag 
 ;is being called. Not all are used for each patch.
 ;These tags are for any needed corrections to DRG Groupings.
 ;PRO - is for making changes to the procedure code, add drg effective 
 ;date,etc (fields will be in REV linetag)
 ;ID is to add or update an identifier for a procedure code(fields
 ; will be in REVID) 
 Q
 ;
PRO ;
 D BMES^XPDUTL(">>>Modifying procedure codes - file 80.1")
 D MES^XPDUTL(">>>for new DRGs")
 N LINE,ICDX,ICDPROC,ENTRY,SUBLINE,DATA,FDA
 F LINE=1:1 S ICDX=$T(REV+LINE) S ICDPROC=$P(ICDX,";;",2) Q:ICDPROC="EXIT"  D
 .Q:ICDPROC["+"
 .S ENTRY=+$O(^ICD0("BA",$P(ICDPROC,U)_" ",0))
 .I ENTRY D
 ..;check for possible inactive dupe
 ..I $P($G(^ICD0(ENTRY,0)),U,9)=1 S ENTRY=+$O(^ICD0("BA",$P(ICDPROC,U)_" ",ENTRY)) I 'ENTRY Q
 ..; check if already created in case patch being re-installed
 ..Q:$D(^ICD0(ENTRY,2,"B",3081001))
 ..;add 80.171, 80.1711 and 80.17111 records
 ..F SUBLINE=1:1 S ICDX=$T(REV+LINE+SUBLINE) S DATA=$P(ICDX,";;",2) Q:DATA'["+"  D
 ...I SUBLINE=1 D
 ....S FDA(1820,80.1,"?1,",.01)="`"_ENTRY
 ....S FDA(1820,80.171,"+2,?1,",.01)=3081001
 ....D UPDATE^DIE("","FDA(1820)") K FDA(1820)
 ...S DATA=$E(DATA,2,99)
 ...S FDA(1820,80.1,"?1,",.01)="`"_ENTRY
 ...S FDA(1820,80.171,"?2,?1,",.01)=3081001
 ...S FDA(1820,80.1711,"+3,?2,?1,",.01)=$P(DATA,U)
 ...D UPDATE^DIE("","FDA(1820)") K FDA(1820)
 ...S FDA(1820,80.1,"?1,",.01)="`"_ENTRY
 ...S FDA(1820,80.171,"?2,?1,",.01)=3081001
 ...S FDA(1820,80.1711,"?3,?2,?1,",.01)=$P(DATA,U)
 ...S FDA(1820,80.17111,"+4,?3,?2,?1,",.01)=$P(DATA,U,2)
 ...I $P(DATA,U,3) S FDA(1820,80.17111,"+5,?3,?2,?1,",.01)=$P(DATA,U,3)
 ...I $P(DATA,U,4) S FDA(1820,80.17111,"+6,?3,?2,?1,",.01)=$P(DATA,U,4)
 ...I $P(DATA,U,5) S FDA(1820,80.17111,"+7,?3,?2,?1,",.01)=$P(DATA,U,5)
 ...I $P(DATA,U,6) S FDA(1820,80.17111,"+8,?3,?2,?1,",.01)=$P(DATA,U,6)
 ...I $P(DATA,U,7) S FDA(1820,80.17111,"+9,?3,?2,?1,",.01)=$P(DATA,U,7)
 ...D UPDATE^DIE("","FDA(1820)") K FDA(1820)
 Q
ID ;modify Identifier field (#2) in file 80.1
 N LINE,ICDX,ICDPROC,ENTRY,DA,DIE,DR,IDENT,DIC
 F LINE=1:1 S ICDX=$T(REVID+LINE) S ICDPROC=$P(ICDX,";;",2) Q:ICDPROC="EXIT"  D
 .S ENTRY=+$O(^ICD0("BA",$P(ICDPROC,U)_" ",0))
 .; check if already done in case patch is being re-installed
 .S IDENT=$P($G(^ICD0(ENTRY,0)),U,2)
 .S IDENA=$P(ICDPROC,U,2)
 .I IDENT[IDENA D ICDMSG Q
 .S IDENT=IDENT_IDENA  D
 .S DA=ENTRY,DIE="^ICD0("
 .S DR="2///^S X=IDENT"
 .D ^DIE
 Q
 ; 
ICDMSG ;
 D BMES^XPDUTL(">>> IDENTIFIER ALREADY UPDATED - NO CHANGE HAS BEEN MADE ")
 D MES^XPDUTL("     TO PROCEDURE CODE: "_ICDPROC) Q
REV ;changes to procedure, if any
 ;;EXIT
 ;;
REVID ; PX code,Identifier - additions, changes or deletions, if any of PX identifiers.
 ;;81.05^OF
 ;;81.63^OF
 ;;57.93^Of
 ;;EXIT
