USRCLST ; SLC/JER - Review User Classes ;11/25/09
        ;;1.0;AUTHORIZATION/SUBSCRIPTION;**1,3,7,33**;Jun 20, 1997;Build 7
MAKELIST        ; Build review screen list
        N STATUS,FNAME,LNAME
        S STATUS=$$SELSTAT("ACTIVE")
        I +STATUS<0 S VALMQUIT=1 Q
        S FNAME=$$RANGE("        Start With Class","FIRST")
        I +FNAME=-1 S VALMQUIT=1 Q
        S LNAME=$$RANGE("             Go To Class","LAST")
        I +LNAME=-1 S VALMQUIT=1 Q
        W !,"Searching for the User Classes."
        D BUILD(STATUS,FNAME,LNAME)
        Q
SELSTAT(DEFLT)  ; Select User Class status
        N DIC,XQORM,X,Y
        S DIC=101,DIC(0)="X",X="USR CLASS STATUS SELECT" D ^DIC
        I +Y>0 D
        . S XQORM=+Y_";ORD(101,",XQORM(0)="1A",XQORM("A")="Select User Class Status: " ;ICR 872
        . S XQORM("B")=DEFLT D ^XQORM
        . I +Y,($D(Y)>9) S Y=$S($P(Y(1),U,3)="Inactive":0,$P(Y(1),U,3)="Active":1,1:2)
        Q Y
