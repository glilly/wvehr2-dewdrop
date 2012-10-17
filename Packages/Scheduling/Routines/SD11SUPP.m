SD11SUPP        ;ALB/RLC- Stop Code/DSS Identifier Update 6/18/07
        ;;5.3;Scheduling;**573**;AUG 13, 1993;Build 10
        ;
        ;**  This patch is used as a Post-Init in a KIDS build to modify the
        ;**  the CLINIC STOP file [^DIC(40.7,] for Mid-FY2011 updates.
        ;
        Q
        ;
EN      ;** Add/inactivate/change/reactivate DSS IDs (stop codes)
        ;**  The following code executes if file modifications exist
        ;
        N SDVAR,SDAUMF,TYPE
        S SDAUMF=1
        D UPDATEDD("O")  ;unlock file to allow edits
        D:$P($T(NEW+1),";;",2)'="QUIT" ADD
        D:$P($T(OLD+1),";;",2)'="QUIT" INACT
        D:$P($T(ACT+1),";;",2)'="QUIT" REACT
        D:$P($T(CHNG+1),";;",2)'="QUIT" CHANGE
        D:$P($T(CDR+1),";;",2)'="QUIT" CDRNUM
        D:$P($T(REST+1),";;",2)'="QUIT" RESTR
        D UPDATEDD("C")  ;lock file back down
        Q
        ;
ADD     ;** Add DSS IDs
        ;
        ;  SDXX is in format:
        ; STOP CODE NAME^AMIS #^RESTRICTION TYPE^REST. DATE^CDR #
        ;
        N SDX,SDXX
        S SDVAR=1
        D MES^XPDUTL("")
        D BMES^XPDUTL(">>> Adding new Clinic Stops (DSS IDs) to CLINIC STOP File (#40.7)...")
        ;
        ;** NOTE: The following line is for DSS IDs that are not yet active
        D BMES^XPDUTL(" [NOTE: These Stop Codes CANNOT be used UNTIL 3/1/2011]")
        S DIC(0)="L",DLAYGO=40.7,DIC="^DIC(40.7,"
        F SDX=1:1 K DD,DO,DA S SDXX=$P($T(NEW+SDX),";;",2) Q:SDXX="QUIT"  DO
        .S DIC("DR")="1///"_$P(SDXX,"^",2)_$S('+$P(SDXX,U,5):"",1:";4///"_$P(SDXX,"^",5))
        .S DIC("DR")=DIC("DR")_";5///"_$P(SDXX,"^",3)_";6///"_$P(SDXX,"^",4)
        .S X=$P(SDXX,"^",1)
        .I '$D(^DIC(40.7,"C",$P(SDXX,"^",2))) D FILE^DICN,MESS Q
        .I $D(^DIC(40.7,"C",$P(SDXX,"^",2))) D EDIT(SDXX),MESSEX
        K DIC,DLAYGO,X
        Q
        ;
EDIT(SDXX)      ;- Edit fields w/new values if stop code record already exists
        ;
        Q:$G(SDXX)=""
        N DA,DIE,DLAYGO,DR
        S DA=+$O(^DIC(40.7,"C",+$P(SDXX,"^",2),0))
        Q:'DA
        S DIE="^DIC(40.7,",DR=".01///"_$P(SDXX,"^")_";1///"_$P(SDXX,"^",2)_";2///@"_$S('+$P(SDXX,U,5):"",1:";4///"_$P(SDXX,"^",5))_";5///"_$P(SDXX,"^",3)_";6///"_$P(SDXX,"^",4)
        D ^DIE
        Q
INACT   ;** Inactivate DSS IDs
        ;
        ;  SDXX is in format:
        ; AMIS #^^INACTIVATION DATE (in FileMan format)
        ;
        N SDX,SDDA,SDXX,SDINDT,SDEXDT
        S SDVAR=1
        D MES^XPDUTL("")
        D BMES^XPDUTL(">>> Inactivating Clinic Stops (DSS IDs) in CLINIC STOP File (#40.7)...")
        D BMES^XPDUTL(" [NOTE:  These Stop Codes CANNOT be used AFTER the indicated inactivation date]")
        F SDX=1:1 K DD,DO,DA S SDXX=$P($T(OLD+SDX),";;",2) Q:SDXX="QUIT"  DO
        . I +$P(SDXX,"^",3) D
        .. S X=$P(SDXX,"^",3)
        .. ;
        .. ;- Validate date passed in
        .. S %DT="FTX"
        .. D ^%DT
        .. Q:Y<0
        .. S SDINDT=Y
        .. D DD^%DT
        .. S SDEXDT=Y
        .. S SDDA=0
        .. F  S SDDA=$O(^DIC(40.7,"C",+SDXX,SDDA)) Q:'SDDA  D
        ... I $D(^DIC(40.7,SDDA,0)) D
        .... S DA=SDDA,DR="2////^S X=SDINDT",DIE="^DIC(40.7,"
        .... D ^DIE,MESI(SDEXDT)
        K %,%H,%I,DR,DA,DIC,DIE,DLAYGO,X,%DT,Y
        Q
        ;
CHANGE  ;** Change DSS ID names
        ;
        ;  SDXX is in format:
        ; STOP CODE NAME^AMIS #^^NEW STOP CODE NAME
        ;
        N SDX,SDXX,SDDA
        S SDVAR=1
        D MES^XPDUTL("")
        D BMES^XPDUTL(">>> Changing Clinic Stop (DSS ID) names in CLINIC STOP File (#40.7)...")
        F SDX=1:1 K DD,DO,DA S SDXX=$P($T(CHNG+SDX),";;",2) Q:SDXX="QUIT"  DO
        .S SDDA=+$O(^DIC(40.7,"C",$P(SDXX,U,2),0))
        .I $D(^DIC(40.7,SDDA,0)) I $P(^(0),U,3)="" D
        ..S DA=SDDA,DR=".01///"_$P(SDXX,U,4),DIE="^DIC(40.7,"
        ..D ^DIE,MESC
        K DIE,DR,DA
        Q
        ;
CDRNUM  ;** Change CDR numbers
        ;
        ;  SDXX is in format:
        ; STOP CODE NAME (AMIS #) ^ AMIS # ^ OLD CDR # ^ NEW CDR #
        ;
        N SDX,SDXX,SDDA
        S SDVAR=2
        D MES^XPDUTL("")
        D BMES^XPDUTL(">>> Changing CDR numbers in CLINIC STOP File (#40.7)...")
        F SDX=1:1 K DD,DO,DA S SDXX=$P($T(CDR+SDX),";;",2) Q:SDXX="QUIT"  DO
        .S SDDA=+$O(^DIC(40.7,"C",$P(SDXX,U,2),0))
        .I $D(^DIC(40.7,SDDA,0)) DO
        ..S DA=SDDA,DR="4///"_$P(SDXX,U,4),DIE="^DIC(40.7,"
        ..D ^DIE,MESN
        K DIE,DR,DA,X
        Q
        ;
REACT   ;** Reactivate DSS IDs
        ;
        ;  SDXX is in format:
        ; AMIS #^
        ;
        N SDX,SDDA,SDXX
        S SDVAR=1
        D MES^XPDUTL("")
        D BMES^XPDUTL(">>> Reactivating Clinic Stops (DSS IDs) in CLINIC STOP File (#40.7)...")
        ;Inactivation date is an uneditable field, cannot use DIE to delete so
        ;must manually set piece to null if stop code being reactivated.
        F SDX=1:1 K DD,DO,DA S SDXX=$P($T(ACT+SDX),";;",2) Q:SDXX="QUIT"  D
        .S SDDA=+$O(^DIC(40.7,"C",+SDXX,0))
        .I $P($G(^DIC(40.7,SDDA,0)),"^",3)'="" S $P(^DIC(40.7,SDDA,0),U,3)="" D MESA
        .I $P(^DIC(40.7,SDDA,0),U,2)=511 I $P(^(0),U,6)'="E" D
        ..S DIE="^DIC(40.7,",DA=SDDA,DR="5///E" D ^DIE
        ..K DIE,DA,DR
        Q
        ;
RESTR   ;** Change Restriction Data
        ;
        ;  SDXX is in format:
        ; STOP CODE NAME^STOP CODE NUMBER^RESTRICTION TYPE^RESTRICTION DATE
        ;
        N SDX,SDXX,SDDA
        S SDVAR=3
        D MES^XPDUTL("")
        D BMES^XPDUTL(">>> Changing Restriction Data in CLINIC STOP File (#40.7)...")
        F SDX=1:1 K DD,DO,DA S SDXX=$P($T(REST+SDX),";;",2) Q:SDXX="QUIT"  D
        .S SDDA=+$O(^DIC(40.7,"C",$P(SDXX,U,2),0))
        .I $D(^DIC(40.7,SDDA,0)) I $P(^(0),U,3)="" D
        ..S DA=SDDA,DR="5///"_$P(SDXX,U,3)_";6///@",DIE="^DIC(40.7,"
        ..D ^DIE,MESR
        K DIE,DR,DA,X
        Q
        ;
MESS    ;** Add message
        N ECXADMSG
        I +$G(SDVAR) D HDR(SDVAR)
        D MES^XPDUTL(" ")
        S ECXADMSG="Added:       "_$P(SDXX,"^",2)_"      "_$P(SDXX,"^")
        I $P(SDXX,"^",5)'="" S ECXADMSG=ECXADMSG_" [CDR#: "_$P(SDXX,"^",5)_"]"
        D MES^XPDUTL(ECXADMSG)
        I $P(SDXX,"^",3)'="" S ECXADMSG="                      Restricted Type: "_$P(SDXX,"^",3)_"    Restricted Date: "_$P(SDXX,"^",4)
        D MES^XPDUTL(ECXADMSG)
        K SDVAR
        Q
        ;
MESSEX  ;** Display message if stop code already exists
        N ECXADMSG
        I +$G(SDVAR) D HDR(SDVAR)
        D MES^XPDUTL(" ")
        S ECXADMSG="             "_$P(SDXX,"^",2)_"      "_$P(SDXX,"^")_"  already exists."
        D MES^XPDUTL(ECXADMSG)
        K SDVAR
        Q
        ;
MESI(SDEXDT)    ;** Inactivate message
        ;
        ;  Parameter:
        ;   SDEXDT - Date inactivation affective (External Format)
        ;
        N SDINMSG
        I +$G(SDVAR) D HDR(SDVAR)
        I $G(SDEXDT)="" S SDEXDT="UNKNOWN"
        D MES^XPDUTL(" ")
        S SDINMSG="Inactivated:  "_+SDXX_"           "_$P($G(^DIC(40.7,SDDA,0)),"^")_" as of "_SDEXDT
        D MES^XPDUTL(SDINMSG)
        K SDVAR
        Q
        ;
MESA    ;** Reactivate message
        ;
        N SDACMSG
        I +$G(SDVAR) D HDR(SDVAR)
        D MES^XPDUTL(" ")
        S SDACMSG="Reactivated:  "_+SDXX_"           "_$P($G(^DIC(40.7,SDDA,0)),"^")
        D MES^XPDUTL(SDACMSG)
        K SDVAR
        Q
        ;
MESC    ;** Change message
        N SDCMSG,SDCMSG1
        I +$G(SDVAR) D HDR(SDVAR)
        D MES^XPDUTL(" ")
        S SDCMSG="Changed:      "_$P(SDXX,U,2)_"           "_$P(SDXX,U)
        S SDCMSG1="     to:      "_$P(SDXX,U,2)_"           "_$P(SDXX,U,4)
        D MES^XPDUTL(SDCMSG)
        D MES^XPDUTL(SDCMSG1)
        K SDVAR
        Q
        ;
MESN    ;** Change number
        N SDNMSG,SDNMSG1
        I +$G(SDVAR) D HDR(SDVAR)
        D MES^XPDUTL(" ")
        S SDNMSG="  Changed: "_$P(SDXX,U,2)_"    "_$P(SDXX,U)
        S SDNMSG1="   : "_$P(SDXX,U,3)_" Date: "_$P(SDXX,U,5)
        D MES^XPDUTL(SDNMSG)
        D MES^XPDUTL(SDNMSG1)
        K SDVAR
        Q
MESR    ;** Restricting Stop Code
        N SDNMSG,SDNMSG1
        I +$G(SDVAR) D HDR(SDVAR)
        D MES^XPDUTL(" ")
        W !,"Changed:  ",?11,$P(SDXX,U,2),?26,$P(SDXX,U),?57,$P(SDXX,U,5),?67,$P(SDXX,U,6)
        W !?5,"to:",?57,$P(SDXX,U,3),?67,$P(SDXX,U,4)
        K SDVAR
        Q
        ;
HDR(SDVAR)      ;- Header
        Q:'$G(SDVAR)
        N SDHDR
        S SDHDR=$P($T(@("HDR"_SDVAR)),";;",2)
        D BMES^XPDUTL(SDHDR)
        Q
        ;
        ;
HDR1    ;;           Stop Code              Name
        ;
HDR2    ;;                CDR        Stop Code             Name
        ;
HDR3    ;;           Stop Code      Name                       Rest. Type    Date
        ;
        ;
UPDATEDD(TYPE)  ;update DD for 40.7 to either lock file and prohibit edits or
        ;unlock file to allow edits
        ;TYPE="C" to lock file or TYPE="O" to unlock file
        N I
        I TYPE="C" D  ;restrict file edits "lockdown" file
        .S ^DD(40.7,.01,7.5)="I $G(DIC(0))[""L"",'$D(SDAUMF) D EN^DDIOL(""Entries can only be added by the Stop Code Counsel."","""",""!?5"") K X"
        .F I=1:1:6 I $P(^DD(40.7,I,0),U,2)'["I" S $P(^DD(40.7,I,0),U,2)=$P(^DD(40.7,I,0),U,2)_"I"  ;makes all fields uneditable
        I TYPE="O" D  ;remove restrictions "unlock" file
        .K ^DD(40.7,.01,7.5)
        .F I=1:1:6 S $P(^DD(40.7,I,0),U,2)=$TR($P(^DD(40.7,I,0),U,2),"I","")
        Q
        ;
        ;
NEW     ;DSS IDs to add- ex ;;STOP CODE NAME^NUMBER^RESTRICTION TYPE^RESTRICTION DATE^CDR
        ;;BRACHYTHERAPY TREATMENT^158^E
        ;;QUIT
        ;
OLD     ;DSS IDs to be inactivated- ex. ;;AMIS NUMBER^^INACTIVE DATE
        ;;219^TBI (TRAUMATIC BRAIN INJURY)^03/1/2011
        ;;QUIT
        ;
CHNG    ;DSS ID name changes- example ;;STOP CODE NAME^NUMBER^^NEW NAME
        ;;POLYTRAUMA INDIV^197^^POLYTRAUMA/TBI IND
        ;;POLYTRAUMA GRP^198^^POLYTRAUMA/TBI GRP
        ;;POLYTRAUMA PHONE^199^^TELEPHONE POLYTRAUMA/TBI
        ;;PRIMARY CARE GROUP PRI ONLY^348^^PRIMARY CARE SHARED APPT
        ;;MED SPECIALTY GROUP PRI ONLY^394^^MED SPECIALTY SHARED APPT
        ;;NEUROBEHAVIORAL-INDIVIDUAL^511^^GRANT AND PER DIEM
        ;;QUIT
        ;
CDR     ;CDR account change- ex. ;;STOP CODE NAME^NUMBER^CDR # (old)^CDR# (new)
        ;;QUIT
        ;
ACT     ;DSS IDs to be reactivated- example ;;NUMBER^
        ;;511^
        ;;QUIT
        ;
REST    ;Change restriction - ;;STOP CODE NAME^NUMBER^REST TYPE^RES DATE^OLD
        ;;NON-OR ANESTHESIA PROCEDURES^434^E^^P
        ;;HCHV/HCMI^529^E^^P
        ;;QUIT
