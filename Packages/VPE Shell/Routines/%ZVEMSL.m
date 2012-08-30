%ZVEMSL ;DJB,VSHL**VA KERNEL Library Functions [3/6/96 6:17pm]
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
EN ;Entry Point
 NEW CNT,COL,COLUMNS,COLCNT,HD,LAST,PROMPT,SET,SPACES,WIDTH,WRITE
 NEW CNTOLD,DX,DY,FLAGQ,I,OPT,TEST,TXT,VEES,X,Y
 I $G(VEESHL)'="RUN" NEW VEE
 S FLAGQ=0 D INIT Q:FLAGQ
 X VEES("RM0")
TOP ;
 F  S FLAGQ=0 D HD^%ZVEMSHY,LIST,GETOPT Q:FLAGQ  D RUN Q:FLAGQ
EX ;
 X VEES("RM0") W @VEE("IOF")
 Q
GETOPT ;
 X PROMPT S OPT=$$READ^%ZVEMKRN()
 I OPT="^" S FLAGQ=1 Q
 I ",<ESC>,<F1E>,<F1Q>,<TAB>,<TO>,"[(","_VEE("K")_",") S FLAGQ=1 Q
 I VEE("K")="<RET>" S OPT=CNT Q
 I VEE("K")?1"<A"1A1">" S CNTOLD=CNT D ARROW S OPT=CNT D REDRAW G GETOPT
 S OPT=$$ALLCAPS^%ZVEMKU(OPT),TEST=0 D  I TEST Q
 . F I=1:1 S X=$P($T(MENU+I),";",5) Q:X=""  I $E(X,1,$L(OPT))=OPT S (CNT,OPT)=I,TEST=1 Q
 G GETOPT
ARROW ;Arrow Keys
 I "<AU>,<AD>"[VEE("K") D  S COL=$P($T(MENU+CNT),";",3) Q
 . I VEE("K")="<AU>" S CNT=CNT-1 S:CNT<1 CNT=LAST Q
 . I VEE("K")="<AD>" S CNT=CNT+1 S:CNT>LAST CNT=1
 I VEE("K")="<AR>" Q:COL=COLCNT  D  D ADJUST Q
 . S CNT=CNT+COL(COL),COL=COL+1 S:CNT>LAST CNT=LAST
 I VEE("K")="<AL>" Q:COL=1  D  D ADJUST Q
 . S COL=COL-1,CNT=CNT-COL(COL)
 Q
RUN ;Run selected routine
 S X=$P($T(MENU+OPT),";",6) I X="QUIT" S FLAGQ=1 Q
 NEW CNT,COL,COLUMNS,COLCNT,HD,LAST,PROMPT,SET,SPACES,WIDTH,WRITE
 I X]"" W @VEE("IOF") D @X X VEES("RM0")
 Q
LIST ;List Menu Options
 F I=1:1 S TXT=$T(MENU+I) Q:TXT=""!(TXT[";***")   X SET,WRITE
 S TXT=$T(MENU+CNT) Q:TXT=""  X SET W @VEE("RON") X WRITE W @VEE("ROFF")
 Q
REDRAW ;User moved cursor
 S TXT=$T(MENU+CNTOLD) X SET,WRITE
 S TXT=$T(MENU+CNT) X SET W @VEE("RON") X WRITE W @VEE("ROFF")
 Q
ADJUST ;Adjust CNT when you switch columns.
 F  Q:$P($T(MENU+CNT),";",3)=COL  S CNT=CNT-1
 Q
INIT ;Initialize variables
 S COLUMNS="5",WIDTH=30
 S HD="VA   K E R N E L   7.1   L I B R A R Y   F U N C T I O N S"
 D INIT^%ZVEMSHY
 Q
MENU ;MENU OPTIONS
 ;;1;Date Functions.........XLFDT;DATE FUNCTIONS;HELP^%ZVEMKT("DATE");7;4
 ;;1;String Functions.......XLFSTR;STRING FUNCTIONS;HELP^%ZVEMKT("STRING");7;6
 ;;1;Math Functions.........XLFMTH;MATH FUNCTIONS;HELP^%ZVEMKT("MATH");7;8
 ;;1;Measurement Functions..XLFMSMT;MEASUREMENT FUNCTIONS;HELP^%ZVEMKT("MEAS");7;10
 ;;1;Quit;QUIT;QUIT;7;12