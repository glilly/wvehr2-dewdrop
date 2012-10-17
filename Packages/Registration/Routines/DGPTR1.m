DGPTR1  ;ALB/MTC - PTF VERIFICATION ; 01 MAR 91 @0800
        ;;5.3;Registration;**58,247,338,342,423,415,565,678,696,729,781,664,817**;Aug 13, 1993;Build 4
START   S T=$E(Y,2,3),T=$S(T=40&($E(Y,28)="P"):"P40",1:T),ERR=$P($T(@("T"_T)),";;",2,999),W=$P($T(@(T)),";;",2,999),F=31 D L
        I T=70 S ERR=$P($T(T701),";;",2,999),W=$P($T(701),";;",2,999),F=72 D L
        D @("D"_T) Q
        K DGFILL
        Q
        ;
L       N DGFOR S DGFOR=$S($$FORIEN^DGADDUTL($P(DG11,U,10))<1:0,1:1) ;set foreign country flag =1, else, set as domestic
        F H=1:1 S DGO=$P(W,U,H) Q:'DGO  F Z=1:1:$P(DGO,";",3) S DGL=DGLOGIC(+DGO),X=$E(Y,F) D @("ERR:"_DGL) S F=F+1
        Q
        ;
T10     ;;1:NAME^2:SOURCE OF ADM^3:TRANS FAC.^4:SOURCE OF PAY^5:POW^6:MARITAL ST^7:SEX^8:DOB^9:POS^10:VIETNAM^11:ION RADIATION^12:RESIDENCE^13:MEANS TEST^14:INCOME^15:MST^16:COMBAT VET^17:CV END DT^18:PROJ 112/SHAD^19:ERI^20:COUNTRY
        ;
T70     ;;1:DT OF DISP.^2:DISCH BD SEC^3:TYPE OF DIS^4:OUT TREAT^5:VA AUS^6:PL OF DIS^7:REC FAC^8:ASIH DAYS^9:NOT USED^10:C&P STAT^11:PDXLS^12:ONLY DX^13:PHY MPCR
        ;T701 is part 2 of T70
T701    ;;1:PHY SPEC^2:%SC^3:LEGION^4:SUICIDE^5:DRUG^6:AXIS-IV^7:AXIS-V^8:SC^9:EXP^10:MST^11:HNC^12:ETHNICITY^13:RACE^14:COMBAT VET^15:PROJ 112/SHAD
        ;
T50     ;;1:DT OF MVMT^2:LOSING BD SEC MPCR^3:LOSING BD SEC^4:LEAVE DAYS^5:PASS DAYS^6:SCI^7:DIAG^8:DOCTOR'S SSN^9:PHY MPCR^10:PHY SPEC^11:DISCHARGE STAT^^^^^16:LEGION^17:SUICIDE^18:DRUG^19:AXIS-IV^20:AXIS-V^21:SC^22:EXP^23:MST^24:HNC
        ;
T53     ;;1:DATE OF PHYSICAL MOVEMENT^2:LOSING PHYSICAL MPCR^3:LOSING PHYSICAL SPECIALTY^4:TR SPECIALTY MPCR^5:TR SPECIALTY^6:LEAVE DAYS^7:PASS DAYS^8:DOCTOR'S SSN (NOT USED)
        ;
T40     ;;1:DATE OF SURGERY^2:SURG SPEC.^3:CAT CHIEF SURGEON^4:CAT FIRST ASS^5:ANEST. TECH.^6:SOURCE OF PAY^7:OP CODE^8:DOCTOR'S SSN (NOT USED)^^^^^13:TRANSPLANT STATUS
        ;
TP40    ;;1:OP CODE
        ;
T60     ;;1:DATE OF PROCEDURE^2:LOSING BD SEC^3:DIALYSIS TYPE^4:NUMBER OF TREATMENTS^5:PROCEDURE CODE
        ;
