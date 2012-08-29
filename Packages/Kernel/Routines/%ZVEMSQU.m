%ZVEMSQU ;DJB,VSHL**QWIKs - Delete,Copy,Boxes [11/06/94]
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
DELETE ;Delete a QWIK
 W !?1,"*** Delete QWIK Command ***"
 NEW CD,FLAGQ,NAM
 F  S FLAGQ=0 D GETNAM^%ZVEMSQ() Q:FLAGQ  D
 . Q:$$ASKDEL()'=1
 . KILL ^%ZVEMS("QU",VEE("ID"),NAM) W !?1,"Deleted.."
 Q
ASKDEL() ;Ok to delete? 1=YES  0,2=NO
 W !?1,"Are you sure you want to delete this QWIK?"
 Q $$CHOICE^%ZVEMKC("YES^NO",1)
 ;====================================================================
COPY ;Copy QWIK code to a new name
 NEW CD,FLAGQ,NAM,TEMP,X
 W !?1,"Select QWIK you wish to copy."
COPY1 ;
 S FLAGQ=0 D GETNAM^%ZVEMSQ() Q:FLAGQ
 S TEMP=NAM W !!?1,"Copy this QWIK to what name?"
COPY2 ;
 D GETNAM^%ZVEMSQ(1) Q:FLAGQ
 I $D(^%ZVEMS("QU",VEE("ID"),NAM)) D  G COPY2
 . W "   This name is already in use"
 S ^(NAM)=^(TEMP) I $D(^(TEMP,"DSC")) S ^%ZVEMS("QU",VEE("ID"),NAM,"DSC")=^%ZVEMS("QU",VEE("ID"),TEMP,"DSC")
 S X="" F  S X=$O(^%ZVEMS("QU",VEE("ID"),TEMP,X)) Q:X'>0  S ^%ZVEMS("QU",VEE("ID"),NAM,X)=^%ZVEMS("QU",VEE("ID"),TEMP,X)
 W "   Copied.."
 Q
 ;====================================================================
BOX ;..QB System QWIK. Put QWIKs into Boxes
 NEW BOX,BX,FLAGQ,NAM
 W !?1,"Assign QWIK to a display BOX"
 S FLAGQ=0 F  D GETNAM^%ZVEMSQ() Q:FLAGQ  D BOX1
 Q
BOX1 ;
 S BX=$P($G(^%ZVEMS("QU",VEE("ID"),NAM,"DSC")),"^",3)
 W !!?1,"Enter BOX: " I BX]"" W BX,"// "
 R BOX:500 S:'$T BOX="^" Q:"^"[BOX
 I BOX="@" D  Q
 . I BX>0 S $P(^%ZVEMS("QU",VEE("ID"),NAM,"DSC"),"^",3)="" W "   Deleted.."
 I BOX?1.N,BOX>0 S $P(^%ZVEMS("QU",VEE("ID"),NAM,"DSC"),"^",3)=BOX W "   Entered.." Q
 W !?2,"Enter a whole number greater than zero to add a QWIK",!?2,"to a display BOX. Enter '@' to delete a BOX."
 G BOX1
