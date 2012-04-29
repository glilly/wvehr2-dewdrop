USRL    ; SLC/JER - User class library ;11/12/09
        ;;1.0;AUTHORIZATION/SUBSCRIPTION;**3,7,33**;Jun 20, 1997;Build 7
        ;======================================================================
UPDATE(ITEM)    ; Updates list following edit
        N DA,USRREC,USRABB,USRCLNM,USRACT,USRITM
        N USRLREC,USREREC
        S DA=+$P(ITEM,U,2),USRREC=$G(^USR(8930,+DA,0))
        S USRITM=+ITEM
        ;S USRCLNM=$S(USRREC']"":"<Class DELETED>",$P(USRREC,U,4)]"":$P(USRREC,U,4),1:$$MIXED^USRLS($P(USRREC,U)))
        S USRCLNM=$S(USRREC']"":"<Class DELETED>",1:$P(USRREC,U))
        I +$D(^USR(8930,DA,1))>9 S USRCLNM="+"_USRCLNM
        S USRABB=$P(USRREC,U,2),USRACT=$S(+$P(USRREC,U,3):"Active",1:"Inactive")
        S USRLREC=$$SETFLD^VALM1(USRITM,$G(USRLREC),"NUMBER")
        S USRLREC=$$SETFLD^VALM1(USRCLNM,$G(USRLREC),"CLASS NAME")
        S USRLREC=$$SETFLD^VALM1(USRABB,$G(USRLREC),"ABBREVIATION")
        S USRLREC=$$SETFLD^VALM1(USRACT,$G(USRLREC),"ACTIVE")
        S USREREC=$$SETFLD^VALM1(USRITM,$G(USREREC),"NUMBER")
        S USREREC=$$SETFLD^VALM1(USRCLNM,$G(USREREC),"CLASS NAME")
        S USREREC=$$SETFLD^VALM1(USRABB,$G(USREREC),"ABBREVIATION")
        S USREREC=$$SETFLD^VALM1(USRACT,$G(USREREC),"ACTIVE")
        S ^TMP("USRCLASS",$J,+USRITM,0)=USRLREC
        D RESTORE^VALM10(+USRITM),CNTRL^VALM10(+USRITM,1,VALM("RM"),IOINHI,IOINORM)
        Q
RESTORE(ITEM)   ; Restore video attributes for a single list element
        D RESTORE^VALM10(ITEM),FLDCTRL^VALM10(ITEM,"NUMBER",IOINHI,IOINORM)
        Q
        ;
        ;======================================================================
VCLDN(NAME)     ;Screen for valid class display names.
        N LEN
        S LEN=$L(NAME)
        I (LEN<3)!(LEN>55) Q 0
        ;
        ;Don't allow "+" or "-", or "|" in the name.
        I (NAME["+")!(NAME["-")!(NAME["|") Q 0
        ;
        Q 1
        ;
