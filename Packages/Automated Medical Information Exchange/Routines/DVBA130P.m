DVBA130P        ;ALB/RLC - Post Init Exam file Update ; 14 Jun 2005
        ;;2.7;AMIE;**130**;AUG 7,2003;Build 2
        ;
        ; This is the post-install for DVBA*2.7*130 to correct the worksheet
        ; number for the Traumatic Brain Injury (TBI) worksheet in the
        ; AMIE EXAM file (#396.6).
        ;
        Q
        ;
EN      ;
        D BMES^XPDUTL("DVBA*2.7*130 Post Installation --")
        D MES^XPDUTL("   Update to AMIE EXAM file (#396.6).")
        D MES^XPDUTL("  ")
        I '$D(^DVB(396.6)) D BMES^XPDUTL("Missing AMIE EXAM (#396.6) file") Q
        I $D(^DVB(396.6)) D
        .D EDIT
        Q
        ;
EDIT    ;edit worksheet # for Traumatic Brain Injury to #1240
        N IEN,WKS,DIC,DIE,DA,DR,EXAM
        D BMES^XPDUTL("Editing Worksheet # for Traumatic Brain Injury...")
        S IEN=223,WKS=1240,EXAM="TRAUMATIC BRAIN INJURY (TBI)"
        S DIE="^DVB(396.6,",DA=IEN,DR=".07///^S X=WKS" D ^DIE
        ;
        I $P(^DVB(396.6,223,0),U,7)=1240 D  Q
        .D MES^XPDUTL("  Successfully edited Entry #"_IEN)
        .D MES^XPDUTL("  for exam "_EXAM_".")
        .D MES^XPDUTL("  New worksheet number is #"_WKS_".")
        I $P(^DVB(396.6,223,0),U,7)'=1240 D
        .D MES^XPDUTL("  *** Warning - Unable to edit Entry #"_IEN)
        .D MES^XPDUTL("                for exam "_EXAM_".")
        K DA,DR,XY,Y,WKS,IEN,X,DIE,EXAM
        Q
