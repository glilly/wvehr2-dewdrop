%ZVEMDI ;DJB,VEDD**Indiv Fld Sum ; 12/8/00 7:23am
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
 NEW %,%XX,%Y,%YY,D,DDH,DIC,X,Y
 NEW A,CNT,DATA,FILE,FLD,FNAM,FNUM,I,LEV,M,ZDSUB
 ;
 D INIT
 D:FLAGP HD
 I $G(FLAGPRM)="VEDD",$G(%3)]"" NEW PARAM,XXX S PARAM=0 D GETFLDP G EX
 D GETFLD
 I FLAGP,$D(^TMP("VEE","VEDD",$J,"IND")) D PRINT
EX ;
 KILL ^TMP("VEE","VEDD",$J,"IND")
 S FLAGQ=1
 Q
 ;
GETFLD ;Field lookup. LEV increments and decrements with Multiple layers.
 S FLAGQ=0
 S DIC="^DD("_FILE(LEV)_","
 S DIC(0)="QEAN"
 S DIC("A")=$S(LEV=1:"  Select FIELD: ",1:"  Select SUBFIELD: ")
 S DIC("W")="W ""   ["",$P($G(^(0)),U,4),""] ["",$P($G(^(0)),U,2),""]"" W:$P($P($G(^(0)),U,4),"";"",2)=0 ?72,""<-Mult"""
 D ^DIC
 KILL DIC("A")
 KILL DIC("W")
 I Y<0 S LEV=LEV-1 Q:LEV=0  G GETFLD
 S FNUM=+Y,FNAM=$P(Y,U,2)
 S VEEX=+$P(^DD(FILE(LEV),FNUM,0),U,2)
 I VEEX D  G GETFLD
 . S LEV=LEV+1
 . S FILE(LEV)=VEEX
 I 'FLAGP D INDIV^%ZVEMKI1(FILE(LEV),FNUM) Q:FLAGE  G GETFLD
 S ^TMP("VEE","VEDD",$J,"IND",CNT)=FILE(LEV)_"^"_FNUM_"^"_FNAM
 S CNT=CNT+1
 G GETFLD
 ;
GETFLDP ;Parameter passing
 S PARAM=PARAM+1
 S X=$P(%3,";",PARAM) I X']"" Q
 I $E(X)="""" S X=$E(X,2,99) I $E($L(X))="""" S X=$E(X,1,$L(X)-1)
 S FLD=X
 S (CNT,LEV)=1
 S FILE(LEV)=ZNUM
 ;
GETFLDP1 S DIC="^DD("_FILE(LEV)_","
 S DIC(0)="M"
 D ^DIC
 I Y<0 D MULT Q:FLAGQ  G GETFLDP
 S FNUM=+Y,FNAM=$P(Y,U,2)
 S VEEX=+$P(^DD(FILE(LEV),FNUM,0),U,2)
 I VEEX D  G GETFLDP1
 . S LEV=LEV+1
 . S FILE(LEV)=VEEX
 D INDIV^%ZVEMKI1(FILE(LEV),FNUM) Q:FLAGQ
 I $P(%3,";",(PARAM+1))]"" W ! I $$CHOICE^%ZVEMKC("NEXT_FIELD^QUIT",1)'=1 S FLAGQ=1 Q
 G GETFLDP
 ;
MULT ;Process a multiple field
 NEW CNT,DATA,FLD1,FLDCNT,I,LEVEL,MAR,MAR1,Z1,ZDD,ZNAME,ZNUMBER
 KILL ^TMP("VEE","VEDD",$J,"FLD")
 D LIST
 D TRACE
 KILL ^TMP("VEE","VEDD",$J,"FLD")
 Q
 ;
LIST ;
 S FLDCNT=1
 S ZDD=""
 F  S ZDD=$O(^TMP("VEE","VEDD",$J,"TMP",ZDD)) Q:ZDD=""  D  ;
 . S LEVEL=$P(^(ZDD),U,2)
 . S ZNAME=""
 . F  S ZNAME=$O(^DD(ZDD,"B",ZNAME)) Q:ZNAME=""  I $E(ZNAME,1,$L(FLD))=FLD D  ;
 .. S ZNUMBER=$O(^DD(ZDD,"B",ZNAME,""))
 .. Q:^DD(ZDD,"B",ZNAME,ZNUMBER)=1
 .. S ^TMP("VEE","VEDD",$J,"FLD",FLDCNT)=ZNAME_"^"_ZDD_"^"_ZNUMBER_"^"_LEVEL
 .. S FLDCNT=FLDCNT+1
 Q
 ;
