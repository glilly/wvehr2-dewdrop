SDAMWI1 ;ALB/MJK - Walk-Ins (cont.) ; 31 Dec 99  6:30 PM
 ;;5.3;Scheduling;**94,167,206,168**;Aug 13, 1993
 ;
MAKE(DFN,SDCL,SDT) ; -- set globals for appt
 ;    input:     DFN ; SDCL := clinic# ; SDT := appt d/t
 ; returned: success := 1
 ;
 N SD,SDINP,SC,DA,DIK
 S SC=SDCL,X=SDT,SDINP=$$INP^SDAM2(DFN,SDT)
 S SD=SDT D EN1^SDM3
 S:'$D(^DPT(DFN,"S",0)) ^(0)="^2.98P^^"
 S ^DPT(DFN,"S",SDT,0)=SC_"^"_$$STATUS^SDM1A(SC,SDINP,SDT)_"^^^^^4^^^^^^^^^"_SDAPTYP_"^^^"_DT_"^^^^^"_$G(SDXSCAT)_"^W^0"
 ;xref DATE APPT. MADE field
 D
 .N DIV
 .S DA=SDT,DA(1)=DFN,DIK="^DPT(DA(1),""S"",",DIK(1)=20 D EN1^DIK
 .Q
 F I=1:1 I '$D(^SC(SC,"S",SDT,1,I)) S:'$D(^(0)) ^(0)="^44.003PA^^" S ^(I,0)=DFN_"^"_SDSL_"^^^^"_DUZ_"^"_DT,^SC(SC,"S",SDT,0)=SDT,SDDA=I D RT,EVT,DUAL,ROUT(DFN) Q
 ;update availability grid
 N HSI,SDDIF,SI,SL,STARTDAY,STR,SDNOT,X,SB,Y,S,I,ST,SS,SM
 S SD=SDT,SC=SDCL
 I '$D(^SC(SC,"ST",$P(SD,"."),1)) Q 1
  S SL=^SC(+SC,"SL"),X=$P(SL,U,3),STARTDAY=$S($L(X):X,1:8),SB=STARTDAY-1/100,X=$P(SL,U,6),HSI=$S(X=1:X,X:X,1:4),SI=$S(X="":4,X<3:4,X:X,1:4),STR="#@!$* XXWVUTSRQPONMLKJIHGFEDCBA0123456789jklmnopqrstuvwxyz",SDDIF=$S(HSI<3:8/HSI,1:2) K Y
SC L +^SC(SC,"ST",$P(SD,"."),1):5 G:'$T SC S S=^SC(SC,"ST",$P(SD,"."),1) S I=SD#1-SB*100,ST=I#1*SI\.6+($P(I,".")*SI),SS=SL*HSI/60*SDDIF+ST+ST G C:(I<1!'$F(S,"["))&(S'["CAN")
 S SM=0
 I SM<7 S %=$F(S,"[",SS-1) S:'%!($P(SL,"^",6)<3) %=999 I $F(S,"]",SS)'<%!(SDDIF=2&$E(S,ST+ST+1,SS-1)["[") S SM=7
SP I ST+ST>$L(S) S S=S_"  " G SP
 S SDNOT=1 F I=ST+ST:SDDIF:SS-SDDIF S ST=$E(S,I+1) S:ST="" ST=" " S Y=$E(STR,$F(STR,ST)-2) G C:S["CAN"!(ST="X"&($D(^SC(+SC,"ST",$P(SD,"."),"CAN")))),C:Y="" S:Y'?1NL&(SM<6) SM=6 S ST=$E(S,I+2,999) S:ST="" ST=" " S S=$E(S,1,I)_Y_ST
 S ^SC(+SC,"ST",$P(SD,"."),1)=S
C L -^SC(+SC,"ST",$P(SD,"."),1)
 Q 1
 ;
RT ; -- request record
 S SDRT="A",SDTTM=SDT,SDPL=I,SDSC=SC D RT^SDUTL
 Q
 ;
ROUT(DFN) ; -- print routing slip
 S DIR("A")="DO YOU WANT TO PRINT A ROUTING SLIP NOW",DIR(0)="Y"
 W ! D ^DIR K DIR G ROUTQ:$D(DIRUT)!(Y=0)
 K IOP S (SDX,SDSTART,ORDER,SDREP)="" D EN^SDROUT1
ROUTQ Q
 ;
DUAL ; -- ask elig if pt has more than one
 I $O(VAEL(1,0))>0 S SDEMP="" D ELIG^SDM4:"369"[SDAPTYP S SDEMP=$S(SDDECOD:SDDECOD,1:SDEMP) I +SDEMP S $P(^SC(SC,"S",SDT,1,I,0),"^",10)=+SDEMP K SDEMP
 Q
 ;
EVT ; -- separate if need to NEW vars
 N I,DIV D MAKE^SDAMEVT(DFN,SDT,SDCL,SDDA,0)
 Q
