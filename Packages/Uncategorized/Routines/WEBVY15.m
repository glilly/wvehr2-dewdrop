WEBVY15 ;SLC/SLCOIFO-Pre and Post-init for patch WEBV*1*15 ;07/08/08 13:54
        ;;1.0;VISTAWEB;**15**;;Build 3
        ;
POST    ; initiate post-init processes
        ;
        N RESULT,APCODE,APNAME,APIP,APPORT,APPATH,APCONTEXT
        S APCODE="/lv-q(U|KizwE79@Z8'"
        S APNAME="VISTAWEB-FW"
        S APIP="10.208.5.41"
        S APPORT=19989
        S APPATH="/resolve.do"
        S APCONTEXT="OR CPRS GUI CHART"
        S RESULT=$$BSESETUP(APCODE,APNAME,APIP,APPORT,APPATH,APCONTEXT)
        I '+RESULT W "***V/W BSE SETUP FAILED: POST INSTALL *NOT* COMPLETED SUCCESSFULLY***",! Q
        W "=== POST INSTALL COMPLETED SUCCESSFULLY ==="
        Q
        ;
BSESETUP(APCODE,APNAME,APIP,APPORT,APPATH,APCONTEXT)    ;
        W !,"REMOVING OLD V/W ENTRY FROM 8994.5",!
        I +$$DELBSE(APCODE) D  Q $$SAVEBSE(APCODE,APNAME,APIP,APPORT,APPATH,APCONTEXT)
        .W "ADDING NEW V/W ENTRY TO 8994.5",!
        W "V/W SETUP *NOT* COMPLETED SUCCESSFULLY",!
        Q 0
        ;
DELBSE(NAME)    ;
        W "LOOKING FOR DUPLICATE V/W ENTRY",!
        N ERR,LIST
        D FIND^DIC(8994.5,"","@","X",NAME,"*","ACODE","","","LIST","ERR")
        I '+$D(LIST("DILIST",0)) D  Q 0
        .W "ERROR LOOKING UP OLD V/W ENTRY",!
        .W ERR
        I '+$P(LIST("DILIST",0),"^",1) D  Q 1
        .W "NO OLD V/W ENTRIES FOUND",!
        N I,FDA S I=0
        F  S I=$O(LIST("DILIST",2,I)) Q:'I  D
        .K FDA S FDA(8994.5,LIST("DILIST",2,I)_",",.01)="@"
        .D FILE^DIE("","FDA","ERR")
        .W "REMOVED OLD V/W ENTRY FROM 8994.5 ("_LIST("DILIST",2,I),")",!
        .I $D(ERR) D
        ..W "ERROR LOOKING UP OLD V/W ENTRY",!
        ..W ERR
        Q 1
        ;
SAVEBSE(APCODE,APNAME,APIP,APPORT,APPATH,APCONTEXT)     ;
        N FDA,ERR,INDEX
        S FDA(8994.5,"+1,",.01)=APNAME
        S INDEX=$$CPRSOPT(APCONTEXT)
        I +$G(INDEX)'>0 D  Q 0
        .W "COULD NOT FIND CPRS OPTION:"_INDEX,!
        S FDA(8994.5,"+1,",.02)=INDEX
        S FDA(8994.5,"+1,",.03)=APCODE
        S FDA(8994.51,"+2,+1,",.01)="H"
        S FDA(8994.51,"+2,+1,",.02)=APPORT
        S FDA(8994.51,"+2,+1,",.03)=APIP
        S FDA(8994.51,"+2,+1,",.04)=APPATH
        W "WRITING TO REMOTE APPLICATION FILE (8994.5)",!
        D UPDATE^DIE("","FDA","","ERR")
        I +$D(ERR) D  Q 0
        .W ERR
        W "VISTAWEB ENTRY SUCCESSFULLY ADDED",!
        Q 1
        ;
CPRSOPT(ACONTEXT)       ;Finds the IEN of the option for a context
        W "LOOKING FOR '"_ACONTEXT_"':"
        N INDEX,ERR S INDEX=$$FIND1^DIC(19,"","X",ACONTEXT,"B","","ERR")
        I +$D(ERR) D  Q 0
        .W "ERROR TRYING TO FIND OPTION",!
        .W ERR
        W "FOUND OPTION",!
        Q INDEX
        ;
