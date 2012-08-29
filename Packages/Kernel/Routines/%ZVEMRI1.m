%ZVEMRI1 ;DJB,VRR**INSERT - RETURN,TAB,OPEN,CLOSE ; 12/25/00 5:34pm
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
RETURN ;<RETURN> key hit
 ;
 ;If user hasn't hit <TAB>, go ahead and insert it for him.
 ;I $G(CD)]"" D MSG^%ZVEMRUM(20) Q  ;Stop giving msg.
 I $G(CD)]"" D TAB Q
 ;
 ;If no code has been added to CD, close the open line.
 D CLOSE S FLAGQ=1 Q
 Q
 ;
TAB ;<TAB> key hit
 ;Process line start character. Setup CD to match scroll nodes.
 NEW TXT
 I $$TAGCHK^%ZVEMRV(CD) Q  ;Bad line tag
 S FLAGQ=1
 I $G(CD)]"" D  I 1
 . S TXT=$J("",8-$L(CD))_CD_" "_$C(30)
 E  S TXT=LNNUM,TXT=TXT_$J("",9-$L(TXT))_$C(30)
 S ^TMP("VEE","IR"_VRRS,$J,YND)=TXT
 W @VEES("BLANK_SOL_C")
 S DX=0,DY=YCUR X VEES("CRSR")
 W $P(TXT,$C(30),1)
 S XCUR=$X
 D REDRAW^%ZVEMREO(YND+1,VEET("BOT"))
 S DX=0,DY=YCUR X VEES("CRSR")
 Q
 ;
OPEN ;Open new line for inserting code
 ;Adj if no code exists in rtn
 I YND=1,$G(^TMP("VEE","IR"_VRRS,$J,YND))=" <> <> <>" D  ;
 . S (YCUR,YND)=0
 D OPEN^%ZVEMREO,ADJOPEN
 S VRRHIGH=VRRHIGH+1
 Q
 ;
CLOSE ;Close a line that's been deleted
 D ADJCLOS,CLOSE^%ZVEMREO
 S VRRHIGH=VRRHIGH-1
 ;Adj if line is closed leaving only " <> <> <>".
 I $G(^TMP("VEE","IR"_VRRS,$J,1))=" <> <> <>"!(YCUR<1)!(YND<1) D  ;
 . S (YCUR,YND)=1
 . S DX=0,DY=YCUR X VEES("CRSR")
 Q
 ;
ADJOPEN ;Adjust scroll array when opening a new line
 NEW END,I,NUM,NUM1
 S END=$O(^TMP("VEE","IR"_VRRS,$J,""),-1)
 F I=END+1:-1:YND+1 D  ;
 . S TMP=^TMP("VEE","IR"_VRRS,$J,I-1)
 . I TMP[$C(30) D  ;Adjust line number
 . . S NUM=+TMP Q:NUM'>0  S NUM1=NUM+1
 . . S TMP=NUM1_$E(TMP,$L(NUM1)+1,999)
 . S ^TMP("VEE","IR"_VRRS,$J,I)=TMP
 S ^TMP("VEE","IR"_VRRS,$J,YND)=""
 Q
 ;
ADJCLOS ;Adjust scroll array when closing a line
 NEW END,I,NUM,NUM1,TMP
 S END=$O(^TMP("VEE","IR"_VRRS,$J,""),-1)
 F I=YND:1:END-1 D  ;
 . S TMP=^TMP("VEE","IR"_VRRS,$J,I+1)
 . I TMP[$C(30) D  ;Adjust line number
 . . S NUM=+TMP Q:NUM'>0  S NUM1=NUM-1
 . . S TMP=NUM1_$J("",$L(NUM)-$L(NUM1))_$E(TMP,$L(NUM)+1,999)
 . S ^TMP("VEE","IR"_VRRS,$J,I)=TMP
 KILL ^TMP("VEE","IR"_VRRS,$J,END)
 Q
