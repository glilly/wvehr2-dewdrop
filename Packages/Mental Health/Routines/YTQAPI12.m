YTQAPI12        ;ASF/ALB MHQ IMPORT PROCEEDURES ; 4/3/07 11:14am
        ;;5.01;MENTAL HEALTH;**85**;Dec 30, 1994;Build 49
        Q
IMPORT(YSATA,YS)        ;
        K ^TMP($J)
        N YSERR,YSMS,%X,%Y,DA,DIK,N,X,Y,YSCP,YSEND,YSFILE,YSFL,YSFLD,YSGL,YSNEW,YSNVAL,YSOVAL,YSPF
        S YSMS=$G(YS("MESSAGE"))
        I YSMS="" S YSDATA(1)="[ERROR]",YSDATA(2)="no msg #" Q  ;-->out
        I YSMS'?1N.N S YSDATA(1)="[ERROR]",YSDATA(2)="bad msg #" Q  ;-->out
        S X=$$GET1^DIQ(3.9,YSMS_",",3,,"^TMP($J,""YSM"")","YSERR")
        I $D(YSERR) S YSDATA(1)="[ERROR]",YSDATA(2)="no load" Q  ;-->out
        S N=0,YSEND=0 F  D  Q:YSEND  S @X=Y
        . S N=N+1,X=$G(^TMP($J,"YSM",N))
        . S:X="" YSEND=1
        . S N=N+1,Y=$G(^TMP($J,"YSM",N))
        K ^TMP($J,"YSM")
        D RAWLOAD ;load into 601 files
        D POINT ;re point foreign keys
        Q
RAWLOAD ; load into new iens
        F YSFL=71,72,73,75,751,76,79,81,82,83,86,87,88,89,91 D
        . S YSFILE="601."_YSFL
        . S N=0  F  S N=$O(^TMP($J,"YSI",YSFILE,N)) Q:N'>0  D
        .. S YSNEW=$$NEW^YTQLIB(YSFILE)
        .. S ^TMP($J,"YSOLD",YSFILE,N)=YSNEW
        .. S %X="^TMP($J,""YSI"","_YSFILE_","_N_","
        .. S %Y="^YTT("_YSFILE_","_YSNEW_","
        .. D %XY^%RCR
        .. I (YSFILE'=601.71)&(YSFILE'=601.751) S $P(^YTT(YSFILE,YSNEW,0),U)=YSNEW
        .. S DA=YSNEW,DIK="^YTT("_YSFILE_"," D IX^DIK ;xref
        Q
POINT   ; set relational keys
        S YSFILE=601.72,YSFLD=2,YSPF=601.73 D FK ;quest intro
        ;S YSFILE=601.751,YSFLD=2,YSPF=601.75 D FK ;
        S YSFILE=601.76,YSFLD=7,YSPF=601.88 D FK ;
        S YSFILE=601.76,YSFLD=8,YSPF=601.88 D FK ;
        S YSFILE=601.76,YSFLD=9,YSPF=601.88 D FK ;
        S YSFILE=601.76,YSFLD=3,YSPF=601.72 D FK ;
        S YSFILE=601.76,YSFLD=1,YSPF=601.71 D FK ;
        S YSFILE=601.79,YSFLD=3,YSPF=601.72 D FK ;
        S YSFILE=601.79,YSFLD=2,YSPF=601.82 D FK ;
        S YSFILE=601.79,YSFLD=1,YSPF=601.71 D FK ;
        S YSFILE=601.81,YSFLD=1,YSPF=601.71 D FK ;
        S YSFILE=601.81,YSFLD=2,YSPF=601.72 D FK ;
        S YSFILE=601.81,YSFLD=6,YSPF=601.88 D FK ;
        S YSFILE=601.82,YSFLD=1,YSPF=601.72 D FK ;
        S YSFILE=601.82,YSFLD=6,YSPF=601.72 D FK ;
        S YSFILE=601.83,YSFLD=2,YSPF=601.72 D FK ;
        S YSFILE=601.83,YSFLD=3,YSPF=601.82 D FK ;
        S YSFILE=601.83,YSFLD=1,YSPF=601.73 D FK ;
        S YSFILE=601.86,YSFLD=1,YSPF=601.71 D FK ;
        S YSFILE=601.87,YSFLD=1,YSPF=601.86 D FK ;
        S YSFILE=601.91,YSFLD=2,YSPF=601.72 D FK ;
        S YSFILE=601.91,YSFLD=1,YSPF=601.87 D FK ;
        Q
