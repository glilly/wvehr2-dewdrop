TIUPS219        ; SLC/JER - Post-Init Routine for TIU*1*219 ;9/12/07
        ;;1.0;TEXT INTEGRATION UTILITIES;**219**;Jun 20, 1997;Build 11
COMPILE ;Recompile DS Input Template
        N TIUERR,Y,X,DMAX,MSGOK,MSGBAD,MSG
        S MSGBAD="The DS Input Template could not be recompiled. Contact the Help Desk."
        S Y=$$FIND1^DIC(.402,,"BX","TIU ENTER/EDIT DS",,,"TIUERR")
        I Y'>0 S MSG=MSGBAD G COMPILEX
        S X=$$GET1^DIQ(.402,Y_",",1815,,,"TIUERR") I $D(TIUERR) S MSG=MSGBAD G COMPILEX
        S X=$P(X,U,2)
        S DMAX=$$ROUSIZE^DILF
        D EN^DIEZ
COMPILEX        ;
        I $D(MSG) D BMES^XPDUTL(MSGBAD) Q
        Q
        ;
