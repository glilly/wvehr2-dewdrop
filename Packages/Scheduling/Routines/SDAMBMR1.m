SDAMBMR1        ;ALB/MLI - AMBULATORY PROCEDURE MANAGEMENT REPORTS ; 4/27/00 10:39am
        ;;5.3;Scheduling;**28,132,180,534**;Aug 13, 1993;Build 8
        S (SDCL,SDT)=$P(SDOE0,U,4) Q:$S('SDT:1,'$D(^SC(SDT,0)):1,1:0)
        D 2^VADPT
        N SDSSN S SDT=$S(SDSC="C":$P(^SC(SDT,0),U),$P(^SC(SDT,0),U,8)]"":$P(^(0),U,8),1:"U"),SDSSN=$P(VADM(2),"^"),VADM(2)=+SDSSN ; save ssn in string format
        S VADM(5)=$S(VADM(5)]"":$P(VADM(5),U),1:"M") S:SDT=0 SDT="Z"
        S SDDIV=$S($P(SDOE0,U,11):$P(SDOE0,U,11),1:$O(^DG(40.8,0)))
        Q:'SDDIV!('VAUTD&'$D(VAUTD(SDDIV)))
        I SDSC="S" Q:'SDAS&'$D(SDS(SDT))
        I SDSC="C" Q:'VAUTC&'$D(VAUTC(SDT))
        ;
        K SDVCPTS
        S SDCT=0
        D GETCPT^SDOE(SDOE,"SDVCPTS")
        S (PROC,SDVCPT)=0
        F  S SDVCPT=$O(SDVCPTS(SDVCPT)) Q:'SDVCPT  D
        . S X=$G(SDVCPTS(SDVCPT))
        . S SDPR=+X
        . S SDQTY=+$P(X,U,16)
        . IF SDPR]"",$$CPT^ICPTCOD(SDPR,0) S SDCT=SDCT+SDQTY I SDRT="E",SDPN="P",'SDP,'$D(SDP(SDPR)) S SDCT=SDCT-SDQTY
        ;
        Q:'SDCT  I SDRT="E",SDPN="N" Q:'VAUTN&'$D(VAUTN(VADM(1)))
EN      S SDVB="SDSX"_$P(VADM(5),U)
        G 1:'$D(^TMP($J,"*PT",VADM(1),VADM(2))),2:'$D(^(VADM(2),VAEL(4))),3:'$D(^TMP($J,"*CL",VADM(2),SDT)),4:'$D(^(SDT,VAEL(4))),5:'$D(^TMP($J,"*DT",VADM(2),$P(SDI,"."))) S SDF=0 D:'$D(^($P(SDI,"."),VAEL(4))) CK
        G 6:SDF,9
1       S SDTOT=SDTOT+1,SDAGE=SDAGE+VADM(4),@(SDVB)=(@(SDVB)+1)
2       S SDTOT(VAEL(4))=SDTOT(VAEL(4))+1,SDAGE(VAEL(4))=SDAGE(VAEL(4))+VADM(4),@(SDVB_"(VAEL(4))")=@(SDVB_"(VAEL(4))")+1
        I $D(^TMP($J,"*CL",VADM(2),SDT)) G 4:'$D(^(SDT,VAEL(4))),5:'$D(^TMP($J,"*DT",VADM(2),$P(SDI,"."))) S SDF=0 D:'$D(^($P(SDI,"."),VAEL(4))) CK G 6:SDF,9
