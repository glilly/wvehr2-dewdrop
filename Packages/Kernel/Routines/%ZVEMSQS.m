%ZVEMSQS ;DJB,VSHL**QWIKs - List & Select [9/9/95 7:50pm]
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
QWIK(CD) ;User's entry used the "." or ".." syntax.
 NEW I,TYPE
 KILL ^TMP("VPE",$J)
 D PARAMS G:CD']"" EX D GETTYPE G:CD']"" EX D GETCODE
EX ;
 KILL ^TMP("VPE",$J)
 S VEESHC=CD I CD']"" F I=1:1:9 KILL @("%"_I)
 Q
PARAMS ;Identify passed parameters.
 NEW CK,CNT,J,P,PAR,TMP
 ;Find spaces that aren't between quotes.
 S (CK,CNT)=0 F  S CNT=CNT+1 Q:$E(CD,CNT)=""  D  ;
 . S:$E(CD,CNT)="""" CK=CK=0  Q:CK  Q:$E(CD,CNT)'=" "
 . S CD=$E(CD,1,CNT-1)_$C(127)_$E(CD,CNT+1,99)
 ;Set parameter variables.
 F I=1:1:9 S P="%"_I,@P=$P(CD,$C(127),I+1)  D  ;
 . ;Get rid of double quotes
 . Q:$E(@P)'=""""  S @P=$E(@P,2,$L(@P)-1) Q:@P'[""""""
 . S PAR=@P,TMP=""
 . F J=1:1:$L(PAR,"""""") D  ;
 . . S TMP=TMP_$P(PAR,"""""",J)_$S(J'=$L(PAR,""""""):"""",1:"")
 . S @P=TMP
 S CD=$P(CD,$C(127),1)
 Q
GETTYPE ;Get the type of QWIK. 1=User  2=System
 S TYPE=$S(CD?1"..".E:2,1:1)
 S (CD,VEESHC)=$E(CD,TYPE+1,99) Q:CD]""
 D @$S(TYPE=2:"SYSTEM",1:"USER") ;User typed . or .. only.
 Q
GETCODE ;Get QWIK command code.
 I TYPE=2 S CD=$S($D(^%ZVEMS("QS",CD,VEE("OS"))):^(VEE("OS")),$D(^%ZVEMS("QS",CD)):^(CD),1:"")
 E  S CD=$S($D(^%ZVEMS("QU",VEE("ID"),CD,VEE("OS"))):^(VEE("OS")),$D(^%ZVEMS("QU",VEE("ID"),CD)):^(CD),1:"")
 Q:CD]""  D @$S(TYPE=1:"LOOKUPU",1:"LOOKUPS")
 Q
LOOKUPU ;Look up User QWIKs
 NEW CNT,FLAGQ,HLD,STAT
 S CNT=1,FLAGQ=0,HLD=VEESHC
 W ! F  S HLD=$O(^%ZVEMS("QU",VEE("ID"),HLD)) Q:HLD']""!FLAGQ!($E(HLD,1,$L(VEESHC))'=VEESHC)  D  ;
 . W !,$J(CNT,3),". ",HLD,?15,$P($G(^(HLD,"DSC")),"^",1)
 . S STAT=$E($O(^%ZVEMS("QU",VEE("ID"),HLD)),1,$L(VEESHC))'=VEESHC
 . S ^TMP("VPE",$J,CNT)=$S($D(^%ZVEMS("QU",VEE("ID"),HLD,VEE("OS"))):^(VEE("OS")),$D(^%ZVEMS("QU",VEE("ID"),HLD)):^(HLD),1:"")
 . S CNT=CNT+1
 . I STAT D ASK Q
 . I CNT#6=0 D ASK Q
 D:CNT=1 NOQWIK
 Q
LOOKUPS ;Look up System QWIKs
 NEW CNT,FLAGQ,HLD,STAT
 S CNT=1,FLAGQ=0,HLD=VEESHC
 W ! F  S HLD=$O(^%ZVEMS("QS",HLD)) Q:HLD']""!FLAGQ!($E(HLD,1,$L(VEESHC))'=VEESHC)  D  ;
 . W !,$J(CNT,3),". ",HLD,?15,$P($G(^(HLD,"DSC")),"^",1)
 . S STAT=$E($O(^%ZVEMS("QS",HLD)),1,$L(VEESHC))'=VEESHC
 . S ^TMP("VPE",$J,CNT)=$S($D(^%ZVEMS("QS",HLD,VEE("OS"))):^(VEE("OS")),$D(^%ZVEMS("QS",HLD)):^(HLD),1:"")
 . S CNT=CNT+1
 . I STAT D ASK Q
 . I CNT#6=0 D ASK Q
 D:CNT=1 NOQWIK
 Q
ASK ;
 NEW ASK
ASK1 I 'STAT W !?1,"TYPE '^' TO STOP, OR"
 W !?1,"CHOOSE 1-"_(CNT-1)_": "
 R ASK:300 S:'$T ASK="^" I "^"[ASK S:ASK="^" FLAGQ=1 Q
 I ASK?1.N,$D(^TMP("VPE",$J,ASK)) S CD=^(ASK),FLAGQ=1 Q
 W $C(7),"   ??"
 G ASK1
NOQWIK ;Bogus QWIK entered
 W $C(7),!?1,"No such QWIK Command."
 W:TYPE=1 " Is your VPE ID correct?"
 S CD=""
 Q
 ;====================================================================
USER ;List User QWIKs
 NEW COL,FLAGQ,HD,NM
 I '$D(^%ZVEMS("QU",VEE("ID"))) W "   No User QWIKs on record" Q
 S COL=0,NM="@",FLAGQ=0,HD="U S E R" D HD
 F  S NM=$O(^%ZVEMS("QU",VEE("ID"),NM)) Q:NM=""!FLAGQ  D LIST
 W !
 Q
SYSTEM ;List System QWIKs
 NEW COL,FLAGQ,HD,NM
 I '$D(^%ZVEMS("QS")) W "   No System QWIKs on record" Q
 S COL=0,NM="@",FLAGQ=0,HD="S Y S T E M" D HD
 F  S NM=$O(^%ZVEMS("QS",NM)) Q:NM=""!FLAGQ  D LIST
 W !
 Q
LIST ;List QWIKs
 I 'COL W ! I $Y>(VEE("IOSL")-5) D PAUSEQ^%ZVEMKC(1) Q:FLAGQ  W @VEE("IOF"),!
 W ?COL,NM S COL=$S(COL<(VEE("IOM")-10):COL+10,1:0)
 Q
HD ;Heading
 S HD=HD_"   Q W I K S"
 W @VEE("IOF"),!?1,HD,!
 W $E("-----------------------------",1,$L(HD)+2)
 Q