RANGE(PROMPT,DEFAULT)   ; Get range of classes to browse
        N Y
        S Y=$$READ^USRU("F^1:20",PROMPT,DEFAULT) ; Y^Y(0)
        I Y="^" S Y=-1 Q Y
        S Y=$S(Y["FIRST":"",Y["LAST":"ZZZZ",1:$P(Y,U))
        Q Y
BUILD(SELSTAT,USRFNM,USRLNM)    ; Build List
        N USRPICK,USRJ,NODE0,STATUS,USRUPNM,CLNM,CLIEN,CLABB,USRCNT,USRREC
        N USRABBR,STATUSNM,NODE0,NAME,CLSTATNM,USRFNMX,USRLNMX,PREFIX
        S VALMCNT=0
        S USRPICK=+$O(^ORD(101,"B","USR ACTION SELECT LIST ELEMENT",0)) ;ICR 872
        ; P33 DRAFT
        K ^TMP("USRCLASS",$J),^TMP("USRCLASSIDX",$J),^TMP("USRUPCL",$J)
        S USRFNMX=$S(USRFNM]"":$$UP^XLFSTR($E(USRFNM)),1:USRFNM)
        S USRLNMX=$$LOW^XLFSTR(USRLNM)_"z"
        ; -- S ^TMP("USRUPCL",$J,UPPERCASE NAME,IEN,STATNM) by Uppercase .01 name --
        F  D  Q:$O(^USR(8930,USRJ))'>0
        . N NAME
        . S USRJ=$G(USRJ)+1,STATUS=""
        . ; -- Reject unselected statuses --
        . I $D(^USR(8930,"D",1,USRJ)) S STATUS=1
        . I $D(^USR(8930,"D",0,USRJ)) S STATUS=0
        . I STATUS']"" Q
        . I SELSTAT'=2,STATUS'=SELSTAT Q
        . S NODE0=$G(^USR(8930,USRJ,0)),NAME=$P(NODE0,U)
        . Q:NODE0']""
        . ; -- Reject entries clearly outside alpha boundaries --
        . I USRFNMX]NAME Q
        . I NAME]USRLNMX Q
        . S STATUSNM=$S(STATUS=0:"INACTIVE",STATUS=1:"ACTIVE",1:"??")
        . S USRABBR=$P(NODE0,U,2)
        . S USRUPNM=$$UP^XLFSTR(NAME)
        . S ^TMP("USRUPCL",$J,USRUPNM,USRJ,STATUSNM)=USRABBR_U_NAME
        ; -- Loop thru TMP("USRUPCL" and set info into USRREC array --
        ;  ; -- Now we're dealing with uppercase only so get exact boundaries --
        S USRFNMX=$$UP^XLFSTR(USRFNM),USRLNMX=$$UP^XLFSTR(USRLNM)_"Z"
        S CLNM=$S($G(USRFNMX)]"":$O(^TMP("USRUPCL",$J,USRFNMX),-1),1:"")
        F  S CLNM=$O(^TMP("USRUPCL",$J,CLNM)) Q:CLNM=""  Q:CLNM]USRLNMX  D
        . N NAME,TMP0
        . ; -- CLASS NAMES may not be unique --
        . S CLIEN="" F  S CLIEN=$O(^TMP("USRUPCL",$J,CLNM,CLIEN)) Q:+CLIEN'>0  D
        . . S PREFIX=+$O(^USR(8930,+CLIEN,1,0))
        . . S PREFIX=$S(PREFIX>0:"+",1:"")
        . . S CLSTATNM=$O(^TMP("USRUPCL",$J,CLNM,CLIEN,""))
        . . S TMP0=^TMP("USRUPCL",$J,CLNM,CLIEN,CLSTATNM)
        . . S CLABB=$P(TMP0,U),NAME=$P(TMP0,U,2)
        . . S USRCNT=+$G(USRCNT)+1
        . . S USRREC=$$SETFLD^VALM1(USRCNT,"","NUMBER")
        . . S USRREC=$$SETFLD^VALM1(PREFIX_NAME,USRREC,"CLASS NAME")
        . . S USRREC=$$SETFLD^VALM1(CLABB,USRREC,"ABBREVIATION")
        . . I SELSTAT=2 S USRREC=$$SETFLD^VALM1(CLSTATNM,USRREC,"ACTIVE")
        . . S VALMCNT=+$G(VALMCNT)+1
        . . S ^TMP("USRCLASS",$J,VALMCNT,0)=USRREC
        . . S ^TMP("USRCLASS",$J,"IDX",VALMCNT,USRCNT)=""
        . . S ^TMP("USRCLASSIDX",$J,USRCNT)=VALMCNT_U_CLIEN_U W:VALMCNT#10'>0 "."
        ;Clear the video attributes so we start fresh.
        D KILL^VALM10(VALMCNT) K ^TMP("USRUPCL",$J)
        S ^TMP("USRCLASS",$J,0)=+$G(USRCNT)_U_SELSTAT_U_USRFNM_U_USRLNM
        S ^TMP("USRCLASS",$J,"#")=USRPICK_U_"1:"_+$G(USRCNT)
        I $D(VALMHDR)>9 D HDR
        I +$G(USRCNT)'>0 D
        . S ^TMP("USRCLASS",$J,1,0)=""
        . S ^TMP("USRCLASS",$J,2,0)="No "_$S(SELSTAT=0:"Inactive ",SELSTAT=1:"Active ",1:"")_"User Classes found"
        . S VALMCNT=2
        Q
         ;
HDR     ; Initialize header for review screen
        N BY,USRX,USRCNT,SCREEN,STATUS,TITLE
        S USRX=$G(^TMP("USRCLASS",$J,0)),STATUS=$P("INACTIVE^ACTIVE^ALL",U,+$P(USRX,U,2)+1)
        S TITLE=STATUS_" USER CLASSES"
        S USRCNT=$J(+$G(^TMP("USRCLASS",$J,0)),4)
        S USRCNT=USRCNT_" Class"_$S(+USRCNT=1:"",1:"es")
        S VALMHDR(1)=$$CENTER^USRLS(TITLE)
        S VALMHDR(1)=$$SETSTR^VALM1(USRCNT,VALMHDR(1),(IOM-$L(USRCNT)),$L(USRCNT))
        Q
CLEAN   ; "Joel...Clean up your mess!"
        K ^TMP("USRCLASS",$J),^TMP("USRCLASSIDX",$J)
        Q