FK      ;foreign keys
        S N=0 F  S N=$O(^TMP($J,"YSI",YSFILE,N)) Q:N'>0  D
        . S YSNEW=^TMP($J,"YSOLD",YSFILE,N)
        . S YSGL=$P(^DD(YSFILE,YSFLD,0),U,4),YSCP=$P(YSGL,";",2),YSGL=+YSGL
        . Q:YSCP=""
        . S YSOVAL=$P($G(^YTT(YSFILE,YSNEW,YSGL)),U,YSCP)
        . Q:YSOVAL'?1N.E
        . S YSNVAL=$G(^TMP($J,"YSOLD",YSPF,YSOVAL))
        . ;I YSNVAL'?1N.N W !,"YSFILE= ",YSFILE,"  YSGL= ",YSGL,"  YSCP= ",YSCP," TMPOLD= ",$G(^TMP($J,"YSOLD",YSPF,YSOVAL)) Q
        . S $P(^YTT(YSFILE,YSNEW,YSGL),U,YSCP)=YSNVAL
        . S DA=YSNEW,DIK="^YTT("_YSFILE_",",DIK(1)=YSFLD D EN^DIK
        Q
MLIST(YSDATA)   ;LISTMSGS^XMXAPIB(XMDUZ,XMK,XMFLDS,XMFLAGS,XMAMT,.XMSTART,.XMCRIT,XMTROOT)
        ;returns list of exported tests in mailbox
        ;input: none
        ;output : msg #^subject^date
        N XMCRIT,N
        K ^TMP("XMLIST",$J)
        K ^TMP("YSMAIL",$J) S YSDATA=$NA(^TMP("YSMAIL",$J))
        S XMCRIT("SUBJ")="EXPORT OF"
        D LISTMSGS^XMXAPIB(DUZ,"*","SUBJ;DATE","B",,,.XMCRIT)
        I $D(^TMP("XMERR",$J)) S ^TMP("YSMAIL",$J,1)="[ERROR]",^TMP("YSMAIL",$J,2)="LISTMSG err" Q  ;-->out
        S ^TMP("YSMAIL",$J,1)="[DATA]"
        S N=0 F  S N=$O(^TMP("XMLIST",$J,N)) Q:N'>0  D
        . S ^TMP("YSMAIL",$J,N+1)=^TMP("XMLIST",$J,N)_U_$G(^TMP("XMLIST",$J,N,"SUBJ"))_U_$P($G(^TMP("XMLIST",$J,N,"DATE")),U,1)
        Q
LISTASI(YSDATA,YS)      ;ASI LISTER
        ;REQUIRES: DFN
        ;RETURNS: IEN=DATE OF INTERVIEW^CLASS^SPECIAL^ESIGNED^INTERVIEWER(E)^INTERVIWER(I)
        ;0 RETURNED IF NO ADMINS
        N DFN,YSIEN,YSN
        K ^TMP("YSDATA",$J) S YSDATA=$NA(^TMP("YSDATA",$J))
        S DFN=$G(YS("DFN"))
        I DFN<1 S ^TMP("YSDATA",$J,1)="[ERROR]^bad DFN" Q  ;--->OUT
        S YSN=1
        S YSIEN=0
        S ^TMP("YSDATA",$J,1)="[DATA]^0"
        F  S YSIEN=$O(^YSTX(604,"C",DFN,YSIEN)) Q:YSIEN'>0  D  S ^TMP("YSDATA",$J,1)="[DATA]^"_(YSN-1)
        . S YSN=YSN+1
        . S ^TMP("YSDATA",$J,YSN)=YSIEN_"="_$$FMTE^XLFDT($$GET1^DIQ(604,YSIEN_",",.05,"I"),"5ZD")_U_$$GET1^DIQ(604,YSIEN_",",.04,"E")_U_$$GET1^DIQ(604,YSIEN_",",.11,"E")_U_$$GET1^DIQ(604,YSIEN_",",.51,"E")
        . S ^TMP("YSDATA",$J,YSN)=^TMP("YSDATA",$J,YSN)_U_$$GET1^DIQ(604,YSIEN_",",.09,"E")_U_$$GET1^DIQ(604,YSIEN_",",.09,"I")
        . S ^TMP("YSDATA",$J,YSN)=^TMP("YSDATA",$J,YSN)_U_$$GET1^DIQ(604,YSIEN_",",.09,"E")_U_$$GET1^DIQ(604,YSIEN_",",.09,"I")
        Q
