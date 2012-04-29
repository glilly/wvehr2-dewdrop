ZZMKEDIT        ;SFISC/MKO-EDIT A ROUTINE ;4/17/11  07:07
        ;;21.0;VA FileMan;;Dec 28, 1994;Build 2
        N DDWRTN
        G EN
        ;
EDIT(DDWRTN)    ;Use the Screen Editor to edit a routine.
EN      ;Entry point to jump around the EDIT entry point, which requires
        ;parameter passing syntax.  (Called from ^ZZMKEDIT.)
        N DDWI,DDWIC,DDWNEW,DDWX,X,Y,%,%X,%Y
        N DIR,DIROUT,DIRUT,DTOUT,DUOUT
        N DIE,XCM,XCN,DTIME
        S DTIME=3600
        ;
        I $G(DDWRTN)]"" D
        . D LOAD(.DDWRTN)
        E  D
        . X ^%ZOSF("EON")
        . K DIR
        . S DIR(0)="FO^1:8^K:X?.E1.C.E!'(X?1""%""1.7AN!(X?1A1.7AN)) X"
        . S DIR("A")="Edit routine"
        . S DIR("?")="Enter the name of a routine, without the leading up-arrow"
        . ;
        . F  D  Q:$G(DDWRTN)]""
        .. W ! D ^DIR I $D(DIRUT) S DDWRTN=U Q
        .. S DDWRTN=X
        .. X ^%ZOSF("TEST") S DDWNEW='$T
        .. I DDWNEW D
        ... D ADD(.DDWRTN) Q:U[$G(DDWRTN)
        ... S DDWIC=$F(^TMP("DDWRTN",$J,1,0),"-")
        .. E  D LOAD(.DDWRTN)
        Q:U[$G(DDWRTN)
        ;
CALL    ;Call Screen Editor
        D EDIT^DDW("^TMP(""DDWRTN"",$J)","M",DDWRTN,"Routine: "_DDWRTN,,$G(DDWIC))
        ;
        ;Prompt whether to save changes
        K DIR
        S DIR(0)="YO"
        S DIR("A")="Do you want to save changes to routine "_DDWRTN
        S DIR("?",1)="Enter 'YES' to save your changes."
        S DIR("?",2)="Enter 'NO' or '^' to discard your changes."
        S DIR("?")="Press <RET> to return to the editor."
        W ! D ^DIR
        I Y="" K DUOUT,DIRUT,DIROUT,DTOUT,DIR,X,Y G CALL
        G:$D(DIRUT)!'Y QUIT
        ;
        ;Time stamp routine
        S $P(^TMP("DDWRTN",$J,1,0),";",3)=$$NOW
        ;
        ;Remove extra spaces
        S DDWI=0
        F  S DDWI=$O(^TMP("DDWRTN",$J,DDWI)) Q:'DDWI  D
        . S DDWX=^TMP("DDWRTN",$J,DDWI,0)
        . S DDWX=$$STRIP(DDWX)
        . S ^TMP("DDWRTN",$J,DDWI,0)=$$LS(DDWX)
        ;
        ;Save routine
        S X=DDWRTN,XCN=0,DIE="^TMP(""DDWRTN"",$J,"
        X ^%ZOSF("SAVE")
        ;
        ;Write routine size
        ;X "ZL "_DDWRTN_" X ^%ZOSF(""SIZE"")"
        ;W !!,"Routine size: "_Y
        ;X "ZL "_DDWRTN_" X ^ZZMKEDIT(""SIZE"")"
        ;W !,"Routine size (excluding commented lines): "_Y,!
        ;
QUIT    K ^TMP("DDWRTN",$J)
        Q
        ;
ADD(DDWRTN)     ;Add routine
        I $$LOADCHK(DDWRTN) D  Q
        . W !!,$C(7)_"Another process has just created routine "_DDWRTN
        . S DDWRTN=""
        ;
        ;Prompt user
        N DIR,DIRUT,DUOUT,DTOUT,DIROUT,INIT,X,Y
        S DIR(0)="Y"
        S DIR("A")="Is "_DDWRTN_" a new routine"
        S DIR("?")="Answer 'YES' if you want to create routine "_DDWRTN_"."
        W ! D ^DIR
        I $D(DIRUT)!'Y S DDWRTN="" Q
        ;
        K DIR
        S DIR(0)="FO^1:15"
        S DIR("A")="Programmer initials"
        S DIR("?")="Enter your initials, which will appear on the first line of the routine."
        W ! D ^DIR
        I $D(DUOUT)!$D(DTOUT) S DDWRTN="" Q
        S INIT=Y
        ;
        K ^TMP("DDWRTN",$J)
        S ^TMP("DDWRTN",$J)=DDWRTN
        ;
        ;Create routine in ^TMP
        S ^TMP("DDWRTN",$J,1,0)=$$SP(DDWRTN_" ;SFISC/"_INIT_"- ;")
        S ^TMP("DDWRTN",$J,2,0)=$$SP(" ;;1.0")
        Q
        ;
LOAD(DDWRTN)    ;Load routine into ^TMP
        N DDWI,DDWX
        ;
        ;Check if routine is already loaded in ^TMP
        I $$LOADCHK(DDWRTN) D  Q
        . W !,$C(7)_"Another process is already editing routine "_DDWRTN,!
        . S DDWRTN=""
        ;
        ;Load routine into ^TMP
        W !,"Loading ",DDWRTN
        K ^TMP("DDWRTN",$J)
        S ^TMP("DDWRTN",$J)=DDWRTN
        F DDWI=1:1 S DDWX=$T(+DDWI^@DDWRTN) Q:DDWX=""  D
        . S ^TMP("DDWRTN",$J,DDWI,0)=$$SP(DDWX)
        Q
        ;
LOADCHK(RTN)    ;Check if routine is already loaded by another process
        N J
        S J=""
        F  S J=$O(^TMP("DDWRTN",J)) Q:J=""  I RTN=^TMP("DDWRTN",J),J'=$J Q
        Q J]""
        ;
LS(X)   ;Replace multiple line start characters with a single space
        N I,P1,P2
        I $G(X)="" S X=" "
        E  I X?1." ".E D
        . F I=1:1:$L(X) Q:$E(X,I+1)'=" "
        . S $E(X,1,I)=" "
        E  D
        . S P1=$F(X," ")-1
        . I P1<0 S X=X_" " Q
        . F P2=P1:1:$L(X) Q:$E(X,P2+1)'=" "
        . S $E(X,P1,P2)=" "
        Q X
        ;
SP(X,N) ;Replace line start character with up to N spaces (default=8)
        N BODY,TAG,SP
        S:$G(N)<1 N=8
        S SP=$J("",N)
        I $G(X)="" S X=""
        E  I X?1" ".E S $E(X,1)=SP
        E  D
        . S TAG=$P(X," "),BODY=$P(X," ",2,999)
        . I $L(TAG)<N S X=TAG_$E(SP,1,N-$L(TAG))_BODY
        . E  S X=TAG_"  "_BODY
        Q X
        ;
STRIP(X)        ;Strip trailing blanks from X
        Q:X[";;=" X
        N I
        F I=$L(X):-1:0 Q:$E(X,I)'=" "
        S X=$E(X,1,I)
        Q X
        ;
NOW()   ;Return current time in external form
        N %,%I,%H,AP,HR,MIN,MON,TIM,X
        D NOW^%DTC
        S TIM=$P(%,".",2)
        S HR=$E(TIM,1,2)
        S AP=$S(HR<12:"AM",1:"PM")
        S HR=$S(HR<13:+HR,1:HR#12)
        S MIN=$E(TIM_"0000",3,4)
        ;
        S MON=$P("Jan^Feb^Mar^Apr^May^Jun^Jul^Aug^Sep^Oct^Nov^Dec",U,%I(1))
        Q HR_":"_MIN_" "_AP_"  "_%I(2)_" "_MON_" "_(%I(3)+1700)
