%ZVEMDT ;DJB,VEDD**Trace a Field [3/9/95 6:35pm]
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
EN ;
 NEW CNT,DATA,FLD,FLD1,FLDCNT,I,LEVEL,MAR,MAR1,Z1,ZDD,ZNAME,ZNUMBER
 KILL ^TMP("VEE","VEDD",$J,"FLD")
 I FLAGP D PRINT^%ZVEMDPR ;Turn off printing
 D GETFLD G:FLAGQ EX D LIST G:FLAGG!(FLAGE) EX
 D TRACE G:FLAGQ EX D PRINT,ASK
EX ;
 KILL ^TMP("VEE","VEDD",$J,"FLD") S FLAGQ=1
 Q
GETFLD ;
 I $G(FLAGPRM)="VEDD",$G(%3)]"" S FLD=%3 Q  ;Parameter passing
 R !?2,"Enter Field Name: ALL FIELDS//",FLD:VEE("TIME") S:'$T FLD="^^" I FLD["^" S FLAGQ=1 S:FLD="^^" FLAGE=1 Q
 I FLD="?" D  G GETFLD
 . W !!?2,"Enter field name or any portion of name. I will display the field's path."
 . W !?2,"Use this option to see the INDIVIDUAL FIELD DD of a field that is"
 . W !?2,"decendent from a multiple.",!
 Q
LIST ;
 S ZDD="",FLDCNT=1
 F  S ZDD=$O(^TMP("VEE","VEDD",$J,"TMP",ZDD)) Q:ZDD=""!(FLAGQ)  S LEVEL=$P(^(ZDD),U,2),ZNAME="" F  S ZNAME=$O(^DD(ZDD,"B",ZNAME)) Q:ZNAME=""  I $E(ZNAME,1,$L(FLD))=FLD D LIST1 Q:FLAGQ
 I '$D(^TMP("VEE","VEDD",$J,"FLD")) W "   No such field name." S FLAGG=1
 S FLAGQ=0 Q
LIST1 ;
 S ZNUMBER=$O(^DD(ZDD,"B",ZNAME,"")) Q:^DD(ZDD,"B",ZNAME,ZNUMBER)=1
 D:FLDCNT=1 HD
 W ! W:$P(^DD(ZDD,ZNUMBER,0),U,2)>0 "Mult->" W ?6,$J(FLDCNT,3),".",?LEVEL*5+6,"  ",ZNAME,"  (",ZNUMBER,")"
 S ^TMP("VEE","VEDD",$J,"FLD",FLDCNT)=ZNAME_"^"_ZDD_"^"_ZNUMBER_"^"_LEVEL
 S FLDCNT=FLDCNT+1
 D:$Y>VEESIZE PAGE Q:FLAGQ
 Q
TRACE ;If more than one match do NUM
 W !
TRACE1 W !?2,"Select Number: "
 R FLD1:VEE("TIME") S:'$T FLD1="^^" S:FLD1="" FLD1="^" I FLD1["^" S FLAGQ=1 S:FLD1="^^" FLAGE=1 Q
 I FLD1'?1.N!(FLD1<1)!(FLD1>(FLDCNT-1)) D  G TRACE1
 . W $C(7),!?2,"Enter a number from the left hand column."
 S CNT=1,ZNAME(CNT)=$P(^TMP("VEE","VEDD",$J,"FLD",FLD1),U)
 S ZNUMBER(CNT)=$P(^(FLD1),U,3),ZDD=$P(^(FLD1),U,2)
 I $G(FLAGPRM)="VEDD",$G(%3)]"" S %3=ZNAME(CNT) ;Parameter passing
 Q:ZDD=ZNUM
 F  S CNT=CNT+1,ZNUMBER(CNT)=$P(^TMP("VEE","VEDD",$J,"TMP",ZDD),U,3),ZDD=^DD(ZDD,0,"UP"),ZNAME(CNT)=$P(^DD(ZDD,ZNUMBER(CNT),0),U) Q:ZDD=ZNUM
 Q
PRINT ;Print data.
 W @VEE("IOF"),!!!,?VEE("IOM")\2-11,"F I E L D    T R A C E",!,$E(VEELINE1,1,VEE("IOM"))
 S MAR=5,MAR1=15
 F  W !!?MAR,ZNUMBER(CNT),?MAR1,ZNAME(CNT) S CNT=CNT-1 Q:CNT=0  S MAR=MAR+5,MAR1=MAR1+5
 Q
ASK ;
 I $Y'>VEESIZE F I=$Y:1:VEESIZE W !
 W !,$E(VEELINE1,1,VEE("IOM"))
 W ! S Z1=$$CHOICE^%ZVEMKC("MAIN_MENU^INDIV_FLD_DD",1)
 I Z1=2 D ^%ZVEMDI
 Q
PAGE ;
 D PAUSEQE^%ZVEMKC(2) Q:FLAGQ  D HD
 Q
HD ;Trace a field
 W @VEE("IOF"),!!,"MULTIPLE",?13,"1    2    3    4    5    6    7",!,"LEVELS",?13,"|    |    |    |    |    |    |",!,$E(VEELINE,1,VEE("IOM")),!
 Q
