%ZVEMSPS ;DJB,VSHL**Print Symbol Table (..ZW) ; 9/3/99 2:56pm
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
WRITE(StarT) ;
 ; StartT is mixed case so it isn't already in symbol table
 ;
 I '$$EXIST^%ZVEMKU("%ZOSV") D  Q
 . W !,"This QWIK requires routine ^%ZOSV.",!
 ;
 KILL ^TMP("VEE",$J)
 D INIT
 D SAVE
 I '$D(^TMP("VEE",$J,"SYM")) W !,"Symbol Table is empty.." G EX
 D START
 D LIST^%ZVEMKT("^TMP(""VEE"","_$J_",""LIST"")")
EX ;
 W !
 KILL ^TMP("VEE",$J)
 Q
 ;
SAVE ;Save symbol table to ^TMP("VEE",$J,"SYM",var)
 NEW %,%X,%Y,X,Y
 S X="^TMP(""VEE"","_$J_",""SYM""," D DOLRO^%ZOSV
 ;
 NEW I,XxX
 F I="%","%X","%Y","X","Y","StarT","VEE","VEESHC","VEESHL" D  ;
 . KILL ^TMP("VEE",$J,"SYM",I)
 F I="%","%X","%Y","X","Y","StarT" I $D(^TMP("VEE",$J,"VAR",I))  D  ;
 . S ^TMP("VEE",$J,"SYM",I)=^(I)
 . S XxX=I
 . F  S XxX=$O(^TMP("VEE",$J,"VAR",XxX)) Q:XxX=""!($P(XxX,"(",1)'=I)  S ^TMP("VEE",$J,"SYM",XxX)=^(XxX)
 Q
 ;
START ;
 NEW %,%CNT,%DOT,%IEN,%L,%TXT,%TMP,%VAL,%VAR
 S ^TMP("VEE",$J,"LIST",1)=$J("",28)_"S Y M B O L   T A B L E"
 S %CNT=1,%IEN=2
 S %TMP="^TMP(""VEE"","_$J_",""SYM"")"
 S %="TMP(""VEE"","_$J_",""SYM"","
 F  S %TMP=$Q(@%TMP) Q:%TMP=""!(%TMP'[%)  D BUILD
 Q
 ;
BUILD ;Build array in ^%ZVEMS("ZZLIST","SYMTBL"_$J) to pass to scroller
 S %VAR=$P(%TMP,",",4),%VAR=$P(%VAR,"""",2) ;Strip quotes
 I $P(%TMP,",",5)]""  S %VAR=%VAR_"("_$P(%TMP,",",5,99)
 Q:StarT]%VAR
 S %VAL=@%TMP
 S %TXT=$J(%CNT,3)_". "_%VAR
 S %DOT=$S($L(%VAR)<11:$E(".............",1,12-$L(%VAR)),1:"..")_": "
 S %TXT=%TXT_%DOT,%L=$L(%TXT)
 S %TXT=%TXT_$E(%VAL,1,VEE("IOM")-1-%L)
 S %VAL=$E(%VAL,VEE("IOM")-%L,9999)
 S ^TMP("VEE",$J,"LIST",%IEN)=%TXT,%CNT=%CNT+1,%IEN=%IEN+1
BUILD1 Q:%VAL']""
 S %TXT=$E(%VAL,1,VEE("IOM")-1-%L)
 S ^TMP("VEE",$J,"LIST",%IEN)=$J("",%L)_%TXT,%IEN=%IEN+1
 S %VAL=$E(%VAL,VEE("IOM")-%L,9999)
 G BUILD1
INIT ;
 NEW %TMP
 S StarT=$G(StarT)
 F XxX="%","%X","%Y","X","Y" I $D(@XxX)#2 D  ;
 . S ^TMP("VEE",$J,"VAR",XxX)=@XxX
 . S %TMP=XxX
 . F  S %TMP=$Q(@%TMP) Q:%TMP=""!(%TMP'[XxX)  D  ;
 .. S ^TMP("VEE",$J,"VAR",%TMP)=@%TMP
 KILL XxX,%1,%2,%3,%4,%5,%6,%7,%8,%9
 Q