3       S ^("T")=^TMP($J,SDT,"T")+1,^("A")=^TMP($J,SDT,"A")+VADM(4),^("S"_$P(VADM(5),U))=^TMP($J,SDT,"S"_$P(VADM(5),U))+1
4       S ^(VAEL(4))=^TMP($J,SDT,"T",VAEL(4))+1,^(VAEL(4))=^TMP($J,SDT,"A",VAEL(4))+VADM(4),^(VAEL(4))=^TMP($J,SDT,"S"_$P(VADM(5),U),VAEL(4))+1 I $D(^TMP($J,"*DT",VADM(2),$P(SDI,"."))) S SDF=0 D:'$D(^($P(SDI,"."),VAEL(4))) CK G 6:SDF,9
5       S SDVST=SDVST+1
6       S SDVST(VAEL(4))=SDVST(VAEL(4))+1
9       S (^TMP($J,"*PT",VADM(1),VADM(2),VAEL(4)),^TMP($J,"*CL",VADM(2),SDT,VAEL(4)),^TMP($J,"*DT",VADM(2),$P(SDI,"."),VAEL(4)))="",SDFL=1 I SDRT="E",SDPN="P",'SDP S SDFL=0
        I SDRT="E",(SDPN="N"),'$D(^TMP($J,"*PTC",SDT,VADM(1),VADM(2),VAEL(4),SDI)) S ^(SDI)=VADM(4)_"^"_VADM(5)_"^^^^^^^^"_SDSSN
        ;
        S (PROC,SDVCPT)=0
        F  S SDVCPT=$O(SDVCPTS(SDVCPT)) Q:'SDVCPT  D
        . S X=$G(SDVCPTS(SDVCPT))
        . S SDPRO=+X
        . S SDQTY=+$P(X,U,16)
        . I SDPRO]"",$$CPT^ICPTCOD(SDPRO,0) I SDFL!('SDFL&$D(SDP(SDPRO))) S SDPRC(VAEL(4))=SDPRC(VAEL(4))+SDQTY,^(VAEL(4))=^TMP($J,SDT,"PR",VAEL(4))+SDQTY I SDRT="E" D PRO:SDPN="P",NM:SDPN="N"
        S SDSTP=SDSTP+1,SDSTP(VAEL(4))=SDSTP(VAEL(4))+1,^("ST")=^TMP($J,SDT,"ST")+1,^(VAEL(4))=^("ST",VAEL(4))+1
        D KVAR^VADPT Q
PRO     S ^(VAEL(4))=$S($D(^TMP($J,"*PRO",SDT,SDPRO,VAEL(4))):^(VAEL(4))+1,1:SDQTY) I SDPT=1 S ^(SDI)=VAEL(4)_"^"_VADM(4)_"^"_VADM(5)_"^"_$S($D(^(VADM(1),VADM(2),SDI)):$P(^(SDI),U,4)+1,1:1)_"^^^^^^"_SDSSN
        N MODIFIER,PTR
        S PTR=0
        F  S PTR=$O(SDVCPTS(SDVCPT,1,PTR)) Q:'PTR  D
        . S MODIFIER=$G(SDVCPTS(SDVCPT,1,PTR,0))
        . Q:'MODIFIER
        . S ^(VAEL(4))=^TMP($J,"*PRO",SDT,SDPRO,VAEL(4))_"^"_MODIFIER
        . Q
        Q
CK      I VAEL(4) S SDF=1 I $D(^TMP($J,"*DT",VADM(2),$P(SDI,"."),0)) K ^(0) S SDVST(0)=SDVST(0)-1
        I 'VAEL(4) I '$D(^TMP($J,"*DT",VADM(2),$P(SDI,"."),1)) S SDF=1 Q
        Q
NM      S ^(SDI)=^TMP($J,"*PTC",SDT,VADM(1),VADM(2),VAEL(4),SDI)_"^"_SDPRO
        N MODIFIER,PTR
        S PTR=0,PROC=PROC+1
        S ^TMP($J,"*PTC",SDT,VADM(1),VADM(2),VAEL(4),SDI,PROC)=""
        F  S PTR=$O(SDVCPTS(SDVCPT,1,PTR)) Q:'PTR  D
        . S MODIFIER=$G(SDVCPTS(SDVCPT,1,PTR,0))
        . Q:'MODIFIER
        . S ^(PROC)=^TMP($J,"*PTC",SDT,VADM(1),VADM(2),VAEL(4),SDI,PROC)_MODIFIER_"^"
        . Q
        Q
QS      W !,"Enter a service or 'return' when all services have been selected" S SDX=$P(^DD(44,9,0),U,3) W !,"Choose from:" F I=1:1:5 S SDI=$P(SDX,";",I) W !,"'",$P(SDI,":",1),"' FOR ",$P(SDI,":",2)
        Q
NONE    W !!,"The ambulatory procedures management reports have run",!,"No matches were found for the following requested information:",! K Y S $P(Y,"-",81)="" W Y D DT^SDAMBMR2 W !!,"DATE RANGE: ",SDB,"-",SDE,!,"DIVISION(S): " W:VAUTD "ALL"
        I 'VAUTD F I=0:0 S I=$O(VAUTD(I)) Q:'I  W VAUTD(I),", "
        W !,$S(SDSC="C":"CLINIC(S): ",1:"SERVICE(S): ") W:VAUTC!SDAS "ALL" I '(VAUTC!SDAS) S I=0 F I1=0:0 S I=$S(SDSC="C":$O(VAUTC(I)),1:$O(SDS(I))) Q:'I  W:SDSC="C" I,", " I SDSC="S" D SET^SDAMBMR2 W SDT,", "
        Q:SDRT="B"  I SDPN="N" W !,"PATIENT(S): " W:VAUTN "ALL" I 'VAUTN S I=0 F I1=0:0 S I=$O(VAUTN(I)) Q:'I  W I,", "
        Q:SDPN="N"  W !,"PROCEDURE(S): " W:SDP "ALL" I 'SDP S I=0 F  S I=$O(SDP(I)) Q:I=""  W $P($$CPT^ICPTCOD(I,0),U),", "
        Q
