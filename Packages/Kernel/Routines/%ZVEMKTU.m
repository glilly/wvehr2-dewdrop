%ZVEMKTU ;DJB,KRN**Txt Scroll-SELECTOR Help [8/16/97 11:10am]
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
HELP ;
 D ENDSCR^%ZVEMKT2
 W !,"S E L E C T O R"
 W !!,"You may select any number of the displayed lines by tagging them. To tag"
 W !,"a line, position the highlight and hit <SPACE BAR>. A '=>' will appear in"
 W !,"front of the line, indicating it's been tagged. To deselect a line, hit"
 W !,"<SPACE BAR> again. This untags the line and the '=>' disappears."
 W !!,"Other ways to tag and untag lines:"
 W !!?3,"A     Tag all lines"
 W !?3,"P     Tag all lines on the displayed page"
 W !?3,"<F4>T Tag from cursor to top of list"
 W !?3,"<F4>B Tag from cursor to bottom of list"
 W !?3,"C     Clear all lines (Untag them)"
 W !?3,"+     Enter characters. SELECTOR will find all lines"
 W !?3,"      containing those characters, and tag them."
 W !?3,"-     Enter characters. SELECTOR will find all lines"
 W !?3,"      containing those characters, and untag them."
 W !!,"SELECTOR uses the SCROLLER. While in SELECTOR hit <ESC>H for scroller help."
 D PAUSE^%ZVEMKC(2)
 Q
MORE ;M=More menu option
 D ENDSCR^%ZVEMKT2
 W !,"A D D I T I O N A L   M E N U   I T E M S"
 W !?3,"F = Find characters (Look on left side of screen only)"
 W !?3,"L = Locate characters (Anywhere in the line)"
 W !?3,"S = Show selected items"
 W !!?3,"U = Move Up a page"
 W !?3,"D = Move Down a page"
 W !?3,"T = Move to Top of list"
 W !?3,"B = Move to Bottom of list"
 W !?3,"G = Goto a line number"
 D PAUSE^%ZVEMKC(2)
 Q
SHOW ;Show selected items
 D ENDSCR^%ZVEMKT2
 NEW FLAGQ,I,ITEM
 W !,"S E L E C T E D   I T E M S"
 S (FLAGQ,ITEM)=0
 F  S ITEM=$O(^TMP("VPE","SELECT",$J,ITEM)) Q:'ITEM!FLAGQ  D  ;
 . W !,$P($G(^TMP("VPE","SELECT",$J,ITEM)),$C(9),2)
 . I '$O(^TMP("VPE","SELECT",$J,ITEM)) D  S FLAGQ=1 Q
 . . F I=$Y:1:(VEE("IOSL")-4) W !
 . . D PAUSE^%ZVEMKC(1)
 . I $Y>(VEE("IOSL")-4) D PAUSEQ^%ZVEMKC(1) Q:FLAGQ  W @VEE("IOF")
 Q
