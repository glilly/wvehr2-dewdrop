ZVEMBLD ;DJB,VSHL**VPE Setup - Start ; 1/5/04 7:37am
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
 I $G(VEESHL)="RUN" D  Q
 . W $C(7),!?2,"Please exit the VShell before running ^ZVEMBLD.",!
 NEW END,FF,FLAGQ,I,LINE,START,TO,TXT,U,X,XX,Y
 D INIT S FLAGQ=0
 D PAGE1^ZVEMBLDA G:FLAGQ EX
 D PAGE2^ZVEMBLDA G:FLAGQ EX
 D PAGE3^ZVEMBLDA G:FLAGQ EX
 D PAGE4^ZVEMBLDB G:FLAGQ EX
 D PAGE5^ZVEMBLDB G:FLAGQ EX
 D PAGE6^ZVEMBLDB G:FLAGQ EX
 D UCI G:FLAGQ EX
 D ^ZVEMBLDL
EX ;
 Q
UCI ;
 W @FF
 Q:'$D(^%ZOSF("UCI"))  X ^%ZOSF("UCI") I Y["MG" Q
 W $C(7),!!?2,"THIS IS NOT THE MANAGER UCI. I think it is ",Y,"."
 D YESNO("Should I continue anyway: YES// ")
 Q
YESNO(PROMPT) ;Process YES/NO questions
 ;Return FLAGQ: 1=NO  2="^"
 NEW XX S PROMPT=$G(PROMPT)
YN W !?2,PROMPT R XX:TO S:'$T XX="^" S:XX="" XX="YES" S XX=$E(XX)
 S:"Nn"[XX FLAGQ=1 S:"^"[XX FLAGQ=2 Q:FLAGQ
 I "YyNn"'[XX W !?10,"Y=Yes  N=No  ^=Quit" G YN
 Q
ASK ;
 NEW X
 W !?1,"<RETURN> to continue, '^' to quit: "
 R X:TO S:'$T X="^" I X'="" S FLAGQ=1 Q
 Q
INIT ;Set numbers
 S $P(LINE,"@",76)="",U="^",TO=300
 I $G(IOF)]"" S FF=IOF Q
 I $D(^%ZIS(1)) D HOME^%ZIS S FF=IOF Q
 S FF="#,$C(27),""[2J"",$C(27),""[H"""
 Q
