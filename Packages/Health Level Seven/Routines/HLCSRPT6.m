HLCSRPT6        ;ISC-SF/RAH-TRANS LOG ERROR LIST ;08/25/2010
        ;;1.6;HEALTH LEVEL SEVEN;**151**;Oct 13, 1995;Build 1
        ;Per VHA Directive 2004-038, this routine should not be modified.
        ;
EXIT    ;
        K I,J
        K HLCSER,HLCSER1,HLCSER2,HLCSI,HLCSJ,HLCSLN,HLCSN
        K HLCSST,HLCSTER1,HLCSTER2,HLCSERMS,HLCSX,HLCSY
        K ^TMP($J,"LIST",HLCSTITL_" ERR") ;HL*1.6*85
        I VERS22'="YES" S ^TMP("DDBPF1Z",$J)="D SHOWMSG^HLCSRPT Q"
        Q
        ;
HLCSBAR ; Center Title on Top Line of Screen
        W RVON,?(80-$L(HLCSHDR)\2),HLCSHDR,$E(SPACE,$X,77),RVOFF,!
        Q
        ;
TEST    ;
        S HLCSJ=$O(^TMP("TLOG",$J,0))
        S HLCSJ=+$P(HLCSJ," ",1)
        S ^TMP($J,"MESSAGE",HLCSJ,0)="^^1^1"
        S ^TMP($J,"MESSAGE",HLCSJ,1,0)=" HEADER: "
        S HLCSRNO=HLCSJ
        Q
        ;
