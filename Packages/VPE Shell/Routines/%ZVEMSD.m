%ZVEMSD ;DJB,VSHL**Delete Range of Variables (..ZD) [05/07/94]
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
 ;;S VEEZD="%,X,Z" D ^%ZVEMSD ;Use in QWIKs to delete a range
 I '$$EXIST^%ZVEMKU("%ZOSV") W !?2,"This QWIK requires routine ^%ZOSV.",! Q
TOP ;
 NEW StarT,StarT1,TemP,TemP1
 S StarT=$S($D(VEEZD):VEEZD,1:"")
 I StarT']"" F TemP=1:1:9 Q:@("%"_TemP)']""  S StarT=StarT_@("%"_TemP)_$S(@("%"_(TemP+1))]"":",",1:"")
 I StarT']"" D HELP G EX
 I $$YN^%ZVEMKU1("OK TO DELETE? ",2)'=1 G EX
 D INIT,SAVE,DELETE
EX ;
 W ! KILL ^TMP("VEE",$J)
 Q
SAVE ;Save symbol table to ^TMP("VEE",$J,"SYM",var)
 NEW %,%X,%Y,X,Y
 S X="^TMP(""VEE"","_$J_",""SYM""," D DOLRO^%ZOSV
 Q:'$D(^TMP("VEE",$J,"SYM"))
 S X="" F  S X=$O(^TMP("VEE",$J,"SYM",X)) Q:X=""  S Y="" F  S Y=$O(^TMP("VEE",$J,"SYM",X,Y)) Q:Y=""  KILL ^(Y) S ^TMP("VEE",$J,"SYM",X)="" ;Don't need subscript.
 F X="StarT","StarT1","TemP","TemP1","VEE","VEESHC","VEESHL" KILL ^TMP("VEE",$J,"SYM",X)
 F X="%","%X","%Y","X","Y","StarT" I $D(^TMP("VEE",$J,"VAR",X)) S ^TMP("VEE",$J,"SYM",X)=^(X)
 Q
DELETE ;Delete variable
 F TemP1=1:1:$L(StarT,",") S StarT1=$P(StarT,",",TemP1) S TemP="" F  S TemP=$O(^TMP("VEE",$J,"SYM",TemP)) Q:TemP=""  D
 . Q:+StarT1=StarT1  Q:StarT1]TemP
 . Q:$E(TemP,1,$L(StarT1))'=StarT1
 . W !?2,TemP,"  deleted.." KILL @TemP
 Q
HELP ;
 W $C(7),!?1,"..ZD will delete local variables from your partition. It requires a"
 W !?1,"parameter which can be any number of letters. Any variables whose"
 W !?1,"name begins with these letters will be deleted."
 W !!?1,"Ex 1: ..ZD XQ      Deletes all local variables whose name begins"
 W !?1,"                   with the letters ""XQ"".",!
 W !?1,"Ex 2: ..ZD % XQ    Deletes all variables with a name starting with"
 W !?1,"                   ""%"" or ""XQ"".",!
 Q
INIT ;
 KILL ^TMP("VEE",$J)
 F XxX="%","%X","%Y","X","Y" I $D(@XxX)#2 S ^TMP("VEE",$J,"VAR",XxX)=@XxX
 KILL %1,%2,%3,%4,%5,%6,%7,%8,%9,XxX,VEEZD
 Q
