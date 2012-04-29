TIUE246 ; SLC/JER - Installer Routine for TIU*1*246 ;02/03/09  13:46
        ;;1.0;TEXT INTEGRATION UTILITIES;**246**;Jun 20, 1997;Build 22
        ;
        ;=======================================================
ENV     ; Environment Check
        N TIUDA
        ; If install option isn't 'Install Package(s)' QUIT
        Q:+$G(XPDENV)'=1
        I '$$ISA^USRLM(DUZ,"CLINICAL COORDINATOR") D  Q:+$G(XPDABORT)
        . N TIUY S TIUY=0
        . W !,"You are not known to the system to be a Clinical Application Coordinator (CAC).",!
        . W !,"Before proceeding with installation of this patch, you need to either have a"
        . W !,"CAC present with you, or have consulted the CAC as to the Document Class under"
        . W !,"Progress Notes in which the new TBI/POLYTRAUMA REHABILITATION/REINTEGRATION"
        . W !,"PLAN OF CARE Title should be placed.",!
        . S TIUY=$$READ^TIUU("YA","Are You Prepared to Continue? ","NO")
        . I '+TIUY W !!,"Okay, no harm done...Hurry back with a CAC (or an answer!)" S XPDABORT=2
        ; If TBI/POLYTRAUMA title is already installed, show hierarchy, and ask if OK
        S TIUDA=$O(^TIU(8925.1,"B","TBI/POLYTRAUMA REHABILITATION/REINTEGRATION PLAN OF CARE",0))
        I +TIUDA>0 D
        . N TIUDCDA,TIUFPRIV,TIUFWHO,TIUY S TIUY=0,TIUFPRIV=1,TIUFWHO="N"
        . W !!,"The TBI/POLYTRAUMA REHABILITATION/REINTEGRATION PLAN OF CARE Title has already"
        . W !,"been installed on your system...",!
        . S TIUDCDA=$O(^TIU(8925.1,"AD",TIUDA,0))
        . I +TIUDCDA>0 D
        . . W !,"It currently descends from the ",$P($G(^TIU(8925.1,TIUDCDA,0)),U)," Document Class.",!
        . S TIUY=$$READ^TIUU("YA","Is this Acceptable? ","YES")
        . ; If acceptable, QUIT the installation of TIU*1*246
        . I +TIUY>0 S XPDQUIT=1 Q
        . ; Otherwise, inactivate and remove TBI/POLYTRAUMA title from current Document Class
        . D REMOVE(TIUDA,TIUDCDA)
        Q
        ;
        ;=======================================================
POS001(DIR)     ; Set DIR("S") and DIR("B") for POS001.
        N DFLT
        S DIR("S")="I $P($G(^TIU(8925.1,+Y,0)),U,4)=""DC"",(+$P($G(^(0)),U,7)=11),+$$ISA^TIULX(+Y,3)"
        S DFLT=$$FINDC
        S:DFLT]"" DIR("B")=DFLT
        Q
        ;
        ;=======================================================
