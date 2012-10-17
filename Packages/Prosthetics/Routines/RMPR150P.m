RMPR150P        ;VM/RB - FIX PROBLEM FILE #660 ISSUES WITH NEGATIVE AMIS GROUPER COUNTER ;03/27/08
        ;;3.0;Prosthetics;**150**;13/27/08;Build 10
        ;;
        Q
FIXAMIS ;   Post install to correct negative AMIS GROUPER pointers/links caused by
        ;   field GROUPER COUNTER in File #669.9 being set to zero and 
        ;   allowing negative pointers to be created. 
        ;
BUILD   K ^XTMP("RMPR150P"),XSTN D NOW^%DTC S RMSTART=%
        S ^XTMP("RMPR150P","START COMPILE")=RMSTART
        S ^XTMP("RMPR150P","END COMPILE")="RUNNING"
        S ^XTMP("RMPR150P",0)=$$FMADD^XLFDT(RMSTART,90)_"^"_RMSTART
0       ;FIND 660 RECORDS WITH NEGATIVE 'AMS' POINTERS
        S IEN=0,U="^",TOT=0 K ^TMP($J)
1       S IEN=$O(^RMPR(660,IEN)) G 90:IEN=""!(IEN]"@")
        S R=$G(^RMPR(660,IEN,0)),AMS=0,RSTN=$P(R,U,10),DFN=$P(R,U,2) K LIEN
        G:DFN="" 1
        G:RSTN="" 1
2       S AMS=$G(^RMPR(660,IEN,"AMS")) G:AMS>0 1
3       I '$D(^RMPR(660,IEN,"LB")) G 1
        S RLB=^RMPR(660,IEN,"LB"),LIEN=$P(RLB,U,10)
        I LIEN="" G 1
        I '$O(^RMPR(668,"F",IEN,0))
5       S STN=$O(^RMPR(669.9,"C",RSTN,0)) I 'STN S ^XTMP("RMPR150P",999,"STATION INVALID",RSTN)="" G 1
        I '$D(XSTN(STN)) D
        . S R669=^RMPR(669.9,STN,0),AMSG=$P(R669,U,7)
        . I AMSG<0 S AMSG=99999999
        . S XSTN(STN)=AMSG
        I $D(^TMP($J,LIEN)) S AMSG=^TMP($J,LIEN)
        E  S $P(XSTN(STN),U)=$P(XSTN(STN),U)-1,AMSG=$P(XSTN(STN),U)
6       S PNAME=$P(^DPT(DFN,0),U,1)
        S ^TMP($J,LIEN)=AMSG
        S TOT=TOT+1
        S ^XTMP("RMPR150P",660,IEN,0)=R
        S ^XTMP("RMPR150P",660,IEN,"AMS")=AMS_U_AMSG_U_"LB: "_$G(LIEN)
        S $P(XSTN(STN),U,2)=$P(XSTN(STN),U,2)+1
        S ^RMPR(660,IEN,"AMS")=AMSG
        ;FIND LINKED SUSPENSE RECORD GROUP (11) AND RESET W/ NEW AMIS GROUPER #
        S SIEN=0,S10=0
10      S SIEN=$O(^RMPR(668,"F",IEN,SIEN)) G 19:SIEN=""
11      S S10=$O(^RMPR(668,"F",IEN,SIEN,S10)) G 10:S10=""
12      S XAMS=$G(^RMPR(668,IEN,11,S10,0))
        I XAMS'="" K ^RMPR(668,IEN,11,S10,0),^RMPR(668,IEN,11,"B",XAMS,S10),^RMPR(668,"G",XAMS,SIEN,S10)
        I AMSG>0 S ^RMPR(668,SIEN,11,S10,0)=AMSG,^RMPR(668,"G",AMSG,SIEN,S10)="",^RMPR(668,SIEN,11,"B",AMSG,S10)=""
        S ^XTMP("RMPR150P",660,IEN,"SUS,668-11",SIEN,S10)=AMS_U_AMSG
        G 11
19      G 1
        ;
90      ;correct any sites with NULL/negative AMIS GROUPER number and change to 99999999.
91      S IEN=0
92      S IEN=$O(^RMPR(669.9,IEN)) I IEN=""!(IEN]"@") G EXIT
        S R=^RMPR(669.9,IEN,0) I $P(R,U,7)>55555555 G 92
        S $P(^RMPR(669.9,IEN,0),U,7)=85000000
        S ^XTMP("RMPR150P",669.9,IEN)=R
        G 92
EXIT    ;
        I $O(XSTN(0)) M ^XTMP("RMPR150P","STN")=XSTN D
        . S X=0 F I=1:1 S X=$O(XSTN(X)) Q:X=""  D
        .. S $P(^RMPR(669.9,X,0),U,7)=$P(XSTN(X),U)
        . Q
        D NOW^%DTC S RMEND=%
        I $O(XSTN(0)) M ^XTMP("RMPR150P","STN")=XSTN
        S ^XTMP("RMPR150P","END COMPILE")=RMEND
        K RMEND,RMSTART,IEN,TOT,R,DFN,PNAME,AMS,AMSG,R669,SIEN,S10,X
        K I,RSTN,STN,XSTN,LIEN,RLB,XAMS,%
        K ^TMP($J)
        Q
