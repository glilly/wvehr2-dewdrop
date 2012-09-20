ORY319  ;SLC/SLCOIFO-Pre and Post-init for patch OR*3*319 ; 9/15/09 8:02am
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**319,LOCAL**;Dec 17, 1997;Build 13
        ;
        ;WORLDVISTA MODS DJW 04/2012
        ;MODIFICATIONS TO REPLACE WRITE COMMANDS WITH CALLS TO MES^XPDUTL()
        ;MODS TO REPLACE ZWRITE COMMANDS WITH $QUERY LOOPS AND CALLS TO MES^XPDUTL()
        ;
POST    ; post-init process
        N CPRSOPT,RPCIEN S CPRSOPT=$$CPRSOPT,RPCIEN=$$RPCIEN("ORVW FACLIST")
        I '+$D(CPRSOPT) D  Q
        .D MES^XPDUTL("CPRS option not found")
        .D NOTCOMP
        I '+$D(RPCIEN) D  Q
        .D MES^XPDUTL("RPC not found")
        .D NOTCOMP
        ;
        I +$$RPCNOPT(CPRSOPT,RPCIEN) D  Q
        .D MES^XPDUTL("RPC already in option")
        .D COMPLETE
        D MES^XPDUTL("Inserting RPC in option")
        I '$$INSERT(CPRSOPT,RPCIEN) D  Q
        .D NOTCOMP
        D COMPLETE
        Q
RPCNOPT(OPTIEN,RPCIEN)  ;
        Q $O(^DIC(19,OPTIEN,"RPC","B",RPCIEN,0))
        ;
INSERT(OPTIEN,RPCIEN)   ;
        N REC,ERR
        S REC(19.05,"+1,"_OPTIEN_",",.01)=RPCIEN
        D UPDATE^DIE("","REC","","ERR")
        I +$D(ERR) D  Q 0
        .D MES^XPDUTL("=== ERROR ===")
        .N J,I S J="ERR" F I=1:1  S J=$Q(@J) Q:J=""  S X(I)=J_" = """_(@J)_""""
        .D MES^ZPDUTL(.J)
        Q 1
        ;
CPRSOPT()       ;Finds the IEN of the "OR CPRS GUI CHART" option
        N OPTNAME S OPTNAME="OR CPRS GUI CHART"
        D MES^XPDUTL("Looking for '"_OPTNAME_"'...")
        N INDEX,ERR S INDEX=$$FIND1^DIC(19,"","X",OPTNAME,"B","","ERR")
        I +$D(ERR) D  Q 0
        .D MES^XPDUTL("ERROR TRYING TO FIND OPTION")
        .N J,I S J="ERR" F I=1:1  S J=$Q(@J) Q:J=""  S X(I)=J_" = """_(@J)_""""
        .D MES^ZPDUTL(.J)
        D MES^XPDUTL("Found option")
        Q INDEX
        ;
RPCIEN(RPCNAME) ; Returns the ICN of the given RPC name
        D MES^XPDUTL("Looking for RPC '"_RPCNAME_"'...")
        N INDEX,ERR S INDEX=$$FIND1^DIC(8994,"","X",RPCNAME,"B","","ERR")
        I +$D(ERR) D  Q 0
        .D MES^XPDUTL("ERROR TRYING TO FIND RPC '"_RPCNAME_"'")
        .N J,I S J="ERR" F I=1:1  S J=$Q(@J) Q:J=""  S X(I)=J_" = """_(@J)_""""
        .D MES^ZPDUTL(.J)
        D MES^XPDUTL("Found RPC")
        Q INDEX
        ;
NOTCOMP ; Not Completed Message
        D MES^XPDUTL("Post-install NOT COMPLETED!")
        Q
        ;
COMPLETE        ; Completed Message
        D MES^XPDUTL("Post-install COMPLETED normally")
        Q
        ;
