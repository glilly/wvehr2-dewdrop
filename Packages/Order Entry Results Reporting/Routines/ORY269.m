ORY269  ;WV/CJS - POST INIT FOR OR*3*269 ;1/24/07  23:34
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**269**;Dec 17, 1997;Build 33
        ; Register Lookup RPCs
        N MENU,RPC
        S MENU="OR CPRS GUI CHART"
        F RPC="ORWPT ENHANCED PATLOOKUP","ORWPT OTHER-RADIOBUTTONS" D INSERT(MENU,RPC)
        Q
INSERT(OPTION,RPC)      ; Call FM Updater with each RPC
        ; Input  -- OPTION   Option file (#19) Name field (#.01)
        ;           RPC      RPC sub-file (#19.05) RPC field (#.01)
        ; Output -- None
        N FDA,FDAIEN,ERR,DIERR
        S FDA(19,"?1,",.01)=OPTION
        S FDA(19.05,"?+2,?1,",.01)=RPC
        D UPDATE^DIE("E","FDA","FDAIEN","ERR")
        Q
