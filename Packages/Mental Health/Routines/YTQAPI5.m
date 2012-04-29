YTQAPI5 ;ALB/ASF- MHAX DISPLAYS ; 4/3/07 1:56pm
        ;;5.01;MENTAL HEALTH;**85**;Dec 30, 1994;Build 49
        Q
SURVDAT(YSDATA,YS)      ;ouput survey type data
        N %DT,X,Y,YSAD,YSANSID,YSBEG,YSB,YSEND,YSLIMIT,YSN,YSQI,YSQID,YSQS
        S YSCODE=$G(YS("CODE")) S:YSCODE="" YSCODE=0 I '$D(^YTT(601.71,"B",YSCODE)) S YSDATA(1)="[ERROR]",YSDATA(2)="bad tcode" Q  ;-->out
        S YSN=$O(^YTT(601.71,"B",YSCODE,0))
        S YSBEG=$G(YS("BEGIN")) S:YSBEG="" YSBEG="01/01/1970" S X=YSBEG,%DT="T" D ^%DT S YSBEG=Y
        S YSEND=$G(YS("END")) S:YSEND="" YSEND="01/01/2099" S X=YSEND,%DT="T" D ^%DT S YSEND=Y
        S YSLIMIT=$G(YS("LIMIT")) S:YSLIMIT="" YSLIMIT=999
        S YSB=0 F  S YSB=$O(^YTT(601.84,"AC",YSN,YSB)) Q:YSB'>0  S YSAD=0 F  S YSAD=$O(^YTT(601.84,"AC",YSN,YSB,YSAD)) Q:YSAD'>0  D
        . Q:$P(^YTT(601.84,YSAD,0),U,9)'="Y"  ;complete admins Only
        . W !,"AD= ",YSAD
        . S YSQS=0 F  S YSQS=$O(^YTT(601.76,"AD",YSN,YSQS)) Q:YSQS'>0  D
        .. S YSQI=$O(^YTT(601.76,"AD",YSN,YSQS,0)) S YSQID=$P(^YTT(601.76,YSQI,0),U,4)
        .. W !,"QID= ",YSQID," QI= ",YSQI
        .. S YSANSID=$O(^YTT(601.85,"AC",YSAD,YSQID,0))
        .. Q:YSANSID=""
        .. W !,"Answer: ",^YTT(601.85,YSANSID,1,1,0)
        Q
DISPLAY(YSDATA,YS)      ;RETURN Dispaly Info
        N N,N1,YSID
        S YSDATA(1)="[DATA]"
        S N=1,N1=0 F  S N1=$O(YS(N1)) Q:N1'>0  D
        . S N=N+1
        . S YSID=YS(N1)
        . S YSDATA(N)=$$DISPEXT^YTQAPI5(YSID)
        . ;I '$D(^YTT(601.88,YSID,0)) S YSDATA(N)=YSID_U_"[ERROR] bad id" Q  ;-->out
        .;S YSDATA(N)=^YTT(601.88,YSID,0)
        Q
DISPEXT(YSID)   ;EXTRINSIC 601.88
        N YSEX,I
        I '$D(^YTT(601.88,YSID,0)) S YSEX="[ERROR] BAD DISPLAY ID" Q YSEX
        S YSEX=YSID
        F I=1:1:11 S YSEX=YSEX_U_$$GET1^DIQ(601.88,YSID_",",I)
        Q YSEX
        ;
ADMINS(YSDATA,YS)       ;administration retrevial
        ;input : DFN
        ;output:Adm. ID^Inst. Name^Date Given^Date Saved^Orderer^Admin.By^Signed^# Answers^R_Privl^Is Legacy^INSTRUMENT id^Test IENS^copyright^location iens
        N N,N4,G,DFN,YSIENS,YSDG,YSCODE,YSRPRIV,YSEXEMP,YSCODIEN,YSINC,YSISCOMP,YSX,YSX1,YSCODEN,YSANSN,YSLEG,YSLEGI,N1,N2,YSCOPY,YSLOCAT
        S DFN=$G(YS("DFN"))
        I DFN'?1N.N S YSDATA(1)="[ERROR]",YSDATA(2)="bad DFN" Q  ;-->out
        I '$D(^DPT(DFN,0)) S YSDATA(1)="[ERROR]",YSDATA(2)="nO pt" Q  ;-->out
        S YSINC=$G(YS("COMPLETE")) I (YSINC'="Y")&(YSINC'="N") S YSDATA(1)="[ERROR]",YSDATA(2)="bad complete flag" Q  ;-->out
        S YSIENS=0,N=2
        S YSDATA(1)="[DATA]"
        F  S YSIENS=$O(^YTT(601.84,"C",DFN,YSIENS)) Q:YSIENS'>0  D
        . S G=$G(^YTT(601.84,YSIENS,0))
        . I G="" S YSDATA(1)="[ERROR]",YSDATA(2)=YSIENS_" bad ien in 84" Q  ;-->out
        . S YSISCOMP=$P(G,U,9)
        . Q:YSISCOMP'=YSINC
        . S YSDG=$P(G,U,4),YSCODE=$$GET1^DIQ(601.84,YSIENS_",",2)
        . Q:YSCODE=""
        . Q:'$D(^YTT(601.71,"B",YSCODE))
        . S YSCODIEN=$O(^YTT(601.71,"B",YSCODE,0))
        . S YSRPRIV=$$GET1^DIQ(601.71,YSCODIEN_",",9)
        . S YSCOPY=$P($G(^YTT(601.71,YSCODIEN,8)),U,5)
        . S YSLOCAT=$P($G(^YTT(601.84,YSIENS,0)),U,11)
        . S YSLEG=$P($G(^YTT(601.71,YSCODIEN,8)),U,3)
        . S YSLEGI="" S:YSLEG="Y" YSLEGI=$O(^YTT(601,"B",YSCODE,0))
        . S YSX=YSIENS_U_YSCODE_U_YSDG_U_$P(G,U,5,8)_U_$P(G,U,10)_U_YSRPRIV_U_YSLEG_U_YSCODIEN_U_YSLEGI_U_YSCOPY_U_YSLOCAT
        . S YSX(YSDG,YSCODE)=YSX
        . S YSX1(YSCODE,YSDG)=""
        D:YSINC="Y" LISTALL
        D:YSINC="N" LISTINC
        D SET
        Q
