PXTTEDL ;ALB/TH - GET AND PRINT EDUCATION SUBTOPIC;11/21/08
        ;;1.0;PCE PATIENT CARE ENCOUNTER;**193**;Aug 12, 1996;Build 2
        ; 
EN      ; Entry point
        Q:'$D(^AUTTEDT(D0,10,0))
        N PXTTEDL,PXTERR,X,SEQ,SUBTOPIC,X1,DATA
        ; Get SEQUENCE and SUBTOPIC from Node 10
        D GETS^DIQ(9999999.09,D0_",","10*","E","PXTTEDL","PXTERR")
        I $D(PXTERR) Q
        S (X,SEQ,SUBTOPIC)=""
        F  S X=$O(PXTTEDL(9999999.091001,X)) Q:'X  D
        . S SEQ=PXTTEDL(9999999.091001,X,3,"E")
        . ; If SEQENCE is null, then set to 0
        . I SEQ="" S SEQ=0
        . S SUBTOPIC=PXTTEDL(9999999.091001,X,.01,"E")
        . S PXTTEDL("P",SEQ,X)=$S(SEQ=0:"",1:SEQ)_U_SUBTOPIC
        ; Print SEQUENCE and SUBTOPIC
        S (SEQ,X1,DATA)=""
        F  S SEQ=$O(PXTTEDL("P",SEQ)) Q:SEQ=""  D
        . F  S X1=$O(PXTTEDL("P",SEQ,X1)) Q:X1=""  D
        . . S DATA=PXTTEDL("P",SEQ,X1)
        . . W ?12,$P(DATA,U),?17,$E($P(DATA,U,2),1,60),!
        Q
