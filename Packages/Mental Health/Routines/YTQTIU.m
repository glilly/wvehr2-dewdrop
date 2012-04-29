YTQTIU  ;ASF/ALB- MHAX TIU ;2/14/05 6:57pm ; 10/30/07 11:15am
        ;;5.01;MENTAL HEALTH;**85**;Dec 30, 1994;Build 49
        Q
PCREATE(YSDATA,YS)      ;pn creation
        ;Input AD AS ien of 601.84 mh administration
        ; YS(1...X) as text of note
        N DFN,N,N1,N2,Y,YSAD,YSAVED,YSENC,YSHOSP,YSOK,YSORD,YSRPRIVL,YST,YSTIT,YSTS,YSVISIT,YSVSIT,YSVSTR,YST1,YSTIUX,YSTIUDA
        N VA,VADM,X,YSAGE,YSB,YSDOB,YSG,YSHDR,YSNM,YSSEX,YSSSN
        S YSTIUDA=$G(YS("TIUIEN"),0)
        S YSDATA(1)="[ERROR]"
        S YSAD=$G(YS("AD"),0)
        I '$D(^YTT(601.84,YSAD,0)) S YSDATA(2)="bad ad" Q  ;-->out
        S YSHOSP=$P(^YTT(601.84,YSAD,0),U,11)
        I YSHOSP'>0 S YSDATA(2)="no location" Q  ;-->out
        S DFN=$$GET1^DIQ(601.84,YSAD_",",1,"I")
        I DFN'>0  S YSDATA(2)="bad dfn" Q  ;-->out
        S YSAVED=$$GET1^DIQ(601.84,YSAD_",",4,"I")
        S YSORD=$$GET1^DIQ(601.84,YSAD_",",5,"I")
        S Y=$$WHATITLE^TIUPUTU("MENTAL HEALTH DIAGNOSTIC STUDY")
        I Y'>0 S Y=$$WHATITLE^TIUPUTU("MHA ASSESSMENT NOTE")
        I Y'>0 S YSDATA(2)="pn not setup" Q  ;--->out
        S YSTIT=+Y
        S YSTS=$$GET1^DIQ(601.84,YSAD_",",2,"I")
        S YSRPRIVL=$$GET1^DIQ(601.71,YSTS_",",9,"E")
        Q:YSRPRIVL'=""  ;-->out  ASF 5/1/07
        D DEM^VADPT,PID^VADPT S YSNM=VADM(1),YSSEX=$P(VADM(5),U),YSDOB=$P(VADM(3),U,2),YSAGE=VADM(4),YSSSN=VA("PID")
        S $P(YSHDR," ",60)="",YSHDR=YSSSN_"  "_YSNM_YSHDR,YSHDR=$E(YSHDR,1,44)_YSSEX_" AGE "_YSAGE
        I YSTIUDA>0 D UPDATE Q  ;-->out
        D TXTCK(0)
        ;
        ;MAKE(SUCCESS,DFN,TITLE,VDT,VLOC,VSIT,TIUX,VSTR,SUPPRESS,NOASF)
        D MAKE^TIUSRVP(.YSOK,DFN,YSTIT,YSAVED,YSHOSP,,.YSTIUX,YSHOSP_";"_YSAVED_";E")
        Q:YSOK'>0  ;-->out
        S YSDATA(1)="[DATA]",YSDATA(2)=YSOK
        S YSVISIT=$$GET1^DIQ(8925,YSOK_",",.03,"I")
        S ^TMP("YSENC",$J,"ENCOUNTER",1,"ENC D/T")=YSAVED
        S ^TMP("YSENC",$J,"ENCOUNTER",1,"HOS LOC")=YSHOSP
        S ^TMP("YSENC",$J,"ENCOUNTER",1,"PATIENT")=DFN
        S ^TMP("YSENC",$J,"ENCOUNTER",1,"SERVICE CATEGORY")="E"
        S ^TMP("YSENC",$J,"ENCOUNTER",1,"ENCOUNTER TYPE")="O"
        S ^TMP("YSENC",$J,"PROCEDURE",1,"ENC PROVIDER")=YSORD
        S ^TMP("YSENC",$J,"PROCEDURE",1,"EVENT D/T")=YSAVED
        S ^TMP("YSENC",$J,"PROVIDER",1,"NAME")=YSORD
        S ^TMP("YSENC",$J,"PROVIDER",1,"PRIMARY")=1
        S YSENC=$$DATA2PCE^PXAPI("^TMP(""YSENC"",$J)",19,"MHA DATA",.YSVISIT,"^TMP(""YSENC"",$J")
        K ^TMP("YSENC",$J)
        Q
UPDATE  ;
        K ^TMP("TUIVIEW",$J)
        D TGET^TIUSRVR1(.YST1,YSTIUDA)
        S N1=4,N2=0 ;keep from adding header each time
        F  S N1=$O(^TMP("TIUVIEW",$J,N1)) Q:N1'>0  S N2=N2+1,YSTIUX("TEXT",N2,0)=^TMP("TIUVIEW",$J,N1)
        K ^TMP("TUIVIEW",$J)
        S YSTIUX(.02)=DFN
        S YSTIUX(1301)=YSAVED
        S YSTIUX(1302)=YSORD
        S $P(X,"_",75)=""
        S N2=N2+1,YSTIUX("TEXT",N2,0)=X
        D TXTCK(N2)
        D UPDATE^TIUSRVP(.YSOK,YSTIUDA,.YSTIUX)
        S:YSOK YSDATA(1)="[DATA]",YSDATA(2)=YSOK
        Q
TXTCK(N2)       ;clean text
        S N=0,N1=0 F  S N=$O(YS(N)) Q:N'>0  D
        . S YSG=YS(N)
        . I YSG="" S YSB=$G(YSB)+1
        . E  S YSB=0
        . I (YSG="")&(YSB>2) Q  ;no print mult blanks
        . I N>3 Q:($E(YSG,1,51)=$E(YSHDR,1,51))
        . I N>3 Q:YSG?." "1"PRINTED    ENTERED"." "
        . Q:YSG?1"Not valid unless signed: Reviewed by".E
        . Q:YSG?1"Printed by: ".E
        . S N1=N1+1
        . S YSTIUX("TEXT",N1+N2,0)=YS(N) K YS(N)
        Q
