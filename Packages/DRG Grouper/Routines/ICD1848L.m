ICD1848L ;ALB/MJB - NEW DIAGNOSIS CODES;7/27/05 14:50;
 ;;18.0;DRG Grouper;**48**;Oct 13,2000;Build 17
 ;
 ;3 line tags are in this routine. See ICD18XXP to find which tag
 ;is being called. Not all are used for each patch.
 ;These tags are for any needed corrections to DRG Groupings.
 ;DRG - is for any changes being made to specific DRG(s) due to an
 ;issue reported in a Remedy ticket.
 ;PX - add major OR identifier
 ;ADDID - Add identifier to diagnosis code(fields are stored at DXID)
 Q
DRG ;
 N FDA,DA,DIE,DR,MAJOR
 ;
 ; HD233286
 ;
 ; next line in case patch being re-installed
 ;I $P(^ICD9(14197,3,1,1,0),U,4)=7 G NEXT
 ;S FDA(1820,80,"?1,",.01)="`14197"
 ;S FDA(1820,80.071,"?2,?1,",.01)=3071001
 ;S FDA(1820,80.711,"+3,?2,?1,",.01)=826
 ;S FDA(1820,80.711,"+4,?2,?1,",.01)=827
 ;S FDA(1820,80.711,"+5,?2,?1,",.01)=828
 ;S FDA(1820,80.711,"+6,?2,?1,",.01)=829
 ;S FDA(1820,80.711,"+7,?2,?1,",.01)=830
 ;D UPDATE^DIE("","FDA(1820)") K FDA(1820)
 ;S FDA(1820,80,"?1,",.01)="`14198"
 ;S FDA(1820,80.071,"?2,?1,",.01)=3071001
 ;S FDA(1820,80.711,"+3,?2,?1,",.01)=826
 ;S FDA(1820,80.711,"+4,?2,?1,",.01)=827
 ;S FDA(1820,80.711,"+5,?2,?1,",.01)=828
 ;S FDA(1820,80.711,"+6,?2,?1,",.01)=829
 ;S FDA(1820,80.711,"+7,?2,?1,",.01)=830
 ;D UPDATE^DIE("","FDA(1820)") K FDA(1820)
 ;
NEXT ;UPDATE PX
 ;
 ;HD397928
 ;
 S DA=4236
 S DIE="^ICD0("
 S MAJOR="@"
 S DR="20////^S X=MAJOR"
 D ^DIE
 Q
 ;
ADDID ;
 ; update diagnoses with identifier
 ;
 N LINE,ICDX,ICDDIAG,ENTRY,IDENT,DA,DIE,DR,DUPE
 F LINE=1:1 S ICDX=$T(DXID+LINE) S ICDDIAG=$P(ICDX,";;",2) Q:ICDDIAG="EXIT"  D
 .S ENTRY=+$O(^ICD9("BA",$P(ICDDIAG,U)_" ",0))
 .S IDENT=$P($G(^ICD9(ENTRY,0)),U,2)
 .; check if already done in case patch is being re-installed
 .S IDENA=$P(ICDDIAG,U,2)
 .I IDENT[IDENA D ICDMSG Q
 .S IDENT=IDENT_IDENA  D
 .S DA=ENTRY,DIE="^ICD9("
 .S DR="2///^S X=IDENT"
 .D ^DIE
 Q
ICDMSG ;
 D BMES^XPDUTL(">>> IDENTIFIER ALREADY UPDATED - NO CHANGE HAS BEEN MADE")
 D MES^XPDUTL("     TO DIAGNOSIS CODE: "_ICDDIAG) Q
DXID ;
 ;;238.79^L
 ;;425.4^XCV
 ;;041.4^k
 ;;EXIT