PRINT ;
 D INIT^%ZVEMDPR
 S CNT=""
 F  S CNT=$O(^TMP("VEE","VEDD",$J,"IND",CNT)) Q:CNT=""  D  Q:FLAGQ
 . S DATA=^TMP("VEE","VEDD",$J,"IND",CNT)
 . S FILE(LEV)=$P(DATA,U)
 . S FNUM=$P(DATA,U,2)
 . S FNAM=$P(DATA,U,3)
 . D INDIV^%ZVEMKI1(FILE(LEV),FNUM) Q:FLAGQ
 . Q:$O(^TMP("VEE","VEDD",$J,"IND",CNT))=""
 . W ! Q:$$CHECK^%ZVEMKI3
 . W !,$E(VEELINE2,1,VEE("IOM")) Q:$$CHECK^%ZVEMKI3
 . W ! Q:$$CHECK^%ZVEMKI3
 . W ! Q:$$CHECK^%ZVEMKI3
 Q
 ;
TRACE ;If more than one match do NUM
 Q:'$D(^TMP("VEE","VEDD",$J,"FLD"))
 S FLDCNT=""
 F  S FLDCNT=$O(^TMP("VEE","VEDD",$J,"FLD",FLDCNT)) Q:FLDCNT=""  S I=FLDCNT
 I I=1 D  D INDIV^%ZVEMKI1(FILE(LEV),FNUM) Q
 . S FNAM=$P(^TMP("VEE","VEDD",$J,"FLD",I),U)
 . S FNUM=$P(^(I),U,3)
 . S FILE(LEV)=$P(^(I),U,2)
 ;
 D HD1
 S FLDCNT=""
 F  S FLDCNT=$O(^TMP("VEE","VEDD",$J,"FLD",FLDCNT)) Q:FLDCNT=""  D  Q:FLAGQ
 . S FNAM=$P(^TMP("VEE","VEDD",$J,"FLD",FLDCNT),U)
 . S FNUM=$P(^(FLDCNT),U,3)
 . S LEVEL=$P(^(FLDCNT),U,4)
 . S FILE(LEV)=$P(^(FLDCNT),U,2)
 . W ! W:$P(^DD(FILE(LEV),FNUM,0),U,2)>0 "Mult->"
 . W ?6,$J(FLDCNT,3),".",?LEVEL*5+6,"  ",FNAM,"  (",FNUM,")"
 . D:$Y>VEESIZE PAGE
TRACE1 ;
 W !!?2,"Select Number: "
 R FLD1:VEE("TIME") S:'$T FLD1="^^" S:FLD1="" FLD1="^"
 I FLD1["^" S FLAGQ=1 S:FLD1="^^" FLAGE=1 Q
 I '$D(^TMP("VEE","VEDD",$J,"FLD",FLD1)) D  G TRACE1
 . W !?2,"Enter a number from the left hand column."
 S CNT=1
 S FNAM=$P(^TMP("VEE","VEDD",$J,"FLD",FLD1),U)
 S FNUM=$P(^(FLD1),U,3)
 S LEV=$P(^(FLD1),U,4)
 S FILE(LEV)=$P(^(FLD1),U,2)
 D INDIV^%ZVEMKI1(FILE(LEV),FNUM)
 Q
 ;
PAGE ;
 D PAUSEQE^%ZVEMKC(2) Q:FLAGQ  D HD
 Q
 ;
HD ;
 W @VEE("IOF"),!,$E(VEELINE1,1,VEE("IOM"))
 W !?5,"Enter one at a time, as many fields as you wish to print."
 W !?5,"The fields will print in the order entered."
 W !,$E(VEELINE1,1,VEE("IOM")),!
 Q
 ;
HD1 ;Trace a field
 W @VEE("IOF"),!
 W !,"MULTIPLE",?13,"1    2    3    4    5    6    7"
 W !,"LEVELS",?13,"|    |    |    |    |    |    |"
 W !,$E(VEELINE,1,VEE("IOM")),!
 Q
 ;
INIT ;
 KILL ^TMP("VEE","VEDD",$J,"IND")
 S (CNT,LEV)=1
 S FILE(LEV)=ZNUM
 S DIC(0)="QEAM"
 S DIC("W")="I $P(^DD(FILE(LEV),Y,0),U,2)>0 W ""    -->Mult Fld"""
 Q
