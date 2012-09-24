ACKQEN17        ;ST/BP-OIFO Pre/Post Install routine for ACKQ*3*17 ; 9/23/09 6:39am
        ;;3.0;QUASAR;**17**;Sept. 26, 2007;Build 28
        ;
        ;This is the EnvCheck install for ACKQ*3*17
        ;
        ;
ENVCH   ;Pre Install Entry
        N ACKQA,ACKQD,MSG,MCNT,MASK,NPNAM,XMY,XMDUZ,DIFROM,NPIEN,XMTEXT,BROKEN
        I $G(XPDENV)'=0 Q
        I $$PATCH^XPDUTL("ACKQ*3.0*17") D
        . W !,"Patch ACKQ*3*17 has been installed before, The data migration associated"
        . W !,"with this patch will NOT take place. Proceed with installation to update "
        . W !,"Routines and Data dictionaries."
        S MCNT=1,MASK="                                                       "
        S MSG(MCNT)="This is a list of the names in the A&SP Staff file.",MCNT=MCNT+1
        S MSG(MCNT)=" Be sure to verify and compare the data in the A&SP Staff file before",MCNT=MCNT+1
        S MSG(MCNT)=" installation of ACKQ*3*17. Below contains the names associated to the",MCNT=MCNT+1
        S MSG(MCNT)=" entry in the A&SP Staff file in comparison to the names the entry actually",MCNT=MCNT+1
        S MSG(MCNT)=" points to. If the names on the left don't match the names on the right,",MCNT=MCNT+1
        S MSG(MCNT)=" there is an obvious problem.",MCNT=MCNT+1
        S MSG(MCNT)="*Note* After installation, there will be no names associated to the IEN",MCNT=MCNT+1
        S MSG(MCNT)="       because the file structure has changed.",MCNT=MCNT+1
        S MSG(MCNT)="FILE #200 NAME                File #509850.3 IEN - ASSOCIATED NAME",MCNT=MCNT+1
        I $D(^ACK(509850.3,"D")) D
        . N I S I="" F  S I=$O(^ACK(509850.3,"D",I)) Q:I']""  S ACKQD($O(^ACK(509850.3,"D",I,0)))=I
        S ACKQA=0 F  S ACKQA=$O(^ACK(509850.3,ACKQA)) Q:'ACKQA  S NPNAM=$$GET1^DIQ(509850.3,ACKQA,.01,"E") D
        . S MSG(MCNT)=" "_NPNAM_$E(MASK,1,30-$L(NPNAM))_ACKQA_$E(MASK,1,10-$L(ACKQA))_"- "_$G(ACKQD(ACKQA)),MCNT=MCNT+1,NPIEN=$$GET1^DIQ(8930.3,$$GET1^DIQ(509850.3,ACKQA,.01,"I"),.01,"I")
        . I +ACKQA,('NPIEN)&(NPNAM']"") S BROKEN(ACKQA)="" Q
        . I $$GET1^DIQ(509850.3,ACKQA,.06,"I") S:+NPIEN XMY(NPIEN)="" S:'NPIEN XMY(NPNAM)=""
        I $D(BROKEN) S MSG(MCNT)="",MCNT=MCNT+1,MSG(MCNT)="These file #509850.3 IEN's are Broken Pointers.",MCNT=MCNT+1 F I=0:0 S I=$O(BROKEN(I)) Q:'I  S MSG(MCNT)=" "_I,MCNT=MCNT+1
        S XMDUZ="QUASAR",XMSUB="VERIFY A&SP STAFF DATA (PRE INSTALL)",XMTEXT="MSG(",XMY(DUZ)=""
        D ^XMD
        Q
        ;
