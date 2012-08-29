%ZVEMOSS ;DJB,VRROLD**Routine String Search [5/17/97 7:09am]
 ;;7.0;VPE;;COPYRIGHT David Bolduc @1993
 ;
 NEW ASK,CHK,CNT,CODE1,CODE2,CODE3,FLAGA,FLAGQ,I,I1,I2,NUMR,NUMS,QUIT,RTN,STRING,TIC,TXT
 D INIT
 I '$D(^%ZOSF("RSEL")),$G(VEE("OS"))="" D OS^%ZVEMKY G:FLAGQ EX
TOP ;
 KILL ^UTILITY($J)
 S FLAGQ=0
 D @$S($D(^%ZOSF("RSEL")):"ZOSF",1:VEE("OS"))
 I $O(^UTILITY($J,""))="" G EX
 D STRG G:'$D(STRING(1))!FLAGQ TOP
 D LIST
 G TOP
EX ;
 KILL ^UTILITY($J)
 Q
ZOSF ;Use ^%ZOSF("RSEL")
 NEW %,X
 X ^%ZOSF("RSEL")
 Q
2 ;Routine Select for DSM Mumps
 D ^%RSEL
 Q
8 ;Routine Select for MSM Mumps
 D INT^%RSEL
 Q
9 ;Routine Select for DataTree Mumps
 NEW RTN
 KILL ^%RSET($J)
 W $$^%rselect
 I $O(^%RSET($J,""))="" Q
 S RTN=""
 F  S RTN=$O(^%RSET($J,RTN)) Q:RTN=""  S ^UTILITY($J,RTN)=""
 KILL ^%RSET($J)
 Q
16 ;Routine Select for VAX DSM Mumps
 NEW %UTILITY
 D ^%RSEL Q:$O(%UTILITY(""))=""
 S RTN=""
 F  S RTN=$O(%UTILITY(RTN)) Q:RTN=""  S ^UTILITY($J,RTN)=""
 Q
18 ;Rtn Select for OpenM
 KILL ^UTILITY($J)
 I $L($T(KERNEL^%RSET)) D KERNEL^%RSET KILL %ST Q  ;VA Kernel rtn
 NEW %JO,%UR,%R
 S %JO=$J,%UR="^ROUTINE",%R=0 D ROU^%RSET
 Q
STRG ;Get String
 KILL STRING
 S CNT=0 W !
STRG1 W !,"Enter search string: "
 R STRING:300 I "^"[STRING S:STRING="^" FLAGQ=1 Q
 I "??"[STRING D HELP G:ASK'="S" STRG1
 S CNT=CNT+1,STRING(CNT)=STRING
 G STRG1
LIST ;List routines
 S RTN="",(FLAGA,FLAGQ,NUMR,NUMS,TIC)=0,CHK=1 W !
 F I=1:1 S RTN=$O(^UTILITY($J,RTN)) Q:RTN=""!FLAGQ  D  ;
 . X "ZL @RTN X CODE1,CODE2"
 . S NUMR=NUMR+1 S:TIC NUMS=NUMS+1 W:TIC ! S TIC=0
 W !!?1,$J(NUMR,4)," Routine",$S(NUMR=1:" ",1:"s "),"searched."
 W !?1,$J(NUMS,4)," Routine",$S(NUMS=1:" ",1:"s "),"contained search string(s)."
 Q
HELP ;User entered '?' at STRING prompt
 W ?25,"Do you want Help, or to search for "
 W $S(STRING="?":"'?'",1:"'??'"),!?25,"Select [H]elp or [S]earch: "
 R ASK:300 Q:"^"[ASK  I "Ss"[$E(ASK) S ASK="S" Q
 W !!?3,"Enter any character string. The selected routines will be searched"
 W !?3,"and any line containing the string will be displayed. You may"
 W !?3,"enter more than 1 search string.",!
 W !?3,"Whenever the display stops at a program line that contains a"
 W !?3,"string, you may enter <RETURN> to contine, '^' to quit, '?' for"
 W !?3,"Help, or 'A' for Autoprint. When Autoprint is active the display"
 W !?3,"will not stop at each line containing a string.",!
 Q
INIT ;
 S CODE1="W !,RTN,""  """
 S CODE2="F I1=1:1 S TXT=$T(+I1) Q:TXT=""""!FLAGQ  F I2=1:1:CNT I TXT[STRING(I2) W !!,RTN,""+"",I1-1,"" -->"",TXT S TIC=1 X:'FLAGA CODE3 Q"
 S CODE3="R ASK:300 S:ASK=""a"" ASK=""A"" R:""^,A""'[ASK !!?2,""<RETURN>=Continue  ^=Quit  A=AutoPrint"",!?2,""Select: "",ASK:300 S:ASK[""^"" FLAGQ=1 S:ASK=""A"" FLAGA=1"
 Q
