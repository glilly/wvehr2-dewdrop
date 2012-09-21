PSNFDAMG        ;BIR/DMA - REQUEST A MED GUIDE ; 12 Feb 2010  8:26 AM
        ;;4.0; NATIONAL DRUG FILE;**108**; 30 Oct 98;Build 22
        I $G(^PSNDF(50.68,PSNIEN,"MG"))="" W !,"There is no FDA Medication Guide associated with this medication.",! Q
        I '$D(^XTMP("PSNMG")) S ^XTMP("PSNMG",0)=$$FMADD^XLFDT(DT,30)_"^"_DT_"^REQUEST A MED GUIDE"
        S X=$O(^XTMP("PSNMG",IO("IP")," "),-1)+1,^XTMP("PSNMG",IO("IP"),X)=^PSNDF(50.68,PSNIEN,"MG"),^XTMP("PSNMG",IO("IP"),X,"P")="Q"
        W !,"The following URL provides the link to the FDA Medication Guide associated"
        W !,"with this medication." S FDAMGURL=$P(^PSNDF(50.68,PSNIEN,"MG"),"^")
        W !!
        W $E(FDAMGURL,1,80)
        I $L(FDAMGURL)>80 D
        .F  Q:$E(FDAMGURL,81,999)=""  S FDAMGURL=$E(FDAMGURL,81,999) W !,$E(FDAMGURL,1,80)
        W !!,"Retrieving the Medication Guide.  (This may take several seconds)",! F J=1:1:10 W "." H 1
        W !!,"If the FDA Medication Guide does not automatically open in a .PDF format,"
        W !,"this desktop may not have the required software installed."
        W !,"Contact your local technical support for assistance."
        S PSNFDAMG=^PSNDF(50.68,PSNIEN,"MG")
        R !!,"Press Enter to continue",X:DTIME Q
        K X,Y Q
RETRIEVE(RESULT,IP)     ;ON DEMAND FDA MED GUIDE PRINTING
         N SEQ I $G(IP)]"" D
        .K RESULT S SEQ=0
        .F  S SEQ=$O(^XTMP("PSNMG",IP,SEQ)) Q:'SEQ  D
        ..I $G(^XTMP("PSNMG",IP,SEQ,"P"))="Q" S RESULT(SEQ)=^XTMP("PSNMG",IP,SEQ),^XTMP("PSNMG",IP,SEQ,"P")="P"
        Q
