%ZVEMG1 ;DJB,VGL**Get Global ; 9/6/02 10:04am
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
GETGL ;Get Global
 ; FLAGPRM = Parameter passing. Used by VEDD,VGL,VRR
 I $G(FLAGPRM)="VGL" S FLAGQ=1 Q
 I $G(FLAGPRM)=1 S FLAGPRM="VGL",ZGL=%1 D  Q:FLAGQ  G GETGL1
 . I $E(ZGL)'="^" D GETFILE^%ZVEMGU I ZGL']"" S FLAGQ=1
 D:GLS=1 HD^%ZVEMGU
 I $G(VEESHL)="RUN" D  G:ZGL?1"<".E1">" GETGL G GETGL1
 . S FLAGPAR=0 ;FLAGPAR tells CLH to remove ending ")"
 . W ! S ZGL=$$CLHEDIT^%ZVEMSCL("VGL","Session "_GLS_"...Global ^")
 W !!?1,"Session ",GLS,"...Global ^"
 R ZGL:VEE("TIME") S:'$T ZGL="^"
GETGL1 ;Come here when passing a parameter
 I "^"[ZGL S FLAGQ=1 W ! Q
 I ZGL=" " D GETFILE^%ZVEMGU I ZGL']"" S FLAGQ=2 Q  ;Lookup by File name or number.
 I ZGL?1.E1"*" S ZGL=$$GLBLIST^%ZVEMGU(ZGL) I ZGL']"" S FLAGQ=2 Q
 I $E(ZGL)="?" D HELP^%ZVEMKT("VGL1") G GETGL
 I ZGL="*D" W @VEE("IOF") D @$S(VEE("OS")=9:"^%gd",1:"^%GD") G GETGL
 I ZGL="*%D" W @VEE("IOF") D @$S(VEE("OS")=9:"^%gd",VEE("OS")=8:"^%GDE",1:"LIB^%GD") G GETGL
 I ZGL'?1"^".E S ZGL="^"_ZGL
 I ",%,[,|,"'[(","_$E(ZGL,2)_","),$E(ZGL,2)'?1A D  G GETGL
 . W !!?1,"Global name must begin with alpha or '%'"
 I ZGL?.E1."," D  S FLAGC1="NP" ;FLAGC used in PRINT^%ZVEMGI to limit subscript levels to that marked by commas.
 . F  Q:ZGL'?.E1","  S FLAGC=FLAGC+1,ZGL=$E(ZGL,1,$L(ZGL)-1)
 I ZGL?.E1.","1")" S ZGL=$E(ZGL,1,$L(ZGL)-1) D  S FLAGC1="P"
 . F  Q:ZGL'?.E1","  S FLAGC=FLAGC+1,ZGL=$E(ZGL,1,$L(ZGL)-1)
 I ZGL?.E1"(".E1")" S FLAGOPEN=1 ;FLAGOPEN notes if right ")" was entered.
 I ZGL?.E1"(" S ZGL=$P(ZGL,"(")
 I ZGL?.E1"(".E,ZGL'?.E1")" S ZGL=ZGL_")",FLAGPAR=1 ;FLAGPAR tells Command Line History to remove ending ")"
 S TEMP=$P(ZGL,"(") D  I FLAGQ W !!?1,"Invalid global name." Q
 . I TEMP["[" D  Q
 . . ;--------> ^["MGR","ROU"]%ZIS <--------
 . . I VEE("OS")=9 S:TEMP'?1"^"1"["""1.AN1"""]".E FLAGQ=2
 . . E  S:TEMP'?1"^"1"["""1.AN1""","""1.AN1"""]".E FLAGQ=2
 . . I $P(TEMP,"]",2)'?1"%".AN,$P(TEMP,"]",2)'?1A.AN S FLAGQ=2
 . I TEMP["|" D  Q
 . . ;--------> ^|"MGR","ROU"|%ZIS <--------
 . . I VEE("OS")=9 S:TEMP'?1"^"1"|"""1.AN1"""|".E FLAGQ=2
 . . E  S:TEMP'?1"^"1"|"""1.AN1""","""1.AN1"""|".E FLAGQ=2
 . . I $P(TEMP,"|",3)'?1"%".AN,$P(TEMP,"|",3)'?1A.AN S FLAGQ=2
 . I TEMP'?1"^".1"%".AN S FLAGQ=2
 S NEWSUB=$$ZDELIM^%ZVEMGU(ZGL) ;Replace commas,spaces,colons (if not between quotes) with variable ZDELIM,ZDELIM1, or ZDELIM2
 I FLAGQ=2 W !!?1,"Invalid subscript" Q
 I FLAGC S FLAGC=FLAGC+($L(NEWSUB,ZDELIM))
 I NEWSUB="" S ZGL=$P(ZGL,"(")
 Q