FINDC() ; Find an ACTIVE candidate Progress Notes DC
        N TIUI,TIUY,TIUC,TIUA S (TIUC,TIUI)=0,TIUY=""
        F  S TIUI=$O(^TIU(8925.1,3,10,TIUI)) Q:+TIUI'>0  D
        . N TIUDA,TIUD0,TIUNM,TIUST
        . S TIUDA=+$G(^TIU(8925.1,3,10,TIUI,0))
        . S TIUD0=$G(^TIU(8925.1,TIUDA,0))
        . S TIUST=$P(TIUD0,U,7) Q:+TIUST'=11  ; Quit if not ACTIVE
        . S TIUNM=$P(TIUD0,U)
        . I TIUNM["TBI"!(TIUNM["POLYTRAUMA") S TIUC=TIUC+1,TIUA(TIUC)=TIUNM
        I TIUC>1 S TIUY=$G(TIUA(1))
        Q TIUY
        ;
        ;=======================================================
REMOVE(TIUDA,TIUDCDA)   ; Remove Title (TIUDA) from Document Class (TIUDCDA)
        N ERR,IENS,FLAGS,FDA,TIUFPRIV,TIUFWHO,TIUTDA
        S TIUFPRIV=1,TIUFWHO="N",IENS=TIUDA_","
        S FDA(8925.1,IENS,.07)="INACTIVE",FLAGS="ET"
        D FILE^DIE(FLAGS,"FDA","ERR")
        ; if filing error occurs, write message to install log & quit
        I $D(ERR) D  Q
        . D BMES^XPDUTL("Unable to INACTIVATE TBI/POLYTRAUMA REHABILITATION/REINTEGRATION PLAN OF CARE title")
        . D MES^XPDUTL($G(ERR("DIERR",1,"TEXT",1)))
        ; otherwise remove title from document class
        K FDA
        S TIUTDA=+$O(^TIU(8925.1,TIUDCDA,10,"B",TIUDA,0))
        I TIUTDA'>0 D  Q
        . D BMES^XPDUTL("Title "_$P($G(^TIU(8925.1,TIUDA,0)),U)_" does not descend from Document Class "_$P($G(^TIU(8925.1,TIUDCDA,0)),U)_".")
        S IENS=TIUTDA_","_TIUDCDA_","
        S FDA(8925.14,IENS,".01")="@",FLAGS="K"
        D FILE^DIE(FLAGS,"FDA","ERR")
        ; if filing error occurs, write message to install log
        I $D(ERR) D  Q
        . D BMES^XPDUTL("Unable to Remove TBI/POLYTRAUMA TITLE from "_$P($G(^TIU(8925.1,TIUDCDA,0)),U)_".")
        . D MES^XPDUTL($G(ERR("DIERR",1,"TEXT",1)))
        ; If the current Document Class is left Empty, inform user and optionally delete
        I +$O(^TIU(8925.1,TIUDCDA,10,0))'>0 D
        . N TIUY
        . W !,"Document Class ",$$PNAME^TIULC1(TIUDCDA)," is now empty...",!
        . S TIUY=$$READ^TIUU("YA","Would you like to DELETE it? ","NO")
        . I +TIUY=1 D DELETEDC(TIUDCDA)
        Q
DELETEDC(TIUDA) ; Delete empty document class
        N ERR,IENS,FLAGS,FDA,TIUFPRIV,TIUFWHO,TIUDADA
        S TIUFPRIV=1,TIUFWHO="N"
        I +$O(^TIU(8925.1,TIUDA,10,0)) D  Q
        . W !,"Document Class has descendent titles -- Can't DELETE."
        ; First, remove empty DC from its parent class
        D REMOVEDC(TIUDA)
        ; Finally, DELETE the empty DC
        S IENS=TIUDA_","
        S FDA(8925.1,IENS,.07)="INACTIVE"
        S FDA(8925.1,IENS,.01)="@",FLAGS="K"
        D FILE^DIE(FLAGS,"FDA","ERR")
        I $D(ERR) D  Q
        . D BMES^XPDUTL("Unable to DELETE Document Class"_$P($G(^TIU(8925.1,TIUDA,0)),U)_".")
        . D MES^XPDUTL($G(ERR("DIERR",1,"TEXT",1)))
        Q
REMOVEDC(TIUDA) ; Remove Empty DC from its Parent Class
        N TIUDADA
        S TIUDADA=$O(^TIU(8925.1,"AD",TIUDA,0))
        I +TIUDADA D
        . N TIUKIDA,IENS,FDA,ERR,TIUFWHO,TIUFPRIV S TIUFPRIV=1,TIUFWHO="N"
        . S TIUKIDA=$O(^TIU(8925.1,"AD",TIUDA,TIUDADA,0))
        . I +TIUKIDA'>0 Q
        . S IENS=TIUKIDA_","_TIUDADA_","
        . S FDA(8925.14,IENS,.01)="@"
        . D FILE^DIE("K","FDA","ERR")
        . I $D(ERR) D
        . . D BMES^XPDUTL("Unable to REMOVE Document Class"_$P($G(^TIU(8925.1,TIUDA,0)),U)_" from "_$P($G(^TIU(8925.1,TIUDADA,0)),U)_".")
        . . D MES^XPDUTL($G(ERR("DIERR",1,"TEXT",1)))
        Q
