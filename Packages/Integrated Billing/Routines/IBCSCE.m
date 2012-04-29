IBCSCE  ;ALB/MRL,MJB - MCCR SCREEN EDITS ;07 JUN 88 14:35
        ;;2.0;INTEGRATED BILLING;**52,80,91,106,51,137,236,245,287,349,371**;21-MAR-94;Build 57
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        ;
        ;MAP TO DGCRSCE
        ; always do procedures last because they are edited upon return to screen routine
        I IBDR20["54," S IBDR20=$P(IBDR20,"54,",1)_$P(IBDR20,"54,",2)_"54,"
        I IBDR20["44," S IBDR20=$P(IBDR20,"44,",1)_$P(IBDR20,"44,",2)_"44,"
LOOP    N IBDRLP,IBDRL S IBDRLP=IBDR20 F IBDRL=1:1 S IBDR20=$P(IBDRLP,",",IBDRL) Q:IBDR20=""  D EDIT
        Q
EDIT    N IBQUERY
        I (IBDR20["31") D MCCR^IBCNSP2 G ENQ
        I (IBDR20["43")!(IBDR20["52") D ^IBCSC4D G ENQ
        I (IBDR20["74")!(IBDR20["53") K DR N I D ^IBCOPV S (DA,Y)=IBIFN G TMPL
        I (IBDR20["54"),$P($G(^IBE(350.9,1,1)),"^",17) K DR N I D EN1^IBCCPT(.IBQUERY) D CLOSE^IBSDU(.IBQUERY) G TMPL ;
        I (IBDR20["55") D ^IBCSC5A G ENQ
        I (IBDR20["45")!(IBDR20["56") D ^IBCSC5B G ENQ
        I (IBDR20["66")!(IBDR20["76") D EDIT^IBCRBE(IBIFN) D ASKCMB^IBCU65(IBIFN) G ENQ
        I IBDR20["85",$$FT^IBCEF(IBIFN)=2 D ^IBCSC8A G ENQ ; chiropractic data
        I IBDR20["84",$$FT^IBCEF(IBIFN)=3 D EN1^IBCEP6 G ENQ   ;UB-04
        I IBDR20["88",$$FT^IBCEF(IBIFN)=2 D EN1^IBCEP6 G ENQ   ;CMS-1500
        F Q=1:1:9 I IBDR20[("9"_Q) D EDIT^IBCSC9 G ENQ
TMPL    N IBFLIAE S IBFLIAE=1 ;to invoke EN^DGREGAED from [IB SCREEN1]
        S DR="[IB SCREEN"_IBSR_IBSR1_"]",(DA,Y)=IBIFN,DIE="^DGCR(399,"
        D ^DIE K DIE,DR,DLAYGO
        I (IBDR20["61")!(IBDR20["71") I +$G(DGRVRCAL) D PROC^IBCU7A(IBIFN,1)
ENQ     K DIE,DR,IBDR1,IBDR20,DGDRD,DGDRS,DGDRS1,DA Q
        ;
        ; W I "^11^12^13^15^14^21^22^23^"[("^"_J_"^") G W1
        ; I "^44^"[("^"_J_"^") S DR(2,399.0304)=".01;1;I $D(IBIP),X<$P(IBIP,""^"",2)!($P(IBIP,""^"",6)&(X>$P(IBIP,""^"",6))) K X"
        ; I "^64^"[("^"_J_"^") S DR(2,399.042)=".01:.03;"
        ; I $T(@J) S DGDRD=$P($T(@J),";;",2) D S S K=(J*10) I $T(@K) S DGDRD=$P($T(@K),";;",2) D S
        ; D ^IBCSCE1:("^31^")[("^"_J_"^") Q
        ; W1 I @DGDRS["^2^DPT(^^D SET^IBCSCE;" D ^IBCSCE1 Q
        ; S DGDRD="^2^DPT(^^D SET^IBCSCE;" D S,^IBCSCE1 Q
        ; S I $L(@DGDRS)+$L(DGDRD)<241 S @DGDRS=@DGDRS_DGDRD Q
        ; S DGCT=DGCT+1,DGDRS="DR(1,399,"_DGCT_")",@DGDRS=DGDRD Q
        ; Q
16      ;;.18;
31      ;;.07;S X=$P(^DGCR(399,DA,0),U,11);S Y="@"_$S(X']"":31,X="p":31,X="o":311,1:310);@310;D 1^IBCSCH1 S Y="@"_$S(IBADI=-1:31,'IBADI:312,1:313);@313;^2^DPT(^^D SET^IBCSCE;D UPDT^IBCSCE;@312;
310     ;;101;102;103;S Y="@31";@311;D INST^IBCU;111;K DIC("DR"),DLAYGO;@31;
32      ;;104;105;106;121;107;108;109
41      ;;S:IBPTF Y="@411";159.5;@411;160;159;158;
42      ;;162;
43      ;;I IBPTF S Y="@943";64;65;66;67;68;S Y="@43";@943;D DX^IBCSC4B;@43;
44      ;;S IBZ20=$P(^DGCR(399,DA,0),U,9);.09;D PRO^IBCSC4B;S IBASKCOD=1
45      ;;41;
46      ;;40;
51      ;;.03;
999     ;;64;65;66;67;68;
52      ;;64;S:X="" Y="@99";65;S:X="" Y="@99";66;S:X="" Y="@99";67;S:X="" Y="@99";68;@99;
53      ;;;;same as 74
54      ;;S IBZ20=$P(^DGCR(399,DA,0),U,9);.09;S IBASKCOD=1
55      ;;41;
56      ;;40;
61      ;;.06;164;
62      ;;155;S:X=0 Y=156;157;156;S:'$D(IBOX) Y="@62";153;@62;
63      ;;151;152;
64      ;;161;165;
65      ;;D RCD^IBCU1;42;202;S:'X Y=201;203;201;I $P(^DGCR(399,DA,"U1"),"^",11)']"" S Y="@65";210;@65;
71      ;;.06;164;
72      ;;155;S:X=0 Y=156;157;156;S:'$D(IBOX) Y="@72";153;@72;
73      ;;151;152;
74      ;;S:$D(IBOUT) Y="@999";43;@999;K IBOUT;
75      ;;D RCD^IBCU1;42;202;S:'X Y=201;203;201;I $P(^DGCR(399,DA,"U1"),"^",11)']"" S Y="@75";210;@75;
81      ;;208;
82      ;;204;
83      ;;205;
84      ;;206;
85      ;;207;
86      ;;163;
        ; AD S X=$S($D(^DPT(DA,.11)):^(.11),1:""),IBPHO=$S($D(^(.13)):$P(^(.13),U,1),1:""),Y=$S($D(^(IBADD)):^(IBADD),1:""),^(IBADD)=$P(Y,U,1)_U_$P(Y,U,2)_U_$P(X,U,1,6)_U_IBPHO_U_$P(Y,U,10) K IBADD,IBPHO Q
        ; SET S I(0,0)=D0,Y(1)=$S($D(^DGCR(399,D0,0)):^(0),1:""),X=$P(Y(1),"^",2),D(0)=X,X=$S(D(0)>0:D(0),1:"") Q
        ;called by screen 3 (input template)
UPDT    F IBDD=0:0 S IBDD=$O(^DPT(DFN,.312,IBDD)) Q:IBDD'>0  S IBI1=^DPT(DFN,.312,IBDD,0) I $D(^DIC(36,+IBI1,0)),$P(^(0),"^",2)'="N" S IBDD(+IBI1)=IBI1
        F IBAIC=0:0 S IBAIC=$O(^DGCR(399,IBIFN,"AIC",IBAIC)) Q:IBAIC'>0  I $D(IBDD(IBAIC)) F IBI1="I1","I2","I3" I $D(^DGCR(399,IBIFN,IBI1)),+^(IBI1)=IBAIC,^(IBI1)'=IBDD(IBAIC) S ^DGCR(399,IBIFN,IBI1)=IBDD(IBAIC)
        K IBAIC,IBDD,IBI1 Q
        ;
        ;Edit patient's address using DGREGAED API
EDADDR(IBDFN)   ;
        I $G(IBFLIAE)'=1!(IBDFN=0) Q 0
        N IBFL S IBFL(1)=1
        N X,Y,DIE,DA,DR,DIDEL,DIW,DIEDA,DG,DICR
        D EN^DGREGAED(IBDFN,.IBFL)
        Q 1
        ;IBCSCE
