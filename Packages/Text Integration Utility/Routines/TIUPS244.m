TIUPS244        ; BP/AJB - Mobile Elec. Doc ; 03/05/09
        ;;1.0;TEXT INTEGRATION UTILITIES;**244**;Jun 20, 1997;Build 9
        ;
        Q
SETUP   ;
        N TIUDFL,TIUERR,TIUFPRIV,TIUFLDR,TIUNAME,TIUX,TIUY
        S TIUDFL="<Default Value>",TIUFPRIV=1
        S TIUNAME="TIU MED HSTYPE"
        D
        . N DA,DIK S DA=+$$LU(8989.51,TIUNAME),DIK="^XTV(8989.51," D:+DA ^DIK
        D
        . Q:+$$LU(8989.51,TIUNAME)
        . N TIU,TIUIEN,TIUMSG
        . S TIU(8989.51,"+1,",.01)=TIUNAME
        . S TIU(8989.51,"+1,",.02)="Health Summary Type for MED"
        . S TIU(8989.51,"+1,",.03)=0
        . S TIU(8989.51,"+1,",1.1)="F"
        . D UPDATE^DIE("","TIU","TIUIEN","TIUMSG")
        . F TIUX="1^200","2^49","3^4","4^4.2" D
        . . N TIU,TIUIEN,TIUMSG
        . . S TIUIEN=+$$LU(8989.51,TIUNAME)
        . . S TIU(8989.513,"+2,"_TIUIEN_",",.01)=+TIUX
        . . S TIU(8989.513,"+2,"_TIUIEN_",",.02)=$P(TIUX,U,2)
        . . D UPDATE^DIE("","TIU","TIUIEN","TIUMSG")
        ;
        S TIUNAME="MED NOTE IMPORT" D
        . Q:+$$LU(101.15,TIUNAME)
        . N TIU,TIUIEN,TIUMSG
        . S TIU(101.15,"+1,",.01)=TIUNAME
        . S TIU(101.15,"+1,",.02)="{1730C986-9BEE-4DE5-9FDD-BE4851823F67}"
        . D UPDATE^DIE("","TIU","TIUIEN","TIUMSG")
        ;
        S TIUFLDR=+$$LU(8927,"Shared Templates","X")
        Q:'+TIUFLDR
        ;
        S TIUNAME="Mobile Electronic Documentation" D
        . Q:+$$LU(8927,TIUNAME)
        . N TIU,TIUIEN,TIUMSG
        . S TIU(8927,"+1,",.01)=TIUNAME
        . S TIU(8927,"+1,",.03)="C"
        . S TIU(8927,"+1,",.04)="A"
        . S TIU(8927,"+1,",.05)=0
        . S TIU(8927,"+1,",.08)=0
        . S TIU(8927,"+1,",.09)=0
        . S TIU(8927,"+1,",.10)=0
        . S TIU(8927,"+1,",.11)=0
        . S TIU(8927,"+1,",.12)=0
        . S TIU(8927,"+1,",.13)=0
        . S TIU(8927,"+1,",.14)=0
        . S TIU(8927,"+1,",.16)=0
        . D UPDATE^DIE("","TIU","TIUIEN","TIUMSG")
        . S TIUX=TIUIEN(1),TIUY="",TIUY=($O(^TIU(8927,1,10,"B",TIUY),-1)+1)
        . S TIU(8927.03,"+2,"_TIUFLDR_",",.01)=TIUY
        . S TIU(8927.03,"+2,"_TIUFLDR_",",.02)=TIUX
        . D UPDATE^DIE("","TIU","TIUIEN","TIUMSG")
        ;
        S TIUNAME="Import M.E.D. Notes" D
        . Q:+$$LU(8927,TIUNAME)
        . N TIU,TIUCO,TIUIEN,TIUMSG
        . S TIU(8927,"+1,",.01)=TIUNAME
        . S TIU(8927,"+1,",.03)="T"
        . S TIU(8927,"+1,",.04)="A"
        . S TIU(8927,"+1,",.05)=0
        . S TIU(8927,"+1,",.08)=0
        . S TIU(8927,"+1,",.09)=0
        . S TIU(8927,"+1,",.10)=0
        . S TIU(8927,"+1,",.11)=0
        . S TIU(8927,"+1,",.12)=0
        . S TIU(8927,"+1,",.13)=0
        . S TIU(8927,"+1,",.14)=0
        . S TIU(8927,"+1,",.16)=0
        . S TIUCO=+$$LU(101.15,"MED NOTE IMPORT") Q:'+TIUCO
        . S TIU(8927,"+1,",.17)=TIUCO
        . D UPDATE^DIE("","TIU","TIUIEN","TIUMSG")
        . S TIUY="",TIUY=($O(^TIU(8927,TIUX,10,"B",TIUY),-1)+1)
        . S TIU(8927.03,"+2,"_TIUX_",",.01)=TIUY
        . S TIU(8927.03,"+2,"_TIUX_",",.02)=TIUIEN(1)
        . D UPDATE^DIE("","TIU","TIUIEN","TIUMSG")
        ;
EXIT    Q
        ;
LU(FILE,NAME,FLAGS,SCREEN,INDEXES)      ;
        Q $$FIND1^DIC(FILE,"",$G(FLAGS),NAME,$G(INDEXES),$G(SCREEN),"TIUERR")
