USRMLST ; SLC/JER - List User Class Members ;3/23/10
        ;;1.0;AUTHORIZATION/SUBSCRIPTION;**2,3,4,9,33**;Jun 20, 1997;Build 7
MAIN    ; Control Branching
        N DIC,MSBPN,X,Y,USRDUZ
        ;MSBPN is set true if a user is missing the SIGNATURE BLOCK PRINT
        ;NAME.
        S MSBPN=0
        S DIC=8930,DIC(0)="AEMQ",DIC("A")="Select CLASS: "
        D ^DIC Q:+Y'>0
        S USRDA=+Y
        D EN^VALM(USRLTMPL)
        K USRLTMPL
        Q
MAKELIST        ; Build review screen list
        K VALMY
        W !,"Searching for the User Classes."
        D BUILD(USRDA)
        Q
BUILD(USRDA)    ; Build List
        N USRCNT,USRNAME,USRPICK
        S (USRCNT,VALMCNT)=0
        S USRPICK=+$O(^ORD(101,"B","USR ACTION SELECT LIST ELEMENT",0)) ;ICR 872
        K ^TMP("USRMMBR",$J),^TMP("USRMMBRIDX",$J),^TMP("USRM",$J)
        ;D WHOIS^USRLM("^TMP(""USRM"",$J)",USRDA)
        D WHOIS^USRLM("^TMP(""USRM"",$J)",USRDA,1) ; Display .01 Class name
        S USRNAME=0
        F  S USRNAME=$O(^TMP("USRM",$J,USRNAME)) Q:USRNAME=""  D
        . N USRDA,USRDUZ,USRSIGNM,USREFF,USREXP,USRMEM,USRREC,USRCLNM
        . S USRMEM=$G(^TMP("USRM",$J,USRNAME))
        . S USRDUZ=+USRMEM,USRSIGNM=$$SIGNAME^USRLS(+USRDUZ)
        . I USRSIGNM["?SBPN" S MSBPN=1
        .;If this user has been terminated change the name to reflect this.
        . I $$ISTERM^USRLM(+USRDUZ) S USRSIGNM="(T) "_USRSIGNM
        . S USRDA=+$P(USRMEM,U,2),USRCLNM=$P(USRMEM,U,3)
        . S USREFF=$$DATE^USRLS(+$P(USRMEM,U,4),"MM/DD/YY")
        . S USREXP=$$DATE^USRLS(+$P(USRMEM,U,5),"MM/DD/YY")
        . S USRCNT=+$G(USRCNT)+1
        . S USRREC=$$SETFLD^VALM1(USRCNT,"","NUMBER")
        . S USRREC=$$SETFLD^VALM1(USRSIGNM,USRREC,"MEMBER")
        . S USRREC=$$SETFLD^VALM1(USREFF,USRREC,"EFFECTIVE")
        . S USRREC=$$SETFLD^VALM1(USREXP,USRREC,"EXPIRES")
        . S USRREC=$$SETFLD^VALM1(USRCLNM,USRREC,"CLASS")
        . S VALMCNT=+$G(VALMCNT)+1
        . S ^TMP("USRMMBR",$J,VALMCNT,0)=USRREC
        . S ^TMP("USRMMBR",$J,"IDX",VALMCNT,USRCNT)=""
        . S ^TMP("USRMMBRIDX",$J,USRCNT)=VALMCNT_U_USRDA W:VALMCNT#10'>0 "."
        S ^TMP("USRMMBR",$J,0)=+$G(USRCNT)_U_$P(^TMP("USRM",$J,0),U,2)
        S ^TMP("USRMMBR",$J,"#")=USRPICK_U_"1:"_USRCNT
        I $D(VALMHDR)>9 D HDR
        I +$G(USRCNT)'>0 D
        . S ^TMP("USRMMBR",$J,1,0)="",VALMCNT=2
        . S ^TMP("USRMMBR",$J,2,0)="No "_$P(^TMP("USRM",$J,0),U,2)_"s found"
        Q
HDR     ; Initialize header for review screen
        N BY,USRX,USRCNT,TITLE,USRCLASS
        S USRX=$G(^TMP("USRMMBR",$J,0)),USRCLASS=$P(USRX,U,2)
        S TITLE=USRCLASS_"s"
        S USRCNT=$J(+USRX,4)_" Member"_$S(+USRX=1:"",1:"s")
        S VALMHDR(1)=$$CENTER^USRLS(TITLE)
        S VALMHDR(1)=$$SETSTR^VALM1(USRCNT,VALMHDR(1),(IOM-$L(USRCNT)),$L(USRCNT))
        I $G(MSBPN) D
        . S VALMSG="(?SBPN) missing SIGNATURE BLOCK PRINTED NAME"
        Q
CLEAN   ; "Joel...Clean up your mess!"
        K ^TMP("USRMMBR",$J),^TMP("USRMMBRIDX",$J),^TMP("USRM",$J)
        Q
