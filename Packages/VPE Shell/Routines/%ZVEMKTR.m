%ZVEMKTR ;DJB,KRN**Txt Scroll-Get REF Number [4/16/95 5:54am]
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
GETSCR(ND,PKG) ;Get scroll array equivilent for a given node
 ;ND=Node number from VGL display
 I $G(ND)'>0 Q 0
 I $G(PKG)']"" Q 0
 NEW X S X=0
 F  S X=$O(^TMP("VEE",PKG,$J,"SCR",X)) Q:X'>0  Q:^(X)=ND
 Q X
 ;====================================================================
GETREF(PKG) ;Get REF number. Return ^,***, or REF number 
 NEW DX,DY,REF,X I $G(PKG)']"" Q "^"
GETREF1 S DX=0,DY=(VEET("S2")+VEET("FT")-1)
 D CURSOR^%ZVEMKU1(DX,DY,1)
 W ?1,"Enter REF NUMBER: " S REF=$$READ^%ZVEMKRN()
 I REF="^" Q REF
 I ",<ESC>,<F1E>,<F1Q>,<RET>,<TO>,"[(","_VEE("K")_",") Q "^"
 I VEE("K")="<TAB>" D  Q REF
 . S REF=$G(^TMP("VEE",PKG,$J,"SCR",VEET("HLN")-1))
 . S:REF']"" REF="***"
 I VEE("K")?1"<A"1U1">" D  G GETREF1
 . I VEE("K")="<AU>" D  Q
 . . I VEET("HLN")-1=VEET("TOP") W $C(7) Q
 . . D HIGHLITE^%ZVEMKTM("OFF")
 . . S VEET("HLN")=VEET("HLN")-1,VEET("H$Y")=VEET("H$Y")-1
 . . D HIGHLITE^%ZVEMKTM("ON")
 . I VEE("K")="<AD>" D  Q
 . . I VEET("HLN")=VEET("BOT") W $C(7) Q
 . . D HIGHLITE^%ZVEMKTM("OFF")
 . . S VEET("HLN")=VEET("HLN")+1,VEET("H$Y")=VEET("H$Y")+1
 . . D HIGHLITE^%ZVEMKTM("ON")
 . I VEE("K")="<AL>" D  Q
 . . I VEET("HLN")-1=VEET("TOP") W $C(7) Q
 . . D HIGHLITE^%ZVEMKTM("OFF")
 . . S VEET("HLN")=VEET("TOP")+1,VEET("H$Y")=VEET("S1")
 . . D HIGHLITE^%ZVEMKTM("ON")
 . I VEE("K")="<AR>" D  Q
 . . I VEET("HLN")=VEET("BOT") W $C(7) Q
 . . D HIGHLITE^%ZVEMKTM("OFF")
 . . S VEET("HLN")=VEET("BOT"),VEET("H$Y")=VEET("S2")
 . . D HIGHLITE^%ZVEMKTM("ON")
 I $E(REF)="?"!(VEE("K")="<ESCH>") D MSG(1) G GETREF1
 I REF'>0!(REF'?1.N) W $C(7) D MSG(1) G GETREF1
 Q REF
 ;====================================================================
GETRANG(PKG) ;Get range of nodes. Return ^ or range of REF numbers
 NEW DX,DY,I,REF,REF1,REF2 Q:$G(PKG)']""
GETRANG1 S DX=0,DY=(VEET("S2")+VEET("FT")-1)
 D CURSOR^%ZVEMKU1(DX,DY,1)
 W ?1,"Enter REF NUMBERS(S): "
 R REF:VEE("TIME") S:'$T REF="^" I "^"[REF Q "^"
 I REF?1.N1"-"1.N D  G:REF']"" GETRANG1 Q REF
 . S REF1=$P(REF,"-"),REF2=$P(REF,"-",2)
 . I '$D(^TMP("VEE",PKG,$J,REF1))!('$D(^(REF2)))!(REF1>REF2) S REF="" D MSG(3) Q
 . S REF=REF1_"^"_REF2
 . Q
 I REF["," D  G:REF']"" GETRANG1 Q REF
 . F I=1:1:$L(REF,",") S REF1=$P(REF,",",I) D  Q:REF']""
 . . I REF1'>0 D MSG(1) S REF="" Q
 . . I '$D(^TMP("VEE",PKG,$J,REF1)) D MSG(1) S REF="" Q
 I REF'>0!(REF'?1.N) D  D MSG(4) G GETRANG1
 . Q:$E(REF)="?"!(REF="<ESCH>")  W $C(7)
 I '$D(^TMP("VEE",PKG,$J,REF)) D MSG(2) G GETRANG1
 Q REF_"^"_REF
 ;====================================================================
MSG(NUM) ;Messages
 ;NUM=Subroutine number
 Q:$G(NUM)'>0
 S DX=0,DY=(VEET("S2")+VEET("FT")-2)
 D CURSOR^%ZVEMKU1(DX,DY,1),@NUM
 Q
1 W "Enter REF number from left hand column or <TAB> for highlight." Q
2 W $C(7),"Invalid. Enter number from left hand column" Q
3 W $C(7),"Invalid range" Q
4 W "Enter number from left hand column, or range of numbers (Ex: 3-5 or 1,3,4)" Q
