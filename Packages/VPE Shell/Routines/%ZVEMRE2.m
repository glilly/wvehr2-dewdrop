%ZVEMRE2 ;DJB,VRR**EDIT - Block Mode ; 1/8/01 8:31am
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
BLOCK ;Block Mode
 ;<AU>/<AD>: Highlight lines of code.
 ;           Clipboard marked: ^%ZVEMS("E","SAVEVRR",$J)="LINE"
 ;<AL>/<AR>: Highlight characters of code on a single line.
 ;           Clipboard marked: ^%ZVEMS("E","SAVEVRR",$J)="CHAR"
 ;
 I VK="<DEL>" D DEL Q  ;.....Delete code
 I VK="<ESCC>" D ESCC Q  ;...Copy code to clipboard
 I VK="<ESCD>" D ESCD Q  ;...Delete code
 I VK="<ESCV>" D ESCV Q  ;...Paste code
 I VK="<ESCX>" D ESCX Q  ;...Cut code to clipboard
 I VK="<F3>" D F3 Q  ;.......Turn Block mode ON/OFF
 Q
 ;
DEL ;Delete code
 D ESCD
 Q
 ;
ESCC ;Copy code to clipboard
 D COPY^%ZVEMRP1
 D BLOCK^%ZVEMRER()
 Q
 ;
ESCD ;Delete code
 ;
 ;Block mode ON
 I FLAGMODE["BLOCK" D  Q
 . I $D(^TMP("VEE","SAVECHAR",$J)) D ESCDC Q  ;Delete characters
 . D ESCDL1 ;..................................Delete lines
 ;
 ;Block mode OFF
 D ESCDL2 ;....................................Delete lines
 Q
 ;
ESCDC ;Delete characters - Block mode must be ON.
 D DELETE^%ZVEMRP2
 D BLOCK^%ZVEMRER()
 Q
 ;
ESCDL1 ;Delete lines - Block mode ON
 D DELETE^%ZVEMRP1()
 D REDRAW1^%ZVEMRU
 D BLOCK^%ZVEMRER(1)
 S QUIT=1
 Q
 ;
ESCDL2 ;Delete lines - Block mode OFF
 D ESCD^%ZVEMRP1
 D REDRAW1^%ZVEMRU
 S QUIT=1
 Q
 ;
ESCV ;Paste characters/lines
 NEW CHAR,CLIPTYPE,LINE
 ;
 ;Block Mode OFF
 I FLAGMODE'["BLOCK" D  D REDRAW^%ZVEMRU(YND) Q
 . I $G(^%ZVEMS("E","SAVEVRR",$J))="CHAR" D INSERT^%ZVEMRP2 Q  ;Chars
 . D PREPASTE^%ZVEMRP1 ;Lines
 ;
 ;Block Mode ON
 S CLIPTYPE=$G(^%ZVEMS("E","SAVEVRR",$J))
 S CHAR=$D(^TMP("VEE","SAVECHAR",$J))
 S LINE=$D(^TMP("VEE","SAVE",$J))
 ;
 I CLIPTYPE="LINE" D  ;...Replace lines
 . I CHAR D  Q  ;.........Can't replace lines with chars
 .. D MSG^%ZVEMRUM(23)
 .. D CLEARALL^%ZVEMRP
 . D ESCV1
 ;
 I CLIPTYPE="CHAR" D  ;...Replace characters
 . I LINE D  Q  ;.........Can't replace chars with lines
 .. D MSG^%ZVEMRUM(22)
 .. D CLEARALL^%ZVEMRP
 . D ESCV2
 ;
 ;Turn off Block Mode
 D BLOCK^%ZVEMRER()
 Q
 ;
ESCV1 ;Replace lines
 ;Set YND=Highest line number of highlighted code. Insert saved lines
 ;after this number, and then delete highlighted lines.
 ;
 Q:'$D(^TMP("VEE","SAVE",$J))
 S YND=$O(^TMP("VEE","SAVE",$J,""),-1) ;Highest line number
 D PREPASTE^%ZVEMRP1 ;..................Insert saved lines
 D DELETE^%ZVEMRP1("") ;................Delete highlighted lines
 D REDRAW2^%ZVEMRU ;....................Redraw screen
 Q
 ;
ESCV2 ;Replace characters
 D DELETE^%ZVEMRP2 ;...Cut characters
 D INSERT^%ZVEMRP2 ;...Insert new characters
 D REDRAW^%ZVEMRU(YND)
 Q
 ;
ESCX ;Cut characters/lines
 ;
 ;Cut characters
 I $D(^TMP("VEE","SAVECHAR",$J)) D  Q
 . D SAVE1^%ZVEMRP1
 . D DELETE^%ZVEMRP2
 . D BLOCK^%ZVEMRER()
 ;
 ;Cut lines
 D CUT^%ZVEMRP1
 D BLOCK^%ZVEMRER(1)
 D REDRAW2^%ZVEMRU
 Q
 ;
F3 ;Block mode ON/OFF
 ;
 ;Turn Block mode OFF
 I $G(FLAGMODE)["BLOCK" D  Q
 . D CLEARALL^%ZVEMRP
 . D BLOCK^%ZVEMRER()
 ;
 ;Turn Block mode ON
 S $P(FLAGMODE,"^",1)="BLOCK"
 D MODEON^%ZVEMRU("BLOCK")
 KILL ^TMP("VEE","SAVE",$J)
 KILL ^TMP("VEE","SAVECHAR",$J)
 Q
