NHINPI  ; SLC/AGP - NHIN package post install ; 12/01/2009
        ;;1.0;NHIN;;Oct 25, 2010;Build 14
        ;
POST    ;
        ; Create proxy user
        Q:$O(^VA(200,"B","NHIN,APPLICATION PROXY",0))
        N X
        S X=$$CREATE^XUSAP("NHIN,APPLICATION PROXY","","NHIN APPLICATION PROXY")
        Q
        ;
