ORDVX1  ; slc/dcm - OE/RR Extract Lab AP Reports ;3/22/03  9:34
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**243**;Dec 17, 199;Build 242
        ; Modified from Health Summary Extract ^GMTSLREE
        ; External References
        ;   DBIA   525  ^LR(
        ;   DBIA 10011  ^DIWP
        ;                    
XEM     ; Extract EM Data
        N IX0,IX K ^TMP("OROOT",$J) S IX=OROMEGA
        F IX0=1:0:ORMAX S IX=$O(^LR(LRDFN,"EM",IX)) Q:IX'>0!(IX>ORALPHA)  D APSET("EM")
        Q
XSP     ; Extract SP Data
        N IX0,IX K ^TMP("OROOT",$J) S IX=OROMEGA
        F IX0=1:0:ORMAX S IX=$O(^LR(LRDFN,"SP",IX)) Q:IX'>0!(IX>ORALPHA)  D APSET("SP")
        Q
XCY     ; Extract CY Data
        N IX0,IX K ^TMP("OROOT",$J) S IX=OROMEGA
        F IX0=1:0:ORMAX S IX=$O(^LR(LRDFN,"CY",IX)) Q:IX'>0!(IX>ORALPHA)  D APSET("CY")
        Q
APSET(LRSS)       ; Sets ^TMP("OROOT",$J
        N ACC,CDT,DA,DIC,DIQ,DR,GMW,SN,X,YR
        S CDT=$P(^LR(LRDFN,LRSS,IX,0),U),ACC=$P(^(0),U,6)
        ;I $S(+$P(^LR(LRDFN,LRSS,IX,0),U)'>0:1,+$P(^(0),U,11)'>0:1,1:0) Q
        I $D(ACC) S IX0=IX0+1
        S X=CDT D DTM4 S CDT=X K X
        S ^TMP("OROOT",$J,IX,LRSS,0)=CDT_U_ACC
        I $D(^LR(LRDFN,LRSS,IX,.1)) S ^TMP("OROOT",$J,IX,LRSS,.1)="Site/Specimen"
        S SN=0 F  S SN=$O(^LR(LRDFN,LRSS,IX,.1,SN)) Q:SN'>0  S ^TMP("OROOT",$J,IX,LRSS,.1,SN)=$P(^LR(LRDFN,LRSS,IX,.1,SN,0),U)
        K ^TMP("ORC",$J)
        D EN^LR7OSAP4("^TMP(""ORC"",$J)",LRDFN,LRSS,IX)
        S J=0,CNT=$O(^TMP("OROOT",$J,IX,LRSS,.2,999999),-1)-1
        F  S J=$O(^TMP("ORC",$J,J)) Q:'J  S CNT=CNT+1,^TMP("OROOT",$J,IX,LRSS,.2,CNT)=^TMP("ORC",$J,J,0)
        K ^TMP("ORC",$J)
        Q
DTM4    ;   Receives X FM date and returns X in MM/DD/YYYY TT:TT
        S X=$TR($$FMTE^XLFDT(X,"5ZM"),"@"," ")
        Q
ALL     ; Get all AP data in one swell foop
        N IX0,IX K ^TMP("OROOT",$J) S IX=OROMEGA
        F IX0=1:0:ORMAX S IX=$O(^LR(LRDFN,"SP",IX)) Q:IX'>0!(IX>ORALPHA)  D APSET("SP")
        S IX=OROMEGA F IX0=1:0:ORMAX S IX=$O(^LR(LRDFN,"CY",IX)) Q:IX'>0!(IX>ORALPHA)  D APSET("CY")
        S IX=OROMEGA F IX0=1:0:ORMAX S IX=$O(^LR(LRDFN,"EM",IX)) Q:IX'>0!(IX>ORALPHA)  D APSET("EM")
        Q
