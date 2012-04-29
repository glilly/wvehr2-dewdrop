YTQHL7  ;ALB/ASF HL7 ; 10/31/07 2:39pm
        ;;5.01;MENTAL HEALTH;**85,93**;Dec 30, 1994;Build 1
        Q
ACKMHA  ;
        N YSLOCAT,YSERT,YSDIV,YSACK,YSMID,YSFS,YSAD,YSMTXT,YSX,YS772,YSMSG
        S YSACK="",YSFS=HL("FS")
        ;get ack type
        F  X HLNEXT Q:HLQUIT'>0  D
        . I $P(HLNODE,YSFS)="MSA" S YSACK=$P(HLNODE,YSFS,2),YSMID=$P(HLNODE,YSFS,3),YSERT=$P(HLNODE,YSFS,1,4)
        ;get ien of 601.84 from message
        S DIC=773,DIC(0)="MZ",X=YSMID D ^DIC K DIC
        I Y'>0 D ERRMAIL("BAD BAD") Q  ;-->out
        S YS772=$P(Y,U,2) ;ien of message 772
        S X=$$GET1^DIQ(772,YS772_",",200,,"YSMSG")
        S N=0,YSAD=0 F  S N=$O(YSMSG(N)) Q:N'>0!(YSAD>0)  S YSOUT=YSMSG(N) S:$P(YSOUT,YSFS)="OBX" YSAD=+$P(YSOUT,YSFS,4)
        I YSAD'>0 D ERRMAIL(YSMTXT_"  MH ADMINITRATION #601.84 ien is 0",YSAD) Q  ;--->out
        ;set 601.84 fields
        S YSX=$S(YSACK="AA":"S",YSACK="AE":"E",YSACK="AR":"E",1:"")
        S DA=YSAD,DIE="^YTT(601.84,",DR="11///"_YSX_";12///NOW" D ^DIE
        I YSX'="S" D ERRMAIL(YSERT,YSAD)
        Q
ERRMAIL(X,YSAD) ;mail error reports
        N XMDUZ,XMSUB,XMTEXT,XMY,YSMAILG
        S YSMAILG=$$GETAPP^HLCS2("YS MHA")
        K ^TMP("YSMHAHL7",$J)
        S ^TMP("YSMHAHL7",$J,1,0)="An attempt to send MHA3 Administration ien #"_YSAD
        S ^TMP("YSMHAHL7",$J,2,0)="generated an error."
        S ^TMP("YSMHAHL7",$J,3,0)="Error: "_X
        S ^TMP("YSMHAHL7",$J,4,0)="Please report this error via official channels."
        S XMSUB="Mental Health Assistant 3 HL7 Error"
        S XMY("G."_$P(YSMAILG,U))=""
        S XMTEXT="^TMP(""YSMHAHL7"",$J,"
        S XMDUZ="AUTOMATED MESSAGE"
        D ^XMD
        K ^TMP("YSMHAHL7",$J)
        Q
HL7(YSDATA,YS)  ;RPC entry
        ;input:ADMIN = ADMINISTRATION #
        ;output: [DATA]
        N G,G1,N,YSAD,YSQ,CNT,MC,HLFS,HLCS,DA,DFN,DIE,DR,HLECH,HLNEXT,HLNODE,HLQUIT,MYOPTNS,MYRESULT
        N VADMVT,VAINDT,X1,Y,YSANSID,YSAVED,YSCC,YSCONID,YSEQ,YSIN,YSIO,YSLINE,YSORBY,YSOUT,YSQN,YSTEST,YSTESTN,YSTS,YSTST
        S YSAD=$G(YS("AD"))
        I YSAD'?1N.N S YSDATA(1)="[ERROR]",YSDATA(2)="bad ad num" Q  ;-->out
        I '$D(^YTT(601.84,YSAD)) S YSDATA(1)="[ERROR]",YSDATA(2)="no such reference" Q  ;-->out
        ;No Dups
        I $P($G(^YTT(601.84,YSAD,2)),U)="S" S YSDATA(1)="[ERROR]",YSDATA(2)=YSAD_" is dup" Q  ;-->out
        S YSTST=$P(^YTT(601.84,YSAD,0),U,3) ;ins ien
        I $P($G(^YTT(601.71,YSTST,8)),U,4)'="Y" S YSDATA="[DATA]",YSDATA(2)="ins not to be sent" Q  ;--> out
        S YSDATA(1)="[ERROR]"
        S DA=YSAD,DIE="^YTT(601.84,",DR="11///T;12///NOW" D ^DIE
        D ADSEND
        Q
ADSEND  ;send completed Admin to MHSHG
        S DFN=$P(^YTT(601.84,YSAD,0),U,2)
        S YSAVED=$P(^YTT(601.84,YSAD,0),U,4) ;changed to GIVEN 10/31/07
        S YSTESTN=$P(^YTT(601.84,YSAD,0),U,3)
        S YSTEST=$$GET1^DIQ(601.71,YSTESTN_",",.01)
        S YSORBY=$P(^YTT(601.84,YSAD,0),U,6)
        S YSLOCAT=$P(^YTT(601.84,YSAD,0),U,11)
        S YSDIV="" S:YSLOCAT?1N.N YSDIV=$$GET1^DIQ(44,YSLOCAT_",",3.5)
        I YSDIV=""&($D(DUZ(2))) S YSDIV=$$GET1^DIQ(4,DUZ(2)_",",.01)
