DGRPC1  ;ALB/MRL/PJR - CHECK CONSISTENCY OF PATIENT DATA (CONT) ; 5/28/04 8:51am
        ;;5.3;Registration;**314,342,451,564,688**;Aug 13, 1993;Build 29
18      ;
19      S X=$S($P(DGCD,"^",5)="Y":1,1:0) I $S(X=DGVT:0,DGVT=2&('X):0,1:1) S X=$S(DGVT:18,1:19) I DGCHK[(","_X_",") D COMB
        S:'DGVT DGLST=$S(+DGLST>22:+DGLST,1:22) G:DGCHK'[",22,"&'DGVT FIND^DGRPC2 D NEXT I DGLST>20!('DGLST) G @DGLST
20      I DGVT,DGSC S DGD=$S(+$P(DGP(.3),"^",2)>49:1,1:3) I $P(DGCD,"^",4)'=DGD!($P(DGCD,"^",5)="N") S X=20 D COMB
        S:DGSC DGLST=$S(+DGLST>22:+DGLST,1:22) G:DGCHK'[",22,"&DGSC FIND^DGRPC2 D NEXT I +DGLST'=21 G @DGLST
21      ; off
        D NEXT I +DGLST'=22 G @DGLST
22      I $P(DGP("VET"),"^",1)'="Y" G 221
        S DGSTR="^"
        I DGSC S DGSTR=DGSTR_$S($P(DGP(.3),"^",2)<50:3,1:1)_"^" G 220 ;only appropriate sc type
        I $P(DGP(.52),"^",5)="Y" S DGSTR=DGSTR_"18^" G 220 ;pow only
        I $P(DGP(.53),"^",1)="Y" S DGSTR=DGSTR_"22^" G 220 ;Purple Heart
        I $P(DGP(0),"^",3)'>2061231 S DGSTR=DGSTR_"16^" ;mex border
        I $P(DGP(0),"^",3)'>2071231 S DGSTR=DGSTR_"17^" ;allow WWI
        S DGFL=0 I $P(DGP(.362),"^",12)="Y" S DGSTR=DGSTR_"2^",DGFL=1 ; a&a
        I $P(DGP(.362),"^",13)="Y" S DGSTR=DGSTR_"15^",DGFL=1 ; hb
        I DGFL=1 G 220
        I $P(DGP(.362),"^",14)="Y" S DGSTR=DGSTR_"4^" G 220 ;nsc, va pen
        S DGSTR=DGSTR_"5^" ;nsc
220     I DGSTR'[("^"_$P(DGCD,"^",9)_"^") S X=22 D COMB
        K DGSTR
221     D NEXT I +DGLST'=23 G @DGLST
23      S DGD=$G(^DPT(DFN,.361)) I $P(DGD,"^",1)="V",$P(DGD,"^",2)="" S X=23 D COMB
        D NEXT I +DGLST'=24 G @DGLST
24      I '$D(^DIC(21,+$P(DGP(.32),"^",3),"E",+$P(DGP(.36),"^",1))) S X=24 D COMB
        D NEXT I +DGLST'=25 G @DGLST
25      ;off
        S:DGVT DGLST=35 G:DGCHK'[",35,"&DGVT FIND^DGRPC2 D NEXT I +DGLST'=26 G @DGLST
26      ;off
27      ;off
28      ;off
        D NEXT I +DGLST>32!('DGLST) G @DGLST
29      ;
30      ;
31      ;
        ;
32      I 'DGVT S DGD=DGP(.362),X=28 F I=12,13,14,16 S X=X+1 I $P(DGD,"^",I)="Y",(DGCHK[(","_X_",")) D COMB
        S DGLST=32 G:DGCHK'[",32," FIND^DGRPC2 D NEXT G @DGLST
33      ;off
        S DGLST=33 G:DGCHK'[",33," FIND^DGRPC2 D NEXT I +DGLST>35!('DGLST) G @DGLST
        ;
34      I 'DGVT,$P(DGP(.52),"^",5)="Y",DGCHK[(","_34_",") D COMB S DGLST=34 G:DGCHK'[",34," FIND^DGRPC2 D NEXT G @DGLST
35      ;off
        S DGLST=35 G:DGCHK'[",35," FIND^DGRPC2 D NEXT I +DGLST'=36 G @DGLST
36      I '$D(^DG(391,+DGP("TYPE"),0)) S X=36 D COMB
        ;;S:'DGVT DGLST=48 G:DGCHK'[",48,"&'DGVT FIND^DGRPC2 D NEXT I +DGLST>40!('DGLST) G @DGLST
        D NEXT I +DGLST>40!('DGLST) G @DGLST
37      ;; This check deactivated by EVC project (DG*5.3*688)
38      ;
39      ;
40      F I=5,11 S I2=0,X=$S(I=5:37,1:39) I $P(DGP(.52),"^",I)="Y" D PC
        ;;
41      ;; Inconsistencies 41 and 42 are superseded by 72 through 82
42      ;;
        ;;
        S DGLST=42 S:'DGVT DGLST=48 G:DGCHK'[",48,"&'DGVT FIND^DGRPC2 D NEXT G @DGLST
        ;
PC      I DGCHK[(","_X_","),X'=37 F I1=I+1:1:I+3 I $P(DGP(.52),"^",I1)="",'I2 D COMB S I2=1
        I DGCHK[(","_X_","),X'=37 F I1=I+2:1:I+3 I $E($P(DGP(.52),"^",I1),4,7)="0000",'I2 D COMB S I2=1
        S X=X+1 I DGCHK[(","_X_","),$P(DGP(.52),"^",I+2),$P(DGP(.52),"^",I+3),'$$B4^DGRPDT($P(DGP(.52),"^",I+2),$P(DGP(.52),"^",I+3),1) D COMB
        Q
        ;
COMB    S DGCT=DGCT+1,DGER=DGER_X_",",DGLST=X Q
        Q
NEXT    S I=$F(DGCHK,(","_+DGLST_",")),DGLST=+$E(DGCHK,I,999) I +DGLST,+DGLST<41 Q
        I +DGLST,+DGLST<79 S DGLST=DGLST_"^DGRPC2" Q
        S:'DGLST DGLST="END^DGRPC3" I +DGLST S DGLST=DGLST_"^DGRPC3"
        Q