LOGIC   ;;X'?.N^X'?.A&(X'=" ")^X'=" "^X'?.N&(X'=" ")^X'?.A&(X'=" ")^0^X'?.N&(X'="X")^X'=" "&(X'="P")^X="E"^X="Y"^X=" "^X'="A"&(X'=" ")^(X'?.A)&(X'?.N)&(X'=" ")^(X'?.AN)&('$P(DG0,U,4))^((T1)&(X'=" "))!(('T1)&(X'?.AN)&('$P(DG0,U,4)))
        ;;(X'?.AN)^'$D(DGFOR)&(X'?.N)^'$D(DGFOR)&X'?.N&(X'="X")
        ;;END
        ;
        ; edit check# ; edit field ; # x check preformed ; display error name #
10      ;;6;;12;1^2;1;1;1^5;1;1;1^1;2;1;2^2;2;1;2^4;3;3;3^6;;3;3^4;4;1;4^6;5;1;5^2;6;1;6^2;7;1;7^1;8;8;8^6;;1;9^11;9;1;9^4;10;1;10^4;10;1;11^17;11;5;12^18;11;5;12^2;12;1;13^6;;1;13^1;;6;14^2;;1;15^1;;1;16^4;;6;17^1;;1;18^5;;1;19^5;;3;20^3;;26
        ;
70      ;;1;1;10;1^13;2;2;2^1;3;1;3^4;4;1;4^4;5;1;5^6;;1;6^4;7;3;7^6;;3;7^4;8;3;8^6;9;1;9^1;10;1;10^9;11;1;11^11;11;2;11^6;;3;11^10;11;1;11^6;;1;12^15;;6;13
        ;701 is part 2 of 70
701     ;;15;;2;1^1;;3;2^4;;1;3^4;;1;4^12;;1;5^4;;3;5^4;;1;6^4;;4;7^4;;1;8^5;;3;9^5;;1;10^5;;1;11^13;12;2;12^13;13;12;13^5;;1;14^5;;1;15^3;;16
        ;
50      ;;1;1;10;1^1;;6;2^16;3;2;3^1;4;3;4^1;5;3;5^6;;1;6^11;7;3;7^6;;32;7^6;;9;8^14;;6;9^14;;2;10^6;;1;11^4;;1;16^4;;1;17^12;;1;18^4;;3;18^4;;1;19^4;;4;20^4;;1;21^5;;3;22^5;;1;23^5;;1;24
        ;
53      ;;1;;10;1^1;;6;2^13;;2;3^1;;6;4^13;;2;5^1;;3;6^1;;3;7^3;;9;8^3;;54;
        ;
40      ;;1;1;10;1^1;2;2;2^11;3;1;3^4;4;1;4^6;5;1;5^4;6;1;6^11;7;2;7^6;;3;7^3;7;2;7^6;;5;7^3;7;2;7^6;;5;7^3;7;2;7^6;;5;7^3;7;2;7^6;;5;7^3;7;2;7^3;;9;8^4;;1;13^3;;34;
        ;
P40     ;;8;;1;^3;;11;^11;1;2;1^6;;3;1^3;1;2;1^6;;5;1^3;;2;1^6;;5;1^3;;2;1^6;;5;1^3;;2;1^6;;5;1^3;;2;1^3;;48
        ;
60      ;;1;1;10;1^13;2;2;2^4;3;1;3^4;4;3;4^11;5;3;5^6;;32;5^3;;44
        ;
ERR     S DGERR=1
        W !,T,$S(T["H":" ",1:$E(Y,4)),"  "
        W:"45"[$E(T,1) $E(Y,31,32),"-",$E(Y,33,34),"-",$E(Y,35,36),"@",$E(Y,37,40)
        W ?25,$P($P(ERR,U,$P(DGO,";",4)),":",2),?40,"COL.",F,"  VALUE: ",$S($E(Y,F)=" ":"BLANK",1:$E(Y,F))
        S I=$S('$D(I):1,I>0:I,1:1),^(I)=$S($D(^UTILITY("DG",$J,T_$S(T["H":"",1:$E(Y,4)),I)):^(I),1:U) I $P(DGO,";",2),^(I)'[(U_$P(DGO,";",2)_U) S ^(I)=^(I)_$P(DGO,";",2)_U
        Q
        ;
D10     I $E(Y,66)="Z" S (F,H)=68,W="11;10;1;10" D L
        ;Allow FEE BASIS with means test of U to transmit to Austin - DG*5.3*817
        ;I $P(^DGPT(J,0),"^",4),$P(^(0),"^",10)="U",$D(^DGPT(J,70)),+^(70)>2890700 S F=79,DGO="2;12;1;12" D ERR
        Q
        ;
D40     Q
DP40    Q
D70     I "467"'[$E(Y,43) S F=44,W="4;4;1;4^1;5;1;5^11;6;1;6" D L
        Q
D50     I "A0"[$P(DG0,U,5)!("A4"[$P(DG0,U,5))!('$D(^DGPT(J,70))) S W="11;6;1;6",F=55 D L
        I $D(^DGPT(J,70)),$S(T1:1,1:+^(70)>2871000) S W="11;6;1;6",F=55 D L
        I $E(Y,4)=1 S W="9;7;1;7",F=56 D L
        I I=1,'T1 S W="1;11;1;11",F=108 D L
        Q
D53     Q
D60     I $E(Y,43) S F=44,W="1;4;3;4" D L
        Q
HEAD    S ERR="1:SSN^2:ADMISSION DATE^3:FACILITY #",W="8;1;1;1^1;1;9;1^1;2;10;2^1;3;3;3^6;;3;3",F=5,T="HEADER" D LOG
        D L
        Q
LOG     ;place DGLOGIC in array inorder to add more logic tests ;DG*5.3*664
        K DGLOGIC ;S DGLOGIC=$P($T(LOGIC),";;",2)
        N LOGX,LOGI,LOGCNT,II,XX
        S LOGI=0,LOGCNT=1
        F LOGI=0:1 S LOGX=$P($T(LOGIC+LOGI),";;",2) Q:LOGX="END"  F II=1:1 S XX=$P(LOGX,U,II) Q:XX=""  S DGLOGIC(LOGCNT)=XX,LOGCNT=LOGCNT+1
        Q
CEN     S T=70,ERR=$P($T(T70),";;",2),W=$P($T(70),";;",2,999),W="13;9;1;9"_$P(W,"13;9;1;9",2,999),F=56 D L
        S ERR=$P($T(T701),";;",2),W=$P($T(701),";;",2,999),F=72 D L
        Q
