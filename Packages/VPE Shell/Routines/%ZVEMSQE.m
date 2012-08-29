%ZVEMSQE ;DJB,VSHL**QWIKs - Edit Name,Code,Description,Param,Box [9/9/95 6:34pm]
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
NAME ;Edit QWIK Name
 Q:$G(NAM)']""  Q:'$D(^%ZVEMS("QU",VEE("ID"),NAM))
 I $G(FLAGJMP) Q:FLAGJMP'=1
 S CD=NAM D SCREEN^%ZVEMKEA("Edit NAME: ",1,VEE("IOM")-1)
 D JUMP^%ZVEMSQA Q:FLAGJMP
 I VEESHC="<ESCH>" D MSG^%ZVEMSQA(1) G NAME
 I ",<ESC>,<F1E>,<F1Q>,<TO>,"[(","_VEESHC_",") S FLAGQ=1 Q
 I VEESHC="<TAB>" Q
 I VEESHC'="<RET>",VEESHC?1"<".E1">".E G NAME
 S CD=$$ALLCAPS^%ZVEMKU(CD) I NAM=CD Q
 I CD']""!(CD="^") G:$$ASKDEL^%ZVEMSQU()'=1 NAME KILL ^%ZVEMS("QU",VEE("ID"),NAM) S VEESHC="<TAB>" W !!?1,NAM," deleted.." Q
 I CD'?1A.7AN D MSG^%ZVEMSQA(1) G NAME
 I $D(^%ZVEMS("QU",VEE("ID"),CD)) D MSG^%ZVEMSQA(6) G NAME
 S ^%ZVEMS("QU",VEE("ID"),CD)=^%ZVEMS("QU",VEE("ID"),NAM)
 NEW X S X="" F  S X=$O(^%ZVEMS("QU",VEE("ID"),NAM,X)) Q:X=""  S ^%ZVEMS("QU",VEE("ID"),CD,X)=^%ZVEMS("QU",VEE("ID"),NAM,X)
 KILL ^%ZVEMS("QU",VEE("ID"),NAM)
 S NAM=CD
 Q
 ;====================================================================
CODE ;Get M Code
 I $G(FLAGJMP),$D(^%ZVEMS("QU",VEE("ID"),NAM)) Q:FLAGJMP'=2
 S (CD,CDHLD)=$G(^%ZVEMS("QU",VEE("ID"),NAM))
CODE1 D SCREEN^%ZVEMKEA("Edit CODE: ",1,VEE("IOM")-1)
 D JUMP^%ZVEMSQA Q:FLAGJMP
 I CD="?"!(CD="??")!(VEESHC="<ESCH>") D MSG^%ZVEMSQA(2) G CODE
 I VEESHC="<ESCU>",CD]"" W $C(7) Q
 I VEESHC="<ESCU>" D UNSAVE^%ZVEMSQA I CD']"" G CODE
 I ",<ESC>,<F1E>,<F1Q>,<TO>,"[(","_VEESHC_",") S FLAGQ=1 Q
 I VEESHC="<TAB>" Q
 I VEESHC'="<RET>",VEESHC'="<ESCU>",VEESHC?1"<".E1">".E G CODE
 I CD']""!(CD="^") G:'$$ASKDEL^%ZVEMSQU() CODE  KILL ^%ZVEMS("QU",VEE("ID"),NAM) S VEESHC="<TAB>" W !!?1,NAM," deleted.." Q
 D KILLCHK^%ZVEMKU(CD)
 I CD'=CDHLD  S ^%ZVEMS("QU",VEE("ID"),NAM)=CD
 I VEESHC="TOO LONG" G CODE1
 Q
 ;====================================================================
TEXT(TYPE) ;Text for Description and Param Notes. TYPE=DSC or PARAM
 I $G(TYPE)'="DSC",$G(TYPE)'="PARAM" Q
 Q:'$D(^%ZVEMS("QU",VEE("ID"),NAM))
 I $G(FLAGJMP) Q:TYPE="DSC"&(FLAGJMP'=3)  Q:TYPE="PARAM"&(FLAGJMP'=4)
TEXT1 I TYPE="DSC" S CD=$P($G(^%ZVEMS("QU",VEE("ID"),NAM,"DSC")),"^",1),PROMPT="Edit DESCRIPTION: "
 I TYPE="PARAM" S CD=$P($G(^%ZVEMS("QU",VEE("ID"),NAM,"DSC")),"^",2),PROMPT="Edit PARAM NOTES: "
 D SCREEN^%ZVEMKEA(PROMPT,1,VEE("IOM")-1)
 D JUMP^%ZVEMSQA Q:FLAGJMP
 I CD="?"!(CD="??")!(VEESHC="<ESCH>") D MSG^%ZVEMSQA(3) G TEXT1
 I ",<ESC>,<F1E>,<F1Q>,<TO>,"[(","_VEESHC_",") S FLAGQ=1 Q
 S:CD="^" VEESHC="<TAB>" Q:VEESHC="<TAB>"
 I VEESHC'="<RET>",VEESHC?1"<".E1">".E G TEXT1
 I CD["^" D MSG^%ZVEMSQA(4) G TEXT1
 I CD]"",CD'?1.55ANP W $C(7) D MSG^%ZVEMSQA(3) G TEXT1
 I TYPE="DSC" S $P(^%ZVEMS("QU",VEE("ID"),NAM,"DSC"),"^",1)=CD
 I TYPE="PARAM" S $P(^%ZVEMS("QU",VEE("ID"),NAM,"DSC"),"^",2)=CD
 Q
 ;====================================================================
BOX ;Display Box
 Q:'$D(^%ZVEMS("QU",VEE("ID"),NAM))
 I $G(FLAGJMP) Q:FLAGJMP'=5
 S CD=$P($G(^%ZVEMS("QU",VEE("ID"),NAM,"DSC")),"^",3)
 D SCREEN^%ZVEMKEA("Edit BOX: ",1,VEE("IOM")-1)
 D JUMP^%ZVEMSQA Q:FLAGJMP
 I CD="?"!(CD="??")!(VEESHC="<ESCH>") D MSG^%ZVEMSQA(5) G BOX
 I ",<ESC>,<F1E>,<F1Q>,<TO>,"[(","_VEESHC_",") S FLAGQ=1 Q
 S:CD="^" VEESHC="<TAB>" Q:VEESHC="<TAB>"
 I VEESHC'="<RET>",VEESHC?1"<".E1">".E G BOX
 I CD]"",CD'?1.N!(CD'>0) W $C(7) D MSG^%ZVEMSQA(5) G BOX
 S $P(^%ZVEMS("QU",VEE("ID"),NAM,"DSC"),"^",3)=CD
 Q
