PSNPO169        ;BIR/RTR-Post Init routine for patch PSN*4*169 ;10/04/08
        ;;4.0;NATIONAL DRUG FILE;**169**; 30 Oct 98;Build 8
        ;
        D BMES^XPDUTL("Importing OVERRIDE DF DOSE CHK EXCLUSION data...")
        D IMP
        D BMES^XPDUTL("Importing OVERRIDE DF DOSE CHK EXCLUSION data complete.")
        D BMES^XPDUTL("Generating Mail Message...")
        D MAIL
        D BMES^XPDUTL("Mail Message sent.")
        Q
        ;
        ;
IMP     ;Import OVVERRIDE DF DOSE CHK EXCLUSION data into VA PRODUCT File
        N PSNFDD,PSNFDX,PSNFDCNT
        S PSNFDCNT=0
        F PSNFDD=0:0 S PSNFDD=$O(@XPDGREF@("PSNVJDD",PSNFDD)) Q:'PSNFDD  D
        .I $D(^PSNDF(50.68,PSNFDD,0)) S $P(^PSNDF(50.68,PSNFDD,9),"^")=@XPDGREF@("PSNVJDD",PSNFDD)
        .S PSNFDCNT=PSNFDCNT+1
        .I '(PSNFDCNT#5000) D BMES^XPDUTL("...still importing data...")
        Q
        ;
        ;
MAIL    ;Send Mail Message
        N PSNFDS,XMTEXT,XMY,XMSUB,XMDUZ,XMMG,XMSTRIP,XMROU,XMYBLOB,XMZ
        K ^TMP($J,"PSNFDSXX")
        S ^TMP($J,"PSNFDSXX",1,0)="The Installation of patch PSN*4.0*169 is complete."
        S XMSUB="PSN*4*169 Installation Complete"
        S XMDUZ="PSN*4*169 Install"
        S XMTEXT="^TMP($J,""PSNFDSXX"","
        F PSNFDS=0:0 S PSNFDS=$O(@XPDGREF@("PSNVJARX",PSNFDS)) Q:'PSNFDS  S XMY(PSNFDS)=""
        N DIFROM D ^XMD
        K ^TMP($J,"PSNFDSXX")
        Q
