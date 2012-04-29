SRTPTMIT        ;BIR/SJA - TRANSMIT ASSESSMENT ;04/29/08
        ;;3.0; Surgery ;**167**;24 Jun 93;Build 27
        ;
START   K TMP("SRA",$J),TMP("SRAMSG",$J) S SRATOT=0,SRASITE=+$P($$SITE^SROVAR,"^",3),(SRAMNUM,SRACNT)=1
        Q
ONE     ; tranmit single entry
        D START
        S SRADFN=0 S SR("RA")=$G(^SRT(SRTPP,"RA")) D STUFF
        K TMP("SRA",$J),TMP("SRAMSG",$J),SRTPP D ^SRSKILL
        Q
NIGHT   ; called by nightly background task
        D START
        S SRATP="" F  S SRATP=$O(^SRT("AF",SRATP)) Q:SRATP=""  S SRAST="" F  S SRAST=$O(^SRT("AF",SRATP,SRAST)) Q:SRAST=""  D
        .S SRADFN=0 F  S SRADFN=$O(^SRT("AF",SRATP,SRAST,SRADFN)) Q:'SRADFN  S SRTPP=0 F  S SRTPP=$O(^SRT("AF",SRATP,SRAST,SRADFN,SRTPP)) Q:'SRTPP  D
        ..S SR("RA")=$G(^SRT(SRTPP,"RA")) I $P(SR("RA"),"^")="C" S (SRAMNUM,SRACNT)=1 D STUFF
        K TMP("SRA",$J),TMP("SRAMSG",$J),SRTPP D ^SRSKILL
        Q
STUFF   ; stuff entries into TMP("SRA"
        I SRACNT+15>100 S SRACNT=1,SRAMNUM=SRAMNUM+1
        S SRATOT=SRATOT+1
        K SRA,VADM D ^SRTPTM1 K SRSHEMP,VADM,SRA
        S SRATOTM=SRAMNUM D PTM2
        I $D(ZTQUEUED) S ZTREQ="@"
        Q
PTM2    S SRSHEMP=3,SRAMNUM=0 F I=0:0 S SRAMNUM=$O(TMP("SRA",$J,SRAMNUM)) Q:'SRAMNUM  D ORG,MSG
STATUS  ; update status
        S (SRAMNUM,SRASS)=0
        F  S SRAMNUM=$O(TMP("SRA",$J,SRAMNUM)) Q:'SRAMNUM  S SRACNT=0 F  S SRACNT=$O(TMP("SRA",$J,SRAMNUM,SRACNT)) Q:'SRACNT  S SRCURL=$E(TMP("SRA",$J,SRAMNUM,SRACNT,0),12,14),SRCURL=$P(SRCURL," ",3) I +SRCURL=1 D UPDATE
        I 'SRASS G END
        S X=$$ACTIVE^XUSER(DUZ) I '+X S XMDUZ=.5
        S XMSUB="TRANSPLANT ASSESSMENT TRANSMISSION COMPLETE"
        S XMY("G.SR TRANSPLANT@"_^XMB("NETNAME"))=""
        D NOW^%DTC S Y=% D D^DIQ S SRATIME=$E($P(Y,"@",2),1,5)
        S TMP("SRAMSG",$J,1,0)="The Surgery Transplant Assessment Transmission was completed at "_SRATIME_"."
        S TMP("SRAMSG",$J,3,0)="  "
        S XMTEXT="TMP(""SRAMSG"",$J," N I D ^XMD
END     Q
MSG     ; send message to Denver and Hines
        S ISC=0,NAME=$G(^XMB("NETNAME")) I NAME["FORUM"!(NAME["ISC-")!($E(NAME,1,3)="ISC")!(NAME["ISC.")!(NAME["TST")!(NAME["FO-") S ISC=1
        I ISC S XMY("G.SR TRANSPLANT@"_^XMB("NETNAME"))=""
        I 'ISC,SRORG="H" D  ;heart transplant
        .S (XMY("G.CARDIAC RISK ASSESSMENTS@DENVER.VA.GOV"),XMY("G.SRTRANSPLANT@FO-HINES.MED.VA.GOV"))=""
        I 'ISC,SRORG'="H" D  ;kidney/lung/liver transplant (non-cardiac)
        .S XMY("G.SRTRANSPLANT@FO-HINES.MED.VA.GOV")=""
        S SRATDATE=$E(DT,4,5)_"/"_$E(DT,6,7)_"/"_$E(DT,2,3)
        S X=$$ACTIVE^XUSER(DUZ) I '+X S XMDUZ=.5
        S XMSUB=$P($$SITE^SROVAR,"^",2)_": "_$$TR^SRTPUTL(SRORG)_" TRANSPLANT  "_SRATDATE,XMTEXT="TMP(""SRA"",$J,"_SRAMNUM_"," N I D ^XMD
        Q
UPDATE  ; Updating is done by the server SRTPSITE after acknowledgement message is received at the site from the National Database
        ; Notification message of assessments transmitted is built below
        S MM=$E(TMP("SRA",$J,SRAMNUM,SRACNT,0),5,11) F X=1:1 S SREMIL=$P(MM," ",X) Q:SREMIL
        S SRASS=SRASS+1
        S DFN=$P(^SRT(SREMIL,0),"^") D DEM^VADPT S SRANAME=$P(VADM(1),"^") K VADM S X=$P(^SRT(SREMIL,0),"^",2),SRADT=$E(X,4,5)_"/"_$E(X,6,7)_"/"_$E(X,2,3)
        S SRSHEMP=SRSHEMP+1,TMP("SRAMSG",$J,SRSHEMP,0)="TRANSPLANT #: "_SREMIL_"   "_$J(SRANAME,20)_"        TRANSPLANT DATE: "_SRADT
        Q
ORG     S XX=$E(TMP("SRA",$J,SRAMNUM,1,0),69,70) S SRORG=$S(XX=" K":"K",XX=" H":"H",1:XX)
        Q
