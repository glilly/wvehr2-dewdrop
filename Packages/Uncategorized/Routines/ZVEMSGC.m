ZVEMSGC ;DJB,VSHL**VShell Global - ZA,ZC,ZO,ZQ ; 4/5/03 7:32am
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
ZA ;;;Main area for processing users input at >> prompt.
 S @($$T^%ZVEMSY) X ^%ZVEMS("ZO",4),^%ZVEMS("ZO",2) F  Q:'$D(^%ZVEMS)  X ^%ZVEMS("ZA",6) I $G(VEESHC)]"" Q:VEESHC="^"  W ! X ^%ZVEMS("ZO",1),VEESHC D RESET^%ZVEMSY X ^%ZVEMS("ZS",2)
 X ^%ZVEMS("ZK",4),^%ZVEMS("ZA",4) Q:"^"[VEESHC  X:VEESHC="<TO>" ^%ZVEMS("ZT",1) Q:"^"[VEESHC  X ^%ZVEMS("ZS",4),$S(VEESHC?1.2".":^%ZVEMS("ZQ",1),VEESHC?1.2"."1A.E:^%ZVEMS("ZQ",1),1:^%ZVEMS("ZA",3))
 I VEESHC?1"<".E1">"!(VEESHC?1.2"."1N.E) D ^%ZVEMSQ S VEESHC=$S(VEESHC?1"**".E:$E(VEESHC,3,999),1:"") I VEESHC]"" X ^%ZVEMS("ZA",2) ;CLH
 S:VEESHC?.E1P1"VEESHL".1P.E VEESHC="" S:$E(VEESHC)="?"!(VEESHC="<ESCH>") VEESHC="D ^%ZVEMSH" I ",^,H,h,HALT,halt,"[(","_VEESHC_",") S VEESHC="^"
 X ^%ZVEMS("ZS",3),^%ZVEMS("ZA",7),^%ZVEMS("ZO",2) KILL VEEWARN S VEESHL="RUN" D USEZERO^%ZVEMSU ;Reset variables
 X ^%ZVEMS("ZA",5),^%ZVEMS("ZR",1) Q:"^"[VEESHC  X ^%ZVEMS("ZA",2) Q:"^"[VEESHC  X ^%ZVEMS("ZC",1) KILL VEEWARN
 I $G(VEE("OS"))=8 X "ZM 0" ;Disable MSM trace function
 ;;;***
ZC ;;;Check for Global KILL
 Q:$G(VEEWARN)="QWIK"  NEW HLD X ^%ZVEMS("ZQ",2) I HLD["K",HLD["^" NEW FLAGG S FLAGG="GLB" D KILLCHK^%ZVEMKU(HLD)
 ;;;***
ZK ;;;Exit Shell-KILL ^%ZVEMS("%"). VA KERNEL interface.
 X:'$D(VEE("ID"))!('$D(VEE("OS"))) ^%ZVEMS("ZS",3) X ^%ZVEMS("ZK",3) Q:$G(VEESHC)="NO EXIT"  X ^%ZVEMS("ZK",2),^%ZVEMS("ZK",5),^%ZVEMS("ZK",6),^%ZVEMS("ZK",7),^%ZVEMS("ZK",9)
 Q:'$D(^%ZVEMS("%",$J_$G(^%ZVEMS("SY")),"XUTL"))  KILL ^XUTL("XQ",$J) NEW %X,%Y S %X="^%ZVEMS(""%"","""_$J_$G(^%ZVEMS("SY"))_""",""XUTL"",",%Y="^XUTL(""XQ"",$J," D %XY^%RCR
 NEW U1,U2 X ^%ZVEMS("ZK",8) I U1]"",U2]"",U1'=U2 S VEESHC="NO EXIT" W $C(7),!!?2,"VA KERNEL menu option active.",!?2,"Move to UCI '",U2,"' to HALT.",!
 I $D(^XUSEC(0)),",D ^ZU,DO ^ZU,d ^zu,do ^zu,d ^ZU,do ^ZU,"[(","_VEESHC_",") S VEESHC="" W $C(7),!!?2,"HALT out of VSHELL before calling ^ZU.",!
 I VEE("OS")=9,$D(^%ZVEMS("%",$J_$G(^%ZVEMS("SY")),"DTM")) X "U $I:(IXXLATE=$P(^(""DTM""),""^"",1))"
 I $D(^%ZVEMS("%",$J_$G(^%ZVEMS("SY")),"KRNUCI")) D NOBRK^%ZVEMKY2
 I $D(^%ZVEMS("%",$J_$G(^%ZVEMS("SY")),"SYMTAB")) D RESSYM^%ZVEMSU ;Restore sym table
 S U1=$G(^%ZVEMS("CLH","UCI",VEE("ID")_$G(^%ZVEMS("SY")))),U2=$G(^%ZVEMS("%",$J_$G(^%ZVEMS("SY")),"KRNUCI"))
 KILL ^%ZVEMS("%",$J_$G(^%ZVEMS("SY")))
 ;;;***
ZO ;;;Other
 NEW X S:$G(VEE("$ZR"))]"" @("X=$"_$S(VEE("$ZR")["(":"O",1:"D")_"("_VEE("$ZR")_")") I $G(VEE("$T")) ;Reset $ZR and $T
 Q:'$D(VEE("ID"))  Q:'$D(^%ZOSF("UCI"))  NEW Y X ^("UCI") Q:$G(^%ZVEMS("CLH","UCI",VEE("ID")_$G(^%ZVEMS("SY"))))=Y  X ^%ZVEMS("ZO",3)
 S ^%ZVEMS("CLH","UCI",VEE("ID")_$G(^%ZVEMS("SY")))=Y KILL ^%ZVEMS("CLH",VEE("ID"),"VSHL") ;Kill VShell's CLH if user switches UCIs.
 S:$D(%1) X=%1 KILL:'$D(%1) X KILL %1 ;Reset X after ^%ZOSF("TRAP")
 ;;;***
ZQ ;;;Process QWIK Commands. VEEWARN turns off Global Kill Warning.
 NEW HLD S VEEWARN="QWIK" X ^%ZVEMS("ZQ",2) D QWIK^%ZVEMSQS(HLD)
 S HLD=$TR(VEESHC,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 ;;;***