SET     ;
        S N=2,N1=9999999 F  S N1=$O(YSX(N1),-1) Q:N1=""  S YSCODE="" F  S YSCODE=$O(YSX(N1,YSCODE)) Q:YSCODE=""  S N=N+1,YSDATA(N)=YSX(N1,YSCODE)
        S YSDATA(1)="[DATA]",YSDATA(2)=N-2_" administrations returned"
        Q
LISTALL ;
        S N=0 F  S N=$O(^YTD(601.2,DFN,1,N)) Q:N'>0  D
        . ;I $P(^YTT(601,N,0),U,9)="I"  QUIT
        . I $D(^YTT(601,N)) S N2=0 F  S N2=$O(^YTD(601.2,DFN,1,N,1,N2)) Q:N2'>0  D
        .. S X=^YTT(601,N,0),N4=$P(X,U)
        .. S YSCODIEN=$O(^YTT(601.71,"B",N4,0)) Q:YSCODIEN'>0  ;-->out
        .. S YSRPRIV=$$GET1^DIQ(601.71,YSCODIEN_",",9)
        .. S YSCOPY=$S($P(X,U,6)?1N.N:"Y",1:"N")
        .. Q:$P(X,U,9)'="T"
        .. Q:'$D(^YTD(601.2,DFN,1,N,1,N2,1))
        .. S G=$G(^YTD(601.2,DFN,1,N,1,N2,0))
        .. I N4="MMPI",$D(^YTD(601.2,DFN,1,N,1,N2,99)),^(99)="MMPIR" S N4="MMPR"
        .. S YSX(N2,N4)=U_N4_U_$S($P(G,U,8)?7N.E:$P(G,U,8),1:N2)_U_N2_U_$P(G,U,3,4)_U_U_U_YSRPRIV_U_"Y"_U_U_N_U_YSCOPY_U ;ASF 12/19/06
        .. Q
        Q
LISTINC ;list all incompletes for a pt
        ;output:Adm. ID1^Inst. Name2^Date Given3^Date Saved4^Orderer5^Admin.By6^Signed7^# Answers8^R_Privl9^Is Legacy10^INSTRUMENT id11^Test IENS12^is COPY
        S N1=0 F  S N1=$O(^YTD(601.4,DFN,1,N1)) Q:N1'>0  D
        . S G=$G(^YTD(601.4,DFN,1,N1,0))
        . S YSCODE=$P($G(^YTT(601,N1,0)),U),YSDG=$P(G,U,2)
        . S YSCODEN=N1
        . S YSCOPY=$P(^YTT(601,N1,0),U,6) S YSCOPY=$S(+YSCOPY:"Y",1:"N")
        . I YSCODE?1"CLERK".E S YSCODEN=$P(G,U,6) S:YSCODEN>0 YSCODE=$P(^YTT(601,YSCODEN,0),U)
        . S YSCODIEN=$O(^YTT(601.71,"B",YSCODE,0)) Q:YSCODIEN'>0  ;-->out
        . S YSRPRIV=$$GET1^DIQ(601.71,YSCODIEN_",",9)
        . Q:$P(^YTT(601,YSCODEN,0),U,9)'="T"
        . S YSANSN=$P(G,U,4) S:YSANSN?1N.E YSANSN=YSANSN-1
        . S YSX(YSDG,YSCODE)=U_YSCODE_U_YSDG_U_$P(G,U,8)_U_$P(G,U,7)_U_U_U_YSANSN_U_YSRPRIV_U_"Y"_U_U_YSCODEN_U_YSCOPY_U
        Q