BLDM    ;BUILD A SINGLE MESSAGE
        ;MSH-EVN-PID-PV1-OBX
        K HLA,HLEVN
        N CNT,MC,HLFS,HLCS
        S CNT=0
1       ;set up environment for message
        K HL D INIT^HLFNC2("YS MHA A08 EVENT",.HL)
        I $G(HL) D  Q  ; error occurred -->out
        . ; put error handler here for init failure
        . S YSDATA(1)="[ERROR]",YSDATA(2)="init Error: "_$P(HL,2) W !,"XXX"
        S HLFS=$G(HL("FS")) I HLFS="" S HLFS="^"
        S HLCS=$E(HL("ECH"),1)
2       ;Add message txt to HLA array
        ;create ENV segment
        S CNT=CNT+1,HLA("HLS",CNT)="EVN"_HLFS_"A08"_HLFS_$$HLDATE^HLFNC(YSAVED,"TS")_HLFS_$$HLDATE^HLFNC(YSAVED,"TS")_HLFS_"05"_HLFS_HLFS_$$HLDATE^HLFNC(YSAVED,"TS")
        ; create PID segment for patient DFN -- call segment generator
        S CNT=CNT+1,HLA("HLS",CNT)=$$EN^VAFHLPID(DFN,"1,2,4,6,7,8,10,11,12,13,16,17,19,22",1,1)
        ;create PV1 segment
        S VAINDT=YSAVED D ADM^VADPT2 S YSIO=$S(VADMVT>0:"I",1:"O")
        S CNT=CNT+1,HLA("HLS",CNT)="PV1"_HLFS_"0001"_HLFS_YSIO_HLFS_"~~~~~~~~"_YSDIV
        ;create OBX segments
        D OBX(YSAD)
        ;crete PR1 proccedure
        S CNT=CNT+1
        S HLA("HLS",CNT)="PR1"_HLFS_1_HLFS_HLFS_YSTESTN_$E($G(HLECH))_YSTEST_HLFS_HLFS_$$HLDATE^HLFNC(YSAVED,"TS")_HLFS_"D"
        N DGNAME S DGNAME("FILE")=200,DGNAME("IENS")=YSORBY,DGNAME("FIELD")=.01
        S X1=$$HLNAME^XLFNAME(.DGNAME,"S",$E($G(HLECH))),X1=YSORBY_$E(HLECH,1)_X1
        S HLA("HLS",CNT)=HLA("HLS",CNT)_HLFS_HLFS_HLFS_HLFS_HLFS_HLFS_X1
        ;
        ;
DIRECT  ;CALL HL7 TO TRANSMIT MESSAGE
        ; VM/RJT - YS*5.01*93 - Turn off message generation
        ;D GENERATE^HLMA("YS MHA A08 EVENT","LM",1,.MYRESULT,"",.MYOPTNS)
        S YSDATA(1)="[DATA]"
        Q
OBX(YSAD)       ;enter multiple OBX seqments
        S YSIN=$P(^YTT(601.84,YSAD,0),U,3)
        S YSEQ=0 F  S YSEQ=$O(^YTT(601.76,"AD",YSIN,YSEQ)) Q:YSEQ'>0  S YSCONID=$O(^YTT(601.76,"AD",YSIN,YSEQ,0)) D
        . S YSQN=$P(^YTT(601.76,YSCONID,0),U,4)
        . S YSANSID=$O(^YTT(601.85,"AC",YSAD,YSQN,0))
        . Q:YSANSID'?1N.N
        . S G=$G(^YTT(601.85,YSANSID,0)),YSCC=$P(G,U,4)
        . S CNT=CNT+1
        . I +YSCC S CNT=CNT+1,HLA("HLS",CNT)="OBX"_HLFS_YSEQ_HLFS_"CE"_HLFS_YSAD_"~~~"_YSQN_HLFS_1_HLFS_YSCC_"~"_$G(^YTT(601.75,$P(G,U,4),1))_"||||||"_"R|||"_$$HLDATE^HLFNC(YSAVED,"TS") Q
        . E  S YSLINE=0 F  S YSLINE=$O(^YTT(601.85,YSANSID,1,YSLINE)) Q:YSLINE'>0  D
        .. S CNT=CNT+1,HLA("HLS",CNT)="OBX"_HLFS_YSEQ_HLFS_"CE"_HLFS_YSAD_"~~~"_YSQN_HLFS_YSLINE_HLFS_0_"~"_$G(^YTT(601.85,YSANSID,1,YSLINE,0))_"||||||"_"R|||"_$$HLDATE^HLFNC(YSAVED,"TS") Q
        Q
REDO    ;resend all no transmits and errors
        S YSAD=0 F  S YSAD=$O(^YTT(601.84,YSAD)) Q:YSAD'>0  D
        . S YSTS=$P($G(^YTT(601.84,YSAD,2)),U)
        . I (YSTS="T")!(YSTS="E") K YS,YSDATA S YS("AD")=YSAD D HL7(.YSDATA,.YS)
        Q
REDO1   ;resend single admin
        K DIC,DIR S DIC(0)="AEQM",DIC="^YTT(601.84," D ^DIC Q:Y'>0  ;-->out
        W !
        S (YSAD,DA)=+Y D EN^DIQ
        S DIR(0)="Y",DIR("A")="Send HL7",DIR("B")="No" D ^DIR
        I Y K YS,YSDATA S YS("AD")=YSAD D HL7(.YSDATA,.YS)
        G REDO1
